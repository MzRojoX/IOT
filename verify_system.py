#!/usr/bin/env python3
"""
Script de verificación y demostración del sistema IoT.
Valida que todo está configurado correctamente.
"""

import sys
import os
from pathlib import Path

sys.path.insert(0, '/home/mzrojox/IOT')

def check_environment():
    """Verifica el ambiente Python."""
    print("\n📋 Verificando Ambiente Python...")
    print(f"  ✓ Python: {sys.version.split()[0]}")
    print(f"  ✓ Ubicación: {sys.executable}")

def check_dependencies():
    """Verifica que están instaladas las dependencias."""
    print("\n📦 Verificando Dependencias...")
    deps = [
        'fastapi',
        'uvicorn',
        'sqlalchemy',
        'psycopg2',
        'pydantic',
        'alembic'
    ]
    
    for dep in deps:
        try:
            __import__(dep)
            print(f"  ✓ {dep}")
        except ImportError:
            print(f"  ✗ {dep} - NO INSTALADO")
            return False
    return True

def check_config():
    """Verifica que la configuración esté cargada."""
    print("\n⚙️  Verificando Configuración...")
    try:
        from app.config import settings
        print(f"  ✓ DATABASE_URL: {settings.DATABASE_URL[:30]}...")
        print(f"  ✓ SENSOR_THRESHOLD: {settings.SENSOR_THRESHOLD} cm")
        print(f"  ✓ EVENT_TIMEOUT_SECONDS: {settings.EVENT_TIMEOUT_SECONDS}s")
        print(f"  ✓ ANIMAL_EVENT_TIMEOUT_SECONDS: {settings.ANIMAL_EVENT_TIMEOUT_SECONDS}s")
        print(f"  ✓ WORKER_INTERVAL_MS: {settings.WORKER_INTERVAL_MS} ms")
        print(f"  ✓ WORKER_ENABLED: {settings.WORKER_ENABLED}")
        return True
    except Exception as e:
        print(f"  ✗ Error loading config: {e}")
        return False

def check_database():
    """Verifica conexión a la base de datos."""
    print("\n🗄️  Verificando Base de Datos...")
    try:
        from app.database import engine
        with engine.connect() as conn:
            print("  ✓ Conexión a PostgreSQL exitosa")
            
            # Verificar tablas
            from sqlalchemy import inspect
            inspector = inspect(engine)
            tables = inspector.get_table_names()
            print(f"  ✓ Tablas encontradas: {', '.join(tables)}")
            
            # Verificar datos
            from app.database import SessionLocal
            from app.models import Zona, Medicion
            
            db = SessionLocal()
            zonas = db.query(Zona).count()
            mediciones_sin_procesar = db.query(Medicion).filter(Medicion.procesado == False).count()
            db.close()
            
            print(f"  ✓ Zonas: {zonas}")
            print(f"  ✓ Mediciones sin procesar: {mediciones_sin_procesar}")
            
            return True
    except Exception as e:
        print(f"  ✗ Error de base de datos: {e}")
        return False

def check_models():
    """Verifica que los modelos se cargan correctamente."""
    print("\n📊 Verificando Modelos...")
    try:
        from app.models import Zona, Medicion, EventoCarro, EventoAnimal, Alerta, EstadoEvento
        print("  ✓ Zona")
        print("  ✓ Medicion")
        print("  ✓ EventoCarro")
        print("  ✓ EventoAnimal")
        print("  ✓ Alerta")
        print("  ✓ EstadoEvento")
        return True
    except Exception as e:
        print(f"  ✗ Error cargando modelos: {e}")
        return False

def check_worker():
    """Verifica que el worker se puede importar."""
    print("\n⚙️  Verificando Worker...")
    try:
        from app.worker import (
            ProcesadorMediciones, 
            worker_procesar_mediciones, 
            iniciar_worker_background
        )
        print("  ✓ ProcesadorMediciones")
        print("  ✓ worker_procesar_mediciones")
        print("  ✓ iniciar_worker_background")
        return True
    except Exception as e:
        print(f"  ✗ Error cargando worker: {e}")
        return False

