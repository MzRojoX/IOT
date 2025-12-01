from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from typing import Optional, Tuple
from app.models import (
    Medicion, EventoCarro, EventoAnimal, Alerta,
    EstadoEvento
)
from app.config import settings


def detectar_sensor_ultrasonico(medicion: Medicion) -> Optional[int]:
    """
    Detecta qué sensor ultrasónico detectó al carro (distancia < umbral).
    Retorna el número de sensor (1-4) o None si ninguno detecta.
    
    Args:
        medicion: Objeto Medicion
        
    Returns:
        int: Número de sensor (1-4) o None
    """
    if medicion.distancia_1 < settings.SENSOR_THRESHOLD:
        return 1
    elif medicion.distancia_2 < settings.SENSOR_THRESHOLD:
        return 2
    elif medicion.distancia_3 < settings.SENSOR_THRESHOLD:
        return 3
    elif medicion.distancia_4 < settings.SENSOR_THRESHOLD:
        return 4
    return None


def obtener_evento_carro_activo(
    db: Session,
    zona_id: int
) -> Optional[EventoCarro]:
    """
    Obtiene el evento de carro activo más reciente en una zona.
    
    Args:
        db: Sesión de base de datos
        zona_id: ID de la zona
        
    Returns:
        EventoCarro o None
    """
    return db.query(EventoCarro).filter(
        EventoCarro.zona_id == zona_id,
        EventoCarro.estado == "activo"
    ).order_by(EventoCarro.hora_inicio.desc()).first()


def crear_evento_carro(
    db: Session,
    zona_id: int,
    sensor: int
) -> EventoCarro:
    """
    Crea un nuevo evento de carro.
    
    Args:
        db: Sesión de base de datos
        zona_id: ID de la zona
        sensor: Número de sensor (1-4)
        
    Returns:
        EventoCarro: Nuevo evento creado
    """
    evento = EventoCarro(
        zona_id=zona_id,
        sensor_inicial=sensor,
        sensor_final=sensor,
        hora_inicio=datetime.utcnow(),
        estado="activo"
    )
    db.add(evento)
    db.flush()
    return evento


def actualizar_evento_carro(
    db: Session,
    evento: EventoCarro,
    sensor: int
) -> EventoCarro:
    """
    Actualiza un evento de carro existente.
    Solo actualiza si el nuevo sensor es >= sensor_final (progresión hacia adelante).
    
    Args:
        db: Sesión de base de datos
        evento: EventoCarro a actualizar
        sensor: Número de sensor actual
        
    Returns:
        EventoCarro: Evento actualizado
    """
    if sensor >= evento.sensor_final:
        evento.sensor_final = sensor
        evento.hora_fin = datetime.utcnow()
    
    db.merge(evento)
    db.flush()
    return evento


def cerrar_evento_carro(
    db: Session,
    evento: EventoCarro
) -> EventoCarro:
    """
    Cierra un evento de carro.
    
    Args:
        db: Sesión de base de datos
        evento: EventoCarro a cerrar
        
    Returns:
        EventoCarro: Evento cerrado
    """
    evento.estado = "cerrado"
    evento.hora_fin = datetime.utcnow()
    db.merge(evento)
    db.flush()
    return evento


def procesar_evento_carro(
    db: Session,
    medicion: Medicion,
    sensor: int
) -> EventoCarro:
    """
    Máquina de estados para procesar evento de carro.
    
    Lógica:
    - Si no hay evento activo → crear uno nuevo
    - Si hay evento activo → actualizar solo si sensor >= sensor_final
    - Asociar medición al evento
    
    Args:
        db: Sesión de base de datos
        medicion: Medicion cruda
        sensor: Número de sensor detectado
        
    Returns:
        EventoCarro: Evento procesado
    """
    evento = obtener_evento_carro_activo(db, medicion.zona_id)
    
    if evento is None:
        # No hay evento activo → crear uno nuevo
        evento = crear_evento_carro(db, medicion.zona_id, sensor)
    else:
        # Hay evento activo → actualizar si progresa
        evento = actualizar_evento_carro(db, evento, sensor)
    
    # Asociar medición al evento
    medicion.evento_carro_id = evento.id
    db.merge(medicion)
    db.flush()
    
    return evento


def obtener_evento_animal_activo(
    db: Session,
    zona_id: int
) -> Optional[EventoAnimal]:
    """
    Obtiene el evento de animal activo más reciente en una zona.
    
    Args:
        db: Sesión de base de datos
        zona_id: ID de la zona
        
    Returns:
        EventoAnimal o None
    """
    return db.query(EventoAnimal).filter(
        EventoAnimal.zona_id == zona_id,
        EventoAnimal.estado == "activo"
    ).order_by(EventoAnimal.hora.desc()).first()


