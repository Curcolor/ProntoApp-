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

def _cliente_repo_inst(db: Session):
    from src.infrastructure.persistence.repositories import SqlAlchemyClienteRepository
    return SqlAlchemyClienteRepository(db)


def _pedido_repo_inst(db: Session):
    from src.infrastructure.persistence.repositories import SqlAlchemyPedidoRepository
    return SqlAlchemyPedidoRepository(db)


def _upsert_cliente(db: Session, nombre: str, numero_whatsapp: str, negocio_id: str):
    """Fachada fina: delega al repositorio hexagonal."""
    return _cliente_repo_inst(db).upsert(nombre, numero_whatsapp, negocio_id)


# ─── Pedidos ──────────────────────────────────────────────────────────────────

def listar_pedidos(db: Session, negocio_id: str) -> list[dict]:
    from src.application.pedidos import ListarPedidos
    from src.infrastructure.web.presenters import pedido_a_dict
    pedidos = ListarPedidos(_pedido_repo_inst(db)).execute(negocio_id)
    return [pedido_a_dict(p) for p in pedidos]


def crear_pedido(db: Session, datos: dict, negocio_id: str) -> dict:
    from src.application.pedidos import CrearPedido
    from src.infrastructure.web.presenters import pedido_a_dict
    pedido = CrearPedido(
        _pedido_repo_inst(db), _cliente_repo_inst(db), _prod_repo(db),
    ).execute(datos, negocio_id)
    return pedido_a_dict(pedido)


def actualizar_estado(db: Session, pedido_id: str, estado: str, negocio_id: str) -> Optional[dict]:
    from src.infrastructure.web.presenters import pedido_a_dict
    actualizado = _pedido_repo_inst(db).cambiar_estado(pedido_id, estado, negocio_id)
    if actualizado is None:
        return None
    return pedido_a_dict(actualizado)


def eliminar_pedido(db: Session, pedido_id: str, negocio_id: str) -> bool:
    return _pedido_repo_inst(db).eliminar(pedido_id, negocio_id)


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
