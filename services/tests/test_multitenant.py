import pytest

from src import models
from src.application.auth import RegistrarNegocio
from src.application.inventario import ActualizarProducto, CrearCategoria, CrearProducto
from src.application.pedidos import CrearPedido, ListarPedidos
from src.application.plantilla import ActualizarPlantillaIa, LeerPlantillaIa
from src.application.usuarios import CrearUsuario, ListarUsuarios
from src.domain.errors import EmailDuplicadoError, NoEncontradoError
from src.infrastructure.persistence.repositories import (
    SqlAlchemyCategoriaRepository,
    SqlAlchemyClienteRepository,
    SqlAlchemyNegocioRepository,
    SqlAlchemyPedidoRepository,
    SqlAlchemyPlantillaIaRepository,
    SqlAlchemyProductoRepository,
    SqlAlchemyUsuarioRepository,
)
from src.infrastructure.security.password import BcryptPasswordHasher
from src.infrastructure.web.presenters import pedido_a_dict, usuario_a_dict


@pytest.fixture(autouse=True)
def _negocios(db):
    """Crea los negocios usados por los tests para satisfacer la FK negocio_id."""
    for nid in ("main", "A", "B"):
        if db.get(models.Negocio, nid) is None:
            db.add(models.Negocio(id=nid, nombre=nid))
    db.flush()


def _cat(db, neg, cid):
    CrearCategoria(SqlAlchemyCategoriaRepository(db)).execute(
        {"id": cid, "name": "C", "emoji": "x"}, neg
    )


def _prod(db, neg, pid, cid):
    CrearProducto(SqlAlchemyProductoRepository(db)).execute(
        {"id": pid, "name": "P", "categoryId": cid, "price": 1,
         "stock": 5, "minStock": 0, "prepTimeMinutes": 0, "isAvailable": True,
         "description": "", "aiContext": "", "aiActive": True, "imageUrl": None, "emoji": "x"},
        neg,
    )


def test_inventario_aislado(db):
    _cat(db, "A", "ca"); _prod(db, "A", "pa", "ca")
    _cat(db, "B", "cb"); _prod(db, "B", "pb", "cb")
    from src.application.inventario import LeerInventario
    cats, prods = LeerInventario(
        SqlAlchemyCategoriaRepository(db),
        SqlAlchemyProductoRepository(db),
    ).execute("A")
    assert [p.id for p in prods] == ["pa"]
    assert [c.id for c in cats] == ["ca"]


def test_actualizar_producto_ajeno_devuelve_none(db):
    _cat(db, "A", "ca"); _prod(db, "A", "pa", "ca")
    with pytest.raises(NoEncontradoError):
        ActualizarProducto(SqlAlchemyProductoRepository(db)).execute("pa", {"price": 9}, "B")
    upd = ActualizarProducto(SqlAlchemyProductoRepository(db)).execute("pa", {"price": 9}, "A")
    assert upd.price == 9


def _pedido(neg_tel):
    return {"cliente": "Ana", "telefono": neg_tel, "items": [], "total": 1000,
            "tipo": "recoger", "direccion": None}


def _crear_pedido(db, datos, neg):
    return CrearPedido(
        SqlAlchemyPedidoRepository(db),
        SqlAlchemyClienteRepository(db),
        SqlAlchemyProductoRepository(db),
    ).execute(datos, neg)


def test_pedidos_aislados(db):
    _crear_pedido(db, _pedido("300A"), "A")
    _crear_pedido(db, _pedido("300B"), "B")
    pedidos_a = ListarPedidos(SqlAlchemyPedidoRepository(db)).execute("A")
    assert len(pedidos_a) == 1
    assert pedido_a_dict(pedidos_a[0])["telefono"] == "300A"


def test_mismo_whatsapp_distinto_negocio(db):
    _crear_pedido(db, _pedido("300"), "A")
    _crear_pedido(db, _pedido("300"), "B")  # no debe chocar
    assert db.query(models.Cliente).count() == 2


def test_usuarios_aislados(db):
    CrearUsuario(SqlAlchemyUsuarioRepository(db), BcryptPasswordHasher()).execute(
        {"nombre": "Ga", "email": "ga@p.com", "password": "x", "rol": "gerente"}, "A"
    )
    CrearUsuario(SqlAlchemyUsuarioRepository(db), BcryptPasswordHasher()).execute(
        {"nombre": "Gb", "email": "gb@p.com", "password": "x", "rol": "gerente"}, "B"
    )
    usuarios_a = ListarUsuarios(SqlAlchemyUsuarioRepository(db)).execute("A")
    dicts_a = [usuario_a_dict(u) for u in usuarios_a]
    assert [u["email"] for u in dicts_a] == ["ga@p.com"]
    assert dicts_a[0]["negocioId"] == "A"


def test_plantilla_aislada(db):
    ActualizarPlantillaIa(SqlAlchemyPlantillaIaRepository(db)).execute({"prompt": "PA"}, "A")
    ActualizarPlantillaIa(SqlAlchemyPlantillaIaRepository(db)).execute({"prompt": "PB"}, "B")
    p_a = LeerPlantillaIa(SqlAlchemyPlantillaIaRepository(db)).execute("A")
    p_b = LeerPlantillaIa(SqlAlchemyPlantillaIaRepository(db)).execute("B")
    assert p_a.prompt == "PA"
    assert p_b.prompt == "PB"


def test_registrar_crea_negocio_y_gerente(db):
    u = RegistrarNegocio(
        SqlAlchemyNegocioRepository(db),
        SqlAlchemyUsuarioRepository(db),
        BcryptPasswordHasher(),
    ).execute({"nombre": "Ana", "email": "a@p.com", "password": "x", "businessName": "Café Ana"})
    d = usuario_a_dict(u)
    assert d["rol"] == "gerente"
    neg_id = d["negocioId"]
    assert db.get(models.Negocio, neg_id).nombre == "Café Ana"
    with pytest.raises(EmailDuplicadoError):
        RegistrarNegocio(
            SqlAlchemyNegocioRepository(db),
            SqlAlchemyUsuarioRepository(db),
            BcryptPasswordHasher(),
        ).execute({"nombre": "Otro", "email": "a@p.com", "password": "y", "businessName": "X"})
