import pytest
from src import models
from src.application.inventario import LeerInventario, ReemplazarInventario
from src.infrastructure.persistence.repositories import (
    SqlAlchemyCategoriaRepository,
    SqlAlchemyProductoRepository,
)


@pytest.fixture(autouse=True)
def _negocio_main(db):
    if db.get(models.Negocio, "main") is None:
        db.add(models.Negocio(id="main", nombre="ProntoApp"))
        db.flush()


def test_reemplazar_y_leer_inventario(db):
    ReemplazarInventario(
        SqlAlchemyCategoriaRepository(db),
        SqlAlchemyProductoRepository(db),
    ).execute(
        categorias=[{"id": "cat_1", "name": "Bebidas", "emoji": "☕"}],
        productos=[{
            "id": "prod_1", "name": "Café", "categoryId": "cat_1", "price": 5000,
            "stock": 10, "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
            "description": "", "aiContext": "", "aiActive": True,
            "imageUrl": None, "emoji": "☕",
        }],
        negocio_id="main",
    )
    cats, prods = LeerInventario(
        SqlAlchemyCategoriaRepository(db),
        SqlAlchemyProductoRepository(db),
    ).execute("main")
    assert cats[0].id == "cat_1"
    assert prods[0].categoryId == "cat_1"
    assert prods[0].price == 5000


def test_descontar_stock_por_nombre(db):
    ReemplazarInventario(
        SqlAlchemyCategoriaRepository(db),
        SqlAlchemyProductoRepository(db),
    ).execute(
        categorias=[{"id": "c", "name": "x", "emoji": "x"}],
        productos=[{
            "id": "p", "name": "Café", "categoryId": "c", "price": 1,
            "stock": 5, "minStock": 0, "prepTimeMinutes": 0, "isAvailable": True,
            "description": "", "aiContext": "", "aiActive": True,
            "imageUrl": None, "emoji": "x",
        }],
        negocio_id="main",
    )
    SqlAlchemyProductoRepository(db).descontar_stock([{"nombre": "café", "cantidad": 2}], "main")
    assert db.get(models.Producto, "p").stock == 3
