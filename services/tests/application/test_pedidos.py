"""Tests unitarios de los casos de uso del contexto Pedidos.

Usan fakes en memoria; no tocan la base de datos."""
import pytest

from src.application.pedidos import (
    ActualizarEstadoPedido, CrearPedido, EliminarPedido, ListarPedidos,
)
from src.domain.entities import Cliente, DetallePedido, Pedido
from src.domain.errors import NoEncontradoError


# ─── Fakes ────────────────────────────────────────────────────────────────────

class FakeClienteRepo:
    def __init__(self):
        self.data: dict[tuple, Cliente] = {}

    def upsert(self, nombre: str, numero_whatsapp: str, negocio_id: str) -> Cliente:
        key = (negocio_id, numero_whatsapp)
        if key not in self.data:
            self.data[key] = Cliente(
                id=f"C-{len(self.data)+1}",
                nombre=nombre,
                numeroWhatsapp=numero_whatsapp,
            )
        return self.data[key]


class FakePedidoRepo:
    def __init__(self):
        self.data: dict[tuple, Pedido] = {}
        self._counter = 0

    def listar(self, negocio_id: str) -> list[Pedido]:
        return [p for (pid, neg), p in self.data.items() if neg == negocio_id]

    def obtener(self, pedido_id: str, negocio_id: str) -> Pedido | None:
        return self.data.get((pedido_id, negocio_id))

    def crear(self, cliente: Cliente, items: list[dict], datos: dict, negocio_id: str) -> Pedido:
        self._counter += 1
        pid = f"P-{self._counter:04d}"
        detalles = [
            DetallePedido(
                nombre=it["nombre"],
                cantidad=it["cantidad"],
                precioUnitario=it["precio"],
            )
            for it in items
        ]
        pedido = Pedido(
            id=pid,
            cliente=cliente,
            items=detalles,
            total=datos["total"],
            estado="recibido",
            tipo=datos["tipo"],
            direccion=datos.get("direccion"),
            creadoEn=None,
        )
        self.data[(pid, negocio_id)] = pedido
        return pedido

    def cambiar_estado(self, pedido_id: str, estado: str, negocio_id: str) -> Pedido | None:
        pedido = self.data.get((pedido_id, negocio_id))
        if pedido is None:
            return None
        pedido.estado = estado
        return pedido

    def eliminar(self, pedido_id: str, negocio_id: str) -> bool:
        return self.data.pop((pedido_id, negocio_id), None) is not None


class FakeProductoRepo:
    def __init__(self):
        self.descuentos_recibidos: list[tuple] = []

    def listar(self, n): return []
    def obtener(self, pid, n): return None
    def agregar(self, p, n): ...
    def actualizar(self, p, n): ...
    def eliminar(self, pid, n): ...
    def hay_en_categoria(self, cid, n): return False
    def reemplazar_todos(self, ps, n): ...

    def descontar_stock(self, items: list[dict], negocio_id: str) -> None:
        self.descuentos_recibidos.append((items, negocio_id))


class FakeNotificador:
    def __init__(self):
        self.llamadas: list[tuple] = []

    def notificar_cambio_estado(self, chat_id: str, pedido_id: str, estado: str) -> None:
        self.llamadas.append((chat_id, pedido_id, estado))


# ─── Fixtures ─────────────────────────────────────────────────────────────────

def _datos_pedido(**kwargs) -> dict:
    base = {
        "cliente": "Ana",
        "telefono": "3001234567",
        "items": [{"nombre": "Café", "cantidad": 2, "precio": 5000.0}],
        "total": 10000.0,
        "tipo": "domicilio",
        "direccion": "Cr 7 #1-2",
    }
    base.update(kwargs)
    return base


# ─── CrearPedido ──────────────────────────────────────────────────────────────

def test_crear_pedido_descuenta_stock():
    pedido_repo = FakePedidoRepo()
    cliente_repo = FakeClienteRepo()
    prod_repo = FakeProductoRepo()

    datos = _datos_pedido()
    uc = CrearPedido(pedido_repo, cliente_repo, prod_repo)
    pedido = uc.execute(datos, "main")

    assert pedido.estado == "recibido"
    assert len(prod_repo.descuentos_recibidos) == 1
    items_pasados, negocio_pasado = prod_repo.descuentos_recibidos[0]
    assert items_pasados == datos["items"]
    assert negocio_pasado == "main"


