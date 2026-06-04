from fastapi.testclient import TestClient


def _client(db):
    from src import api_pedidos
    api_pedidos.app.dependency_overrides[api_pedidos.get_db] = lambda: db
    return TestClient(api_pedidos.app)


def test_get_plantilla_default(db):
    client = _client(db)
    r = client.get("/plantilla-ia")
    assert r.status_code == 200
    assert "prompt" in r.json() and "contexto" in r.json()


def test_put_plantilla_persiste(db):
    client = _client(db)
    r = client.put("/plantilla-ia", json={"prompt": "Sos Pronto", "contexto": "[\"hola\"]"})
    assert r.status_code == 200
    assert r.json()["prompt"] == "Sos Pronto"
    assert client.get("/plantilla-ia").json()["contexto"] == "[\"hola\"]"
