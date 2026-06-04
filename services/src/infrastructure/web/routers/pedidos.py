"""Router del contexto Pedidos (adaptador IN).

Recrea los endpoints GET/POST /pedidos, PATCH /pedidos/{id}/estado y
DELETE /pedidos/{id} con el MISMO contrato. Traduce errores de dominio a HTTP."""
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from src.application.pedidos import (
    ActualizarEstadoPedido, CrearPedido, EliminarPedido, ListarPedidos,
)
from src.domain.errors import NoEncontradoError
from src.infrastructure.web.deps import (
    actualizar_estado_pedido_uc, crear_pedido_uc, eliminar_pedido_uc,
    listar_pedidos_uc, requerir_tenant,
)
from src.infrastructure.web.presenters import pedido_a_dict

router = APIRouter()


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class ItemPedidoIn(BaseModel):
    nombre: str
    cantidad: int
    precio: float


class PedidoIn(BaseModel):
    cliente: str
    telefono: str
    items: list[ItemPedidoIn]
    total: float
    tipo: str
    direccion: Optional[str] = None


class EstadoIn(BaseModel):
    estado: str


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.get("/pedidos")
def obtener_pedidos(
    uc: ListarPedidos = Depends(listar_pedidos_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    return [pedido_a_dict(p) for p in uc.execute(negocio_id)]


@router.post("/pedidos", status_code=status.HTTP_201_CREATED)
def crear_pedido(
    body: PedidoIn,
    uc: CrearPedido = Depends(crear_pedido_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    pedido = uc.execute(body.model_dump(), negocio_id)
    return pedido_a_dict(pedido)


@router.patch("/pedidos/{pedido_id}/estado")
def actualizar_estado(
    pedido_id: str,
    body: EstadoIn,
    uc: ActualizarEstadoPedido = Depends(actualizar_estado_pedido_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    try:
        pedido = uc.execute(pedido_id, body.estado, negocio_id)
    except NoEncontradoError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Pedido {pedido_id} no encontrado",
        )
    return pedido_a_dict(pedido)


@router.delete("/pedidos/{pedido_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_pedido(
    pedido_id: str,
    uc: EliminarPedido = Depends(eliminar_pedido_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    try:
        uc.execute(pedido_id, negocio_id)
    except NoEncontradoError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Pedido {pedido_id} no encontrado",
        )
