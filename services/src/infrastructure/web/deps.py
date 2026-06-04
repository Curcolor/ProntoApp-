"""Inyección de dependencias para los routers (composición de adaptadores).

Aquí vive `requerir_tenant` (lo usan todos los routers) y `SECRETO` como global
de módulo, para que los tests puedan monkeypatchearlo. NO importa api_pedidos,
para evitar el ciclo api_pedidos → routers → deps."""
import os
from typing import Optional

from fastapi import Depends, Header, HTTPException, status
from sqlalchemy.orm import Session

from src.infrastructure.security.jwt import TokenInvalidoError
from src.db import SessionLocal
from src.application.inventario import (
    ActualizarCategoria, ActualizarProducto, CrearCategoria, CrearProducto,
    EliminarCategoria, EliminarProducto, LeerInventario, ReemplazarInventario,
)
from src.application.pedidos import (
    ActualizarEstadoPedido, CrearPedido, EliminarPedido, ListarPedidos,
)
from src.domain.ports import (
    CategoriaRepository, ClienteRepository, NegocioRepository, PedidoRepository,
    PasswordHasher, PlantillaIaRepository, ProductoRepository, TokenService,
    UsuarioRepository,
)
from src.application.auth import Login, RegistrarNegocio
from src.application.negocio import ActualizarNegocio, LeerNegocio
from src.application.plantilla import ActualizarPlantillaIa, LeerPlantillaIa
from src.application.usuarios import (
    ActualizarUsuario, CrearUsuario, EliminarUsuario, ListarUsuarios,
)
from src.infrastructure.notifications.telegram import TelegramNotificador
from src.infrastructure.persistence.repositories import (
    SqlAlchemyCategoriaRepository, SqlAlchemyClienteRepository,
    SqlAlchemyNegocioRepository, SqlAlchemyPedidoRepository,
    SqlAlchemyPlantillaIaRepository, SqlAlchemyProductoRepository,
    SqlAlchemyUsuarioRepository,
)
from src.infrastructure.security.password import BcryptPasswordHasher

SECRETO = os.getenv("TELEGRAM_WEBHOOK_SECRET", "")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_token_service() -> TokenService:
    from src.infrastructure.security.jwt_service import JwtTokenService
    return JwtTokenService()


def requerir_tenant(
    authorization: Optional[str] = Header(default=None),
    x_secret: Optional[str] = Header(default=None),
    x_negocio_id: Optional[str] = Header(default=None),
    token_service: TokenService = Depends(get_token_service),
) -> str:
    """Resuelve el negocio del request. App: del JWT. Bot/servicio: del header."""
    if authorization and authorization.lower().startswith("bearer "):
        try:
            claims = token_service.verificar(authorization.split(" ", 1)[1].strip())
        except TokenInvalidoError:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token inválido o expirado")
        negocio = claims.get("negocio_id")
        if not negocio:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token sin negocio_id")
        return negocio
    if SECRETO and x_secret != SECRETO:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Autenticación requerida")
    return x_negocio_id or "main"


# ─── Repositorios ─────────────────────────────────────────────────────────────

def _cat_repo(db: Session = Depends(get_db)) -> CategoriaRepository:
    return SqlAlchemyCategoriaRepository(db)


def _prod_repo(db: Session = Depends(get_db)) -> ProductoRepository:
    return SqlAlchemyProductoRepository(db)


# ─── Casos de uso ─────────────────────────────────────────────────────────────

def leer_inventario_uc(
    cat: CategoriaRepository = Depends(_cat_repo),
    prod: ProductoRepository = Depends(_prod_repo),
) -> LeerInventario:
    return LeerInventario(cat, prod)


def reemplazar_inventario_uc(
    cat: CategoriaRepository = Depends(_cat_repo),
    prod: ProductoRepository = Depends(_prod_repo),
) -> ReemplazarInventario:
    return ReemplazarInventario(cat, prod)


def crear_producto_uc(prod: ProductoRepository = Depends(_prod_repo)) -> CrearProducto:
    return CrearProducto(prod)


def actualizar_producto_uc(prod: ProductoRepository = Depends(_prod_repo)) -> ActualizarProducto:
    return ActualizarProducto(prod)


def eliminar_producto_uc(prod: ProductoRepository = Depends(_prod_repo)) -> EliminarProducto:
    return EliminarProducto(prod)


def crear_categoria_uc(cat: CategoriaRepository = Depends(_cat_repo)) -> CrearCategoria:
    return CrearCategoria(cat)


