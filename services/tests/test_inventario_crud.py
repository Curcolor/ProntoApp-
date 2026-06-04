import pytest
from src import models
from src.application.inventario import (
    ActualizarCategoria,
    ActualizarProducto,
    CrearCategoria,
    CrearProducto,
    EliminarCategoria,
    EliminarProducto,
)
from src.domain.errors import CategoriaConProductosError, NoEncontradoError
from src.infrastructure.persistence.repositories import (
    SqlAlchemyCategoriaRepository,
    SqlAlchemyProductoRepository,
)


@pytest.fixture(autouse=True)
def _negocio_main(db):
    if db.get(models.Negocio, "main") is None:
        db.add(models.Negocio(id="main", nombre="ProntoApp"))
        db.flush()


def _cat(db, id="cat_1"):
    CrearCategoria(SqlAlchemyCategoriaRepository(db)).execute(
        {"id": id, "name": "Bebidas", "emoji": "☕"}, "main"
    )


def test_crear_producto_genera_id_y_devuelve_contrato(db):
    _cat(db)
    p = CrearProducto(SqlAlchemyProductoRepository(db)).execute({
        "name": "Café", "categoryId": "cat_1", "price": 5000, "stock": 10,
        "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True,
        "imageUrl": None, "emoji": "☕",
    }, "main")
    assert p.id.startswith("prod-")
    assert p.categoryId == "cat_1"
    assert db.get(models.Producto, p.id).name == "Café"


def test_actualizar_producto(db):
    _cat(db)
    p = CrearProducto(SqlAlchemyProductoRepository(db)).execute({
        "name": "Café", "categoryId": "cat_1", "price": 5000,
        "stock": 10, "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "☕",
    }, "main")
    upd = ActualizarProducto(SqlAlchemyProductoRepository(db)).execute(
        p.id, {"price": 6000, "stock": 8}, "main"
    )
    assert upd.price == 6000
    assert upd.stock == 8
    with pytest.raises(NoEncontradoError):
        ActualizarProducto(SqlAlchemyProductoRepository(db)).execute("noexiste", {"price": 1}, "main")


def test_eliminar_producto(db):
    _cat(db)
    p = CrearProducto(SqlAlchemyProductoRepository(db)).execute({
        "name": "Café", "categoryId": "cat_1", "price": 5000,
        "stock": 10, "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "☕",
    }, "main")
    # First delete succeeds (no return value to assert)
    EliminarProducto(SqlAlchemyProductoRepository(db)).execute(p.id, "main")
    assert db.get(models.Producto, p.id) is None
    # Second delete raises NoEncontradoError
    with pytest.raises(NoEncontradoError):
        EliminarProducto(SqlAlchemyProductoRepository(db)).execute(p.id, "main")


def test_crear_actualizar_eliminar_categoria(db):
    c = CrearCategoria(SqlAlchemyCategoriaRepository(db)).execute(
        {"name": "Postres", "emoji": "🍰"}, "main"
    )
    assert c.id.startswith("cat-")
    upd = ActualizarCategoria(SqlAlchemyCategoriaRepository(db)).execute(
        c.id, {"name": "Dulces"}, "main"
    )
    assert upd.name == "Dulces"
    # Delete succeeds (returns None)
    EliminarCategoria(
        SqlAlchemyCategoriaRepository(db), SqlAlchemyProductoRepository(db)
    ).execute(c.id, "main")
    assert db.get(models.Categoria, c.id) is None


def test_eliminar_categoria_con_productos_falla(db):
    CrearCategoria(SqlAlchemyCategoriaRepository(db)).execute(
        {"id": "cat_1", "name": "Bebidas", "emoji": "☕"}, "main"
    )
    CrearProducto(SqlAlchemyProductoRepository(db)).execute({
        "name": "Café", "categoryId": "cat_1", "price": 1, "stock": 1,
        "minStock": 0, "prepTimeMinutes": 0, "isAvailable": True, "description": "",
        "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "☕",
    }, "main")
    with pytest.raises(CategoriaConProductosError):
        EliminarCategoria(
            SqlAlchemyCategoriaRepository(db), SqlAlchemyProductoRepository(db)
        ).execute("cat_1", "main")
