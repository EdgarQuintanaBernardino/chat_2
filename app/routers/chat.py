from fastapi import APIRouter, HTTPException
from fastapi.responses import StreamingResponse
from app.models.schemas import ChatRequest, ChatResponse
from app.services import gemini_service

router = APIRouter(prefix="/chat", tags=["chat"])


@router.post("/", response_model=ChatResponse)
async def send_message(request: ChatRequest):
    if not request.message.strip():
        raise HTTPException(status_code=400, detail="El mensaje no puede estar vacío.")

    try:
        reply, session_id, fuentes = await gemini_service.chat(
            message=request.message,
            history=request.history,
            session_id=request.session_id,
        )
    except Exception as exc:
        raise HTTPException(status_code=502, detail=f"Error al consultar Gemini: {exc}")

    return ChatResponse(reply=reply, session_id=session_id, fuentes=fuentes)


@router.post("/stream")
async def stream_message(request: ChatRequest):
    if not request.message.strip():
        raise HTTPException(status_code=400, detail="El mensaje no puede estar vacío.")

    return StreamingResponse(
        gemini_service.chat_stream(
            message=request.message,
            history=request.history,
            session_id=request.session_id,
        ),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "X-Accel-Buffering": "no",
        },
    )
