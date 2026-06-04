import pytest
from fastapi.testclient import TestClient

from src import models


@pytest.fixture(autouse=True)
def _negocio_main(db):
    if db.get(models.Negocio, "main") is None:
        db.add(models.Negocio(id="main", nombre="ProntoApp"))
        db.flush()


def _client(db):
    from src import api_pedidos
    api_pedidos.app.dependency_overrides[api_pedidos.get_db] = lambda: db
    return TestClient(api_pedidos.app)


def test_crud_producto_endpoints(db):
    client = _client(db)
    client.post("/categorias", json={"id": "cat_1", "name": "Bebidas", "emoji": "☕"})
    r = client.post("/productos", json={
        "name": "Café", "categoryId": "cat_1", "price": 5000, "stock": 10,
        "minStock": 2, "prepTimeMinutes": 3, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "☕"})
    assert r.status_code == 201
    pid = r.json()["id"]
    assert r.json()["categoryId"] == "cat_1"
    up = client.patch(f"/productos/{pid}", json={"price": 6000})
    assert up.status_code == 200 and up.json()["price"] == 6000
    assert client.patch("/productos/nope", json={"price": 1}).status_code == 404
    assert client.delete(f"/productos/{pid}").status_code == 204
    assert client.delete(f"/productos/{pid}").status_code == 404


def test_eliminar_categoria_con_productos_409(db):
    client = _client(db)
    client.post("/categorias", json={"id": "cat_1", "name": "Bebidas", "emoji": "☕"})
    client.post("/productos", json={"name": "Café", "categoryId": "cat_1", "price": 1,
        "stock": 1, "minStock": 0, "prepTimeMinutes": 0, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "☕"})
    assert client.delete("/categorias/cat_1").status_code == 409
