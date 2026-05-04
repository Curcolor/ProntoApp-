"""
Bot de Telegram para ProntoApp.
Recibe pedidos de clientes, los procesa con DeepSeek y los guarda
en el servidor FastAPI local para que la app Flutter los muestre.

Ejecutar con:
    python bot_telegram.py
"""
import json
import logging
import os
import re
from collections import defaultdict

import httpx
from dotenv import load_dotenv
from openai import OpenAI
from telegram import (
    ForceReply,
    InlineKeyboardButton,
    InlineKeyboardMarkup,
    ParseMode,
    Update,
)
from telegram.error import BadRequest
from telegram.ext import (
    CallbackContext,
    CallbackQueryHandler,
    CommandHandler,
    Filters,
    MessageHandler,
    Updater,
)

load_dotenv()

# ─── Configuración ────────────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.INFO,
    format="[%(levelname)s %(asctime)s] %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)

TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")
DEEPSEEK_API_KEY = os.getenv("DEEPSEEK_API_KEY", "")
FASTAPI_URL = os.getenv("FASTAPI_URL", "http://localhost:5050")
SECRETO = os.getenv("TELEGRAM_WEBHOOK_SECRET", "")

if not TOKEN:
    raise RuntimeError("TELEGRAM_BOT_TOKEN no está configurado en .env")
if not DEEPSEEK_API_KEY:
    raise RuntimeError("DEEPSEEK_API_KEY no está configurado en .env")

# Cliente DeepSeek (compatible con la API de OpenAI)
cliente_ia = OpenAI(
    api_key=DEEPSEEK_API_KEY,
    base_url="https://api.deepseek.com",
)

# Historial de conversación por chat_id (últimos 12 mensajes)
conversaciones: dict[int, list[dict]] = defaultdict(list)

CABECERAS_API = {"X-Secret": SECRETO} if SECRETO else {}


# ─── Inventario ───────────────────────────────────────────────────────────────

def _obtener_menu_texto() -> str:
    """Obtiene el menú real del FastAPI y lo convierte en texto para el prompt."""
    try:
        respuesta = httpx.get(
            f"{FASTAPI_URL}/inventario",
            headers=CABECERAS_API,
            timeout=5,
        )
        if respuesta.status_code != 200:
            return "Menú no disponible en este momento."

        inventario = respuesta.json()
        productos = inventario.get("productos", [])
        categorias = {c["id"]: c for c in inventario.get("categorias", [])}

        if not productos:
            return "El menú aún no tiene productos cargados."

        lineas = ["🍽️ Menú disponible:\n"]
        cat_actual = None

        for producto in productos:
            if not producto.get("isAvailable", True):
                continue
            if producto.get("stock", 1) == 0:
                continue

            cat_id = producto.get("categoryId", "")
            cat = categorias.get(cat_id, {})
            cat_nombre = f"{cat.get('emoji', '')} {cat.get('name', 'General')}".strip()

            if cat_nombre != cat_actual:
                lineas.append(f"\n{cat_nombre}:")
                cat_actual = cat_nombre

            precio = producto.get("price", 0)
            nombre = producto.get("name", "")
            emoji = producto.get("emoji", "•")
            stock = producto.get("stock", 0)
            lineas.append(f"  {emoji} {nombre} — ${precio:,.0f} (Stock: {stock} disponibles)")

        return "\n".join(lineas)

    except Exception as error:
        logger.warning(f"No se pudo obtener el inventario del FastAPI: {error}")
        return "El menú no está disponible en este momento. Por favor contáctanos."


# ─── Prompt del sistema ───────────────────────────────────────────────────────

def _construir_system_prompt() -> str:
    """Construye el prompt del sistema con el menú actual del inventario."""
    menu = _obtener_menu_texto()

    return f"""Eres el asistente de pedidos de ProntoApp, una panadería y cafetería.
Tu nombre es "Pronto" y eres amable, conciso y eficiente.

{menu}

Tu misión:
1. Ayuda al cliente a armar su pedido usando SOLO los productos del menú.
2. Confirma los ítems, cantidades y tipo de entrega (domicilio o para recoger en tienda).
3. Si es domicilio, solicita la dirección de entrega.
4. Cuando el pedido esté COMPLETAMENTE confirmado por el cliente,
   responde ÚNICAMENTE con este JSON (sin texto adicional ni backticks):

{{"pedido_confirmado": true, "cliente": "<nombre o 'Cliente'>", "telefono": "<tg:chat_id>",
  "items": [{{"nombre": "<nombre producto>", "cantidad": <N>, "precio": <precio unitario>}}],
  "tipo": "<domicilio|recoger>", "direccion": "<dirección o null>", "total": <suma total>}}

Reglas importantes:
- Solo incluye productos que están en el menú.
- NUNCA permitas pedir más cantidad de la que hay disponible en el (Stock: X).
- Si un producto no está disponible o el cliente pide más del stock, discúlpate y sugiere una alternativa.
- No inventes precios; usa los del menú exactamente.
- SIEMPRE pregúntale el nombre al cliente si aún no lo sabes, es obligatorio para ponerlo en el pedido.
- NUNCA uses formato de negrita (asteriscos dobles como **palabra**) en tus respuestas. Escribe texto plano.
- Antes de enviar el JSON, confirma el pedido con el cliente y espera su "sí" o confirmación.
- Responde siempre en español, de forma cálida y profesional.
- Sé breve: máximo 3 oraciones por respuesta (excepto cuando listas el menú).
"""


