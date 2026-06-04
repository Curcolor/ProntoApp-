import pytest
from src import models
from src.application.pedidos import CrearPedido, EliminarPedido, ListarPedidos
from src.domain.errors import NoEncontradoError
from src.infrastructure.persistence.repositories import (
    SqlAlchemyClienteRepository,
    SqlAlchemyPedidoRepository,
    SqlAlchemyProductoRepository,
)
from src.infrastructure.web.presenters import pedido_a_dict


@pytest.fixture(autouse=True)
def _negocio_main(db):
    if db.get(models.Negocio, "main") is None:
        db.add(models.Negocio(id="main", nombre="ProntoApp"))
        db.flush()


def _payload():
    return {
        "cliente": "Ana", "telefono": "tg:99|3001234567",
        "items": [{"nombre": "Café", "cantidad": 2, "precio": 5000.0}],
        "total": 10000.0, "tipo": "domicilio", "direccion": "Cr 7 #1-2",
    }


def _crear_pedido(db, datos=None):
    return CrearPedido(
        SqlAlchemyPedidoRepository(db),
        SqlAlchemyClienteRepository(db),
        SqlAlchemyProductoRepository(db),
    ).execute(datos or _payload(), "main")


def test_crear_pedido_upsert_cliente_y_detalle(db):
    pedido = _crear_pedido(db)
    d = pedido_a_dict(pedido)
    assert d["id"].startswith("P-")
    assert d["estado"] == "recibido"
    # cliente upsert por numero_whatsapp
    clientes = db.query(models.Cliente).all()
    assert len(clientes) == 1
    # segundo pedido del mismo telefono no duplica cliente
    _crear_pedido(db)
    assert db.query(models.Cliente).count() == 1
    assert db.query(models.DetallePedido).count() == 2


def test_listar_pedidos_limpia_telefono(db):
    _crear_pedido(db)
    pedidos = ListarPedidos(SqlAlchemyPedidoRepository(db)).execute("main")
    d = pedido_a_dict(pedidos[0])
    assert d["telefono"] == "3001234567"
    assert d["cliente"] == "Ana"
    assert d["items"][0]["nombre"] == "Café"


def test_upsert_actualiza_nombre_del_cliente(db):
    _crear_pedido(db, _payload())  # cliente "Ana"
    _crear_pedido(db, {**_payload(), "cliente": "Ana María"})  # mismo telefono, nuevo nombre
    clientes = db.query(models.Cliente).all()
    assert len(clientes) == 1                  # no duplica el cliente
    assert clientes[0].nombre == "Ana María"   # usa el último nombre dado en el chat


def test_upsert_no_pisa_nombre_real_con_generico(db):
    _crear_pedido(db, {**_payload(), "cliente": "Ana María"})
    _crear_pedido(db, {**_payload(), "cliente": "Cliente"})  # genérico no debe pisar
    assert db.query(models.Cliente).one().nombre == "Ana María"


def test_actualizar_estado(db):
    pedido = _crear_pedido(db)
    actualizado = SqlAlchemyPedidoRepository(db).cambiar_estado(pedido.id, "listo", "main")
    assert actualizado is not None
    assert db.get(models.Pedido, pedido.id).estado == "listo"


def test_eliminar_pedido_cascade(db):
    pedido = _crear_pedido(db)
    # First delete succeeds
    EliminarPedido(SqlAlchemyPedidoRepository(db)).execute(pedido.id, "main")
    assert db.get(models.Pedido, pedido.id) is None
    assert db.query(models.DetallePedido).count() == 0
