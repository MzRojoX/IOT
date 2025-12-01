"""
Worker de procesamiento en segundo plano.
Monitorea la tabla mediciones y procesa las que aún no han sido procesadas.
"""

import asyncio
import logging
from datetime import datetime, timedelta
from typing import Optional, Tuple
from sqlalchemy.orm import Session
from sqlalchemy import and_

from app.database import SessionLocal
from app.models import Medicion, EventoCarro, EventoAnimal, Alerta, EstadoEvento
from app.config import settings

logger = logging.getLogger(__name__)


class ProcesadorMediciones:
    """Procesa mediciones crudas y genera eventos de forma incremental."""
    
    # Diccionario en memoria para rastrear eventos activos por zona
    _eventos_activos_por_zona: dict = {}
    
    @staticmethod
    def detectar_sensor_ultrasonico(medicion: Medicion) -> Optional[int]:
        """
        Detecta qué sensor ultrasónico detectó al carro.
        
        Args:
            medicion: Objeto Medicion
            
        Returns:
            int: Número de sensor (1-4) o None si ninguno detecta
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
    
    @staticmethod
    def obtener_evento_carro_activo(
        db: Session,
        zona_id: int
    ) -> Optional[EventoCarro]:
        """Obtiene el evento de carro activo más reciente en una zona."""
        return db.query(EventoCarro).filter(
            EventoCarro.zona_id == zona_id,
            EventoCarro.estado == "activo"
        ).order_by(EventoCarro.hora_inicio.desc()).first()
    
    @staticmethod
    def crear_evento_carro(
        db: Session,
        zona_id: int,
        sensor: int
    ) -> EventoCarro:
        """Crea un nuevo evento de carro."""
        ahora = datetime.utcnow()
        evento = EventoCarro(
            zona_id=zona_id,
            sensor_inicial=sensor,
            sensor_final=sensor,
            hora_inicio=ahora,
            hora_fin=ahora,
            estado="activo"
        )
        db.add(evento)
        db.flush()
        return evento
    
    @staticmethod
    def actualizar_evento_carro(
        db: Session,
        evento: EventoCarro,
        sensor: int
    ) -> EventoCarro:
        """
        Actualiza evento existente.
        Solo actualiza si sensor >= sensor_final (progresión adelante).
        """
        if sensor >= evento.sensor_final:
            evento.sensor_final = sensor
            evento.hora_fin = datetime.utcnow()
        
        db.merge(evento)
        db.flush()
        return evento
    
    @staticmethod
    def cerrar_evento_carro(
        db: Session,
        evento: EventoCarro
    ) -> EventoCarro:
        """Cierra un evento de carro."""
        evento.estado = "cerrado"
        evento.hora_fin = datetime.utcnow()
        db.merge(evento)
        db.flush()
        return evento
    
    @staticmethod
    def procesar_evento_carro(
        db: Session,
        medicion: Medicion,
        sensor: int
    ) -> EventoCarro:
        """
        Máquina de estados para procesar evento de carro.
        
        - Si no hay evento activo → crear uno nuevo
        - Si hay evento activo → actualizar si progresa
        - Asociar medición al evento
        """
        evento = ProcesadorMediciones.obtener_evento_carro_activo(db, medicion.zona_id)
        
        if evento is None:
            evento = ProcesadorMediciones.crear_evento_carro(db, medicion.zona_id, sensor)
        else:
            evento = ProcesadorMediciones.actualizar_evento_carro(db, evento, sensor)
        
        medicion.evento_carro_id = evento.id
        db.merge(medicion)
        db.flush()
        
        return evento
    
    @staticmethod
    def obtener_evento_animal_activo(
        db: Session,
        zona_id: int
    ) -> Optional[EventoAnimal]:
        """Obtiene el evento de animal activo más reciente en una zona."""
        return db.query(EventoAnimal).filter(
            EventoAnimal.zona_id == zona_id,
            EventoAnimal.estado == "activo"
        ).order_by(EventoAnimal.hora.desc()).first()
    
    @staticmethod
    def crear_evento_animal(
        db: Session,
        zona_id: int
    ) -> EventoAnimal:
        """Crea un nuevo evento de animal."""
        evento = EventoAnimal(
            zona_id=zona_id,
            hora=datetime.utcnow(),
            estado="activo"
        )
        db.add(evento)
        db.flush()
        return evento
    
    @staticmethod
    def cerrar_evento_animal(
        db: Session,
        evento: EventoAnimal
    ) -> EventoAnimal:
        """Cierra un evento de animal."""
        evento.estado = "cerrado"
        evento.hora_fin = datetime.utcnow()
        db.merge(evento)
        db.flush()
        return evento
    
    @staticmethod
    def procesar_evento_animal(
        db: Session,
        medicion: Medicion
    ) -> EventoAnimal:
        """Procesa evento de animal cuando se detecta movimiento."""
        evento = ProcesadorMediciones.obtener_evento_animal_activo(db, medicion.zona_id)
        
        if evento is None:
            evento = ProcesadorMediciones.crear_evento_animal(db, medicion.zona_id)
        else:
            evento.hora = datetime.utcnow()
            db.merge(evento)
            db.flush()
        
        return evento
    
    @staticmethod
    def crear_alerta(
        db: Session,
        evento_carro: EventoCarro,
        evento_animal: EventoAnimal
    ) -> Alerta:
        """Crea alerta cuando hay carro + animal simultáneamente."""
        alerta = Alerta(
            evento_carro_id=evento_carro.id,
            evento_animal_id=evento_animal.id,
            hora=datetime.utcnow()
        )
        db.add(alerta)
        db.flush()
        return alerta
    
    @staticmethod
    def cerrar_eventos_inactivos(
        db: Session,
        zona_id: int
    ) -> None:
        """Cierra eventos que han estado inactivos por más de X segundos."""
        ahora = datetime.utcnow()
        
        # Cerrar eventos de carro inactivos
        tiempo_limite_carro = ahora - timedelta(seconds=settings.EVENT_TIMEOUT_SECONDS)
        eventos_carro_inactivos = db.query(EventoCarro).filter(
            EventoCarro.zona_id == zona_id,
            EventoCarro.estado == "activo",
            EventoCarro.hora_fin < tiempo_limite_carro
        ).all()
        
        for evento in eventos_carro_inactivos:
            ProcesadorMediciones.cerrar_evento_carro(db, evento)
        
        # Cerrar eventos de animal inactivos
        tiempo_limite_animal = ahora - timedelta(seconds=settings.ANIMAL_EVENT_TIMEOUT_SECONDS)
        eventos_animal_inactivos = db.query(EventoAnimal).filter(
            EventoAnimal.zona_id == zona_id,
            EventoAnimal.estado == "activo",
            EventoAnimal.hora < tiempo_limite_animal
        ).all()
        
        for evento in eventos_animal_inactivos:
            ProcesadorMediciones.cerrar_evento_animal(db, evento)
    
    @staticmethod
    def procesar_medicion(
        db: Session,
        medicion: Medicion
    ) -> Tuple[Optional[EventoCarro], Optional[EventoAnimal], Optional[Alerta]]:
        """
        Procesa una medición cruda.
        
        Lógica:
        1. Detectar sensor ultrasónico activo
        2. Procesar carro (si hay detección)
        3. Procesar animal (si hay movimiento)
        4. Crear alerta (si hay carro + animal)
        5. Cerrar eventos inactivos
        6. Marcar medición como procesada
        """
        evento_carro = None
        evento_animal = None
        alerta = None
        
        # 1. Detectar sensor activo
        sensor = ProcesadorMediciones.detectar_sensor_ultrasonico(medicion)
        
        # 2. Procesar carro si hay detección
        if sensor is not None:
            evento_carro = ProcesadorMediciones.procesar_evento_carro(db, medicion, sensor)
        
        # 3. Procesar animal si hay movimiento
        if medicion.movimiento:
            evento_animal = ProcesadorMediciones.procesar_evento_animal(db, medicion)
        
        # 4. Crear alerta si hay carro + animal
        if evento_carro is not None and evento_animal is not None:
            alerta = ProcesadorMediciones.crear_alerta(db, evento_carro, evento_animal)
        
        # 5. Cerrar eventos inactivos
        ProcesadorMediciones.cerrar_eventos_inactivos(db, medicion.zona_id)
        
        # 6. Marcar como procesada
        medicion.procesado = True
        db.merge(medicion)
        db.flush()
        
        return evento_carro, evento_animal, alerta
    
    @staticmethod
    def procesar_pendientes(db: Session) -> int:
        """
        Procesa todas las mediciones no procesadas ordenadas por hora.
        
        Returns:
            int: Cantidad de mediciones procesadas
        """
        mediciones_pendientes = db.query(Medicion).filter(
            Medicion.procesado == False
        ).order_by(Medicion.hora.asc()).all()
        
        procesadas = 0
        
        for medicion in mediciones_pendientes:
            try:
                ProcesadorMediciones.procesar_medicion(db, medicion)
                procesadas += 1
            except Exception as e:
                logger.error(f"Error procesando medición {medicion.id}: {e}")
                db.rollback()
                continue
        
        if procesadas > 0:
            db.commit()
            logger.info(f"Procesadas {procesadas} mediciones")
        
        return procesadas


async def worker_procesar_mediciones(
    intervalo_ms: int = 1000
) -> None:
    """
    Worker asincrónico que procesa mediciones cada N milisegundos.
    
    Args:
        intervalo_ms: Intervalo en milisegundos entre ejecuciones
    """
    while True:
        try:
            db = SessionLocal()
            ProcesadorMediciones.procesar_pendientes(db)
            db.close()
        except Exception as e:
            logger.error(f"Error en worker: {e}")
        
        await asyncio.sleep(intervalo_ms / 1000.0)


def iniciar_worker_background() -> None:
    """Inicia el worker en background de forma asincrónica."""
    try:
        asyncio.create_task(
            worker_procesar_mediciones(intervalo_ms=settings.WORKER_INTERVAL_MS)
        )
        logger.info("Worker de procesamiento iniciado")
    except RuntimeError:
        logger.warning("Worker ya está en ejecución")
