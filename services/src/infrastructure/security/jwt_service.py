"""Adaptador de TokenService: implementa la emisión y validación de JWT usando src.infrastructure.security.jwt."""
from src.domain.entities import Usuario
from src.infrastructure.security.jwt import crear_token, decodificar_token


class JwtTokenService:
    """Implementa el puerto TokenService usando jwt.crear_token / jwt.decodificar_token."""

    def emitir(self, usuario: Usuario) -> str:
        return crear_token({
            "id": usuario.id,
            "negocioId": usuario.negocioId,
            "rol": usuario.rol,
            "email": usuario.email,
        })

    def verificar(self, token: str) -> dict:
        return decodificar_token(token)
