# Chatbot SRE — Backend

Backend del chatbot de la Secretaría de Relaciones Exteriores (SRE) de México.  
Responde preguntas de ciudadanos mexicanos en el extranjero usando **Gemini 1.5 Flash** de Google como motor de lenguaje natural, con base en el catálogo oficial de preguntas frecuentes.

---

## ¿Qué hace el sistema?

1. **Al arrancar**, lee el archivo `preguntas_frecuentes.sql` y extrae las preguntas activas (las que tienen `baja_logica = 0`).
2. Construye un *system prompt* que le entrega **todo el catálogo de FAQs como contexto** al modelo de IA.
3. Expone una **API REST** con tres grupos de endpoints:
   - `/chat` — recibir mensajes del usuario y obtener respuestas del chatbot.
   - `/faqs` — consultar y filtrar el catálogo de preguntas frecuentes.
   - `/health` — verificar que el servicio está activo.
4. Gemini recibe la pregunta del usuario junto con el historial de la conversación y el catálogo completo, y responde **solo con información oficial**, sin inventar datos.

---

## Estructura del proyecto

```
chat_v2/
├── app/
│   ├── core/
│   │   └── config.py          # Variables de entorno (Settings con pydantic-settings)
│   ├── models/
│   │   └── schemas.py         # Modelos Pydantic (request/response)
│   ├── routers/
│   │   ├── chat.py            # POST /chat/
│   │   └── faqs.py            # GET /faqs/ y GET /faqs/temas
│   ├── services/
│   │   ├── faq_service.py     # Parseo del SQL y construcción del contexto
│   │   └── gemini_service.py  # Integración con la API de Gemini
│   └── main.py                # Punto de entrada FastAPI
├── preguntas_frecuentes.sql   # Datos originales exportados de MySQL
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env.example
└── README.md
```

---

## Requisitos previos

- **Docker** y **Docker Compose** instalados.
- Una **API Key de Google AI Studio**:  
  Obtén la tuya en https://aistudio.google.com/app/apikey (es gratuita para desarrollo).

---

## Instalación y arranque

### 1. Configurar variables de entorno

```bash
cp .env.example .env
```

Abre `.env` y pega tu API Key:

```
GEMINI_API_KEY=AIza...tu_clave_real
```

### 2. Levantar con Docker Compose

```bash
docker-compose up --build
```

El servidor estará disponible en: **http://localhost:8000**

Para detenerlo:

```bash
docker-compose down
```

### Arranque sin Docker (desarrollo local)

```bash
pip install -r requirements.txt
cp .env.example .env   # y edita GEMINI_API_KEY
uvicorn app.main:app --reload
```

---

## Endpoints de la API

La documentación interactiva (Swagger UI) está en:  
**http://localhost:8000/docs**

### `POST /chat/`

Envía un mensaje al chatbot. Devuelve la respuesta del modelo.

**Body:**
```json
{
  "message": "¿Qué hago si pierdo mi pasaporte en el extranjero?",
  "history": [],
  "session_id": null
}
```

**Respuesta:**
```json
{
  "reply": "Debe reportar el hecho a la policía local...",
  "session_id": "uuid-generado-automaticamente",
  "fuentes": ["Protección / Documentación"]
}
```

**Conversaciones con historial:**  
Reutiliza el `session_id` devuelto y agrega los mensajes anteriores en `history` para que el modelo recuerde el contexto de la conversación.

```json
{
  "message": "¿Y si ya lo reporté?",
  "session_id": "uuid-de-la-respuesta-anterior",
  "history": [
    { "role": "user", "content": "¿Qué hago si pierdo mi pasaporte?" },
    { "role": "assistant", "content": "Debe reportar el hecho a la policía..." }
  ]
}
```

---

### `GET /faqs/`

Lista todas las preguntas frecuentes activas. Acepta filtros opcionales.

| Parámetro | Tipo   | Descripción              |
|-----------|--------|--------------------------|
| `tema`    | string | Filtra por tema          |
| `subtema` | string | Filtra por subtema       |

Ejemplo: `GET /faqs/?tema=Proteccion`

---

### `GET /faqs/temas`

Devuelve la lista de temas disponibles en el catálogo.

```json
["Asuntos consulares", "Protección", "Sistema de registro"]
```

---

### `GET /health`

Verifica el estado del servicio.

```json
{
  "status": "ok",
  "faqs_cargadas": 22,
  "modelo": "gemini-1.5-flash"
}
```

---

## ¿Cómo funciona por dentro?

### Carga de FAQs (`faq_service.py`)

Al iniciarse el servidor, se lee `preguntas_frecuentes.sql` con un parser propio que:
- Extrae las filas del `INSERT INTO` sin necesitar una base de datos MySQL.
- Filtra los registros con `baja_logica = '1'` (inactivos).
- Limpia etiquetas HTML de las respuestas para que el modelo de IA reciba texto plano.
- Almacena el resultado en memoria para no releer el archivo en cada petición.

### Integración con Gemini (`gemini_service.py`)

Cada llamada al endpoint `/chat/`:
1. Construye el historial de conversación en el formato que espera Gemini.
2. Inicia una sesión de chat con `start_chat(history=...)`.
3. Envía el mensaje con `send_message(message)`.
4. Retorna la respuesta de texto y los temas del catálogo que podrían ser relevantes como `fuentes`.

El **system prompt** le indica al modelo que:
- Responda solo en español.
- Use exclusivamente la información del catálogo.
- No invente datos ni incluya HTML.

### Configuración (`config.py`)

Usa `pydantic-settings` para leer variables del archivo `.env`.  
Las únicas variables obligatorias son:

| Variable         | Descripción                              |
|------------------|------------------------------------------|
| `GEMINI_API_KEY` | Clave de API de Google AI Studio         |
| `GEMINI_MODEL`   | Modelo a usar (default: gemini-1.5-flash)|
| `CORS_ORIGINS`   | Orígenes CORS permitidos (default: *)    |

---

## Temas cubiertos por el chatbot

El catálogo cargado cubre las siguientes categorías:

| Tema                  | Subtemas                                          |
|-----------------------|---------------------------------------------------|
| Protección            | Documentación, Legal, Asuntos migratorios         |
| Asuntos consulares    | Documentación, Asuntos migratorios                |
| Sistema de registro   | Registro, Modificación, Familiares, Contacto      |

---

## Próximos pasos sugeridos

- **Base de datos**: migrar las FAQs a PostgreSQL para poder editarlas sin tocar el SQL.
- **Memoria persistente de sesión**: guardar historial en Redis para sobrevivir reinicios.
- **Autenticación**: agregar JWT si el chatbot se expone públicamente.
- **Google Calendar / Gmail**: integrar los servicios de Google para agendar citas consulares directamente desde el chat.
# chat_2
