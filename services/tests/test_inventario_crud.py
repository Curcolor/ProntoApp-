import pytest
from src import crud, models


def _cat(db, id="cat_1"):
    crud.crear_categoria(db, {"id": id, "name": "Bebidas", "emoji": "☕"})


def test_crear_producto_genera_id_y_devuelve_contrato(db):
    _cat(db)
    p = crud.crear_producto(db, {
        "name": "Café", "categoryId": "cat_1", "price": 5000, "stock": 10,
        "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True,
        "imageUrl": None, "emoji": "☕",
    })
    assert p["id"].startswith("prod-")
    assert p["categoryId"] == "cat_1"
    assert db.get(models.Producto, p["id"]).name == "Café"


def test_actualizar_producto(db):
    _cat(db)
    p = crud.crear_producto(db, {"name": "Café", "categoryId": "cat_1", "price": 5000,
        "stock": 10, "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "☕"})
    upd = crud.actualizar_producto(db, p["id"], {"price": 6000, "stock": 8})
    assert upd["price"] == 6000
    assert upd["stock"] == 8
    assert crud.actualizar_producto(db, "noexiste", {"price": 1}) is None


def test_eliminar_producto(db):
    _cat(db)
    p = crud.crear_producto(db, {"name": "Café", "categoryId": "cat_1", "price": 5000,
        "stock": 10, "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "☕"})
    assert crud.eliminar_producto(db, p["id"]) is True
    assert crud.eliminar_producto(db, p["id"]) is False


def test_crear_actualizar_eliminar_categoria(db):
    c = crud.crear_categoria(db, {"name": "Postres", "emoji": "🍰"})
    assert c["id"].startswith("cat-")
    upd = crud.actualizar_categoria(db, c["id"], {"name": "Dulces"})
    assert upd["name"] == "Dulces"
    assert crud.eliminar_categoria(db, c["id"]) is True


def test_eliminar_categoria_con_productos_falla(db):
    crud.crear_categoria(db, {"id": "cat_1", "name": "Bebidas", "emoji": "☕"})
    crud.crear_producto(db, {"name": "Café", "categoryId": "cat_1", "price": 1, "stock": 1,
        "minStock": 0, "prepTimeMinutes": 0, "isAvailable": True, "description": "",
        "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "☕"})
    with pytest.raises(crud.CategoriaConProductosError):
        crud.eliminar_categoria(db, "cat_1")
