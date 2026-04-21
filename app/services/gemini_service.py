import uuid
import json
import asyncio
import logging
import threading
from google import genai
from google.genai import types
from app.core.config import settings
from app.services.faq_service import obtener_contexto_faqs, cargar_faqs
from app.models.schemas import ChatMessage

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

SYSTEM_PROMPT = """Eres un asistente de consulta del catálogo de preguntas frecuentes de la SRE (Secretaría de Relaciones Exteriores de México).

INSTRUCCIONES ESTRICTAS:
- SOLO puedes responder usando la información del catálogo que se te proporciona a continuación.
- Si la pregunta no está en el catálogo, responde exactamente: "No cuento con información sobre ese tema. Por favor contacta a la Embajada o Consulado de México más cercano."
- NO agregues información propia, NO elabores, NO supongas nada fuera del catálogo.
- Responde en español, de forma clara y directa.
- Sin etiquetas HTML, solo texto plano.

{contexto_faqs}
"""


def _get_client() -> genai.Client:
    return genai.Client(api_key=settings.GEMINI_API_KEY)


def _build_history(history: list[ChatMessage]) -> list[types.Content]:
    result = []
    for msg in history:
        role = "user" if msg.role == "user" else "model"
        result.append(types.Content(role=role, parts=[types.Part(text=msg.content)]))
    return result


def _make_chat_session(client: genai.Client, history: list[types.Content]):
    system_instruction = SYSTEM_PROMPT.format(contexto_faqs=obtener_contexto_faqs())
    return client.chats.create(
        model=settings.GEMINI_MODEL,
        config=types.GenerateContentConfig(
            system_instruction=system_instruction,
            temperature=0.0,
            max_output_tokens=2048,
        ),
        history=history,
    )


async def chat(
    message: str,
    history: list[ChatMessage],
    session_id: str | None,
) -> tuple[str, str, list[str]]:
    if not session_id:
        session_id = str(uuid.uuid4())

    client = _get_client()
    gemini_history = _build_history(history)
    chat_session = _make_chat_session(client, gemini_history)

    response = chat_session.send_message(message)
    reply = response.text.strip()

    try:
        candidate = response.candidates[0]
        finish_reason = candidate.finish_reason
        token_count = response.usage_metadata.candidates_token_count if response.usage_metadata else "N/A"
        logger.info(
            "[CHAT] mensaje=%r | finish_reason=%s | tokens_respuesta=%s | chars_respuesta=%d | respuesta=%r",
            message[:80],
            finish_reason,
            token_count,
            len(reply),
            reply[:200],
        )
        if str(finish_reason) in ("FinishReason.MAX_TOKENS", "MAX_TOKENS", "2"):
            logger.warning("[CHAT] RESPUESTA CORTADA POR LIMITE DE TOKENS")
    except Exception as log_exc:
        logger.warning("[CHAT] No se pudo leer metadata: %s", log_exc)

    faqs = cargar_faqs()
    fuentes: set[str] = set()
    for faq in faqs:
        if any(
            palabra.lower() in message.lower()
            for palabra in faq.pregunta.split()
            if len(palabra) > 4
        ):
            fuentes.add(f"{faq.tema} / {faq.subtema}")

    return reply, session_id, sorted(fuentes)[:3]


async def chat_stream(
    message: str,
    history: list[ChatMessage],
    session_id: str | None,
):
    """
    Async generator para SSE.
    Corre el streaming síncrono de Gemini en un thread separado y
    pasa los chunks al event loop vía asyncio.Queue.
    """
    if not session_id:
        session_id = str(uuid.uuid4())

    client = _get_client()
    gemini_history = _build_history(history)
    chat_session = _make_chat_session(client, gemini_history)

    yield f"data: {json.dumps({'type': 'session', 'session_id': session_id})}\n\n"

    queue: asyncio.Queue = asyncio.Queue()
    loop = asyncio.get_event_loop()

    def _run_sync_stream():
        try:
            for chunk in chat_session.send_message_stream(message):
                if chunk.text:
                    loop.call_soon_threadsafe(queue.put_nowait, ("chunk", chunk.text))
        except Exception as exc:
            loop.call_soon_threadsafe(queue.put_nowait, ("error", str(exc)))
        finally:
            loop.call_soon_threadsafe(queue.put_nowait, ("done", None))

    threading.Thread(target=_run_sync_stream, daemon=True).start()

    while True:
        event_type, data = await queue.get()
        if event_type == "chunk":
            yield f"data: {json.dumps({'type': 'chunk', 'text': data})}\n\n"
        elif event_type == "error":
            yield f"data: {json.dumps({'type': 'error', 'message': data})}\n\n"
            break
        elif event_type == "done":
            break

    yield f"data: {json.dumps({'type': 'done'})}\n\n"
