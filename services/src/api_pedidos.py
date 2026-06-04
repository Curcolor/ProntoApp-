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
from . import auth, crud
from .auth import TokenInvalidoError, decodificar_token

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


def get_negocio_id(x_negocio_id: Optional[str] = Header(default=None)) -> str:
    # Conservada solo por compatibilidad de imports/tests; ya no la usan los endpoints.
    return x_negocio_id or "main"


def requerir_tenant(
    authorization: Optional[str] = Header(default=None),
    x_secret: Optional[str] = Header(default=None),
    x_negocio_id: Optional[str] = Header(default=None),
) -> str:
    """Resuelve el negocio del request. App: del JWT. Bot/servicio: del header."""
    if authorization and authorization.lower().startswith("bearer "):
        try:
            claims = decodificar_token(authorization.split(" ", 1)[1].strip())
        except TokenInvalidoError:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token inválido o expirado")
        negocio = claims.get("negocio_id")
        if not negocio:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token sin negocio_id")
        return negocio
    if SECRETO and x_secret != SECRETO:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Autenticación requerida")
    return x_negocio_id or "main"


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
def obtener_pedidos(db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.listar_pedidos(db, negocio_id)


@app.post("/pedidos", status_code=status.HTTP_201_CREATED)
def crear_pedido(pedido: PedidoIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.crear_pedido(db, pedido.model_dump(), negocio_id)


@app.patch("/pedidos/{pedido_id}/estado")
def actualizar_estado(pedido_id: str, body: EstadoIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    # leer teléfono antes/después para notificar
    from .models import Pedido
    from sqlalchemy import select
    pedido_row = db.scalars(select(Pedido).where(
        Pedido.id == pedido_id, Pedido.negocio_id == negocio_id)).first()
    if pedido_row is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Pedido {pedido_id} no encontrado")
    estado_anterior = pedido_row.estado
    actualizado = crud.actualizar_estado(db, pedido_id, body.estado, negocio_id)
    if estado_anterior != body.estado and TELEGRAM_BOT_TOKEN:
        telefono = pedido_row.cliente.numero_whatsapp
        if telefono.startswith("tg:"):
            chat_id = telefono.split("|")[0].replace("tg:", "")
            _notificar_cambio_estado_telegram(chat_id, pedido_id, body.estado)
    return actualizado


@app.delete("/pedidos/{pedido_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_pedido(pedido_id: str, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    if not crud.eliminar_pedido(db, pedido_id, negocio_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Pedido {pedido_id} no encontrado")


@app.get("/inventario")
def obtener_inventario(db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.leer_inventario(db, negocio_id)


@app.put("/inventario")
def actualizar_inventario(body: InventarioIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    crud.reemplazar_inventario(db, body.categorias, body.productos, negocio_id)
    return {"ok": True}


class LoginIn(BaseModel):
    email: str
    password: str


@app.post("/auth/login")
def auth_login(body: LoginIn, db: Session = Depends(get_db)):
    user = crud.login(db, body.email, body.password)
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Credenciales inválidas")
    return {**user, "token": auth.crear_token(user)}


class RegistroIn(BaseModel):
    nombre: str
    email: str
    password: str
    businessName: str
    telefono: Optional[str] = None


@app.post("/registro", status_code=status.HTTP_201_CREATED)
def registro_endpoint(body: RegistroIn, db: Session = Depends(get_db)):
    try:
        user = crud.registrar(db, body.model_dump())
    except crud.EmailDuplicadoError:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="El email ya está registrado")
    return {**user, "token": auth.crear_token(user)}


@app.get("/negocio")
def obtener_negocio(db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.leer_negocio(db, negocio_id)


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
def crear_producto(body: ProductoIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.crear_producto(db, body.model_dump(), negocio_id)


@app.patch("/productos/{prod_id}")
def actualizar_producto(prod_id: str, body: ProductoPatch, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    actualizado = crud.actualizar_producto(db, prod_id, datos, negocio_id)
    if actualizado is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Producto {prod_id} no encontrado")
    return actualizado


@app.delete("/productos/{prod_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_producto(prod_id: str, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    if not crud.eliminar_producto(db, prod_id, negocio_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Producto {prod_id} no encontrado")


@app.post("/categorias", status_code=status.HTTP_201_CREATED)
def crear_categoria(body: CategoriaIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.crear_categoria(db, body.model_dump(), negocio_id)


@app.patch("/categorias/{cat_id}")
def actualizar_categoria(cat_id: str, body: CategoriaPatch, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    actualizado = crud.actualizar_categoria(db, cat_id, datos, negocio_id)
    if actualizado is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Categoría {cat_id} no encontrada")
    return actualizado


@app.delete("/categorias/{cat_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_categoria(cat_id: str, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    try:
        ok = crud.eliminar_categoria(db, cat_id, negocio_id)
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
def crear_usuario_endpoint(body: UsuarioIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    try:
        return crud.crear_usuario(db, body.model_dump(), negocio_id)
    except crud.EmailDuplicadoError:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="El email ya está registrado")


@app.get("/usuarios")
def listar_usuarios_endpoint(db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.listar_usuarios(db, negocio_id)


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
def actualizar_negocio_endpoint(body: NegocioIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    return crud.actualizar_negocio(db, datos, negocio_id)


@app.patch("/usuarios/{usuario_id}")
def actualizar_usuario_endpoint(usuario_id: str, body: UsuarioPatch, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    actualizado = crud.actualizar_usuario(db, usuario_id, datos, negocio_id)
    if actualizado is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Usuario {usuario_id} no encontrado")
    return actualizado


@app.delete("/usuarios/{usuario_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_usuario_endpoint(usuario_id: str, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    if not crud.eliminar_usuario(db, usuario_id, negocio_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Usuario {usuario_id} no encontrado")


class PlantillaIaIn(BaseModel):
    prompt: Optional[str] = None
    contexto: Optional[str] = None


@app.get("/plantilla-ia")
def obtener_plantilla_ia(db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    p = crud.leer_plantilla_ia(db, negocio_id)
    if p is None:
        return {"id": "main", "prompt": "", "contexto": "[]"}
    return p


@app.put("/plantilla-ia")
def actualizar_plantilla_ia_endpoint(body: PlantillaIaIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    return crud.actualizar_plantilla_ia(db, datos, negocio_id)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("api_pedidos:app", host="0.0.0.0", port=5050, reload=True)
