#!/usr/bin/env python3
"""
Script de demostración: Simula un sistema externo insertando mediciones
directamente en la base de datos (sin pasar por la API).

El worker en background las procesará automáticamente.
"""

import sys
from datetime import datetime, timedelta
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Asegurarse que el módulo app esté disponible
sys.path.insert(0, '/home/mzrojox/IOT')

from app.config import settings
from app.models import Medicion

# Configurar conexión a la base de datos
engine = create_engine(settings.DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def insertar_mediciones_demo():
    """Inserta mediciones de demostración en la base de datos."""
    db = SessionLocal()
    
    try:
        # Obtener zona_id (asumir que existe zona 1)
        zona_id = 1
        
        # Escenario 1: Carro sin animal
        print("📦 Inserting: Carro en sensores 1→2→3→4 (sin animal)...")
        for i, sensor in enumerate([1, 2, 3, 4], 1):
            medicion = Medicion(
                zona_id=zona_id,
                hora=datetime.now() - timedelta(seconds=30 - i*5),
                distancia_1=50.0 if sensor != 1 else 30.0,
                distancia_2=50.0 if sensor != 2 else 32.0,
                distancia_3=50.0 if sensor != 3 else 35.0,
                distancia_4=50.0 if sensor != 4 else 38.0,
                movimiento=False,
                procesado=False
            )
            db.add(medicion)
        
        # Escenario 2: Carro con animal
        print("📦 Inserting: Carro en sensores 1→2 (CON animal)...")
        for i, (sensor, tiene_animal) in enumerate([(1, True), (2, True), (3, False)], 1):
            medicion = Medicion(
                zona_id=zona_id,
                hora=datetime.now() - timedelta(seconds=20 - i*3),
                distancia_1=50.0 if sensor != 1 else 28.0,
                distancia_2=50.0 if sensor != 2 else 30.0,
                distancia_3=50.0,
                distancia_4=50.0,
                movimiento=tiene_animal,
                procesado=False
            )
            db.add(medicion)
        
        # Escenario 3: Solo animal (sin carro)
        print("📦 Inserting: Solo animal detectado (sin carro)...")
        for i in range(2):
            medicion = Medicion(
                zona_id=zona_id,
                hora=datetime.now() - timedelta(seconds=10 - i*2),
                distancia_1=50.0,
                distancia_2=50.0,
                distancia_3=50.0,
                distancia_4=50.0,
                movimiento=True,
                procesado=False
            )
            db.add(medicion)
        
        # Confirmar transacción
        db.commit()
        
        # Verificar que se insertaron
        count = db.query(Medicion).filter(Medicion.procesado == False).count()
        print(f"\n✅ {count} mediciones sin procesar insertadas en la BD")
        print("⏳ El worker las procesará en background...")
        
    except Exception as e:
        db.rollback()
        print(f"❌ Error al insertar mediciones: {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    print("""
    ╔════════════════════════════════════════════════════════════╗
    ║   Script: Insertar mediciones desde sistema externo        ║
    ║   Las mediciones se procesan automáticamente en background  ║
    ╚════════════════════════════════════════════════════════════╝
    """)
    
    insertar_mediciones_demo()
    
    print("""
    📝 Próximos pasos:
    1. Inicia el servidor FastAPI: uvicorn app.main:app --reload
    2. Verifica que el worker está activo en los logs
    3. Consulta los eventos procesados:
       - GET http://localhost:8000/eventos-carros/1
       - GET http://localhost:8000/eventos-animales/1
       - GET http://localhost:8000/alertas/1
    """)
