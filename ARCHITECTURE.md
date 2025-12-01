# 🏗️ Arquitectura Técnica - Sistema IoT

## Visión General

```
┌─────────────────────────────────────────────────────────────────┐
│                     SISTEMA IOT PLATFORM                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  CAPA DE INGESTA          CAPA DE PROCESAMIENTO   CAPA DE API   │
│  ───────────────          ─────────────────────   ────────────  │
│                                                                 │
│  Sistema Externo                                                │
│  (RPI, MQTT, etc)         Worker Background     FastAPI REST   │
│         ↓                        ↓                    ↓         │
│   INSERT mediciones   →   ProcesadorMediciones →  Endpoints    │
│   (sin procesar)            (cada 1s)            (consulta)     │
│         ↓                        ↓                    ↓         │
│   PostgreSQL ←────────────── Estado Procesado ──→ Respuesta    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 1. Capa de Ingesta (Data Source)

### Responsabilidades
- Recibir datos crudos de sensores
- Insertar en tabla `mediciones`
- NO procesa datos

### Tabla: `mediciones`

```sql
CREATE TABLE mediciones (
    id SERIAL PRIMARY KEY,
    zona_id INTEGER NOT NULL FOREIGN KEY,
    hora TIMESTAMP DEFAULT NOW(),
    
    -- Sensores ultrasónicos (4 puntos)
    distancia_1 DECIMAL(5,2),  -- Sensor 1 (cm)
    distancia_2 DECIMAL(5,2),  -- Sensor 2 (cm)
    distancia_3 DECIMAL(5,2),  -- Sensor 3 (cm)
    distancia_4 DECIMAL(5,2),  -- Sensor 4 (cm)
    
    -- Sensor de movimiento
    movimiento BOOLEAN DEFAULT FALSE,
    
    -- Estado de procesamiento (ÍNDICE para eficiencia)
    procesado BOOLEAN DEFAULT FALSE,
    
    -- Relación con evento (si existe)
    evento_carro_id INTEGER FOREIGN KEY (nullable)
);

-- Índice crítico para eficiencia del worker
CREATE INDEX idx_mediciones_procesado ON mediciones(procesado);
CREATE INDEX idx_mediciones_zona_procesado ON mediciones(zona_id, procesado);
```

### Ejemplo de Inserción (Sistema Externo)

```python
# El sistema externo NO usa la API
# Inserta directamente en BD:

INSERT INTO mediciones (
    zona_id, 
    distancia_1, distancia_2, distancia_3, distancia_4,
    movimiento,
    procesado
) VALUES (
    1,
    35.0, 50.0, 50.0, 50.0,
    false,
    false
);
```

## 2. Capa de Procesamiento (Worker Background)

### Responsabilidades
- Leer mediciones sin procesar
- Detectar patrones (carros, animales)
- Crear eventos y alertas
- Marcar mediciones como procesadas

### Flujo del Worker

```python
WHILE INFINITO cada 1000ms:
    1. db = SessionLocal()
    
    2. mediciones = SELECT * FROM mediciones 
                    WHERE procesado = FALSE 
                    ORDER BY hora ASC
    
    3. PARA CADA medicion IN mediciones:
        a) sensor = detectar_sensor_ultrasonico(medicion)
           └─ ¿Algún distancia_X < 40cm?
           
        b) evento_carro = procesar_evento_carro(db, medicion, sensor)
           ├─ Si no hay evento activo → Crear nuevo
           │  └─ sensor_inicial = sensor, sensor_final = sensor
           ├─ Si hay evento activo:
           │  └─ Si sensor > sensor_final → Actualizar
           │  └─ Asociar medicion a evento
           
        c) SI medicion.movimiento == TRUE:
           evento_animal = procesar_evento_animal(db, medicion)
           
        d) SI evento_carro ACTIVO Y evento_animal ACTIVO:
           alerta = crear_alerta(db, evento_carro, evento_animal)
           
        e) medicion.procesado = TRUE
    
    4. db.commit()
       (persiste todos los cambios)
    
    5. await asyncio.sleep(1.0)
