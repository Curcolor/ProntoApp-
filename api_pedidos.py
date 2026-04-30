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

from dotenv import load_dotenv
from fastapi import FastAPI, Header, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

load_dotenv()

# ─── Configuración ────────────────────────────────────────────────────────────

SECRETO = os.getenv("TELEGRAM_WEBHOOK_SECRET", "")
ARCHIVO_PEDIDOS = Path("pedidos.json")
ARCHIVO_INVENTARIO = Path("inventario.json")

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
    return _leer_pedidos()


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
    pedidos.append(nuevo)
    _guardar_pedidos(pedidos)
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
            pedido["estado"] = body.estado
            _guardar_pedidos(pedidos)
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
