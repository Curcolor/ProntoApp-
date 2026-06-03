from src import crud, models


def _payload():
    return {
        "cliente": "Ana", "telefono": "tg:99|3001234567",
        "items": [{"nombre": "Café", "cantidad": 2, "precio": 5000.0}],
        "total": 10000.0, "tipo": "domicilio", "direccion": "Cr 7 #1-2",
    }


def test_crear_pedido_upsert_cliente_y_detalle(db):
    pedido = crud.crear_pedido(db, _payload())
    assert pedido["id"].startswith("P-")
    assert pedido["estado"] == "recibido"
    # cliente upsert por numero_whatsapp
    clientes = db.query(models.Cliente).all()
    assert len(clientes) == 1
    # segundo pedido del mismo telefono no duplica cliente
    crud.crear_pedido(db, _payload())
    assert db.query(models.Cliente).count() == 1
    assert db.query(models.DetallePedido).count() == 2


def test_listar_pedidos_limpia_telefono(db):
    crud.crear_pedido(db, _payload())
    pedidos = crud.listar_pedidos(db)
    assert pedidos[0]["telefono"] == "3001234567"
    assert pedidos[0]["cliente"] == "Ana"
    assert pedidos[0]["items"][0]["nombre"] == "Café"


def test_actualizar_estado(db):
    p = crud.crear_pedido(db, _payload())
    ok = crud.actualizar_estado(db, p["id"], "listo")
    assert ok is not None
    assert db.get(models.Pedido, p["id"]).estado == "listo"


def test_eliminar_pedido_cascade(db):
    p = crud.crear_pedido(db, _payload())
    assert crud.eliminar_pedido(db, p["id"]) is True
    assert db.query(models.DetallePedido).count() == 0