def test_crear_pedido_upsert_cliente_no_duplica():
    pedido_repo = FakePedidoRepo()
    cliente_repo = FakeClienteRepo()
    prod_repo = FakeProductoRepo()

    uc = CrearPedido(pedido_repo, cliente_repo, prod_repo)
    uc.execute(_datos_pedido(), "main")
    uc.execute(_datos_pedido(), "main")

    assert len(cliente_repo.data) == 1


# ─── ActualizarEstadoPedido ───────────────────────────────────────────────────

def test_actualizar_estado_notifica_cuando_tg_y_estado_cambia():
    pedido_repo = FakePedidoRepo()
    cliente_repo = FakeClienteRepo()
    prod_repo = FakeProductoRepo()
    notificador = FakeNotificador()

    datos = _datos_pedido(telefono="tg:99|3001234567")
    CrearPedido(pedido_repo, cliente_repo, prod_repo).execute(datos, "main")
    pedido_id = list(pedido_repo.data.keys())[0][0]

    ActualizarEstadoPedido(pedido_repo, notificador).execute(pedido_id, "listo", "main")

    assert len(notificador.llamadas) == 1
    chat_id, pid, estado = notificador.llamadas[0]
    assert chat_id == "99"
    assert pid == pedido_id
    assert estado == "listo"


def test_actualizar_estado_no_notifica_si_estado_no_cambia():
    pedido_repo = FakePedidoRepo()
    cliente_repo = FakeClienteRepo()
    prod_repo = FakeProductoRepo()
    notificador = FakeNotificador()

    datos = _datos_pedido(telefono="tg:99|3001234567")
    CrearPedido(pedido_repo, cliente_repo, prod_repo).execute(datos, "main")
    pedido_id = list(pedido_repo.data.keys())[0][0]

    # estado inicial ya es "recibido", actualizamos a "recibido" → sin cambio
    ActualizarEstadoPedido(pedido_repo, notificador).execute(pedido_id, "recibido", "main")

    assert len(notificador.llamadas) == 0


def test_actualizar_estado_no_notifica_si_telefono_no_es_tg():
    pedido_repo = FakePedidoRepo()
    cliente_repo = FakeClienteRepo()
    prod_repo = FakeProductoRepo()
    notificador = FakeNotificador()

    datos = _datos_pedido(telefono="3001234567")  # sin prefijo tg:
    CrearPedido(pedido_repo, cliente_repo, prod_repo).execute(datos, "main")
    pedido_id = list(pedido_repo.data.keys())[0][0]

    ActualizarEstadoPedido(pedido_repo, notificador).execute(pedido_id, "listo", "main")

    assert len(notificador.llamadas) == 0


def test_actualizar_estado_pedido_inexistente_lanza_error():
    pedido_repo = FakePedidoRepo()
    notificador = FakeNotificador()

    with pytest.raises(NoEncontradoError):
        ActualizarEstadoPedido(pedido_repo, notificador).execute("P-9999", "listo", "main")


# ─── EliminarPedido ───────────────────────────────────────────────────────────

def test_eliminar_pedido_inexistente_lanza_error():
    pedido_repo = FakePedidoRepo()

    with pytest.raises(NoEncontradoError):
        EliminarPedido(pedido_repo).execute("P-9999", "main")


# ─── ListarPedidos ────────────────────────────────────────────────────────────

def test_listar_pedidos_aislado_por_negocio():
    pedido_repo = FakePedidoRepo()
    cliente_repo = FakeClienteRepo()
    prod_repo = FakeProductoRepo()

    uc_crear = CrearPedido(pedido_repo, cliente_repo, prod_repo)
    uc_crear.execute(_datos_pedido(), "negocio_A")
    uc_crear.execute(_datos_pedido(), "negocio_A")
    uc_crear.execute(_datos_pedido(), "negocio_B")

    resultado_a = ListarPedidos(pedido_repo).execute("negocio_A")
    resultado_b = ListarPedidos(pedido_repo).execute("negocio_B")

    assert len(resultado_a) == 2
    assert len(resultado_b) == 1