```

### Módulo: `app/worker.py`

```python
class ProcesadorMediciones:
    """Procesa mediciones crudas y genera eventos."""
    
    @staticmethod
    def detectar_sensor_ultrasonico(medicion: Medicion) -> Optional[int]:
        """Retorna número de sensor (1-4) con distancia < 40cm"""
        if medicion.distancia_1 < 40: return 1
        if medicion.distancia_2 < 40: return 2
        if medicion.distancia_3 < 40: return 3
        if medicion.distancia_4 < 40: return 4
        return None
    
    @staticmethod
    def procesar_evento_carro(db, medicion, sensor):
        """Máquina de estados para eventos de carro"""
        evento = obtener_evento_carro_activo(db, medicion.zona_id)
        
        if evento is None:
            # Nuevo carro detectado
            evento = crear_evento_carro(db, medicion.zona_id, sensor)
        elif sensor > evento.sensor_final:
            # Carro progresó
            evento = actualizar_evento_carro(db, evento, sensor)
        # else: ignorar (mismo sensor o anterior)
        
        # Asociar medición a evento
        medicion.evento_carro_id = evento.id
        return evento
    
    @staticmethod
    def procesar_pendientes(db: Session) -> int:
        """Procesa todas las mediciones sin procesar"""
        mediciones = db.query(Medicion)\
            .filter(Medicion.procesado == False)\
            .order_by(Medicion.hora)\
            .all()
        
        for medicion in mediciones:
            procesar_medicion(db, medicion)
        
        db.commit()
        return len(mediciones)

async def worker_procesar_mediciones(intervalo_ms: int):
    """Loop infinito procesando mediciones"""
    while True:
        db = SessionLocal()
        ProcesadorMediciones.procesar_pendientes(db)
        db.close()
        
        await asyncio.sleep(intervalo_ms / 1000.0)

def iniciar_worker_background():
    """Inicia worker como tarea background"""
    asyncio.create_task(
        worker_procesar_mediciones(settings.WORKER_INTERVAL_MS)
    )
```

### Estados de Eventos

#### EventoCarro - Máquina de Estados

```
                    ┌─────────┐
                    │  NUEVO  │
                    └────┬────┘
                         │ (primer sensor detectado)
                         ↓
                    ┌─────────┐
        ┌───────────→ ACTIVO  ←───────────┐
        │            └────┬────┘           │
        │                 │                │
        │  (sensor       │    (progresa    │
        │   regresa)     │     a siguiente │
        │                │     sensor)     │
        │           ┌────┴────┐            │
        │           │  CERRAR │            │
        │ (timeout) │  (5seg) │            │
        │           └────┬────┘            │
        │                │                 │
        └────────────────┤                 │
                         ↓                 │
                    ┌─────────┐            │
                    │ CERRADO │────────────┘
                    └─────────┘
```

#### EventoAnimal - Máquina de Estados

```
                    ┌─────────┐
                    │  NUEVO  │
                    └────┬────┘
                         │ (movimiento detectado)
                         ↓
                    ┌─────────┐
        ┌───────────→ ACTIVO  ←───────────┐
        │            └────┬────┘           │
        │                 │                │
        │  (movimiento    │  (continúa     │
        │   se detiene)   │   detectando)  │
        │                 │                │
        │           ┌────┴────┐            │
        │           │  CERRAR │            │
        │(timeout)  │  (3seg) │            │
        │           └────┬────┘            │
        │                │                 │
        └────────────────┤                 │
                         ↓                 │
                    ┌─────────┐            │
                    │ CERRADO │────────────┘
                    └─────────┘
```

## 3. Capa de API (Consulta y Control)

### Responsabilidades
- Consultar eventos procesados
- Crear zonas
- Health checks
- Documentación automática

### FastAPI + Lifespan

```python
from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app: FastAPI):
    # STARTUP
    if settings.WORKER_ENABLED:
        iniciar_worker_background()
    
    yield
    
    # SHUTDOWN
    # (cleanup si es necesario)

