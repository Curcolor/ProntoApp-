"""Acceso a datos para FastAPI. Devuelve dicts con el MISMO contrato JSON que
la versión basada en archivos, para no romper Flutter ni el bot."""
import uuid
from typing import Optional
from sqlalchemy import func, select
from sqlalchemy.orm import Session
from . import models


# ─── IDs ──────────────────────────────────────────────────────────────────────

def _nuevo_id(prefijo: str) -> str:
    return f"{prefijo}-{str(uuid.uuid4())[:8].upper()}"


# ─── Serialización (contrato) ─────────────────────────────────────────────────

def _producto_a_dict(p: "models.Producto") -> dict:
    return {
        "id": p.id, "name": p.name, "categoryId": p.categoria_id,
        "price": p.price, "stock": p.stock, "minStock": p.min_stock,
        "prepTimeMinutes": p.prep_time_minutes, "isAvailable": p.is_available,
        "description": p.description, "aiContext": p.ai_context,
        "aiActive": p.ai_active, "imageUrl": p.image_url, "emoji": p.emoji,
    }


def _categoria_a_dict(c: "models.Categoria") -> dict:
    return {"id": c.id, "name": c.name, "emoji": c.emoji}


def _limpiar_telefono(telefono: str) -> str:
    """tg:chat_id|telefono_real -> telefono_real (igual que la versión JSON)."""
    if telefono.startswith("tg:"):
        partes = telefono.split("|", 1)
        return partes[1] if len(partes) > 1 else ""
    return telefono


def _pedido_a_dict(p: "models.Pedido") -> dict:
    return {
        "id": p.id,
        "cliente": p.cliente.nombre,
        "telefono": _limpiar_telefono(p.cliente.numero_whatsapp),
        "items": [
            {"nombre": d.nombre, "cantidad": d.cantidad, "precio": d.precio_unitario}
            for d in p.items
        ],
        "total": p.total,
        "tipo": p.tipo,
        "direccion": p.direccion,
        "estado": p.estado,
        "creado_en": p.creado_en.isoformat() if p.creado_en else None,
    }


# ─── Inventario ───────────────────────────────────────────────────────────────

def leer_inventario(db: Session) -> dict:
    cats = db.scalars(select(models.Categoria)).all()
    prods = db.scalars(select(models.Producto)).all()
    return {
        "categorias": [_categoria_a_dict(c) for c in cats],
        "productos": [_producto_a_dict(p) for p in prods],
    }


def reemplazar_inventario(db: Session, categorias: list[dict], productos: list[dict]) -> None:
    """Reemplaza todo el inventario (PUT /inventario)."""
    db.query(models.Producto).delete()
    db.query(models.Categoria).delete()
    db.flush()
    for c in categorias:
        db.add(models.Categoria(id=c["id"], name=c["name"], emoji=c.get("emoji", "")))
    db.flush()
    for p in productos:
        db.add(models.Producto(
            id=p["id"], categoria_id=p["categoryId"], name=p["name"],
            price=p["price"], stock=p.get("stock", 0), min_stock=p.get("minStock", 0),
            prep_time_minutes=p.get("prepTimeMinutes", 0),
            is_available=p.get("isAvailable", True), description=p.get("description", ""),
            ai_context=p.get("aiContext", ""), ai_active=p.get("aiActive", True),
            image_url=p.get("imageUrl"), emoji=p.get("emoji", "📦"),
        ))
    db.commit()


def descontar_stock(db: Session, items: list[dict]) -> None:
    """Descuenta stock por nombre de producto (case-insensitive), sin bajar de 0."""
    for item in items:
        nombre = str(item.get("nombre", "")).lower()
        prod = db.scalars(
            select(models.Producto).where(func.lower(models.Producto.name) == nombre)
        ).first()
        if prod is not None:
            prod.stock = max(0, prod.stock - int(item.get("cantidad", 0)))
    db.commit()


# ─── Clientes ─────────────────────────────────────────────────────────────────

def _upsert_cliente(db: Session, nombre: str, numero_whatsapp: str) -> "models.Cliente":
    cliente = db.scalars(
        select(models.Cliente).where(models.Cliente.numero_whatsapp == numero_whatsapp)
    ).first()
    if cliente is None:
        cliente = models.Cliente(id=_nuevo_id("C"), nombre=nombre, numero_whatsapp=numero_whatsapp)
        db.add(cliente)
        db.flush()
    return cliente


# ─── Pedidos ──────────────────────────────────────────────────────────────────

def listar_pedidos(db: Session) -> list[dict]:
    pedidos = db.scalars(select(models.Pedido).order_by(models.Pedido.creado_en.desc())).all()
    return [_pedido_a_dict(p) for p in pedidos]


def crear_pedido(db: Session, datos: dict) -> dict:
    cliente = _upsert_cliente(db, datos["cliente"], datos["telefono"])
    pedido = models.Pedido(
        id=_nuevo_id("P"), cliente_id=cliente.id, total=datos["total"],
        estado="recibido", tipo=datos["tipo"], direccion=datos.get("direccion"),
    )
    db.add(pedido)
    db.flush()
    for it in datos["items"]:
        db.add(models.DetallePedido(
            id=_nuevo_id("D"), pedido_id=pedido.id, producto_id=None,
            nombre=it["nombre"], cantidad=it["cantidad"], precio_unitario=it["precio"],
        ))
    db.flush()
    descontar_stock(db, datos["items"])
    db.commit()
    db.refresh(pedido)
    return _pedido_a_dict(pedido)


