from fastapi import APIRouter, Query
from app.models.schemas import PreguntaFrecuente
from app.services.faq_service import cargar_faqs

router = APIRouter(prefix="/faqs", tags=["faqs"])


@router.get("/", response_model=list[PreguntaFrecuente])
def listar_faqs(
    tema: str | None = Query(default=None, description="Filtrar por tema"),
    subtema: str | None = Query(default=None, description="Filtrar por subtema"),
):
    faqs = cargar_faqs()
    if tema:
        faqs = [f for f in faqs if tema.lower() in f.tema.lower()]
    if subtema:
        faqs = [f for f in faqs if subtema.lower() in f.subtema.lower()]
    return faqs


@router.get("/temas", response_model=list[str])
def listar_temas():
    faqs = cargar_faqs()
    return sorted({f.tema for f in faqs})
