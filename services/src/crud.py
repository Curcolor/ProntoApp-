"""Acceso a datos para FastAPI. Devuelve dicts con el MISMO contrato JSON que
la versión basada en archivos, para no romper Flutter ni el bot."""
import uuid
from typing import Optional
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session
from . import models


# ─── IDs ──────────────────────────────────────────────────────────────────────

def _nuevo_id(prefijo: str) -> str:
    return f"{prefijo}-{str(uuid.uuid4())[:8].upper()}"


# ─── Serialización (contrato) ─────────────────────────────────────────────────
# Los serializadores de inventario (producto/categoría) viven ahora en
# src/infrastructure/web/presenters.py; aquí solo quedan los de pedidos.

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


# ─── Inventario (fachadas finas sobre los casos de uso hexagonales) ───────────
# Estas funciones conservan su firma y su retorno de dict para no romper a quien
# importe `crud.*`. La lógica vive ahora en src/application/inventario.py.

def _cat_repo(db: Session):
    from src.infrastructure.persistence.repositories import SqlAlchemyCategoriaRepository
    return SqlAlchemyCategoriaRepository(db)


def _prod_repo(db: Session):
    from src.infrastructure.persistence.repositories import SqlAlchemyProductoRepository
    return SqlAlchemyProductoRepository(db)


def _categoria_a_dict_dom(c) -> dict:
    from src.infrastructure.web.presenters import categoria_a_dict
    return categoria_a_dict(c)


def _producto_a_dict_dom(p) -> dict:
    from src.infrastructure.web.presenters import producto_a_dict
    return producto_a_dict(p)


def leer_inventario(db: Session, negocio_id: str) -> dict:
    from src.application.inventario import LeerInventario
    cats, prods = LeerInventario(_cat_repo(db), _prod_repo(db)).execute(negocio_id)
    return {
        "categorias": [_categoria_a_dict_dom(c) for c in cats],
        "productos": [_producto_a_dict_dom(p) for p in prods],
    }


def reemplazar_inventario(db: Session, categorias: list[dict], productos: list[dict], negocio_id: str) -> None:
    """Reemplaza todo el inventario (PUT /inventario)."""
    from src.application.inventario import ReemplazarInventario
    ReemplazarInventario(_cat_repo(db), _prod_repo(db)).execute(categorias, productos, negocio_id)


def descontar_stock(db: Session, items: list[dict], negocio_id: str) -> None:
    """Descuenta stock por nombre de producto (case-insensitive), sin bajar de 0."""
    _prod_repo(db).descontar_stock(items, negocio_id)


# ─── Clientes ─────────────────────────────────────────────────────────────────

def _upsert_cliente(db: Session, nombre: str, numero_whatsapp: str, negocio_id: str) -> "models.Cliente":
    cliente = db.scalars(select(models.Cliente).where(
        models.Cliente.negocio_id == negocio_id,
        models.Cliente.numero_whatsapp == numero_whatsapp)).first()
    if cliente is None:
        cliente = models.Cliente(id=_nuevo_id("C"), nombre=nombre,
                                 numero_whatsapp=numero_whatsapp, negocio_id=negocio_id)
        db.add(cliente)
        db.flush()
    return cliente


# ─── Pedidos ──────────────────────────────────────────────────────────────────

def listar_pedidos(db: Session, negocio_id: str) -> list[dict]:
    pedidos = db.scalars(select(models.Pedido).where(
        models.Pedido.negocio_id == negocio_id).order_by(models.Pedido.creado_en.desc())).all()
    return [_pedido_a_dict(p) for p in pedidos]


def crear_pedido(db: Session, datos: dict, negocio_id: str) -> dict:
    cliente = _upsert_cliente(db, datos["cliente"], datos["telefono"], negocio_id)
    pedido = models.Pedido(
        id=_nuevo_id("P"), cliente_id=cliente.id, total=datos["total"],
        estado="recibido", tipo=datos["tipo"], direccion=datos.get("direccion"),
        negocio_id=negocio_id,
    )
    db.add(pedido)
    db.flush()
    for it in datos["items"]:
        db.add(models.DetallePedido(
            id=_nuevo_id("D"), pedido_id=pedido.id, producto_id=None,
            nombre=it["nombre"], cantidad=it["cantidad"], precio_unitario=it["precio"],
        ))
    db.flush()
    descontar_stock(db, datos["items"], negocio_id)
    db.commit()
    db.refresh(pedido)
    return _pedido_a_dict(pedido)