def crear_evento_animal(
    db: Session,
    zona_id: int
) -> EventoAnimal:
    """
    Crea un nuevo evento de animal.
    
    Args:
        db: Sesión de base de datos
        zona_id: ID de la zona
        
    Returns:
        EventoAnimal: Nuevo evento creado
    """
    evento = EventoAnimal(
        zona_id=zona_id,
        hora=datetime.utcnow(),
        estado="activo"
    )
    db.add(evento)
    db.flush()
    return evento


def cerrar_evento_animal(
    db: Session,
    evento: EventoAnimal
) -> EventoAnimal:
    """
    Cierra un evento de animal.
    
    Args:
        db: Sesión de base de datos
        evento: EventoAnimal a cerrar
        
    Returns:
        EventoAnimal: Evento cerrado
    """
    evento.estado = "cerrado"
    evento.hora_fin = datetime.utcnow()
    db.merge(evento)
    db.flush()
    return evento


def procesar_evento_animal(
    db: Session,
    medicion: Medicion
) -> EventoAnimal:
    """
    Procesa evento de animal cuando se detecta movimiento.
    
    Args:
        db: Sesión de base de datos
        medicion: Medicion cruda
        
    Returns:
        EventoAnimal: Evento procesado
    """
    evento = obtener_evento_animal_activo(db, medicion.zona_id)
    
    if evento is None:
        # No hay evento activo → crear uno nuevo
        evento = crear_evento_animal(db, medicion.zona_id)
    else:
        # Actualizar timestamp del evento existente
        evento.hora = datetime.utcnow()
        db.merge(evento)
        db.flush()
    
    return evento


def crear_alerta(
    db: Session,
    evento_carro: EventoCarro,
    evento_animal: EventoAnimal
) -> Alerta:
    """
    Crea una alerta cuando hay carro + animal simultáneamente.
    
    Args:
        db: Sesión de base de datos
        evento_carro: EventoCarro activo
        evento_animal: EventoAnimal activo
        
    Returns:
        Alerta: Nueva alerta creada
    """
    alerta = Alerta(
        evento_carro_id=evento_carro.id,
        evento_animal_id=evento_animal.id,
        hora=datetime.utcnow()
    )
    db.add(alerta)
    db.flush()
    return alerta


def cerrar_eventos_inactivos(
    db: Session,
    zona_id: int
) -> None:
    """
    Cierra eventos que han estado inactivos por más de X segundos.
    
    Args:
        db: Sesión de base de datos
        zona_id: ID de la zona
    """
    ahora = datetime.utcnow()
    
    # Cerrar eventos de carro inactivos
    tiempo_limite_carro = ahora - timedelta(seconds=settings.EVENT_TIMEOUT_SECONDS)
    eventos_carro_inactivos = db.query(EventoCarro).filter(
        EventoCarro.zona_id == zona_id,
        EventoCarro.estado == "activo",
        EventoCarro.hora_fin < tiempo_limite_carro
    ).all()
    
    for evento in eventos_carro_inactivos:
        cerrar_evento_carro(db, evento)
    
    # Cerrar eventos de animal inactivos
    tiempo_limite_animal = ahora - timedelta(seconds=settings.ANIMAL_EVENT_TIMEOUT_SECONDS)
    eventos_animal_inactivos = db.query(EventoAnimal).filter(
        EventoAnimal.zona_id == zona_id,
        EventoAnimal.estado == "activo",
        EventoAnimal.hora < tiempo_limite_animal
    ).all()
    
    for evento in eventos_animal_inactivos:
        cerrar_evento_animal(db, evento)


def procesar_medicion(
    db: Session,
    medicion: Medicion
) -> Tuple[Optional[EventoCarro], Optional[EventoAnimal], Optional[Alerta]]:
    """
    Función central que procesa una medición cruda.
    
    Lógica:
    1. Detectar sensor ultrasónico activo
    2. Procesar carro (si hay detección)
    3. Procesar animal (si hay movimiento)
    4. Crear alerta (si hay carro + animal)
    5. Cerrar eventos inactivos
    
    Args:
        db: Sesión de base de datos
        medicion: Medicion cruda
        
    Returns:
        Tuple[EventoCarro, EventoAnimal, Alerta]: Eventos creados/procesados
    """
    evento_carro = None
    evento_animal = None
    alerta = None
    
    # 1. Detectar sensor activo
    sensor = detectar_sensor_ultrasonico(medicion)
    
    # 2. Procesar carro si hay detección
    if sensor is not None:
        evento_carro = procesar_evento_carro(db, medicion, sensor)
    
    # 3. Procesar animal si hay movimiento
    if medicion.movimiento:
        evento_animal = procesar_evento_animal(db, medicion)
    
    # 4. Crear alerta si hay carro + animal
    if evento_carro is not None and evento_animal is not None:
        alerta = crear_alerta(db, evento_carro, evento_animal)
    
    # 5. Cerrar eventos inactivos
    cerrar_eventos_inactivos(db, medicion.zona_id)
    
    return evento_carro, evento_animal, alerta
