"""
Servidor FastAPI para ProntoApp.
Actúa como puente entre el bot de Telegram y la app Flutter.

Ejecutar con:
    uvicorn api_pedidos:app --reload --port 5050
"""
import json
import os
import uuid
from datetime import datetime
from pathlib import Path
from typing import Optional
import httpx

from dotenv import load_dotenv
from fastapi import FastAPI, Header, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

load_dotenv()

# ─── Configuración ────────────────────────────────────────────────────────────

SECRETO = os.getenv("TELEGRAM_WEBHOOK_SECRET", "")
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")
BASE_DIR = Path(__file__).resolve().parent.parent
ARCHIVO_PEDIDOS = BASE_DIR / "data" / "pedidos.json"
ARCHIVO_INVENTARIO = BASE_DIR / "data" / "inventario.json"

app = FastAPI(title="ProntoApp API", version="1.0.0")

# CORS para que Flutter web pueda llamar al servidor
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


# ─── Utilidades de persistencia ───────────────────────────────────────────────

def _leer_pedidos() -> list[dict]:
    """Carga los pedidos desde el archivo JSON."""
    if not ARCHIVO_PEDIDOS.exists():
        return []
    try:
        return json.loads(ARCHIVO_PEDIDOS.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError):
        return []


def _guardar_pedidos(pedidos: list[dict]) -> None:
    """Persiste la lista de pedidos en el archivo JSON."""
    ARCHIVO_PEDIDOS.write_text(
        json.dumps(pedidos, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


def _leer_inventario() -> dict:
    """Carga el inventario desde el archivo JSON."""
    if not ARCHIVO_INVENTARIO.exists():
        return {"categorias": [], "productos": []}
    try:
        return json.loads(ARCHIVO_INVENTARIO.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError):
        return {"categorias": [], "productos": []}


def _verificar_secreto(x_secret: Optional[str]) -> None:
    """Valida el header de autenticación si hay secreto configurado."""
    if SECRETO and x_secret != SECRETO:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Acceso denegado: secreto inválido",
        )

def _notificar_cambio_estado_telegram(chat_id: str, pedido_id: str, estado: str) -> None:
    """Envía un mensaje al usuario de Telegram avisando del cambio de estado."""
    estados_amigables = {
        "recibido": "📋 Recibido y en cola",
        "en_preparacion": "👨‍🍳 En preparación (¡Ya casi!)",
        "listo": "🛍️ Listo para recoger/enviar",
        "en_camino": "🛵 En camino a tu dirección",
        "entregado": "✅ Entregado. ¡Que lo disfrutes!"
    }
    estado_texto = estados_amigables.get(estado, estado)
    mensaje = f"🔔 Tu pedido *{pedido_id}* ha cambiado de estado:\n\n👉 {estado_texto}"

    try:
        url = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
        httpx.post(
            url,
            json={"chat_id": chat_id, "text": mensaje, "parse_mode": "Markdown"},
            timeout=5
        )
    except Exception as e:
        print(f"Error enviando notificación a Telegram: {e}")


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class ItemPedidoIn(BaseModel):
    """Un ítem dentro de un pedido entrante."""
    nombre: str
    cantidad: int
    precio: float


class PedidoIn(BaseModel):
    """Cuerpo del POST /pedidos enviado por el bot."""
    cliente: str
    telefono: str
    items: list[ItemPedidoIn]
    total: float
    tipo: str          # "domicilio" | "recoger"
    direccion: Optional[str] = None


class EstadoIn(BaseModel):
    """Cuerpo del PATCH /pedidos/{id}/estado."""
    estado: str        # "recibido" | "en_preparacion" | "listo" | "en_camino" | "entregado"


class InventarioIn(BaseModel):
    """Cuerpo del PUT /inventario enviado por Flutter."""
    categorias: list[dict]
    productos: list[dict]


# ─── Endpoints ────────────────────────────────────────────────────────────────

@app.get("/health")
def health_check():
    """Verifica que el servidor esté activo."""
    return {"ok": True, "timestamp": datetime.now().isoformat()}


# ── Pedidos ──────────────────────────────────────────────────────────────────

@app.get("/pedidos")
def obtener_pedidos(x_secret: Optional[str] = Header(default=None)):
    """Flutter lee la lista completa de pedidos."""
    _verificar_secreto(x_secret)
    pedidos = _leer_pedidos()
    
    # Limpiar el campo teléfono para no mostrar tg:chat_id| en Flutter
    for pedido in pedidos:
        telefono = pedido.get("telefono", "")
        if telefono.startswith("tg:"):
            partes = telefono.split("|", 1)
            pedido["telefono"] = partes[1] if len(partes) > 1 else ""
            
    return pedidos


@app.post("/pedidos", status_code=status.HTTP_201_CREATED)
def crear_pedido(
    pedido: PedidoIn,
    x_secret: Optional[str] = Header(default=None),
):
    """El bot de Telegram guarda un pedido confirmado."""
    _verificar_secreto(x_secret)

    pedidos = _leer_pedidos()
    nuevo = {
        "id": f"P-{str(uuid.uuid4())[:8].upper()}",
        "cliente": pedido.cliente,
        "telefono": pedido.telefono,
        "items": [i.model_dump() for i in pedido.items],
        "total": pedido.total,
        "tipo": pedido.tipo,
        "direccion": pedido.direccion,
        "estado": "recibido",
        "creado_en": datetime.now().isoformat(),
    }
    
    # Guardar pedido
    pedidos.append(nuevo)
    _guardar_pedidos(pedidos)

    # Descontar del inventario
    inventario = _leer_inventario()
    cambios_inventario = False
    for item in pedido.items:
        for p in inventario.get("productos", []):
            # Compara ignorando mayúsculas/minúsculas para mayor tolerancia
            if p.get("name", "").lower() == item.nombre.lower():
                stock_actual = p.get("stock", 0)
                # No descontar más allá de 0
                nuevo_stock = max(0, stock_actual - item.cantidad)
                if stock_actual != nuevo_stock:
                    p["stock"] = nuevo_stock
                    cambios_inventario = True
                break

    if cambios_inventario:
        ARCHIVO_INVENTARIO.write_text(
            json.dumps(inventario, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )

    return nuevo


@app.patch("/pedidos/{pedido_id}/estado")
def actualizar_estado(
    pedido_id: str,
    body: EstadoIn,
    x_secret: Optional[str] = Header(default=None),
):
    """Flutter actualiza el estado de un pedido."""
    _verificar_secreto(x_secret)

    pedidos = _leer_pedidos()
    for pedido in pedidos:
        if pedido["id"] == pedido_id:
            estado_anterior = pedido.get("estado")
            if estado_anterior != body.estado:
                pedido["estado"] = body.estado
                _guardar_pedidos(pedidos)
                
                # Enviar notificación por Telegram si está asociado a un chat_id
                telefono = pedido.get("telefono", "")
                if TELEGRAM_BOT_TOKEN and telefono.startswith("tg:"):
                    # Extraer chat_id del formato tg:12345|telefono_real
                    chat_id_str = telefono.split("|")[0]
                    chat_id = chat_id_str.replace("tg:", "")
                    _notificar_cambio_estado_telegram(chat_id, pedido["id"], body.estado)

            return pedido

    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail=f"Pedido {pedido_id} no encontrado",
    )


@app.delete("/pedidos/{pedido_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_pedido(
    pedido_id: str,
    x_secret: Optional[str] = Header(default=None),
):
    """Flutter elimina un pedido de la lista."""
    _verificar_secreto(x_secret)

    pedidos = _leer_pedidos()
    pedidos_nuevos = [p for p in pedidos if p["id"] != pedido_id]

    if len(pedidos_nuevos) == len(pedidos):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Pedido {pedido_id} no encontrado",
        )

    _guardar_pedidos(pedidos_nuevos)


# ── Inventario ───────────────────────────────────────────────────────────────

@app.get("/inventario")
def obtener_inventario(x_secret: Optional[str] = Header(default=None)):
    """El bot lee el inventario para responder preguntas sobre el menú."""
    _verificar_secreto(x_secret)
    return _leer_inventario()


@app.put("/inventario")
def actualizar_inventario(
    body: InventarioIn,
    x_secret: Optional[str] = Header(default=None),
):
    """Flutter sincroniza el inventario al FastAPI cuando hay cambios."""
    _verificar_secreto(x_secret)

    inventario = {"categorias": body.categorias, "productos": body.productos}
    ARCHIVO_INVENTARIO.write_text(
        json.dumps(inventario, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    return {"ok": True}

if __name__ == "__main__":
    import uvicorn
    # Se corre en el puerto 5050 según el .env
    uvicorn.run("api_pedidos:app", host="0.0.0.0", port=5050, reload=True)
