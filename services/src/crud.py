"""Acceso a datos para FastAPI. Devuelve dicts con el MISMO contrato JSON que
la versión basada en archivos, para no romper Flutter ni el bot."""
from typing import Optional
from sqlalchemy.orm import Session


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


def _usuario_repo_inst(db: Session):
    from src.infrastructure.persistence.repositories import SqlAlchemyUsuarioRepository
    return SqlAlchemyUsuarioRepository(db)


def crear_usuario(db: Session, datos: dict, negocio_id: str) -> dict:
    from src.application.usuarios import CrearUsuario
    from src.infrastructure.security.password import BcryptPasswordHasher
    from src.infrastructure.web.presenters import usuario_a_dict as _ua_dict
    usuario = CrearUsuario(_usuario_repo_inst(db), BcryptPasswordHasher()).execute(datos, negocio_id)
    return _ua_dict(usuario)


def registrar(db: Session, datos: dict) -> dict:
    from src.application.auth import RegistrarNegocio
    from src.infrastructure.persistence.repositories import (
        SqlAlchemyNegocioRepository, SqlAlchemyUsuarioRepository,
    )
    from src.infrastructure.security.password import BcryptPasswordHasher
    from src.infrastructure.web.presenters import usuario_a_dict as _ua_dict
    usuario = RegistrarNegocio(
        SqlAlchemyNegocioRepository(db),
        SqlAlchemyUsuarioRepository(db),
        BcryptPasswordHasher(),
    ).execute(datos)
    return _ua_dict(usuario)


def listar_usuarios(db: Session, negocio_id: str) -> list[dict]:
    from src.application.usuarios import ListarUsuarios
    from src.infrastructure.web.presenters import usuario_a_dict as _ua_dict
    usuarios = ListarUsuarios(_usuario_repo_inst(db)).execute(negocio_id)
    return [_ua_dict(u) for u in usuarios]


def login(db: Session, email: str, password: str) -> Optional[dict]:
    from src.application.auth import Login
    from src.infrastructure.persistence.repositories import SqlAlchemyUsuarioRepository
    from src.infrastructure.security.password import BcryptPasswordHasher
    from src.infrastructure.web.presenters import usuario_a_dict as _ua_dict
    usuario = Login(SqlAlchemyUsuarioRepository(db), BcryptPasswordHasher()).execute(email, password)
    if usuario is None:
        return None
    return _ua_dict(usuario)


def _negocio_repo_inst(db: Session):
    from src.infrastructure.persistence.repositories import SqlAlchemyNegocioRepository
    return SqlAlchemyNegocioRepository(db)


def _plantilla_repo_inst(db: Session):
    from src.infrastructure.persistence.repositories import SqlAlchemyPlantillaIaRepository
    return SqlAlchemyPlantillaIaRepository(db)


def leer_negocio(db: Session, negocio_id: str) -> Optional[dict]:
    from src.application.negocio import LeerNegocio
    from src.infrastructure.web.presenters import negocio_a_dict
    n = LeerNegocio(_negocio_repo_inst(db)).execute(negocio_id)
    if n is None:
        return None
    return negocio_a_dict(n)


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


def actualizar_negocio(db: Session, datos: dict, negocio_id: str) -> dict:
    from src.application.negocio import ActualizarNegocio
    from src.infrastructure.web.presenters import negocio_a_dict
    n = ActualizarNegocio(_negocio_repo_inst(db)).execute(datos, negocio_id)
    return negocio_a_dict(n)


def actualizar_usuario(db: Session, usuario_id: str, datos: dict, negocio_id: str) -> Optional[dict]:
    from src.application.usuarios import ActualizarUsuario
    from src.domain.errors import NoEncontradoError
    from src.infrastructure.web.presenters import usuario_a_dict as _ua_dict
    try:
        usuario = ActualizarUsuario(_usuario_repo_inst(db)).execute(usuario_id, datos, negocio_id)
    except NoEncontradoError:
        return None
    return _ua_dict(usuario)


def eliminar_usuario(db: Session, usuario_id: str, negocio_id: str) -> bool:
    from src.application.usuarios import EliminarUsuario
    from src.domain.errors import NoEncontradoError
    try:
        EliminarUsuario(_usuario_repo_inst(db)).execute(usuario_id, negocio_id)
    except NoEncontradoError:
        return False
    return True


def leer_plantilla_ia(db: Session, negocio_id: str) -> Optional[dict]:
    from src.application.plantilla import LeerPlantillaIa
    from src.infrastructure.web.presenters import plantilla_a_dict
    p = LeerPlantillaIa(_plantilla_repo_inst(db)).execute(negocio_id)
    if p is None:
        return None
    return plantilla_a_dict(p)


def actualizar_plantilla_ia(db: Session, datos: dict, negocio_id: str) -> dict:
    from src.application.plantilla import ActualizarPlantillaIa
    from src.infrastructure.web.presenters import plantilla_a_dict
    p = ActualizarPlantillaIa(_plantilla_repo_inst(db)).execute(datos, negocio_id)
    return plantilla_a_dict(p)