# ─── Procesamiento con DeepSeek ───────────────────────────────────────────────

def _procesar_con_deepseek(chat_id: int, texto_usuario: str, nombre_usuario: str) -> str:
    """
    Envía el mensaje al modelo DeepSeek y devuelve la respuesta.
    Mantiene el historial de conversación por chat_id.
    """
    historial = conversaciones[chat_id]

    # Agregar mensaje del usuario al historial
    historial.append({"role": "user", "content": texto_usuario})

    # Limitar historial a los últimos 12 mensajes (6 turnos)
    if len(historial) > 12:
        historial[:] = historial[-12:]

    mensajes = [
        {"role": "system", "content": _construir_system_prompt()},
        *historial,
    ]

    try:
        completion = cliente_ia.chat.completions.create(
            model="deepseek-chat",
            messages=mensajes,
            temperature=0.7,
            max_tokens=800,
        )
        respuesta = completion.choices[0].message.content or ""

        # Guardar respuesta del asistente en el historial
        historial.append({"role": "assistant", "content": respuesta})

        return respuesta.strip()

    except Exception as error:
        logger.error(f"Error llamando a DeepSeek: {error}")
        return "Lo siento, tuve un problema procesando tu mensaje. Por favor intenta nuevamente."


# ─── Detección y envío de pedido ─────────────────────────────────────────────

def _extraer_pedido_confirmado(texto: str) -> dict | None:
    """Detecta si la respuesta de DeepSeek contiene un pedido confirmado en JSON."""
    # Intentar parsear directamente (si la respuesta ES el JSON)
    texto_limpio = texto.strip()

    # Eliminar code fences si los hay
    match_fence = re.match(r"^```(?:json)?\s*(.*?)\s*```$", texto_limpio, re.DOTALL)
    if match_fence:
        texto_limpio = match_fence.group(1)

    # Buscar un bloque JSON con pedido_confirmado
    match_json = re.search(r'\{[^{}]*"pedido_confirmado"\s*:\s*true[^{}]*\}', texto_limpio, re.DOTALL)
    if match_json:
        try:
            return json.loads(match_json.group(0))
        except json.JSONDecodeError:
            pass

    # Intentar parsear el texto completo como JSON
    if texto_limpio.startswith("{") and "pedido_confirmado" in texto_limpio:
        try:
            datos = json.loads(texto_limpio)
            if datos.get("pedido_confirmado"):
                return datos
        except json.JSONDecodeError:
            pass

    return None


def _enviar_pedido_a_api(pedido_json: dict, chat_id: int) -> bool:
    """Envía el pedido confirmado al servidor FastAPI."""
    try:
        payload = {
            "cliente": pedido_json.get("cliente", "Cliente Telegram"),
            "telefono": f"tg:{chat_id}|{pedido_json.get('telefono', '')}",
            "items": pedido_json.get("items", []),
            "total": float(pedido_json.get("total", 0)),
            "tipo": pedido_json.get("tipo", "recoger"),
            "direccion": pedido_json.get("direccion"),
        }

        respuesta = httpx.post(
            f"{FASTAPI_URL}/pedidos",
            json=payload,
            headers=CABECERAS_API,
            timeout=10,
        )

        if respuesta.status_code == 201:
            datos = respuesta.json()
            logger.info(f"✅ Pedido guardado: {datos.get('id')} para {payload['cliente']}")
            return True

        logger.error(f"FastAPI rechazó el pedido: {respuesta.status_code} — {respuesta.text}")
        return False

    except Exception as error:
        logger.error(f"Error enviando pedido al FastAPI: {error}")
        return False


# ─── Handlers del bot ─────────────────────────────────────────────────────────

def cmd_start(update: Update, context: CallbackContext) -> None:
    """Comando /start — saludo inicial."""
    usuario = update.effective_user
    nombre = usuario.first_name if usuario else "amigo"
    chat_id = update.effective_chat.id

    # Limpiar historial al iniciar
    conversaciones[chat_id].clear()

    update.message.reply_text(
        f"¡Hola {nombre}! 👋 Soy *Pronto*, el asistente de ProntoApp.\n\n"
        "Puedes pedirme lo que desees o escribir *menú* para ver nuestros productos. 😊",
        parse_mode=ParseMode.MARKDOWN,
        reply_markup=ForceReply(selective=True),
    )


def cmd_menu(update: Update, context: CallbackContext) -> None:
    """Comando /menu — muestra el menú del inventario."""
    menu = _obtener_menu_texto()
    update.message.reply_text(
        f"{menu}\n\n_¿Qué te gustaría ordenar?_",
        parse_mode=ParseMode.MARKDOWN,
    )


