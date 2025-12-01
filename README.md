# 🌐 IoT Platform - FastAPI + Background Worker

Plataforma de monitoreo IoT en tiempo real con procesamiento asincrónico en background. Procesa datos de sensores ultrasónicos para detectar vehículos y animales, generando alertas automáticas.

## ✨ Características Principales

- **Procesamiento en Background**: Worker asincrónico que procesa mediciones en tiempo real
- **Detección de Vehículos**: Sensores ultrasónicos (4 puntos) con máquina de estados
- **Detección de Animales**: Sensor de movimiento integrado
- **Generación de Alertas**: Alertas automáticas cuando vehículo + animal se detectan simultáneamente
- **API REST**: Endpoints para consultar eventos, alertas y zonas
- **Migración de Base de Datos**: Alembic para control de versiones de esquema
- **Configuración Centralizada**: Pydantic Settings para gestión de parámetros

## 🏗️ Arquitectura

```
Sistema Externo
    ↓
INSERT mediciones (raw) → PostgreSQL
    ↓
Worker Background (cada 1s)
    ├─ Detecta sensor ultrasónico activo
    ├─ Crea/Actualiza EventoCarro
    ├─ Crea EventoAnimal si movimiento
    ├─ Genera Alerta si ambos activos
    └─ Marca medicion.procesado = True
    ↓
FastAPI Endpoints
    ├─ GET /eventos-carros/{zona_id}
    ├─ GET /eventos-animales/{zona_id}
    ├─ GET /alertas/{zona_id}
    └─ GET /mediciones/{zona_id}
```

## 📋 Requisitos

- **Python 3.9+**
- **PostgreSQL 12+**
- **pip** (gestor de paquetes Python)

## 🚀 Instalación y Configuración

### 1. Crear Ambiente Virtual

```bash
python3 -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
```

### 2. Instalar Dependencias

```bash
pip install -r requirements.txt
```

### 3. Configurar Base de Datos PostgreSQL

```bash
# Crear base de datos
createdb -U postgres iot

# Crear tablas (via Alembic)
alembic upgrade head

# Insertar datos de prueba (opcional)
psql -U postgres iot < populate_data.sql
```

### 4. Variables de Entorno (.env)

```bash
# .env
DATABASE_URL=postgresql://postgres:toor@localhost:5432/iot
SENSOR_THRESHOLD=40.0
EVENT_TIMEOUT_SECONDS=5
ANIMAL_EVENT_TIMEOUT_SECONDS=3
WORKER_INTERVAL_MS=1000
WORKER_ENABLED=true
DEBUG=true
```

### 5. Ejecutar la Aplicación

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**URL**: http://localhost:8000

## 📊 Flujo de Procesamiento

### 1️⃣ Ingesta de Datos (Sistema Externo)

El sistema externo inserta mediciones directamente en PostgreSQL:

```sql
INSERT INTO mediciones (
  zona_id, hora, distancia_1, distancia_2, 
  distancia_3, distancia_4, movimiento, procesado
) VALUES (
  1, NOW(), 35.5, 50.0, 50.0, 50.0, false, false
);
```

### 2️⃣ Procesamiento en Background

El worker cada N ms (configurable, default 1s):

```python
# 1. Obtiene mediciones no procesadas
SELECT * FROM mediciones WHERE procesado = False ORDER BY hora ASC

# 2. Para cada medición:
a) Detecta sensor ultrasónico activo (< 40 cm)
b) Crea o actualiza EventoCarro
   - Primer sensor detectado → crear nuevo evento
   - Sensor nuevo > anterior → actualizar sensor_final
   - Mismo/anterior sensor → ignorar
c) Si movimiento=true → crear/actualizar EventoAnimal
d) Si ambos eventos activos → crear Alerta
e) Marca medicion.procesado = True

# 3. Persiste cambios en base de datos
db.commit()
```

### 3️⃣ Consulta de Eventos (API)

Las aplicaciones cliente consultan los eventos procesados:

```bash
# Eventos de carros activos
GET /eventos-carros/1/activos

# Eventos de animales
GET /eventos-animales/1?estado=ACTIVO

# Alertas generadas
GET /alertas/1
```

## 📡 API Endpoints

### Mediciones

