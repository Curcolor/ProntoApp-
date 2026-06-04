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


def test_put_negocio_persiste(db):
    client = _client(db)
    r = client.put("/negocio", json={"nombre": "Pronto Café", "numeroWhatsapp": "+57 300"})
    assert r.status_code == 200
    assert r.json()["nombre"] == "Pronto Café"
    assert client.get("/negocio").json()["numeroWhatsapp"] == "+57 300"


def test_patch_usuario(db):
    client = _client(db)
    pid = client.post("/usuarios", json={"nombre": "Ana", "email": "a@p.com",
                                         "password": "x", "rol": "cocinero"}).json()["id"]
    r = client.patch(f"/usuarios/{pid}", json={"nombre": "Ana María", "rol": "repartidor"})
    assert r.status_code == 200
    assert r.json()["nombre"] == "Ana María"
    assert r.json()["rol"] == "repartidor"
    assert client.patch("/usuarios/nope", json={"nombre": "x"}).status_code == 404


def test_delete_usuario(db):
    client = _client(db)
    pid = client.post("/usuarios", json={"nombre": "Tmp", "email": "t@p.com",
                                         "password": "x", "rol": "cocinero"}).json()["id"]
    assert client.delete(f"/usuarios/{pid}").status_code == 204
    assert client.delete(f"/usuarios/{pid}").status_code == 404
