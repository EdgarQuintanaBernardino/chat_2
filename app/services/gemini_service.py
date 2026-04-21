import uuid
import json
import asyncio
import logging
import threading
from google import genai
from google.genai import types
from app.core.config import settings
from app.services.faq_service import obtener_contexto_faqs, cargar_faqs, obtener_faq_por_id
from app.models.schemas import ChatMessage

logger = logging.getLogger(__name__)

MATCH_PROMPT = """Eres un clasificador de preguntas frecuentes.

Se te dará una pregunta del usuario y una lista de FAQs numeradas por id_pregunta.
Responde ÚNICAMENTE con el id_pregunta (número entero) de la FAQ que mejor responda la pregunta del usuario.
Si ninguna FAQ es relevante, responde exactamente: 0

No expliques nada, solo el número.

{contexto_faqs}
"""

NO_MATCH = "No cuento con información sobre ese tema. Por favor contacta a la Embajada o Consulado de México más cercano."


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
            max_output_tokens=8192,
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
    system_instruction = MATCH_PROMPT.format(contexto_faqs=obtener_contexto_faqs())

    response = client.models.generate_content(
        model=settings.GEMINI_MODEL,
        contents=message,
        config=types.GenerateContentConfig(
            system_instruction=system_instruction,
            temperature=0.0,
            max_output_tokens=16,
        ),
    )

    raw = response.text.strip()
    logger.info("[CHAT] mensaje=%r | id_match=%r", message[:80], raw)

    try:
        id_match = int(raw)
    except ValueError:
        id_match = 0

    if id_match == 0:
        return NO_MATCH, session_id, []

    faq = obtener_faq_por_id(id_match)
    if faq is None:
        logger.warning("[CHAT] id_match=%d no encontrado en FAQs", id_match)
        return NO_MATCH, session_id, []

    logger.info("[CHAT] FAQ encontrada id=%d | respuesta chars=%d", faq.id_pregunta, len(faq.respuesta))
    return faq.respuesta, session_id, [f"{faq.tema} / {faq.subtema}"]


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