app = FastAPI(lifespan=lifespan)
```

### Endpoints REST

| HTTP | Ruta | Descripción |
|------|------|-------------|
| GET | `/health` | Verificar que servidor está vivo |
| GET | `/zonas` | Listar zonas de monitoreo |
| POST | `/zonas` | Crear nueva zona |
| GET | `/mediciones/{zona_id}` | Últimas mediciones |
| POST | `/mediciones` | Crear medición (API) |
| GET | `/eventos-carros/{zona_id}` | Todos los eventos de carros |
| GET | `/eventos-carros/{zona_id}/activos` | Solo carros activos |
| GET | `/eventos-animales/{zona_id}` | Todos los eventos de animales |
| GET | `/eventos-animales/{zona_id}/activos` | Solo animales activos |
| GET | `/alertas/{zona_id}` | Alertas generadas |

### Respuesta JSON Típica

```json
{
  "id": 5,
  "zona_id": 1,
  "sensor_inicial": 1,
  "sensor_final": 4,
  "hora_inicio": "2024-01-15T10:30:45.123Z",
  "hora_fin": null,
  "estado": "ACTIVO"
}
```

## 4. Base de Datos (PostgreSQL)

### Diagrama de Relaciones

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│                      ZONAS (Área)                        │
│                   ┌────────────┐                         │
│                   │    id (PK) │                         │
│                   │    nombre  │                         │
│                   │ descripción│                         │
│                   └────────────┘                         │
│                         ▲                                │
│                         │ (1:N)                          │
│         ┌───────────────┼───────────────┐                │
│         │               │               │                │
│         ↓               ↓               ↓                │
│    ┌─────────┐   ┌────────────┐   ┌──────────────┐     │
│    │MEDICIONES│   │EV. CARROS  │   │EV. ANIMALES  │    │
│    ├─────────┤   ├────────────┤   ├──────────────┤    │
│    │ id (PK) │   │ id (PK)    │   │ id (PK)      │    │
│    │zona_id  │   │ zona_id    │   │ zona_id      │    │
│    │ hora    │   │sensor_ini  │   │ hora         │    │
│    │ dist1-4 │   │sensor_fin  │   │ hora_fin     │    │
│    │mov      │   │hora_inicio │   │ estado       │    │
│    │procesado│   │hora_fin    │   └──────────────┘    │
│    │ev_carro │──→│ estado     │                        │
│    │         │   └────────────┘                        │
│    └─────────┘         ▲                               │
│         │              │ (1:N)                          │
│         │         ┌──────────────┐                      │
│         │         │   ALERTAS    │                      │
│         └────────→├──────────────┤                      │
│                   │ id (PK)      │                      │
│                   │ zona_id      │                      │
│                   │ ev_carro_id  │                      │
│                   │ ev_animal_id │                      │
│                   │ hora         │                      │
│                   └──────────────┘                      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Índices para Rendimiento

```sql
-- Mediciones: búsqueda rápida de sin procesar
CREATE INDEX idx_mediciones_procesado ON mediciones(procesado);
CREATE INDEX idx_mediciones_zona_procesado ON mediciones(zona_id, procesado);

-- Eventos activos
CREATE INDEX idx_eventos_carros_activos 
ON eventos_carros(zona_id, estado);

CREATE INDEX idx_eventos_animales_activos 
ON eventos_animales(zona_id, estado);

-- Búsqueda por zona
CREATE INDEX idx_alertas_zona ON alertas(zona_id);
```

## 5. Ciclo de Procesamiento Detallado

### Scenario: Vehículo cruzando zona

```
TIEMPO  │ MEDICIÓN              │ WORKER                │ BD ACTUALIZA
────────┼───────────────────────┼──────────────────────┼────────────────
  t=0   │ dist1=30, d2-4=50    │                      │
        │ mov=false, proc=false │                      │
        │ (INSERT)              │                      │
        │                       │                      │
  t=1s  │ [WORKER TICK]         │ detecta sensor=1     │ EventoCarro creado
        │ proc → true           │ crea evento          │ id=1, s_ini=1
        │                       │ asocia medición       │ medicion.proc=true
        │                       │                      │
  t=1.5s│ dist1=50, d2=28      │                      │
        │ mov=false, proc=false │                      │
        │ (INSERT)              │                      │
        │                       │                      │
  t=2s  │ [WORKER TICK]         │ detecta sensor=2     │ EventoCarro
        │ proc → true           │ evento existe        │ actualizado
        │                       │ s_fin=2 (progresa)   │ s_fin → 2
        │                       │                      │
  t=2.5s│ dist1-2=50, d3=32    │                      │
        │ mov=false, proc=false │                      │
        │ (INSERT)              │                      │
        │                       │                      │
  t=3s  │ [WORKER TICK]         │ detecta sensor=3     │ EventoCarro
        │ proc → true           │ s_fin=3 (progresa)   │ s_fin → 3
        │                       │                      │
  t=3.5s│ dist1-3=50, d4=35    │                      │
        │ mov=false, proc=false │                      │
        │ (INSERT)              │                      │
        │                       │                      │
  t=4s  │ [WORKER TICK]         │ detecta sensor=4     │ EventoCarro
        │ proc → true           │ s_fin=4 (progresa)   │ s_fin → 4
        │                       │ VEHÍCULO CRUZÓ       │
        │                       │                      │
  t=5s  │ dist1-4=50 (sin)     │                      │
        │ [5seg sin actividad]  │ TIMEOUT activado     │ EventoCarro
        │                       │ evento → CERRADO     │ estado → CERRADO
        │ [WORKER TICK]         │                      │ hora_fin → NOW()
