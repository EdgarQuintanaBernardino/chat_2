from pydantic import BaseModel
from typing import Optional


class PreguntaFrecuente(BaseModel):
    id_pregunta: int
    tema: str
    subtema: str
    pregunta: str
    respuesta: str
    orden: Optional[int] = None


class ChatMessage(BaseModel):
    role: str  # "user" | "assistant"
    content: str


class ChatRequest(BaseModel):
    message: str
    history: list[ChatMessage] = []
    session_id: Optional[str] = None


class ChatResponse(BaseModel):
    reply: str
    session_id: str
    fuentes: list[str] = []


class HealthResponse(BaseModel):
    status: str
    faqs_cargadas: int
    modelo: str
