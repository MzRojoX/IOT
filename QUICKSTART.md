# 🚀 Guía de Inicio Rápido

## 1. Requisitos Previos

```bash
# Asegúrate que tienes Python 3.9+ instalado
python3 --version

# Y PostgreSQL 12+ corriendo
psql --version
```

## 2. Configuración Inicial (Primera vez)

```bash
# 1. Navega al proyecto
cd /home/mzrojox/IOT

# 2. Crea ambiente virtual
python3 -m venv venv
source venv/bin/activate

# 3. Instala dependencias
pip install -r requirements.txt

# 4. Crea la base de datos
createdb -U postgres iot

# 5. Aplica migraciones
alembic upgrade head

# 6. Copia archivo .env de ejemplo
cp .env.example .env

# 7. Verifica que todo está correcto
python3 verify_system.py
```

## 3. Uso Diario

### Terminal 1: Iniciar el Servidor

```bash
cd /home/mzrojox/IOT
source venv/bin/activate
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Espera a ver:**
```
INFO:     Application startup complete
INFO:app.main:Iniciando worker de procesamiento en background...
INFO:app.worker:Worker de procesamiento iniciado
```

### Terminal 2: Insertar Datos de Prueba

```bash
cd /home/mzrojox/IOT
source venv/bin/activate
python3 insert_mediciones_external.py
```

**Verás en Terminal 1:**
```
INFO:app.worker:Procesadas 9 mediciones
INFO:app.worker:Creado EventoCarro: id=1, sensor_inicial=1, sensor_final=4
INFO:app.worker:Creada Alerta: evento_carro=1, evento_animal=1
```

### Terminal 3: Consultar Resultados

```bash
# Ver API interactiva
open http://localhost:8000/docs

# O usar curl
curl http://localhost:8000/eventos-carros/1
curl http://localhost:8000/eventos-animales/1
curl http://localhost:8000/alertas/1
```

## 4. Verificaciones Útiles

### ¿Es el worker está funcionando?

```sql
-- Conectar a la BD
psql -U postgres iot

-- Ver mediciones sin procesar
SELECT COUNT(*) FROM mediciones WHERE procesado = false;
-- Debería ser 0 si el worker está trabajando

-- Ver eventos generados
SELECT * FROM eventos_carros;
SELECT * FROM eventos_animales;
SELECT * FROM alertas;
```

### Monitorear logs en tiempo real

```bash
# Ver logs del servidor mientras procesa
# (En la Terminal 1 donde está corriendo uvicorn)

# Buscar líneas del worker
grep "Procesadas" # Para ver cuántas mediciones procesó
grep "Creado EventoCarro" # Para ver carros detectados
grep "Alerta" # Para ver alertas generadas
```

## 5. Estructura de Datos

### Flujo de Procesamiento

```
Sistema Externo → INSERT mediciones → Base de Datos
                        ↓
               Worker (cada 1s) ✓ AUTOMÁTICO
                        ↓
        ┌───────────────┼───────────────┐
        ↓               ↓               ↓
   EventoCarro    EventoAnimal       Alerta
   (vehículos)   (movimiento)   (ambos activos)
        ↓               ↓               ↓
     API REST     API REST        API REST
```

### Entidades Principales

| Tabla | Descripción | Relación |
|-------|-------------|----------|
| `zonas` | Áreas monitoreadas | FK en todas las tablas |
| `mediciones` | Datos crudos de sensores | 1-N con eventos |
| `eventos_carros` | Cruce de vehículos | Genera alertas |
| `eventos_animales` | Detección de movimiento | Genera alertas |
| `alertas` | Vehículo + Animal | Resultado final |

## 6. Parámetros Configurables

En `.env` o `app/config.py`:

```bash
# ¿A qué distancia se detecta un carro? (cm)
SENSOR_THRESHOLD=40.0

# ¿Cuántos segundos de inactividad para cerrar evento de carro?
EVENT_TIMEOUT_SECONDS=5

# ¿Cuántos segundos de inactividad para cerrar evento de animal?
ANIMAL_EVENT_TIMEOUT_SECONDS=3

# ¿Cada cuántos milisegundos procesar mediciones?
WORKER_INTERVAL_MS=1000

# ¿Activar procesamiento en background?
WORKER_ENABLED=true
```

### Cambiar Parámetros

Edita `.env` y reinicia el servidor:

```bash
# 1. Detén el servidor (Ctrl+C en Terminal 1)

# 2. Edita .env
nano .env

# 3. Reinicia
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## 7. Casos de Uso Comunes

### Insertar Mediciones Vía API

```bash
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
```

### Crear Nueva Zona

```bash
curl -X POST http://localhost:8000/zonas \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Entrada Trasera",
    "descripcion": "Puerta trasera del edificio"
  }'
```

### Consultar Eventos de Zona

```bash
# Todos los eventos de carros
curl http://localhost:8000/eventos-carros/1

# Solo activos
curl http://localhost:8000/eventos-carros/1/activos

# Con filtro de límite
curl "http://localhost:8000/mediciones/1?limite=50"
```

## 8. Troubleshooting

| Problema | Solución |
|----------|----------|
| "Connection refused" | PostgreSQL no está corriendo: `sudo systemctl start postgresql` |
| "Worker ya está en ejecución" | Es normal, ignorar el mensaje |
| "No module named 'app'" | Activa venv: `source venv/bin/activate` |
| Mediciones no se procesan | Verifica: `WORKER_ENABLED=true` en .env |
| Base de datos no existe | Crea: `createdb -U postgres iot` |

## 9. Desarrollo y Debugging

### Ver SQL que genera SQLAlchemy

```python
# En app/config.py, cambia DEBUG a True
DEBUG=true

# En logs verás las queries SQL
```

### Ejecutar Scripts SQL Directos

```bash
psql -U postgres iot < populate_data.sql
psql -U postgres iot -c "SELECT * FROM eventos_carros;"
```

### Recrear Base de Datos Limpia

```bash
# ⚠️ ESTO BORRARÁ TODO
dropdb -U postgres iot
createdb -U postgres iot
alembic upgrade head
```

## 10. Recursos

- **API Documentation**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **README Completo**: Abre README.md en este directorio
- **Verificación del Sistema**: `python3 verify_system.py`

---

**¿Preguntas?** Revisa README.md o los archivos en `app/` para más detalles.
