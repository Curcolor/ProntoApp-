import pytest
from src import crud, models


@pytest.fixture(autouse=True)
def _negocio_main(db):
    if db.get(models.Negocio, "main") is None:
        db.add(models.Negocio(id="main", nombre="ProntoApp"))
        db.flush()


def test_reemplazar_y_leer_inventario(db):
    crud.reemplazar_inventario(
        db,
        categorias=[{"id": "cat_1", "name": "Bebidas", "emoji": "☕"}],
        productos=[{
            "id": "prod_1", "name": "Café", "categoryId": "cat_1", "price": 5000,
            "stock": 10, "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
            "description": "", "aiContext": "", "aiActive": True,
            "imageUrl": None, "emoji": "☕",
        }],
        negocio_id="main",
    )
    inv = crud.leer_inventario(db, "main")
    assert inv["categorias"][0]["id"] == "cat_1"
    assert inv["productos"][0]["categoryId"] == "cat_1"
    assert inv["productos"][0]["price"] == 5000


def test_descontar_stock_por_nombre(db):
    crud.reemplazar_inventario(
        db, categorias=[{"id": "c", "name": "x", "emoji": "x"}],
        productos=[{
            "id": "p", "name": "Café", "categoryId": "c", "price": 1,
            "stock": 5, "minStock": 0, "prepTimeMinutes": 0, "isAvailable": True,
            "description": "", "aiContext": "", "aiActive": True,
            "imageUrl": None, "emoji": "x",
        }],
        negocio_id="main",
    )
    crud.descontar_stock(db, [{"nombre": "café", "cantidad": 2}], "main")
    assert db.get(models.Producto, "p").stock == 3