def cmd_cancelar(update: Update, context: CallbackContext) -> None:
    """Comando /cancelar — resetea la conversación."""
    chat_id = update.effective_chat.id
    conversaciones[chat_id].clear()
    update.message.reply_text(
        "Pedido cancelado. Cuando quieras empezar de nuevo, escríbeme. 😊"
    )


def manejar_mensaje(update: Update, context: CallbackContext) -> None:
    """Handler principal — procesa mensajes con DeepSeek."""
    mensaje = update.message
    if not mensaje or not mensaje.text:
        return

    chat_id = mensaje.chat_id
    texto = mensaje.text.strip()
    usuario = mensaje.from_user
    nombre = getattr(usuario, "first_name", f"tg:{chat_id}")

    logger.info(f"💬 [{chat_id}] {nombre}: {texto[:80]}")

    # Enviar "escribiendo..." mientras procesa
    context.bot.send_chat_action(chat_id=chat_id, action="typing")

    respuesta = _procesar_con_deepseek(chat_id, texto, nombre)

    # Detectar si la respuesta contiene un pedido confirmado
    pedido = _extraer_pedido_confirmado(respuesta)

    if pedido:
        # El JSON no se envía al cliente — se guarda en el FastAPI
        exito = _enviar_pedido_a_api(pedido, chat_id)

        if exito:
            # Limpiar historial después de un pedido exitoso
            conversaciones[chat_id].clear()

            # Calcular resumen para el cliente
            items_texto = "\n".join(
                f"  • {i.get('cantidad', 1)}× {i.get('nombre', '?')} — ${i.get('precio', 0):,.0f}"
                for i in pedido.get("items", [])
            )
            total = pedido.get("total", 0)
            tipo = "📍 Domicilio" if pedido.get("tipo") == "domicilio" else "🏪 Para recoger"
            direccion = pedido.get("direccion", "")
            dir_texto = f"\n📌 {direccion}" if direccion else ""

            confirmacion = (
                f"✅ *¡Pedido confirmado!*\n\n"
                f"{items_texto}\n\n"
                f"💰 *Total: ${total:,.0f}*\n"
                f"{tipo}{dir_texto}\n\n"
                f"Ya está en manos del equipo. ¡Gracias por tu pedido! 🙌"
            )
            _enviar_seguro(context, chat_id, confirmacion, parse_mode=ParseMode.MARKDOWN)
        else:
            _enviar_seguro(
                context, chat_id,
                "✅ Pedido recibido, pero hubo un problema registrándolo. "
                "Por favor contáctanos directamente. Disculpa los inconvenientes."
            )
    else:
        # Respuesta de texto normal de DeepSeek
        _enviar_seguro(context, chat_id, respuesta)


def manejar_error(update: Update, context: CallbackContext) -> None:
    """Handler global de errores."""
    logger.error(f"Error en actualización {update}: {context.error}")

    if update and update.effective_chat:
        try:
            context.bot.send_message(
                chat_id=update.effective_chat.id,
                text="Lo siento, ocurrió un error. Por favor intenta nuevamente.",
            )
        except Exception as error:
            logger.error(f"Error enviando mensaje de error: {error}")


# ─── Utilidades ───────────────────────────────────────────────────────────────

def _enviar_seguro(
    context: CallbackContext,
    chat_id: int,
    texto: str,
    parse_mode: str | None = None,
) -> bool:
    """Envía un mensaje con fallback a texto plano si hay errores de formato."""
    try:
        context.bot.send_message(chat_id, texto, parse_mode=parse_mode)
        return True
    except BadRequest:
        try:
            # Fallback: enviar sin formato
            context.bot.send_message(chat_id, texto)
            return True
        except Exception as error:
            logger.error(f"Error enviando mensaje a {chat_id}: {error}")
            return False
    except Exception as error:
        logger.error(f"Error inesperado enviando mensaje: {error}")
        return False


# ─── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    """Punto de entrada del bot."""
    logger.info("🚀 Iniciando bot de Telegram ProntoApp...")
    logger.info(f"📡 FastAPI URL: {FASTAPI_URL}")

    # Verificar conexión con el FastAPI
    try:
        respuesta = httpx.get(f"{FASTAPI_URL}/health", timeout=5)
        if respuesta.status_code == 200:
            logger.info("✅ FastAPI está activo y respondiendo")
        else:
            logger.warning(f"⚠️  FastAPI respondió con estado {respuesta.status_code}")
    except Exception:
        logger.warning(
            "⚠️  No se pudo conectar al FastAPI. "
            "Asegúrate de que api_pedidos.py esté corriendo en el puerto 5050."
        )

    updater = Updater(TOKEN)
    dispatcher = updater.dispatcher

    # Registrar handlers
    dispatcher.add_handler(CommandHandler("start", cmd_start))
    dispatcher.add_handler(CommandHandler("menu", cmd_menu))
    dispatcher.add_handler(CommandHandler("cancelar", cmd_cancelar))
    dispatcher.add_handler(MessageHandler(~Filters.command, manejar_mensaje))
    dispatcher.add_error_handler(manejar_error)

    logger.info("✅ Bot activo. Presiona Ctrl+C para detenerlo.")
    updater.start_polling()
    updater.idle()


if __name__ == "__main__":
    main()
