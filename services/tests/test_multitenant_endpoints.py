import pytest
from fastapi.testclient import TestClient

from src import models


@pytest.fixture(autouse=True)
def _negocios(db):
    """Crea los negocios usados por los tests para satisfacer la FK negocio_id."""
    for nid in ("main", "A", "B"):
        if db.get(models.Negocio, nid) is None:
            db.add(models.Negocio(id=nid, nombre=nid))
    db.flush()


def _client(db):
    from src import api_pedidos
    api_pedidos.app.dependency_overrides[api_pedidos.get_db] = lambda: db
    return TestClient(api_pedidos.app)


def test_inventario_por_header(db):
    c = _client(db)
    c.post("/categorias", json={"id": "ca", "name": "C", "emoji": "x"}, headers={"X-Negocio-Id": "A"})
    c.post("/categorias", json={"id": "cb", "name": "C", "emoji": "x"}, headers={"X-Negocio-Id": "B"})
    inv_a = c.get("/inventario", headers={"X-Negocio-Id": "A"}).json()
    assert [x["id"] for x in inv_a["categorias"]] == ["ca"]


def test_registro_y_login_devuelve_negocio(db):
    c = _client(db)
    r = c.post("/registro", json={"nombre": "Ana", "email": "a@p.com", "password": "x", "businessName": "Café"})
    assert r.status_code == 201
    neg = r.json()["negocioId"]
    login = c.post("/auth/login", json={"email": "a@p.com", "password": "x"}).json()
    assert login["negocioId"] == neg
