"""Router del contexto Inventario (adaptador IN).

Recrea los endpoints GET/PUT /inventario, POST/PATCH/DELETE /productos y
/categorias con el MISMO contrato. Traduce errores de dominio a HTTP."""
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from src.application.inventario import (
    ActualizarCategoria, ActualizarProducto, CrearCategoria, CrearProducto,
    EliminarCategoria, EliminarProducto, LeerInventario, ReemplazarInventario,
)
from src.domain.errors import CategoriaConProductosError, NoEncontradoError
from src.infrastructure.web.deps import (
    actualizar_categoria_uc, actualizar_producto_uc, crear_categoria_uc,
    crear_producto_uc, eliminar_categoria_uc, eliminar_producto_uc,
    leer_inventario_uc, reemplazar_inventario_uc, requerir_tenant,
)
from src.infrastructure.web.presenters import categoria_a_dict, producto_a_dict

router = APIRouter()


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class InventarioIn(BaseModel):
    categorias: list[dict]
    productos: list[dict]


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


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.get("/inventario")
def obtener_inventario(
    uc: LeerInventario = Depends(leer_inventario_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    cats, prods = uc.execute(negocio_id)
    return {
        "categorias": [categoria_a_dict(c) for c in cats],
        "productos": [producto_a_dict(p) for p in prods],
    }


@router.put("/inventario")
def actualizar_inventario(
    body: InventarioIn,
    uc: ReemplazarInventario = Depends(reemplazar_inventario_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    uc.execute(body.categorias, body.productos, negocio_id)
    return {"ok": True}


@router.post("/productos", status_code=status.HTTP_201_CREATED)
def crear_producto(
    body: ProductoIn,
    uc: CrearProducto = Depends(crear_producto_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    return producto_a_dict(uc.execute(body.model_dump(), negocio_id))


@router.patch("/productos/{prod_id}")
def actualizar_producto(
    prod_id: str,
    body: ProductoPatch,
    uc: ActualizarProducto = Depends(actualizar_producto_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    try:
        prod = uc.execute(prod_id, datos, negocio_id)
    except NoEncontradoError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Producto {prod_id} no encontrado")
    return producto_a_dict(prod)


@router.delete("/productos/{prod_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_producto(
    prod_id: str,
    uc: EliminarProducto = Depends(eliminar_producto_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    try:
        uc.execute(prod_id, negocio_id)
    except NoEncontradoError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Producto {prod_id} no encontrado")


@router.post("/categorias", status_code=status.HTTP_201_CREATED)
def crear_categoria(
    body: CategoriaIn,
    uc: CrearCategoria = Depends(crear_categoria_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    return categoria_a_dict(uc.execute(body.model_dump(), negocio_id))


@router.patch("/categorias/{cat_id}")
def actualizar_categoria(
    cat_id: str,
    body: CategoriaPatch,
    uc: ActualizarCategoria = Depends(actualizar_categoria_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    try:
        cat = uc.execute(cat_id, datos, negocio_id)
    except NoEncontradoError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Categoría {cat_id} no encontrada")
    return categoria_a_dict(cat)


@router.delete("/categorias/{cat_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_categoria(
    cat_id: str,
    uc: EliminarCategoria = Depends(eliminar_categoria_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    try:
        uc.execute(cat_id, negocio_id)
    except CategoriaConProductosError:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="La categoría tiene productos asociados")
    except NoEncontradoError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Categoría {cat_id} no encontrada")
