"""Router del contexto Negocio (adaptador IN).

Implementa GET/PUT /negocio con el mismo contrato que los endpoints originales
de api_pedidos.py."""
from typing import Optional

from fastapi import APIRouter, Depends
from pydantic import BaseModel

from src.application.negocio import ActualizarNegocio, LeerNegocio
from src.infrastructure.web.deps import (
    actualizar_negocio_uc, leer_negocio_uc, requerir_tenant,
)
from src.infrastructure.web.presenters import negocio_a_dict

router = APIRouter()


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class NegocioIn(BaseModel):
    tipoNegocio: Optional[str] = None
    nombre: Optional[str] = None
    direccion: Optional[str] = None
    horaApertura: Optional[str] = None
    horaCierre: Optional[str] = None
    formatoEntrega: Optional[str] = None
    terminosEntrega: Optional[str] = None
    numeroWhatsapp: Optional[str] = None


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.get("/negocio")
def obtener_negocio(
    uc: LeerNegocio = Depends(leer_negocio_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    n = uc.execute(negocio_id)
    if n is None:
        return None
    return negocio_a_dict(n)


@router.put("/negocio")
def actualizar_negocio_endpoint(
    body: NegocioIn,
    uc: ActualizarNegocio = Depends(actualizar_negocio_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    n = uc.execute(datos, negocio_id)
    return negocio_a_dict(n)
