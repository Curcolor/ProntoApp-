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


def test_crear_usuario_201_y_listar(db):
    client = _client(db)
    r = client.post("/usuarios", json={"nombre": "Carlos", "email": "g@p.com",
                                       "password": "password123", "rol": "gerente"})
    assert r.status_code == 201
    assert r.json()["rol"] == "gerente"
    assert "contrasena_hash" not in r.json()
    lista = client.get("/usuarios").json()
    assert any(u["email"] == "g@p.com" for u in lista)


def test_crear_usuario_email_duplicado_409(db):
    client = _client(db)
    payload = {"nombre": "Carlos", "email": "dup@p.com", "password": "x", "rol": "gerente"}
    assert client.post("/usuarios", json=payload).status_code == 201
    assert client.post("/usuarios", json=payload).status_code == 409
