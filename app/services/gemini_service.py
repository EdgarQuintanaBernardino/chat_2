import asyncio
import logging
from google import genai
from google.genai import types
from app.core.config import settings
from app.services.faq_service import cargar_faqs

logger = logging.getLogger(__name__)

NO_MATCH = "No cuento con información sobre ese tema. Por favor contacta a la Embajada o Consulado de México más cercano."

_client: genai.Client | None = None
_system_prompt: str | None = None


def _get_client() -> genai.Client:
    global _client
    if _client is None:
        _client = genai.Client(api_key=settings.GEMINI_API_KEY)
    return _client


def init_system_prompt() -> None:
    global _system_prompt
    if _system_prompt:
        return
    faqs = cargar_faqs()
    faq_block = "\n\n".join(f"P: {faq.pregunta}\nR: {faq.respuesta}" for faq in faqs)
    _system_prompt = (
        f'Eres un asistente consular de la Embajada de México en Honduras.\n'
        f'Responde de forma breve y directa basándote ÚNICAMENTE en las siguientes preguntas frecuentes.\n'
        f'Si la pregunta no corresponde, responde: "{NO_MATCH}"\n\n'
        f'{faq_block}'
    )
    logger.info("[PROMPT] System prompt listo con %d FAQs", len(faqs))


async def chat(message: str) -> str:
    client = _get_client()
    loop = asyncio.get_event_loop()

    last_exc: Exception | None = None
    for intento in range(1, 4):  # hasta 3 intentos
        try:
            response = await loop.run_in_executor(
                None,
                lambda: client.models.generate_content(
                    model=settings.GEMINI_MODEL,
                    contents=message,
                    config=types.GenerateContentConfig(
                        system_instruction=_system_prompt,
                        temperature=0.0,
                        max_output_tokens=512,
                    ),
                ),
            )
            logger.info("[CHAT] mensaje=%r | chars=%d", message[:80], len(response.text))
            return response.text.strip()
        except Exception as exc:
            last_exc = exc
            if "503" in str(exc) or "UNAVAILABLE" in str(exc):
                logger.warning("[CHAT] Intento %d/3 falló (503), reintentando en %ds...", intento, intento)
                await asyncio.sleep(intento)  # 1s, 2s, 3s
            else:
                raise  # error distinto, no reintentar

    raise last_exc
