import logging
from pathlib import Path
from app.models.schemas import PreguntaFrecuente

logger = logging.getLogger(__name__)

_faqs: list[PreguntaFrecuente] = []


def cargar_faqs(ruta_md: str | None = None) -> list[PreguntaFrecuente]:
    global _faqs

    if _faqs:
        return _faqs

    if ruta_md is None:
        base = Path(__file__).resolve().parents[2]
        ruta_md = str(base / "preguntas_honduras.md")

    _faqs = _parse_md(ruta_md)
    logger.info("[FAQ] %d preguntas cargadas desde MD", len(_faqs))
    return _faqs


def _parse_md(ruta: str) -> list[PreguntaFrecuente]:
    with open(ruta, encoding="utf-8") as f:
        lines = [l.rstrip() for l in f]

    faqs: list[PreguntaFrecuente] = []
    id_counter = 1
    current_q: str = ""
    current_a: list[str] = []

    def save():
        nonlocal id_counter
        q = current_q.strip()
        a = " ".join(current_a).strip()
        if q and a:
            faqs.append(PreguntaFrecuente(
                id_pregunta=id_counter,
                tema="Asuntos consulares",
                subtema="General",
                pregunta=q,
                respuesta=a,
                orden=id_counter,
            ))
            id_counter += 1

    for line in lines:
        stripped = line.strip()

        # Encabezados H2 que contienen una pregunta (¿)
        if stripped.startswith("## ") and "¿" in stripped:
            save()
            current_q = stripped[3:].strip()
            current_a = []
        # Ignorar H1, H3+ y separadores
        elif stripped.startswith("#") or stripped == "---":
            continue
        # Líneas de contenido (respuesta)
        elif stripped:
            current_a.append(stripped)

    save()
    return faqs


def obtener_contexto_faqs() -> str:
    faqs = cargar_faqs()
    lineas = ["=== PREGUNTAS FRECUENTES ===\n"]
    for faq in faqs:
        lineas.append(
            f"id_pregunta: {faq.id_pregunta}\n"
            f"P: {faq.pregunta}\n"
        )
    return "\n".join(lineas)


def obtener_faq_por_id(id_pregunta: int):
    faqs = cargar_faqs()
    for faq in faqs:
        if faq.id_pregunta == id_pregunta:
            return faq
    return None
