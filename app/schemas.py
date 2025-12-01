from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from enum import Enum


class EstadoEventoEnum(str, Enum):
    activo = "activo"
    cerrado = "cerrado"


# ============================================
# Mediciones
# ============================================

class MedicionBase(BaseModel):
    zona_id: int
    distancia_1: float
    distancia_2: float
    distancia_3: float
    distancia_4: float
    movimiento: bool
    luz: int
    humedad: float
    temperatura: float


class MedicionCreate(MedicionBase):
    pass


class MedicionResponse(MedicionBase):
    id: int
    hora: datetime
    evento_carro_id: Optional[int] = None
    
    class Config:
        from_attributes = True


# ============================================
# Eventos de Carro
# ============================================

class EventoCarroBase(BaseModel):
    zona_id: int
    sensor_inicial: int
    sensor_final: int
    estado: EstadoEventoEnum = EstadoEventoEnum.activo


class EventoCarroCreate(EventoCarroBase):
    pass


class EventoCarroResponse(EventoCarroBase):
    id: int
    hora_inicio: datetime
    hora_fin: Optional[datetime] = None
    
    class Config:
        from_attributes = True


# ============================================
# Eventos de Animal
# ============================================

class EventoAnimalBase(BaseModel):
    zona_id: int
    estado: EstadoEventoEnum = EstadoEventoEnum.activo


class EventoAnimalCreate(EventoAnimalBase):
    pass


class EventoAnimalResponse(EventoAnimalBase):
    id: int
    hora: datetime
    hora_fin: Optional[datetime] = None
    
    class Config:
        from_attributes = True


# ============================================
# Alertas
# ============================================

class AlertaBase(BaseModel):
    evento_carro_id: int
    evento_animal_id: int


class AlertaCreate(AlertaBase):
    pass


class AlertaResponse(AlertaBase):
    id: int
    hora: datetime
    
    class Config:
        from_attributes = True


# ============================================
# Zonas
# ============================================

class ZonaResponse(BaseModel):
    id: int
    nombre: str
    
    class Config:
        from_attributes = True
