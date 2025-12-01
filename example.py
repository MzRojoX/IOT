#!/usr/bin/env python3
"""
Script de ejemplo: Cómo usar el sistema de procesamiento en tiempo real.

1. Inicia el servidor: uvicorn app.main:app --reload
2. Ejecuta este script en otra terminal: python example.py
"""

import requests
import json
import time
from datetime import datetime

BASE_URL = "http://localhost:8001"


def crear_zona(nombre: str):
    """Crea una nueva zona"""
    response = requests.post(
        f"{BASE_URL}/zonas",
        params={"nombre": nombre}
    )
    return response.json()


def enviar_medicion(
    zona_id: int,
    distancia_1: float,
    distancia_2: float,
    distancia_3: float,
    distancia_4: float,
    movimiento: bool,
    luz: int,
    humedad: float,
    temperatura: float
):
    """Envía una medición al servidor"""
    payload = {
        "zona_id": zona_id,
        "distancia_1": distancia_1,
        "distancia_2": distancia_2,
        "distancia_3": distancia_3,
        "distancia_4": distancia_4,
        "movimiento": movimiento,
        "luz": luz,
        "humedad": humedad,
        "temperatura": temperatura
    }
    
    response = requests.post(
        f"{BASE_URL}/mediciones",
        json=payload
    )
    return response.json()


def listar_eventos_carros(zona_id: int):
    """Lista eventos de carros"""
    response = requests.get(f"{BASE_URL}/eventos-carros/{zona_id}")
    return response.json()


def listar_eventos_animales(zona_id: int):
    """Lista eventos de animales"""
    response = requests.get(f"{BASE_URL}/eventos-animales/{zona_id}")
    return response.json()


def listar_alertas(zona_id: int):
    """Lista alertas"""
    response = requests.get(f"{BASE_URL}/alertas/{zona_id}")
    return response.json()


def main():
    print("="*80)
    print("DEMOSTRACIÓN: Sistema de Procesamiento en Tiempo Real".center(80))
    print("="*80)
    
    # 1. Crear zona
    print("\n1️⃣  Creando zona de monitoreo...")
    zona = crear_zona("Entrada Principal")
    zona_id = zona["id"]
    print(f"   ✓ Zona creada: {zona['nombre']} (ID: {zona_id})")
    
    # 2. Simular carro SIN animal
    print("\n2️⃣  Simulando carro PASANDO SIN ANIMAL...")
    print("   • Carro pasa por sensores: 1 → 2 → 3 → 4")
    print("   • Sin movimiento detectado")
    
    mediciones_carro_sin_animal = [
        (25, 40, 40, 40, False),  # Sensor 1 detecta
        (40, 28, 40, 40, False),  # Sensor 2 detecta
        (40, 40, 30, 40, False),  # Sensor 3 detecta
        (40, 40, 40, 25, False),  # Sensor 4 detecta
    ]
    
    for d1, d2, d3, d4, mov in mediciones_carro_sin_animal:
        enviar_medicion(zona_id, d1, d2, d3, d4, mov, 800, 60, 22)
        time.sleep(0.5)
    
    print("   ✓ Carro sin animal procesado")
    
    # 3. Simular carro CON animal
    print("\n3️⃣  Simulando carro PASANDO CON ANIMAL...")
    print("   • Carro pasa por sensores: 1 → 2")
    print("   • MOVIMIENTO DETECTADO (animal)")
    
    mediciones_carro_con_animal = [
        (26, 40, 40, 40, True),   # Sensor 1 detecta + movimiento
        (40, 29, 40, 40, True),   # Sensor 2 detecta + movimiento
    ]
    
    for d1, d2, d3, d4, mov in mediciones_carro_con_animal:
        enviar_medicion(zona_id, d1, d2, d3, d4, mov, 850, 65, 23)
        time.sleep(0.5)
    
    print("   ✓ Carro con animal procesado")
    
    # 4. Solo animal sin carro
    print("\n4️⃣  Simulando SOLO ANIMAL (sin carro)...")
    print("   • MOVIMIENTO detectado")
    print("   • Todos los sensores > 40 (sin detección de carro)")
    
    enviar_medicion(zona_id, 45, 45, 45, 45, True, 750, 58, 21)
    print("   ✓ Animal sin carro procesado")
    
    time.sleep(1)
    
    # 5. Mostrar resultados
    print("\n" + "="*80)
    print("RESULTADOS".center(80))
    print("="*80)
    
    eventos_carros = listar_eventos_carros(zona_id)
    eventos_animales = listar_eventos_animales(zona_id)
    alertas = listar_alertas(zona_id)
    
    print(f"\n📍 Zona: {zona['nombre']}")
    print(f"\n🚗 Eventos de Carros: {len(eventos_carros)}")
    for i, evento in enumerate(eventos_carros, 1):
        print(f"   {i}. Sensores {evento['sensor_inicial']}-{evento['sensor_final']}, "
              f"Estado: {evento['estado']}")
    
    print(f"\n🐾 Eventos de Animales: {len(eventos_animales)}")
    for i, evento in enumerate(eventos_animales, 1):
        print(f"   {i}. Estado: {evento['estado']}")
    
    print(f"\n⚠️  Alertas (Carro + Animal): {len(alertas)}")
    for i, alerta in enumerate(alertas, 1):
        print(f"   {i}. Evento Carro #{alerta['evento_carro_id']}, "
              f"Evento Animal #{alerta['evento_animal_id']}")
    
    print("\n" + "="*80)
    print("✅ Demostración completada".center(80))
    print("="*80 + "\n")


if __name__ == "__main__":
    try:
        main()
    except requests.exceptions.ConnectionError:
        print("\n❌ Error: No se puede conectar al servidor.")
        print("   Asegúrate de que el servidor está corriendo:")
        print("   uvicorn app.main:app --reload\n")
    except Exception as e:
        print(f"\n❌ Error: {e}\n")
