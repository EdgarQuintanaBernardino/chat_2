import re
import os
from pathlib import Path
from app.models.schemas import PreguntaFrecuente

_faqs: list[PreguntaFrecuente] = []


def _limpiar_html(texto: str) -> str:
    """Elimina etiquetas HTML y decodifica entidades básicas."""
    texto = re.sub(r"<[^>]+>", " ", texto)
    texto = texto.replace("&amp;", "&").replace("&lt;", "<").replace("&gt;", ">")
    return re.sub(r"\s+", " ", texto).strip()


def cargar_faqs(ruta_sql: str | None = None) -> list[PreguntaFrecuente]:
    global _faqs

    if _faqs:
        return _faqs

    if ruta_sql is None:
        base = Path(__file__).resolve().parents[2]
        ruta_sql = str(base / "preguntas_honduras.sql")

    with open(ruta_sql, encoding="latin-1") as f:
        contenido = f.read()

    # Extraer bloque VALUES del INSERT
    patron = re.compile(
        r"INSERT INTO `preguntas_frecuentes`.*?VALUES\s*(.*?);",
        re.DOTALL | re.IGNORECASE,
    )
    match = patron.search(contenido)
    if not match:
        return []

    bloque_valores = match.group(1)

    # Cada fila: (val1, val2, ...)
    patron_fila = re.compile(r"\(([^)]*(?:'[^']*'[^)]*)*)\)")

    for m in patron_fila.finditer(bloque_valores):
        raw = m.group(1)
        # Separar campos respetando strings entre comillas simples
        campos = _split_sql_row(raw)
        if len(campos) < 7:
            continue

        baja = campos[6].strip().strip("'")
        if baja == "1":  # baja lógica activa → no cargar
            continue

        orden_raw = campos[5].strip()
        orden = int(orden_raw) if orden_raw.lstrip("-").isdigit() else None

        faq = PreguntaFrecuente(
            id_pregunta=int(campos[0].strip()),
            tema=campos[1].strip().strip("'"),
            subtema=campos[2].strip().strip("'"),
            pregunta=_limpiar_html(campos[3].strip().strip("'")),
            respuesta=_limpiar_html(campos[4].strip().strip("'")),
            orden=orden,
        )
        _faqs.append(faq)

    return _faqs


def _split_sql_row(row: str) -> list[str]:
    """Divide una fila SQL respetando strings entre comillas simples."""
    campos = []
    actual = ""
    dentro_str = False
    i = 0
    while i < len(row):
        c = row[i]
        if c == "'" and not dentro_str:
            dentro_str = True
            actual += c
        elif c == "'" and dentro_str:
            if i + 1 < len(row) and row[i + 1] == "'":
                actual += "'"
                i += 1
            else:
                dentro_str = False
                actual += c
        elif c == "," and not dentro_str:
            campos.append(actual)
            actual = ""
        else:
            actual += c
        i += 1
    campos.append(actual)
    return campos


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
