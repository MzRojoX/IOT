from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    """Configuración de la aplicación"""
    
    # Database
    DATABASE_URL: str = "postgresql://postgres:toor@localhost:5432/iot"
    
    # App
    APP_NAME: str = "IoT Platform"
    DEBUG: bool = True
    
    # Sensores ultrasónicos - umbral de detección en cm
    SENSOR_THRESHOLD: float = 60.0
    
    # Procesamiento de eventos
    EVENT_TIMEOUT_SECONDS: int = 5  # Cerrar evento si pasan X segundos sin actividad
    ANIMAL_EVENT_TIMEOUT_SECONDS: int = 3  # Cerrar evento de animal si pasan X segundos
    
    # Worker de procesamiento
    WORKER_INTERVAL_MS: int = 1000  # Intervalo entre ejecuciones del worker
    WORKER_ENABLED: bool = True  # Habilitar procesamiento en background
    
    class Config:
        env_file = ".env"


settings = Settings()
