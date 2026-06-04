"""Router del contexto Plantilla IA (adaptador IN).

Implementa GET/PUT /plantilla-ia con el mismo contrato que los endpoints
originales de api_pedidos.py. Cuando no existe ninguna plantilla, GET devuelve
el fallback {"id": "main", "prompt": "", "contexto": "[]"}."""
from typing import Optional

from fastapi import APIRouter, Depends
from pydantic import BaseModel

from src.application.plantilla import ActualizarPlantillaIa, LeerPlantillaIa
from src.infrastructure.web.deps import (
    actualizar_plantilla_uc, leer_plantilla_uc, requerir_tenant,
)
from src.infrastructure.web.presenters import plantilla_a_dict

router = APIRouter()


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class PlantillaIaIn(BaseModel):
    prompt: Optional[str] = None
    contexto: Optional[str] = None


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.get("/plantilla-ia")
def obtener_plantilla_ia(
    uc: LeerPlantillaIa = Depends(leer_plantilla_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    p = uc.execute(negocio_id)
    if p is None:
        return {"id": "main", "prompt": "", "contexto": "[]"}
    return plantilla_a_dict(p)


@router.put("/plantilla-ia")
def actualizar_plantilla_ia_endpoint(
    body: PlantillaIaIn,
    uc: ActualizarPlantillaIa = Depends(actualizar_plantilla_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    p = uc.execute(datos, negocio_id)
    return plantilla_a_dict(p)
