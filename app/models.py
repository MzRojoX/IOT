from sqlalchemy import Column, Integer, Float, DateTime, Boolean, ForeignKey, String, Enum
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
from app.database import Base


class EstadoEvento(str, enum.Enum):
    """Estados posibles de un evento de carro"""
    activo = "activo"
    cerrado = "cerrado"


class Zona(Base):
    """Zonas de monitoreo"""
    __tablename__ = "zonas"
    
    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False, unique=True)
    
    mediciones = relationship("Medicion", back_populates="zona")
    eventos_carros = relationship("EventoCarro", back_populates="zona")
    eventos_animales = relationship("EventoAnimal", back_populates="zona")


class Medicion(Base):
    """Medición cruda de sensores - una fila por lectura"""
    __tablename__ = "mediciones"
    
    id = Column(Integer, primary_key=True, index=True)
    zona_id = Column(Integer, ForeignKey("zonas.id"), nullable=False)
    
    # Sensores ultrasónicos (en cm)
    distancia_1 = Column(Float, nullable=False)
    distancia_2 = Column(Float, nullable=False)
    distancia_3 = Column(Float, nullable=False)
    distancia_4 = Column(Float, nullable=False)
    
    # Sensor de movimiento
    movimiento = Column(Boolean, default=False)
    
    # Sensores ambientales
    luz = Column(Integer, nullable=False)  # Lux
    humedad = Column(Float, nullable=False)  # %
    temperatura = Column(Float, nullable=False)  # °C
    
    # Timestamp
    hora = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Control de procesamiento
    procesado = Column(Boolean, default=False, nullable=False, index=True)
    
    # Relación
    evento_carro_id = Column(Integer, ForeignKey("eventos_carros.id"), nullable=True)
    zona = relationship("Zona", back_populates="mediciones")
    evento_carro = relationship("EventoCarro", back_populates="mediciones")


class EventoCarro(Base):
    """Evento de carro agrupando múltiples mediciones"""
    __tablename__ = "eventos_carros"
    
    id = Column(Integer, primary_key=True, index=True)
    zona_id = Column(Integer, ForeignKey("zonas.id"), nullable=False)
    
    # Sensores por donde pasó
    sensor_inicial = Column(Integer, nullable=False)  # 1, 2, 3 o 4
    sensor_final = Column(Integer, nullable=False)  # 1, 2, 3 o 4
    
    # Timestamps
    hora_inicio = Column(DateTime, default=datetime.utcnow, nullable=False)
    hora_fin = Column(DateTime, nullable=True)
    
    # Estado del evento
    estado = Column(Enum(EstadoEvento), default=EstadoEvento.activo, nullable=False)
    
    # Relaciones
    zona = relationship("Zona", back_populates="eventos_carros")
    mediciones = relationship("Medicion", back_populates="evento_carro")
    alertas = relationship("Alerta", back_populates="evento_carro")


class EventoAnimal(Base):
    """Evento de animal detectado"""
    __tablename__ = "eventos_animales"
    
    id = Column(Integer, primary_key=True, index=True)
    zona_id = Column(Integer, ForeignKey("zonas.id"), nullable=False)
    
    # Timestamp
    hora = Column(DateTime, default=datetime.utcnow, nullable=False)
    hora_fin = Column(DateTime, nullable=True)
    
    # Estado
    estado = Column(Enum(EstadoEvento), default=EstadoEvento.activo, nullable=False)
    
    # Relaciones
    zona = relationship("Zona", back_populates="eventos_animales")
    alertas = relationship("Alerta", back_populates="evento_animal")


class Alerta(Base):
    """Alerta: carro + animal al mismo tiempo"""
    __tablename__ = "alertas"
    
    id = Column(Integer, primary_key=True, index=True)
    evento_carro_id = Column(Integer, ForeignKey("eventos_carros.id"), nullable=False)
    evento_animal_id = Column(Integer, ForeignKey("eventos_animales.id"), nullable=False)
    
    # Timestamp
    hora = Column(DateTime, default=datetime.utcnow, nullable=False)
    
    # Relaciones
    evento_carro = relationship("EventoCarro", back_populates="alertas")
    evento_animal = relationship("EventoAnimal", back_populates="alertas")