def actualizar_categoria_uc(cat: CategoriaRepository = Depends(_cat_repo)) -> ActualizarCategoria:
    return ActualizarCategoria(cat)


def eliminar_categoria_uc(
    cat: CategoriaRepository = Depends(_cat_repo),
    prod: ProductoRepository = Depends(_prod_repo),
) -> EliminarCategoria:
    return EliminarCategoria(cat, prod)


# ─── Pedidos ──────────────────────────────────────────────────────────────────

def _cliente_repo(db: Session = Depends(get_db)) -> ClienteRepository:
    return SqlAlchemyClienteRepository(db)


def _pedido_repo(db: Session = Depends(get_db)) -> PedidoRepository:
    return SqlAlchemyPedidoRepository(db)


def listar_pedidos_uc(
    pedido: PedidoRepository = Depends(_pedido_repo),
) -> ListarPedidos:
    return ListarPedidos(pedido)


def crear_pedido_uc(
    pedido: PedidoRepository = Depends(_pedido_repo),
    cliente: ClienteRepository = Depends(_cliente_repo),
    prod: ProductoRepository = Depends(_prod_repo),
) -> CrearPedido:
    return CrearPedido(pedido, cliente, prod)


def actualizar_estado_pedido_uc(
    pedido: PedidoRepository = Depends(_pedido_repo),
) -> ActualizarEstadoPedido:
    return ActualizarEstadoPedido(pedido, TelegramNotificador())


def eliminar_pedido_uc(
    pedido: PedidoRepository = Depends(_pedido_repo),
) -> EliminarPedido:
    return EliminarPedido(pedido)


# ─── Auth ─────────────────────────────────────────────────────────────────────

def _usuario_repo(db: Session = Depends(get_db)) -> UsuarioRepository:
    return SqlAlchemyUsuarioRepository(db)


def _negocio_repo(db: Session = Depends(get_db)) -> NegocioRepository:
    return SqlAlchemyNegocioRepository(db)


def get_password_hasher() -> PasswordHasher:
    return BcryptPasswordHasher()


def login_uc(
    usuario_repo: UsuarioRepository = Depends(_usuario_repo),
    hasher: PasswordHasher = Depends(get_password_hasher),
) -> Login:
    return Login(usuario_repo, hasher)


def registrar_negocio_uc(
    negocio_repo: NegocioRepository = Depends(_negocio_repo),
    usuario_repo: UsuarioRepository = Depends(_usuario_repo),
    hasher: PasswordHasher = Depends(get_password_hasher),
) -> RegistrarNegocio:
    return RegistrarNegocio(negocio_repo, usuario_repo, hasher)


# ─── Usuarios ─────────────────────────────────────────────────────────────────


def listar_usuarios_uc(repo: UsuarioRepository = Depends(_usuario_repo)) -> ListarUsuarios:
    return ListarUsuarios(repo)


def crear_usuario_uc(
    repo: UsuarioRepository = Depends(_usuario_repo),
    hasher: PasswordHasher = Depends(get_password_hasher),
) -> CrearUsuario:
    return CrearUsuario(repo, hasher)


def actualizar_usuario_uc(repo: UsuarioRepository = Depends(_usuario_repo)) -> ActualizarUsuario:
    return ActualizarUsuario(repo)


def eliminar_usuario_uc(repo: UsuarioRepository = Depends(_usuario_repo)) -> EliminarUsuario:
    return EliminarUsuario(repo)


# ─── Negocio / Plantilla ──────────────────────────────────────────────────────

def _plantilla_repo(db: Session = Depends(get_db)) -> PlantillaIaRepository:
    return SqlAlchemyPlantillaIaRepository(db)


def leer_negocio_uc(
    repo: NegocioRepository = Depends(_negocio_repo),
) -> LeerNegocio:
    return LeerNegocio(repo)


def actualizar_negocio_uc(
    repo: NegocioRepository = Depends(_negocio_repo),
) -> ActualizarNegocio:
    return ActualizarNegocio(repo)


def leer_plantilla_uc(
    repo: PlantillaIaRepository = Depends(_plantilla_repo),
) -> LeerPlantillaIa:
    return LeerPlantillaIa(repo)


def actualizar_plantilla_uc(
    repo: PlantillaIaRepository = Depends(_plantilla_repo),
) -> ActualizarPlantillaIa:
    return ActualizarPlantillaIa(repo)
