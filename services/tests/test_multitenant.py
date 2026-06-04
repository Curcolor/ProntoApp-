import pytest

from src import crud, models


@pytest.fixture(autouse=True)
def _negocios(db):
    """Crea los negocios usados por los tests para satisfacer la FK negocio_id."""
    for nid in ("main", "A", "B"):
        if db.get(models.Negocio, nid) is None:
            db.add(models.Negocio(id=nid, nombre=nid))
    db.flush()


def _cat(db, neg, cid):
    crud.crear_categoria(db, {"id": cid, "name": "C", "emoji": "x"}, neg)


def _prod(db, neg, pid, cid):
    crud.crear_producto(db, {"id": pid, "name": "P", "categoryId": cid, "price": 1,
        "stock": 5, "minStock": 0, "prepTimeMinutes": 0, "isAvailable": True,
        "description": "", "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "x"}, neg)


def test_inventario_aislado(db):
    _cat(db, "A", "ca"); _prod(db, "A", "pa", "ca")
    _cat(db, "B", "cb"); _prod(db, "B", "pb", "cb")
    inv_a = crud.leer_inventario(db, "A")
    assert [p["id"] for p in inv_a["productos"]] == ["pa"]
    assert [c["id"] for c in inv_a["categorias"]] == ["ca"]


def test_actualizar_producto_ajeno_devuelve_none(db):
    _cat(db, "A", "ca"); _prod(db, "A", "pa", "ca")
    assert crud.actualizar_producto(db, "pa", {"price": 9}, "B") is None
    assert crud.actualizar_producto(db, "pa", {"price": 9}, "A")["price"] == 9


def _pedido(neg_tel):
    return {"cliente": "Ana", "telefono": neg_tel, "items": [], "total": 1000,
            "tipo": "recoger", "direccion": None}


def test_pedidos_aislados(db):
    crud.crear_pedido(db, _pedido("300A"), "A")
    crud.crear_pedido(db, _pedido("300B"), "B")
    assert len(crud.listar_pedidos(db, "A")) == 1
    assert crud.listar_pedidos(db, "A")[0]["telefono"] == "300A"


def test_mismo_whatsapp_distinto_negocio(db):
    crud.crear_pedido(db, _pedido("300"), "A")
    crud.crear_pedido(db, _pedido("300"), "B")  # no debe chocar
    assert db.query(models.Cliente).count() == 2