def check_api():
    """Verifica que la API se puede importar."""
    print("\n🔗 Verificando API...")
    try:
        from app.main import app
        print(f"  ✓ FastAPI app cargada: {app.title}")
        print(f"  ✓ Debug: {app.debug}")
        print(f"  ✓ Endpoints disponibles:")
        for route in app.routes:
            if hasattr(route, 'path'):
                print(f"    - {route.path}")
        return True
    except Exception as e:
        print(f"  ✗ Error cargando API: {e}")
        return False

def show_summary():
    """Muestra resumen de uso."""
    print("""
╔════════════════════════════════════════════════════════════════╗
║                    SISTEMA LISTO PARA USAR                    ║
╚════════════════════════════════════════════════════════════════╝

🚀 PARA INICIAR EL SERVIDOR:

    uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

📡 ENDPOINTS DISPONIBLES:

    - GET  /health                          Health check
    - GET  /zonas                           Listar zonas
    - POST /zonas                           Crear zona
    - GET  /mediciones/{zona_id}            Listar mediciones
    - POST /mediciones                      Crear medición (API)
    - GET  /eventos-carros/{zona_id}        Eventos de carros
    - GET  /eventos-carros/{zona_id}/activos
    - GET  /eventos-animales/{zona_id}      Eventos de animales
    - GET  /eventos-animales/{zona_id}/activos
    - GET  /alertas/{zona_id}               Alertas generadas

📊 INSERTAR DATOS DE PRUEBA:

    # Con script Python
    python3 insert_mediciones_external.py

    # Con SQL
    psql -U postgres iot < populate_data.sql

🧪 MONITOREAR PROCESAMIENTO:

    # Ver mediciones sin procesar
    psql -U postgres iot -c \\
      "SELECT COUNT(*) FROM mediciones WHERE procesado=false;"
    
    # Ver eventos carros activos
    psql -U postgres iot -c \\
      "SELECT * FROM eventos_carros WHERE estado='ACTIVO';"

📖 DOCUMENTACIÓN INTERACTIVA:

    - Swagger UI: http://localhost:8000/docs
    - ReDoc:      http://localhost:8000/redoc

✨ CARACTERÍSTICAS ACTIVAS:

    ✓ Worker background procesando mediciones cada {WORKER_INTERVAL_MS}ms
    ✓ Detección automática de vehículos (sensores ultrasónicos)
    ✓ Detección automática de animales (sensor de movimiento)
    ✓ Generación automática de alertas
    ✓ API REST para consulta de eventos
    ✓ Migraciones Alembic para control de esquema

📚 MÁS INFORMACIÓN:

    Ver README.md para documentación completa
""")

if __name__ == "__main__":
    print("""
╔════════════════════════════════════════════════════════════════╗
║          VERIFICACIÓN DEL SISTEMA IoT PLATFORM                 ║
╚════════════════════════════════════════════════════════════════╝
    """)
    
    checks = [
        ("Ambiente Python", check_environment),
        ("Dependencias", check_dependencies),
        ("Configuración", check_config),
        ("Base de Datos", check_database),
        ("Modelos", check_models),
        ("Worker", check_worker),
        ("API", check_api),
    ]
    
    failed = False
    for name, check_func in checks:
        try:
            if not check_func():
                failed = True
        except Exception as e:
            print(f"\n❌ {name} falló: {e}")
            failed = True
    
    if not failed:
        print("\n✅ TODAS LAS VERIFICACIONES PASARON")
        show_summary()
    else:
        print("\n❌ ALGUNAS VERIFICACIONES FALLARON")
        print("\nVerifica los errores anteriores y ejecuta nuevamente.")
        sys.exit(1)