def actualizar_estado(db: Session, pedido_id: str, estado: str, negocio_id: str) -> Optional[dict]:
    pedido = db.scalars(select(models.Pedido).where(
        models.Pedido.id == pedido_id, models.Pedido.negocio_id == negocio_id)).first()
    if pedido is None:
        return None
    pedido.estado = estado
    db.commit()
    db.refresh(pedido)
    return _pedido_a_dict(pedido)


def eliminar_pedido(db: Session, pedido_id: str, negocio_id: str) -> bool:
    pedido = db.scalars(select(models.Pedido).where(
        models.Pedido.id == pedido_id, models.Pedido.negocio_id == negocio_id)).first()
    if pedido is None:
        return False
    db.delete(pedido)
    db.commit()
    return True


from passlib.hash import bcrypt


def _usuario_a_dict(u: "models.Usuario") -> dict:
    return {"id": u.id, "nombre": u.nombre, "email": u.email,
            "telefono": u.telefono, "rol": u.rol, "negocioId": u.negocio_id}



def crear_usuario(db: Session, datos: dict, negocio_id: str) -> dict:
    user = models.Usuario(
        id=datos.get("id") or _nuevo_id("U"), nombre=datos["nombre"],
        email=datos["email"], contrasena_hash=bcrypt.hash(datos["password"]),
        telefono=datos.get("telefono"), rol=datos["rol"], negocio_id=negocio_id,
    )
    db.add(user)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise EmailDuplicadoError(datos["email"])
    return _usuario_a_dict(user)


def registrar(db: Session, datos: dict) -> dict:
    negocio = models.Negocio(id=_nuevo_id("N"), nombre=datos["businessName"])
    db.add(negocio)
    db.flush()
    user = models.Usuario(
        id=_nuevo_id("U"), nombre=datos["nombre"], email=datos["email"],
        contrasena_hash=bcrypt.hash(datos["password"]), rol="gerente",
        telefono=datos.get("telefono"), negocio_id=negocio.id,
    )
    db.add(user)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise EmailDuplicadoError(datos["email"])
    return _usuario_a_dict(user)


def listar_usuarios(db: Session, negocio_id: str) -> list[dict]:
    return [_usuario_a_dict(u) for u in db.scalars(
        select(models.Usuario).where(models.Usuario.negocio_id == negocio_id)).all()]


def login(db: Session, email: str, password: str) -> Optional[dict]:
    user = db.scalars(select(models.Usuario).where(models.Usuario.email == email)).first()
    if user is None or not bcrypt.verify(password, user.contrasena_hash):
        return None
    return _usuario_a_dict(user)


def leer_negocio(db: Session, negocio_id: str) -> Optional[dict]:
    n = db.get(models.Negocio, negocio_id)
    if n is None:
        return None
    return {
        "id": n.id, "tipoNegocio": n.tipo_negocio, "nombre": n.nombre,
        "direccion": n.direccion, "horaApertura": n.hora_apertura,
        "horaCierre": n.hora_cierre, "formatoEntrega": n.formato_entrega,
        "terminosEntrega": n.terminos_entrega, "numeroWhatsapp": n.numero_whatsapp,
    }


from src.domain.errors import CategoriaConProductosError, EmailDuplicadoError  # noqa: E402  (alias de errores de dominio)


def crear_categoria(db: Session, datos: dict, negocio_id: str) -> dict:
    from src.application.inventario import CrearCategoria
    cat = CrearCategoria(_cat_repo(db)).execute(datos, negocio_id)
    return _categoria_a_dict_dom(cat)


def actualizar_categoria(db: Session, cat_id: str, datos: dict, negocio_id: str) -> Optional[dict]:
    from src.application.inventario import ActualizarCategoria
    from src.domain.errors import NoEncontradoError
    try:
        cat = ActualizarCategoria(_cat_repo(db)).execute(cat_id, datos, negocio_id)
    except NoEncontradoError:
        return None
    return _categoria_a_dict_dom(cat)


