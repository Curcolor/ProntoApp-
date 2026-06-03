"""Servidor FastAPI para ProntoApp. Persiste en Postgres vía SQLAlchemy."""
import os
from typing import Optional
import httpx
from dotenv import load_dotenv
from fastapi import Depends, FastAPI, Header, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from sqlalchemy.orm import Session

from .db import SessionLocal
from . import crud

load_dotenv()

SECRETO = os.getenv("TELEGRAM_WEBHOOK_SECRET", "")
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")

app = FastAPI(title="ProntoApp API", version="2.0.0")
app.add_middleware(
    CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"],
)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def _verificar_secreto(x_secret: Optional[str]) -> None:
    if SECRETO and x_secret != SECRETO:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Acceso denegado: secreto inválido")


def _notificar_cambio_estado_telegram(chat_id: str, pedido_id: str, estado: str) -> None:
    estados = {
        "recibido": "📋 Recibido y en cola", "en_preparacion": "👨‍🍳 En preparación (¡Ya casi!)",
        "listo": "🛍️ Listo para recoger/enviar", "en_camino": "🛵 En camino a tu dirección",
        "entregado": "✅ Entregado. ¡Que lo disfrutes!",
    }
    mensaje = f"🔔 Tu pedido *{pedido_id}* ha cambiado de estado:\n\n👉 {estados.get(estado, estado)}"
    try:
        httpx.post(
            f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage",
            json={"chat_id": chat_id, "text": mensaje, "parse_mode": "Markdown"}, timeout=5,
        )
    except Exception as e:
        print(f"Error enviando notificación a Telegram: {e}")


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class ItemPedidoIn(BaseModel):
    nombre: str
    cantidad: int
    precio: float


class PedidoIn(BaseModel):
    cliente: str
    telefono: str
    items: list[ItemPedidoIn]
    total: float
    tipo: str
    direccion: Optional[str] = None


class EstadoIn(BaseModel):
    estado: str


class InventarioIn(BaseModel):
    categorias: list[dict]
    productos: list[dict]


# ─── Endpoints ────────────────────────────────────────────────────────────────

@app.get("/health")
def health_check():
    from datetime import datetime
    return {"ok": True, "timestamp": datetime.now().isoformat()}


@app.get("/pedidos")
def obtener_pedidos(x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    return crud.listar_pedidos(db)


@app.post("/pedidos", status_code=status.HTTP_201_CREATED)
def crear_pedido(pedido: PedidoIn, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    return crud.crear_pedido(db, pedido.model_dump())


@app.patch("/pedidos/{pedido_id}/estado")
def actualizar_estado(pedido_id: str, body: EstadoIn, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    # leer teléfono antes/después para notificar
    from .models import Pedido
    pedido_row = db.get(Pedido, pedido_id)
    if pedido_row is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Pedido {pedido_id} no encontrado")
    estado_anterior = pedido_row.estado
    actualizado = crud.actualizar_estado(db, pedido_id, body.estado)
    if estado_anterior != body.estado and TELEGRAM_BOT_TOKEN:
        telefono = pedido_row.cliente.numero_whatsapp
        if telefono.startswith("tg:"):
            chat_id = telefono.split("|")[0].replace("tg:", "")
            _notificar_cambio_estado_telegram(chat_id, pedido_id, body.estado)
    return actualizado


@app.delete("/pedidos/{pedido_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_pedido(pedido_id: str, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    if not crud.eliminar_pedido(db, pedido_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Pedido {pedido_id} no encontrado")


@app.get("/inventario")
def obtener_inventario(x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    return crud.leer_inventario(db)


@app.put("/inventario")
def actualizar_inventario(body: InventarioIn, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    crud.reemplazar_inventario(db, body.categorias, body.productos)
    return {"ok": True}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("api_pedidos:app", host="0.0.0.0", port=5050, reload=True)
