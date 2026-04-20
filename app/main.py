from contextlib import asynccontextmanager
from pathlib import Path
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.core.config import settings
from app.routers import chat, faqs
from app.services.faq_service import cargar_faqs
from app.models.schemas import HealthResponse


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Precarga las FAQs al iniciar el servidor
    faqs_cargadas = cargar_faqs()
    print(f"[startup] {len(faqs_cargadas)} preguntas frecuentes cargadas.")
    yield


app = FastAPI(
    title=settings.APP_TITLE,
    version=settings.APP_VERSION,
    description="Backend del chatbot de la SRE impulsado por Gemini 1.5 Flash",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS.split(","),
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(chat.router)
app.include_router(faqs.router)


@app.get("/health", response_model=HealthResponse, tags=["sistema"])
def health():
    return HealthResponse(
        status="ok",
        faqs_cargadas=len(cargar_faqs()),
        modelo=settings.GEMINI_MODEL,
    )
