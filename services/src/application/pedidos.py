"""Casos de uso del contexto Pedidos.

Dependencias inyectadas por constructor; cada caso expone `execute(...)`.
Replican el comportamiento de las funciones `crud.*` originales, pero lanzan
errores de dominio (nunca HTTPException) y operan sobre entidades de dominio."""
from src.domain.entities import Pedido
from src.domain.errors import NoEncontradoError
from src.domain.ports import ClienteRepository, NotificadorPedidos, PedidoRepository, ProductoRepository


class ListarPedidos:
    def __init__(self, pedido_repo: PedidoRepository):
        self._pedido_repo = pedido_repo

    def execute(self, negocio_id: str) -> list[Pedido]:
        return self._pedido_repo.listar(negocio_id)


class CrearPedido:
    def __init__(
        self,
        pedido_repo: PedidoRepository,
        cliente_repo: ClienteRepository,
        prod_repo: ProductoRepository,
    ):
        self._pedido_repo = pedido_repo
        self._cliente_repo = cliente_repo
        self._prod_repo = prod_repo

    def execute(self, datos: dict, negocio_id: str) -> Pedido:
        cliente = self._cliente_repo.upsert(datos["cliente"], datos["telefono"], negocio_id)
        pedido = self._pedido_repo.crear(cliente, datos["items"], datos, negocio_id)
        self._prod_repo.descontar_stock(datos["items"], negocio_id)
        return pedido


class ActualizarEstadoPedido:
    def __init__(self, pedido_repo: PedidoRepository, notificador: NotificadorPedidos):
        self._pedido_repo = pedido_repo
        self._notificador = notificador

    def execute(self, pedido_id: str, estado: str, negocio_id: str) -> Pedido:
        pedido = self._pedido_repo.obtener(pedido_id, negocio_id)
        if pedido is None:
            raise NoEncontradoError(pedido_id)
        estado_anterior = pedido.estado
        actualizado = self._pedido_repo.cambiar_estado(pedido_id, estado, negocio_id)
        if actualizado is None:
            raise NoEncontradoError(pedido_id)
        if estado_anterior != estado and actualizado.cliente.numeroWhatsapp.startswith("tg:"):
            chat_id = actualizado.cliente.numeroWhatsapp.split("|")[0].replace("tg:", "")
            self._notificador.notificar_cambio_estado(chat_id, pedido_id, estado)
        return actualizado


class EliminarPedido:
    def __init__(self, pedido_repo: PedidoRepository):
        self._pedido_repo = pedido_repo

    def execute(self, pedido_id: str, negocio_id: str) -> None:
        if not self._pedido_repo.eliminar(pedido_id, negocio_id):
            raise NoEncontradoError(pedido_id)