def eliminar_categoria(db: Session, cat_id: str, negocio_id: str) -> bool:
    from src.application.inventario import EliminarCategoria
    from src.domain.errors import NoEncontradoError
    try:
        EliminarCategoria(_cat_repo(db), _prod_repo(db)).execute(cat_id, negocio_id)
    except NoEncontradoError:
        return False
    return True


def crear_producto(db: Session, datos: dict, negocio_id: str) -> dict:
    from src.application.inventario import CrearProducto
    prod = CrearProducto(_prod_repo(db)).execute(datos, negocio_id)
    return _producto_a_dict_dom(prod)


def actualizar_producto(db: Session, prod_id: str, datos: dict, negocio_id: str) -> Optional[dict]:
    from src.application.inventario import ActualizarProducto
    from src.domain.errors import NoEncontradoError
    try:
        prod = ActualizarProducto(_prod_repo(db)).execute(prod_id, datos, negocio_id)
    except NoEncontradoError:
        return None
    return _producto_a_dict_dom(prod)


def eliminar_producto(db: Session, prod_id: str, negocio_id: str) -> bool:
    from src.application.inventario import EliminarProducto
    from src.domain.errors import NoEncontradoError
    try:
        EliminarProducto(_prod_repo(db)).execute(prod_id, negocio_id)
    except NoEncontradoError:
        return False
    return True


_CAMPOS_NEGOCIO = {
    "tipoNegocio": "tipo_negocio", "nombre": "nombre", "direccion": "direccion",
    "horaApertura": "hora_apertura", "horaCierre": "hora_cierre",
    "formatoEntrega": "formato_entrega", "terminosEntrega": "terminos_entrega",
    "numeroWhatsapp": "numero_whatsapp",
}


def actualizar_negocio(db: Session, datos: dict, negocio_id: str) -> dict:
    negocio = db.get(models.Negocio, negocio_id)
    if negocio is None:
        negocio = models.Negocio(id=negocio_id, nombre=datos.get("nombre", "ProntoApp"))
        db.add(negocio)
    for clave_json, attr in _CAMPOS_NEGOCIO.items():
        if clave_json in datos:
            setattr(negocio, attr, datos[clave_json])
    db.commit()
    return leer_negocio(db, negocio_id)


_CAMPOS_USUARIO = {"nombre": "nombre", "telefono": "telefono", "rol": "rol"}


def actualizar_usuario(db: Session, usuario_id: str, datos: dict, negocio_id: str) -> Optional[dict]:
    user = db.scalars(select(models.Usuario).where(
        models.Usuario.id == usuario_id, models.Usuario.negocio_id == negocio_id)).first()
    if user is None:
        return None
    for clave_json, attr in _CAMPOS_USUARIO.items():
        if clave_json in datos:
            setattr(user, attr, datos[clave_json])
    db.commit()
    return _usuario_a_dict(user)


def eliminar_usuario(db: Session, usuario_id: str, negocio_id: str) -> bool:
    user = db.scalars(select(models.Usuario).where(
        models.Usuario.id == usuario_id, models.Usuario.negocio_id == negocio_id)).first()
    if user is None:
        return False
    db.delete(user)
    db.commit()
    return True


_CAMPOS_PLANTILLA_IA = {"prompt": "prompt", "contexto": "contexto"}


def leer_plantilla_ia(db: Session, negocio_id: str) -> Optional[dict]:
    p = db.scalars(select(models.PlantillaIa).where(models.PlantillaIa.negocio_id == negocio_id)).first()
    if p is None:
        return None
    return {"id": p.id, "prompt": p.prompt, "contexto": p.contexto}


def actualizar_plantilla_ia(db: Session, datos: dict, negocio_id: str) -> dict:
    p = db.scalars(select(models.PlantillaIa).where(models.PlantillaIa.negocio_id == negocio_id)).first()
    if p is None:
        p = models.PlantillaIa(id=_nuevo_id("pia"), prompt=datos.get("prompt", ""),
                               contexto=datos.get("contexto", "[]"), negocio_id=negocio_id)
        db.add(p)
    for clave, attr in _CAMPOS_PLANTILLA_IA.items():
        if clave in datos:
            setattr(p, attr, datos[clave])
    db.commit()
    return {"id": p.id, "prompt": p.prompt, "contexto": p.contexto}
