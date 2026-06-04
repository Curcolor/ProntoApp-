"""Router del contexto Usuarios (adaptador IN).

Implementa POST/GET /usuarios y PATCH/DELETE /usuarios/{usuario_id} con el
mismo contrato que los endpoints originales de api_pedidos.py. Traduce errores
de dominio a HTTP."""
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from src.application.usuarios import (
    ActualizarUsuario, CrearUsuario, EliminarUsuario, ListarUsuarios,
)
from src.domain.errors import EmailDuplicadoError, NoEncontradoError
from src.infrastructure.web.deps import (
    actualizar_usuario_uc, crear_usuario_uc, eliminar_usuario_uc,
    listar_usuarios_uc, requerir_tenant,
)
from src.infrastructure.web.presenters import usuario_a_dict

router = APIRouter()


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class UsuarioIn(BaseModel):
    nombre: str
    email: str
    password: str
    rol: str
    telefono: Optional[str] = None


class UsuarioPatch(BaseModel):
    nombre: Optional[str] = None
    telefono: Optional[str] = None
    rol: Optional[str] = None


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.post("/usuarios", status_code=status.HTTP_201_CREATED)
def crear_usuario_endpoint(
    body: UsuarioIn,
    uc: CrearUsuario = Depends(crear_usuario_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    try:
        usuario = uc.execute(body.model_dump(), negocio_id)
    except EmailDuplicadoError:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El email ya está registrado",
        )
    return usuario_a_dict(usuario)


@router.get("/usuarios")
def listar_usuarios_endpoint(
    uc: ListarUsuarios = Depends(listar_usuarios_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    return [usuario_a_dict(u) for u in uc.execute(negocio_id)]


@router.patch("/usuarios/{usuario_id}")
def actualizar_usuario_endpoint(
    usuario_id: str,
    body: UsuarioPatch,
    uc: ActualizarUsuario = Depends(actualizar_usuario_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    try:
        usuario = uc.execute(usuario_id, datos, negocio_id)
    except NoEncontradoError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Usuario {usuario_id} no encontrado",
        )
    return usuario_a_dict(usuario)


@router.delete("/usuarios/{usuario_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_usuario_endpoint(
    usuario_id: str,
    uc: EliminarUsuario = Depends(eliminar_usuario_uc),
    negocio_id: str = Depends(requerir_tenant),
):
    try:
        uc.execute(usuario_id, negocio_id)
    except NoEncontradoError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Usuario {usuario_id} no encontrado",
        )
