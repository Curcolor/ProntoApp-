import pytest
from fastapi.testclient import TestClient

from src import models


@pytest.fixture(autouse=True)
def _negocios(db):
    for nid in ("main", "A", "B"):
        if db.get(models.Negocio, nid) is None:
            db.add(models.Negocio(id=nid, nombre=nid))
    db.flush()


def _client(db):
    from src import api_pedidos
    api_pedidos.app.dependency_overrides[api_pedidos.get_db] = lambda: db
    return TestClient(api_pedidos.app)


def _token_de_negocio_nuevo(c):
    reg = c.post("/registro", json={"nombre": "Ana", "email": "a@p.com",
                                    "password": "x", "businessName": "Café"}).json()
    return reg["token"], reg["negocioId"]


def test_token_overridea_el_header_x_negocio_id(db):
    c = _client(db)
    token, _neg = _token_de_negocio_nuevo(c)
    hdr = {"Authorization": f"Bearer {token}"}
    c.post("/categorias", json={"id": "c1", "name": "C", "emoji": "x"}, headers=hdr)
    # Aunque el cliente afirme otro negocio en el header, ve solo el suyo.
    inv = c.get("/inventario", headers={**hdr, "X-Negocio-Id": "B"}).json()
    assert [x["id"] for x in inv["categorias"]] == ["c1"]


def test_token_invalido_da_401(db):
    c = _client(db)
    r = c.get("/inventario", headers={"Authorization": "Bearer no.es.jwt"})
    assert r.status_code == 401


def test_sin_auth_con_secreto_seteado_da_401(db, monkeypatch):
    monkeypatch.setattr("src.infrastructure.web.deps.SECRETO", "s3cr3t")
    c = _client(db)
    r = c.get("/inventario", headers={"X-Negocio-Id": "A"})
    assert r.status_code == 401


def test_ruta_servicio_con_secreto_correcto(db, monkeypatch):
    monkeypatch.setattr("src.infrastructure.web.deps.SECRETO", "s3cr3t")
    c = _client(db)
    hdr = {"X-Secret": "s3cr3t", "X-Negocio-Id": "A"}
    c.post("/categorias", json={"id": "c1", "name": "C", "emoji": "x"}, headers=hdr)
    inv = c.get("/inventario", headers=hdr).json()
    assert [x["id"] for x in inv["categorias"]] == ["c1"]


def test_token_valido_sin_negocio_id_da_401(db):
    import os

    import jwt

    tok = jwt.encode({"sub": "x"}, os.environ["JWT_SECRET"], algorithm="HS256")
    c = _client(db)
    r = c.get("/inventario", headers={"Authorization": f"Bearer {tok}"})
    assert r.status_code == 401
