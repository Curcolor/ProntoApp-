"""Inyección de dependencias para los routers (composición de adaptadores).

Aquí vive `requerir_tenant` (lo usan todos los routers) y `SECRETO` como global
de módulo, para que los tests puedan monkeypatchearlo. NO importa api_pedidos,
para evitar el ciclo api_pedidos → routers → deps."""
import os
from typing import Optional

from fastapi import Depends, Header, HTTPException, status
from sqlalchemy.orm import Session

from src.auth import TokenInvalidoError, decodificar_token
from src.db import SessionLocal
from src.application.inventario import (
    ActualizarCategoria, ActualizarProducto, CrearCategoria, CrearProducto,
    EliminarCategoria, EliminarProducto, LeerInventario, ReemplazarInventario,
)
from src.domain.ports import CategoriaRepository, ProductoRepository
from src.infrastructure.persistence.repositories import (
    SqlAlchemyCategoriaRepository, SqlAlchemyProductoRepository,
)

SECRETO = os.getenv("TELEGRAM_WEBHOOK_SECRET", "")


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


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
