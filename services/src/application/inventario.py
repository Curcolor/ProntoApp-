"""Casos de uso del contexto Inventario.

Dependencias inyectadas por constructor; cada caso expone `execute(...)`.
Replican el comportamiento de las funciones `crud.*` originales, pero lanzan
errores de dominio (nunca HTTPException) y operan sobre entidades de dominio."""
from src.domain.entities import Categoria, Producto
from src.domain.errors import CategoriaConProductosError, NoEncontradoError
from src.domain.ids import nuevo_id
from src.domain.ports import CategoriaRepository, ProductoRepository


def _producto_desde_dict(datos: dict, prod_id: str) -> Producto:
    return Producto(
        id=prod_id,
        categoryId=datos["categoryId"],
        name=datos["name"],
        price=datos["price"],
        stock=datos.get("stock", 0),
        minStock=datos.get("minStock", 0),
        prepTimeMinutes=datos.get("prepTimeMinutes", 0),
        isAvailable=datos.get("isAvailable", True),
        description=datos.get("description", ""),
        aiContext=datos.get("aiContext", ""),
        aiActive=datos.get("aiActive", True),
        imageUrl=datos.get("imageUrl"),
        emoji=datos.get("emoji", "📦"),
    )


def _categoria_desde_dict(datos: dict, cat_id: str) -> Categoria:
    return Categoria(id=cat_id, name=datos["name"], emoji=datos.get("emoji", ""))


# Claves JSON que admite un PATCH de producto -> atributo de la entidad.
_CAMPOS_PRODUCTO = (
    "categoryId", "name", "price", "stock", "minStock", "prepTimeMinutes",
    "isAvailable", "description", "aiContext", "aiActive", "imageUrl", "emoji",
)


class LeerInventario:
    def __init__(self, cat_repo: CategoriaRepository, prod_repo: ProductoRepository):
        self._cat_repo = cat_repo
        self._prod_repo = prod_repo

    def execute(self, negocio_id: str) -> tuple[list[Categoria], list[Producto]]:
        return (self._cat_repo.listar(negocio_id), self._prod_repo.listar(negocio_id))


class ReemplazarInventario:
    def __init__(self, cat_repo: CategoriaRepository, prod_repo: ProductoRepository):
        self._cat_repo = cat_repo
        self._prod_repo = prod_repo

    def execute(self, categorias: list[dict], productos: list[dict], negocio_id: str) -> None:
        cats = [_categoria_desde_dict(c, c["id"]) for c in categorias]
        prods = [_producto_desde_dict(p, p["id"]) for p in productos]
        # Productos referencian categorías (FK). Para respetar la FK hay que
        # borrar en orden hijo→padre e insertar en orden padre→hijo, igual que
        # crud.reemplazar_inventario. Se vacían primero los productos para que
        # el reemplazo de categorías pueda borrar las viejas sin violar la FK.
        self._prod_repo.reemplazar_todos([], negocio_id)
        self._cat_repo.reemplazar_todas(cats, negocio_id)
        self._prod_repo.reemplazar_todos(prods, negocio_id)


class CrearProducto:
    def __init__(self, prod_repo: ProductoRepository):
        self._prod_repo = prod_repo

    def execute(self, datos: dict, negocio_id: str) -> Producto:
        prod = _producto_desde_dict(datos, datos.get("id") or nuevo_id("prod"))
        self._prod_repo.agregar(prod, negocio_id)
        return prod


class ActualizarProducto:
    def __init__(self, prod_repo: ProductoRepository):
        self._prod_repo = prod_repo

    def execute(self, prod_id: str, datos: dict, negocio_id: str) -> Producto:
        prod = self._prod_repo.obtener(prod_id, negocio_id)
        if prod is None:
            raise NoEncontradoError(prod_id)
        for clave in _CAMPOS_PRODUCTO:
            if clave in datos:
                setattr(prod, clave, datos[clave])
        self._prod_repo.actualizar(prod, negocio_id)
        return prod


class EliminarProducto:
    def __init__(self, prod_repo: ProductoRepository):
        self._prod_repo = prod_repo

    def execute(self, prod_id: str, negocio_id: str) -> None:
        if self._prod_repo.obtener(prod_id, negocio_id) is None:
            raise NoEncontradoError(prod_id)
        self._prod_repo.eliminar(prod_id, negocio_id)


class CrearCategoria:
    def __init__(self, cat_repo: CategoriaRepository):
        self._cat_repo = cat_repo

    def execute(self, datos: dict, negocio_id: str) -> Categoria:
        cat = _categoria_desde_dict(datos, datos.get("id") or nuevo_id("cat"))
        self._cat_repo.agregar(cat, negocio_id)
        return cat


class ActualizarCategoria:
    def __init__(self, cat_repo: CategoriaRepository):
        self._cat_repo = cat_repo

    def execute(self, cat_id: str, datos: dict, negocio_id: str) -> Categoria:
        cat = self._cat_repo.obtener(cat_id, negocio_id)
        if cat is None:
            raise NoEncontradoError(cat_id)
        if "name" in datos:
            cat.name = datos["name"]
        if "emoji" in datos:
            cat.emoji = datos["emoji"]
        self._cat_repo.actualizar(cat, negocio_id)
        return cat


class EliminarCategoria:
    def __init__(self, cat_repo: CategoriaRepository, prod_repo: ProductoRepository):
        self._cat_repo = cat_repo
        self._prod_repo = prod_repo

    def execute(self, cat_id: str, negocio_id: str) -> None:
        if self._cat_repo.obtener(cat_id, negocio_id) is None:
            raise NoEncontradoError(cat_id)
        if self._prod_repo.hay_en_categoria(cat_id, negocio_id):
            raise CategoriaConProductosError(cat_id)
        self._cat_repo.eliminar(cat_id, negocio_id)