```

## 6. Configuración y Parámetros

### Archivo: `app/config.py`

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Base de datos
    DATABASE_URL: str = "postgresql://postgres:toor@localhost/iot"
    
    # Detección de sensores
    SENSOR_THRESHOLD: float = 40.0  # cm
    
    # Timeouts
    EVENT_TIMEOUT_SECONDS: int = 5  # cerrar evento carro
    ANIMAL_EVENT_TIMEOUT_SECONDS: int = 3  # cerrar evento animal
    
    # Worker
    WORKER_INTERVAL_MS: int = 1000  # cada cuántos ms procesa
    WORKER_ENABLED: bool = True  # activar/desactivar
    
    # App
    DEBUG: bool = True
    APP_NAME: str = "IoT Platform"
```

### Impacto de Cambiar Parámetros

| Parámetro | Aumentar | Disminuir |
|-----------|----------|-----------|
| SENSOR_THRESHOLD | Menos sensible | Más sensible |
| EVENT_TIMEOUT_SECONDS | Eventos se cierran más lento | Se cierran rápido |
| WORKER_INTERVAL_MS | Menos CPU, más latencia | Más CPU, latencia baja |

## 7. Manejo de Errores

### Error Handling en Worker

```python
for medicion in mediciones:
    try:
        procesar_medicion(db, medicion)
        medicion.procesado = True
    except Exception as e:
        logger.error(f"Error procesando medición {medicion.id}: {e}")
        # Continuar con próxima medición (no detener worker)

db.commit()  # Incluye todas las que sí se procesaron
```

### Recuperación de Fallos

```sql
-- Ver mediciones que fallaron
SELECT * FROM mediciones 
WHERE procesado = false 
AND hora < NOW() - INTERVAL '1 hour';

-- Reintentar manualmente (opcional)
UPDATE mediciones 
SET procesado = false 
WHERE id IN (lista_de_ids);
```

## 8. Monitoreo y Observabilidad

### Logs Importantes

```
[INFO] Procesadas 5 mediciones
[INFO] Creado EventoCarro: id=1, sensor_inicial=1, sensor_final=4
[INFO] Creada Alerta: evento_carro=1, evento_animal=2
[ERROR] Error procesando medición: ...
```

### Queries de Monitoreo

```sql
-- Volumen de procesamiento
SELECT COUNT(*) FROM mediciones WHERE procesado = true;

-- Eventos activos ahora
SELECT * FROM eventos_carros WHERE estado = 'ACTIVO';
SELECT * FROM eventos_animales WHERE estado = 'ACTIVO';

-- Alertas generadas hoy
SELECT * FROM alertas WHERE DATE(hora) = TODAY();

-- Performance: mediciones sin procesar por zona
SELECT zona_id, COUNT(*) FROM mediciones 
WHERE procesado = false 
GROUP BY zona_id;
```

## 9. Escalabilidad Futura

### Límites Actuales

- **Mediciones/segundo**: ~1000 (depende de WORKER_INTERVAL_MS)
- **Zonas simultáneas**: Ilimitadas
- **Conexiones BD**: Configurable en pool

### Mejoras Futuras

1. **Job Queue** (Celery/RQ): Múltiples workers
2. **Redis Cache**: Caché de eventos activos
3. **Event Streaming** (Kafka): Publicar eventos
4. **Métricas** (Prometheus): Monitoreo en producción
5. **Clustering**: Múltiples instancias de API

---

**Versión**: 2.0 (Background Worker)  
**Última actualización**: 2024  
**Autor**: Sistema IoT Platform
