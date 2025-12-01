import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, Depends, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db, engine, Base
from app.models import Zona, Medicion, EventoCarro, EventoAnimal, Alerta
from app.schemas import (
    MedicionCreate, MedicionResponse,
    EventoCarroResponse, EventoAnimalResponse,
    AlertaResponse, ZonaResponse
)
from app.processador import procesar_medicion
from app.config import settings
from app.worker import iniciar_worker_background

logger = logging.getLogger(__name__)

# Crear tablas
Base.metadata.create_all(bind=engine)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Contexto de ciclo de vida de la aplicación.
    - Startup: Inicia el worker de procesamiento en background
    - Shutdown: Limpia recursos
    """
    # Startup
    if settings.WORKER_ENABLED:
        logger.info("Iniciando worker de procesamiento en background...")
        iniciar_worker_background()
    else:
        logger.info("Worker de procesamiento deshabilitado")
    
    yield
    
    # Shutdown
    logger.info("Aplicación siendo detenida...")


app = FastAPI(
    title=settings.APP_NAME,
    debug=settings.DEBUG,
    lifespan=lifespan
)

# CORS middleware para permitir frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, usar ["http://localhost:3000", ...]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================
# Mediciones
# ============================================

@app.post("/mediciones", response_model=MedicionResponse)
def crear_medicion(
    medicion_data: MedicionCreate,
    db: Session = Depends(get_db)
):
    """
    Recibe una medición cruda, la guarda en BD y procesa automáticamente.
    """
    # Crear medición
    medicion = Medicion(**medicion_data.model_dump())
    db.add(medicion)
    db.flush()
    
    # Procesar medición (genera eventos y alertas)
    evento_carro, evento_animal, alerta = procesar_medicion(db, medicion)
    
    db.commit()
    db.refresh(medicion)
    
    return medicion


@app.get("/mediciones/{zona_id}", response_model=List[MedicionResponse])
def listar_mediciones(
    zona_id: int,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """
    Lista las mediciones más recientes de una zona.
    """
    mediciones = db.query(Medicion).filter(
        Medicion.zona_id == zona_id
    ).order_by(Medicion.hora.desc()).limit(limit).all()
    
    return mediciones


# ============================================
# Eventos de Carro
# ============================================

@app.get("/api/eventos-carros", response_model=List[EventoCarroResponse])
def listar_eventos_carros(
    zona_id: int = Query(..., description="ID de la zona"),
    limit: int = Query(100, description="Límite de registros"),
    db: Session = Depends(get_db)
):
    """
    Lista los eventos de carros de una zona.
    """
    eventos = db.query(EventoCarro).filter(
        EventoCarro.zona_id == zona_id
    ).order_by(EventoCarro.hora_inicio.desc()).limit(limit).all()
    
    return eventos


@app.get("/eventos-carros/{zona_id}", response_model=List[EventoCarroResponse])
def listar_eventos_carros_legacy(
    zona_id: int,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """
    Lista los eventos de carros de una zona. (Endpoint legacy)
    """
    eventos = db.query(EventoCarro).filter(
        EventoCarro.zona_id == zona_id
    ).order_by(EventoCarro.hora_inicio.desc()).limit(limit).all()
    
    return eventos


@app.get("/eventos-carros/{zona_id}/activos", response_model=List[EventoCarroResponse])
def listar_eventos_carros_activos(
    zona_id: int,
    db: Session = Depends(get_db)
):
    """
    Lista solo los eventos de carros ACTIVOS en una zona.
    """
    from app.models import EstadoEvento
    
    eventos = db.query(EventoCarro).filter(
        EventoCarro.zona_id == zona_id,
        EventoCarro.estado == "activo"
    ).all()
    
    return eventos


# ============================================
# Eventos de Animal
# ============================================

@app.get("/api/eventos-animales", response_model=List[EventoAnimalResponse])
def listar_eventos_animales(
    zona_id: int = Query(..., description="ID de la zona"),
    limit: int = Query(100, description="Límite de registros"),
    db: Session = Depends(get_db)
):
    """
    Lista los eventos de animales de una zona.
    """
    eventos = db.query(EventoAnimal).filter(
        EventoAnimal.zona_id == zona_id
    ).order_by(EventoAnimal.hora.desc()).limit(limit).all()
    
    return eventos


@app.get("/eventos-animales/{zona_id}", response_model=List[EventoAnimalResponse])
def listar_eventos_animales_legacy(
    zona_id: int,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """
    Lista los eventos de animales de una zona. (Endpoint legacy)
    """
    eventos = db.query(EventoAnimal).filter(
        EventoAnimal.zona_id == zona_id
    ).order_by(EventoAnimal.hora.desc()).limit(limit).all()
    
    return eventos


@app.get("/eventos-animales/{zona_id}/activos", response_model=List[EventoAnimalResponse])
def listar_eventos_animales_activos(
    zona_id: int,
    db: Session = Depends(get_db)
):
    """
    Lista solo los eventos de animales ACTIVOS en una zona.
    """
    from app.models import EstadoEvento
    
    eventos = db.query(EventoAnimal).filter(
        EventoAnimal.zona_id == zona_id,
        EventoAnimal.estado == "activo"
    ).all()
    
    return eventos


# ============================================
# Alertas
# ============================================

@app.get("/api/alertas", response_model=List[AlertaResponse])
def listar_alertas(
    zona_id: int = Query(..., description="ID de la zona"),
    limit: int = Query(100, description="Límite de registros"),
    db: Session = Depends(get_db)
):
    """
    Lista las alertas únicas (carro + animal) de una zona.
    Retorna solo alertas por evento_carro único (sin duplicados).
    """
    # Subquery para obtener la alerta más reciente por evento_carro
    alertas = db.query(Alerta).join(
        EventoCarro,
        Alerta.evento_carro_id == EventoCarro.id
    ).filter(
        EventoCarro.zona_id == zona_id
    ).order_by(Alerta.hora.desc()).limit(limit).all()
    
    # Deduplicate by evento_carro_id (mantener la más reciente)
    seen = set()
    unique_alertas = []
    for alerta in alertas:
        if alerta.evento_carro_id not in seen:
            seen.add(alerta.evento_carro_id)
            unique_alertas.append(alerta)
    
    return unique_alertas


@app.get("/alertas/{zona_id}", response_model=List[AlertaResponse])
def listar_alertas_legacy(
    zona_id: int,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """
    Lista las alertas (carro + animal) de una zona. (Endpoint legacy)
    """
    alertas = db.query(Alerta).join(
        EventoCarro,
        Alerta.evento_carro_id == EventoCarro.id
    ).filter(
        EventoCarro.zona_id == zona_id
    ).order_by(Alerta.hora.desc()).limit(limit).all()
    
    # Deduplicate by evento_carro_id
    seen = set()
    unique_alertas = []
    for alerta in alertas:
        if alerta.evento_carro_id not in seen:
            seen.add(alerta.evento_carro_id)
            unique_alertas.append(alerta)
    
    return unique_alertas


# ============================================
# Zonas
# ============================================

@app.get("/api/zonas", response_model=List[ZonaResponse])
def listar_zonas(db: Session = Depends(get_db)):
    """
    Lista todas las zonas.
    """
    zonas = db.query(Zona).all()
    return zonas


@app.get("/zonas", response_model=List[ZonaResponse])
def listar_zonas_legacy(db: Session = Depends(get_db)):
    """
    Lista todas las zonas. (Endpoint legacy)
    """
    zonas = db.query(Zona).all()
    return zonas


@app.post("/zonas", response_model=ZonaResponse)
def crear_zona(
    nombre: str,
    db: Session = Depends(get_db)
):
    """
    Crea una nueva zona de monitoreo.
    """
    zona = Zona(nombre=nombre)
    db.add(zona)
    db.commit()
    db.refresh(zona)
    return zona


# ============================================
# Health Check
# ============================================

@app.get("/health")
def health_check():
    """
    Verifica que el servidor esté corriendo.
    """
    return {"status": "ok", "app": settings.APP_NAME}
