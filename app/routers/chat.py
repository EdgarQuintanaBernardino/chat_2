from fastapi import APIRouter, HTTPException
from app.models.schemas import ChatRequest, ChatResponse
from app.services import gemini_service

router = APIRouter(prefix="/chat", tags=["chat"])


@router.post("/", response_model=ChatResponse)
async def send_message(request: ChatRequest):
    if not request.message.strip():
        raise HTTPException(status_code=400, detail="El mensaje no puede estar vacío.")

    try:
        reply = await gemini_service.chat(request.message)
    except Exception as exc:
        raise HTTPException(status_code=502, detail=f"Error al consultar Gemini: {exc}")

    return ChatResponse(reply=reply)
