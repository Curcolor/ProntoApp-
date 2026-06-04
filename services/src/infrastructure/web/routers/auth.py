"""Router del contexto Auth (adaptador IN).

Implementa POST /auth/login y POST /registro con el MISMO contrato que los
endpoints originales de api_pedidos.py. Traduce errores de dominio a HTTP."""
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel

from src.application.auth import Login, RegistrarNegocio
from src.domain.errors import EmailDuplicadoError
from src.domain.ports import TokenService
from src.infrastructure.web.deps import get_token_service, login_uc, registrar_negocio_uc
from src.infrastructure.web.presenters import usuario_a_dict

router = APIRouter()


# ─── Modelos Pydantic ─────────────────────────────────────────────────────────

class LoginIn(BaseModel):
    email: str
    password: str


class RegistroIn(BaseModel):
    nombre: str
    email: str
    password: str
    businessName: str
    telefono: Optional[str] = None


# ─── Endpoints ────────────────────────────────────────────────────────────────

@router.post("/auth/login")
def auth_login(
    body: LoginIn,
    uc: Login = Depends(login_uc),
    token_service: TokenService = Depends(get_token_service),
):
    usuario = uc.execute(body.email, body.password)
    if usuario is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales inválidas",
        )
    return {**usuario_a_dict(usuario), "token": token_service.emitir(usuario)}


@router.post("/registro", status_code=status.HTTP_201_CREATED)
def registro_endpoint(
    body: RegistroIn,
    uc: RegistrarNegocio = Depends(registrar_negocio_uc),
    token_service: TokenService = Depends(get_token_service),
):
    try:
        usuario = uc.execute(body.model_dump())
    except EmailDuplicadoError:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El email ya está registrado",
        )
    return {**usuario_a_dict(usuario), "token": token_service.emitir(usuario)}
