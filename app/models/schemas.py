from pydantic import BaseModel
from typing import Optional


class PreguntaFrecuente(BaseModel):
    id_pregunta: int
    tema: str
    subtema: str
    pregunta: str
    respuesta: str
    orden: Optional[int] = None


class ChatRequest(BaseModel):
    message: str


class ChatResponse(BaseModel):
    reply: str


class HealthResponse(BaseModel):
    status: str
    faqs_cargadas: int
    modelo: str
