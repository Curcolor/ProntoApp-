from fastapi.testclient import TestClient


def _client(db):
    from src import api_pedidos
    api_pedidos.app.dependency_overrides[api_pedidos.get_db] = lambda: db
    return TestClient(api_pedidos.app)


def test_login_ok_y_fallo(db):
    from src import crud
    crud.crear_usuario(db, {"id": "1", "nombre": "Carlos", "email": "g@p.com",
                            "password": "password123", "rol": "gerente"})
    client = _client(db)
    ok = client.post("/auth/login", json={"email": "g@p.com", "password": "password123"})
    assert ok.status_code == 200
    assert ok.json()["rol"] == "gerente"
    assert "contrasena_hash" not in ok.json()
    bad = client.post("/auth/login", json={"email": "g@p.com", "password": "mala"})
    assert bad.status_code == 401
