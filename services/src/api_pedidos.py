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


class LoginIn(BaseModel):
    email: str
    password: str


@app.post("/auth/login")
def auth_login(body: LoginIn, db: Session = Depends(get_db)):
    user = crud.login(db, body.email, body.password)
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Credenciales inválidas")
    return user


@app.get("/negocio")
def obtener_negocio(db: Session = Depends(get_db)):
    return crud.leer_negocio(db)


class ProductoIn(BaseModel):
    id: Optional[str] = None
    name: str
    categoryId: str
    price: float
    stock: int = 0
    minStock: int = 0
    prepTimeMinutes: int = 0
    isAvailable: bool = True
    description: str = ""
    aiContext: str = ""
    aiActive: bool = True
    imageUrl: Optional[str] = None
    emoji: str = "📦"


class ProductoPatch(BaseModel):
    name: Optional[str] = None
    categoryId: Optional[str] = None
    price: Optional[float] = None
    stock: Optional[int] = None
    minStock: Optional[int] = None
    prepTimeMinutes: Optional[int] = None
    isAvailable: Optional[bool] = None
    description: Optional[str] = None
    aiContext: Optional[str] = None
    aiActive: Optional[bool] = None
    imageUrl: Optional[str] = None
    emoji: Optional[str] = None


class CategoriaIn(BaseModel):
    id: Optional[str] = None
    name: str
    emoji: str = ""


class CategoriaPatch(BaseModel):
    name: Optional[str] = None
    emoji: Optional[str] = None


@app.post("/productos", status_code=status.HTTP_201_CREATED)
def crear_producto(body: ProductoIn, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    return crud.crear_producto(db, body.model_dump())


@app.patch("/productos/{prod_id}")
def actualizar_producto(prod_id: str, body: ProductoPatch, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    actualizado = crud.actualizar_producto(db, prod_id, datos)
    if actualizado is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Producto {prod_id} no encontrado")
    return actualizado


@app.delete("/productos/{prod_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_producto(prod_id: str, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    if not crud.eliminar_producto(db, prod_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Producto {prod_id} no encontrado")


@app.post("/categorias", status_code=status.HTTP_201_CREATED)
def crear_categoria(body: CategoriaIn, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    return crud.crear_categoria(db, body.model_dump())


@app.patch("/categorias/{cat_id}")
def actualizar_categoria(cat_id: str, body: CategoriaPatch, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    actualizado = crud.actualizar_categoria(db, cat_id, datos)
    if actualizado is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Categoría {cat_id} no encontrada")
    return actualizado


@app.delete("/categorias/{cat_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_categoria(cat_id: str, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    try:
        ok = crud.eliminar_categoria(db, cat_id)
    except crud.CategoriaConProductosError:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="La categoría tiene productos asociados")
    if not ok:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Categoría {cat_id} no encontrada")


class UsuarioIn(BaseModel):
    nombre: str
    email: str
    password: str
    rol: str
    telefono: Optional[str] = None


@app.post("/usuarios", status_code=status.HTTP_201_CREATED)
def crear_usuario_endpoint(body: UsuarioIn, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    try:
        return crud.crear_usuario(db, body.model_dump())
    except crud.EmailDuplicadoError:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="El email ya está registrado")


@app.get("/usuarios")
def listar_usuarios_endpoint(x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    return crud.listar_usuarios(db)


class NegocioIn(BaseModel):
    tipoNegocio: Optional[str] = None
    nombre: Optional[str] = None
    direccion: Optional[str] = None
    horaApertura: Optional[str] = None
    horaCierre: Optional[str] = None
    formatoEntrega: Optional[str] = None
    terminosEntrega: Optional[str] = None
    numeroWhatsapp: Optional[str] = None


class UsuarioPatch(BaseModel):
    nombre: Optional[str] = None
    telefono: Optional[str] = None
    rol: Optional[str] = None


@app.put("/negocio")
def actualizar_negocio_endpoint(body: NegocioIn, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    return crud.actualizar_negocio(db, datos)


@app.patch("/usuarios/{usuario_id}")
def actualizar_usuario_endpoint(usuario_id: str, body: UsuarioPatch, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    actualizado = crud.actualizar_usuario(db, usuario_id, datos)
    if actualizado is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Usuario {usuario_id} no encontrado")
    return actualizado


@app.delete("/usuarios/{usuario_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_usuario_endpoint(usuario_id: str, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    if not crud.eliminar_usuario(db, usuario_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Usuario {usuario_id} no encontrado")


class PlantillaIaIn(BaseModel):
    prompt: Optional[str] = None
    contexto: Optional[str] = None


@app.get("/plantilla-ia")
def obtener_plantilla_ia(x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    p = crud.leer_plantilla_ia(db)
    if p is None:
        return {"id": "main", "prompt": "", "contexto": "[]"}
    return p


@app.put("/plantilla-ia")
def actualizar_plantilla_ia_endpoint(body: PlantillaIaIn, x_secret: Optional[str] = Header(default=None), db: Session = Depends(get_db)):
    _verificar_secreto(x_secret)
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    return crud.actualizar_plantilla_ia(db, datos)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("api_pedidos:app", host="0.0.0.0", port=5050, reload=True)