def actualizar_estado(db: Session, pedido_id: str, estado: str) -> Optional[dict]:
    pedido = db.get(models.Pedido, pedido_id)
    if pedido is None:
        return None
    pedido.estado = estado
    db.commit()
    db.refresh(pedido)
    return _pedido_a_dict(pedido)


def eliminar_pedido(db: Session, pedido_id: str) -> bool:
    pedido = db.get(models.Pedido, pedido_id)
    if pedido is None:
        return False
    db.delete(pedido)
    db.commit()
    return True


from passlib.hash import bcrypt


def _usuario_a_dict(u: "models.Usuario") -> dict:
    return {"id": u.id, "nombre": u.nombre, "email": u.email,
            "telefono": u.telefono, "rol": u.rol}


def crear_usuario(db: Session, datos: dict) -> dict:
    user = models.Usuario(
        id=datos.get("id") or _nuevo_id("U"), nombre=datos["nombre"],
        email=datos["email"], contrasena_hash=bcrypt.hash(datos["password"]),
        telefono=datos.get("telefono"), rol=datos["rol"],
    )
    db.add(user)
    db.commit()
    return _usuario_a_dict(user)


def login(db: Session, email: str, password: str) -> Optional[dict]:
    user = db.scalars(select(models.Usuario).where(models.Usuario.email == email)).first()
    if user is None or not bcrypt.verify(password, user.contrasena_hash):
        return None
    return _usuario_a_dict(user)


def leer_negocio(db: Session) -> Optional[dict]:
    n = db.scalars(select(models.Negocio)).first()
    if n is None:
        return None
    return {
        "id": n.id, "tipoNegocio": n.tipo_negocio, "nombre": n.nombre,
        "direccion": n.direccion, "horaApertura": n.hora_apertura,
        "horaCierre": n.hora_cierre, "formatoEntrega": n.formato_entrega,
        "terminosEntrega": n.terminos_entrega, "numeroWhatsapp": n.numero_whatsapp,
    }


class CategoriaConProductosError(Exception):
    """Se intentó borrar una categoría que aún tiene productos."""


def crear_categoria(db: Session, datos: dict) -> dict:
    cat = models.Categoria(
        id=datos.get("id") or _nuevo_id("cat"),
        name=datos["name"], emoji=datos.get("emoji", ""),
    )
    db.add(cat)
    db.commit()
    return _categoria_a_dict(cat)


def actualizar_categoria(db: Session, cat_id: str, datos: dict) -> Optional[dict]:
    cat = db.get(models.Categoria, cat_id)
    if cat is None:
        return None
    if "name" in datos:
        cat.name = datos["name"]
    if "emoji" in datos:
        cat.emoji = datos["emoji"]
    db.commit()
    return _categoria_a_dict(cat)


def eliminar_categoria(db: Session, cat_id: str) -> bool:
    cat = db.get(models.Categoria, cat_id)
    if cat is None:
        return False
    tiene = db.scalars(
        select(models.Producto).where(models.Producto.categoria_id == cat_id)
    ).first()
    if tiene is not None:
        raise CategoriaConProductosError(cat_id)
    db.delete(cat)
    db.commit()
    return True


def crear_producto(db: Session, datos: dict) -> dict:
    prod = models.Producto(
        id=datos.get("id") or _nuevo_id("prod"),
        categoria_id=datos["categoryId"], name=datos["name"], price=datos["price"],
        stock=datos.get("stock", 0), min_stock=datos.get("minStock", 0),
        prep_time_minutes=datos.get("prepTimeMinutes", 0),
        is_available=datos.get("isAvailable", True), description=datos.get("description", ""),
        ai_context=datos.get("aiContext", ""), ai_active=datos.get("aiActive", True),
        image_url=datos.get("imageUrl"), emoji=datos.get("emoji", "📦"),
    )
    db.add(prod)
    db.commit()
    return _producto_a_dict(prod)


_CAMPOS_PRODUCTO = {
    "categoryId": "categoria_id", "name": "name", "price": "price", "stock": "stock",
    "minStock": "min_stock", "prepTimeMinutes": "prep_time_minutes",
    "isAvailable": "is_available", "description": "description",
    "aiContext": "ai_context", "aiActive": "ai_active", "imageUrl": "image_url",
    "emoji": "emoji",
}


def actualizar_producto(db: Session, prod_id: str, datos: dict) -> Optional[dict]:
    prod = db.get(models.Producto, prod_id)
    if prod is None:
        return None
    for clave_json, attr in _CAMPOS_PRODUCTO.items():
        if clave_json in datos:
            setattr(prod, attr, datos[clave_json])
    db.commit()
    return _producto_a_dict(prod)


def eliminar_producto(db: Session, prod_id: str) -> bool:
    prod = db.get(models.Producto, prod_id)
    if prod is None:
        return False
    db.delete(prod)
    db.commit()
    return True
