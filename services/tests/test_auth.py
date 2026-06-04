import pytest
from fastapi.testclient import TestClient

from src import models
from src.application.usuarios import CrearUsuario
from src.infrastructure.persistence.repositories import SqlAlchemyUsuarioRepository
from src.infrastructure.security.password import BcryptPasswordHasher


@pytest.fixture(autouse=True)
def _negocio_main(db):
    if db.get(models.Negocio, "main") is None:
        db.add(models.Negocio(id="main", nombre="ProntoApp"))
        db.flush()


def _client(db):
    from src import api_pedidos
    api_pedidos.app.dependency_overrides[api_pedidos.get_db] = lambda: db
    return TestClient(api_pedidos.app)


def test_login_ok_devuelve_token_y_fallo(db):
    from src.infrastructure.security import jwt as auth
    CrearUsuario(SqlAlchemyUsuarioRepository(db), BcryptPasswordHasher()).execute(
        {"id": "1", "nombre": "Carlos", "email": "g@p.com",
         "password": "password123", "rol": "gerente"},
        "main",
    )
    client = _client(db)
    ok = client.post("/auth/login", json={"email": "g@p.com", "password": "password123"})
    assert ok.status_code == 200
    cuerpo = ok.json()
    assert cuerpo["rol"] == "gerente"          # respuesta sigue plana
    assert "contrasena_hash" not in cuerpo
    assert auth.decodificar_token(cuerpo["token"])["negocio_id"] == "main"
    bad = client.post("/auth/login", json={"email": "g@p.com", "password": "mala"})
    assert bad.status_code == 401


def test_registro_devuelve_token(db):
    from src.infrastructure.security import jwt as auth
    client = _client(db)
    r = client.post("/registro", json={"nombre": "Ana", "email": "a@p.com",
                                       "password": "x", "businessName": "Café"})
    assert r.status_code == 201
    cuerpo = r.json()
    assert auth.decodificar_token(cuerpo["token"])["negocio_id"] == cuerpo["negocioId"]