```bash
# Listar mediciones recientes de una zona
GET /mediciones/{zona_id}
GET /mediciones/{zona_id}?limite=50

# Crear medición vía API (uso opcional)
POST /mediciones
Content-Type: application/json
{
  "zona_id": 1,
  "distancia_1": 35.0,
  "distancia_2": 50.0,
  "distancia_3": 50.0,
  "distancia_4": 50.0,
  "movimiento": false
}
```

### Eventos de Carros

```bash
# Todos los eventos de carros en zona
GET /eventos-carros/{zona_id}

# Solo eventos ACTIVOS
GET /eventos-carros/{zona_id}/activos
```

### Eventos de Animales

```bash
# Todos los eventos de movimiento
GET /eventos-animales/{zona_id}

# Solo activos
GET /eventos-animales/{zona_id}/activos
```

### Alertas

```bash
# Todas las alertas (vehículo + animal simultáneamente)
GET /alertas/{zona_id}
```

### Zonas

```bash
# Listar todas las zonas
GET /zonas

# Crear nueva zona
POST /zonas
{
  "nombre": "Entrada Principal",
  "descripcion": "Puerta de acceso principal"
}
```

### Health Check

```bash
GET /health
```

## 🧪 Pruebas

### Insertar Mediciones con Script Python

```bash
# Ejecutar script que inserta mediciones de demostración
python3 insert_mediciones_external.py

# El worker las procesará automáticamente
```

### Insertar con SQL Directo

```bash
psql -U postgres iot < populate_data.sql
```

### Usar curl

```bash
# Crear zona
curl -X POST http://localhost:8000/zonas \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Zona A","descripcion":"Test"}'

# Crear medición
curl -X POST http://localhost:8000/mediciones \
  -H "Content-Type: application/json" \
  -d '{
    "zona_id": 1,
    "distancia_1": 35.0,
    "distancia_2": 50.0,
    "distancia_3": 50.0,
    "distancia_4": 50.0,
    "movimiento": false
  }'

# Consultar eventos
curl http://localhost:8000/eventos-carros/1
curl http://localhost:8000/eventos-animales/1
curl http://localhost:8000/alertas/1
```

## ⚙️ Configuración Detallada

En `app/config.py`:

```python
SENSOR_THRESHOLD = 40.0              # Distancia en cm para detectar vehículo
EVENT_TIMEOUT_SECONDS = 5            # Cerrar evento carro si pasa X segundos sin actividad
ANIMAL_EVENT_TIMEOUT_SECONDS = 3     # Cerrar evento animal si pasa X segundos
WORKER_INTERVAL_MS = 1000            # Intervalo procesamiento (ms)
WORKER_ENABLED = true                # Activar/desactivar worker
```

## 🗂️ Estructura de Archivos

```
/home/mzrojox/IOT/
├── app/
│   ├── __init__.py
│   ├── main.py              # Aplicación FastAPI + lifespan
│   ├── config.py            # Configuración (Pydantic Settings)
│   ├── database.py          # SQLAlchemy setup
│   ├── models.py            # Modelos SQLAlchemy
│   ├── schemas.py           # Esquemas Pydantic
│   ├── worker.py            # 🔴 Worker background
│   └── processador.py       # Lógica sincrónica (referencia)
├── alembic/
│   ├── env.py
│   ├── script.py.mako
│   └── versions/
│       └── 001_initial_schema.py  # Migración inicial
├── populate_data.sql        # Datos de prueba
├── insert_mediciones_external.py  # Script demo
├── requirements.txt         # Dependencias Python
├── README.md                # Esta documentación
└── .env                     # Variables de entorno (no incluir en git)
```

## 🔧 Troubleshooting

### Error: "Worker ya está en ejecución"
El worker ya está activo. Ignorar este mensaje, es normal.

### Error: "No module named 'app'"
```bash
cd /home/mzrojox/IOT
source venv/bin/activate
```

### Error: "Connection refused" a PostgreSQL
```bash
# En Linux
sudo systemctl status postgresql

# En macOS con Homebrew
brew services list
```

### Las mediciones no se procesan
1. Verificar que `WORKER_ENABLED=true` en .env
2. Revisar logs del servidor para errores
3. Verificar que hay mediciones con `procesado=false` en BD

```sql
SELECT * FROM mediciones WHERE procesado = false;
```

## 📚 Referencias

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [SQLAlchemy 2.0](https://docs.sqlalchemy.org/en/20/)
- [Alembic Migrations](https://alembic.sqlalchemy.org/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)

## 📝 Licencia

MIT
