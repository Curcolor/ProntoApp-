import pytest
from fastapi.testclient import TestClient

from src import models


@pytest.fixture(autouse=True)
def _negocio_main(db):
    if db.get(models.Negocio, "main") is None:
        db.add(models.Negocio(id="main", nombre="ProntoApp"))
        db.flush()


def _client(db):
    """Sustituye la dependencia get_db por la sesión de test (sin cerrarla)."""
    from src import api_pedidos
    api_pedidos.app.dependency_overrides[api_pedidos.get_db] = lambda: db
    return TestClient(api_pedidos.app)


def test_post_get_pedidos_contract(db):
    client = _client(db)
    # inventario base para descuento de stock
    client.put("/inventario", json={
        "categorias": [{"id": "c", "name": "x", "emoji": "x"}],
        "productos": [{
            "id": "p", "name": "Café", "categoryId": "c", "price": 5000,
            "stock": 5, "minStock": 0, "prepTimeMinutes": 0, "isAvailable": True,
            "description": "", "aiContext": "", "aiActive": True,
            "imageUrl": None, "emoji": "x",
        }],
    })
    r = client.post("/pedidos", json={
        "cliente": "Ana", "telefono": "tg:9|300", "tipo": "recoger", "total": 10000,
        "items": [{"nombre": "Café", "cantidad": 2, "precio": 5000}],
    })
    assert r.status_code == 201
    body = r.json()
    assert set(body) >= {"id", "cliente", "telefono", "items", "total", "tipo",
                          "direccion", "estado", "creado_en"}
    g = client.get("/pedidos").json()
    assert g[0]["telefono"] == "300"
    assert g[0]["items"][0]["nombre"] == "Café"


def test_get_inventario_contract(db):
    client = _client(db)
    inv = client.get("/inventario").json()
    assert "categorias" in inv and "productos" in inv
