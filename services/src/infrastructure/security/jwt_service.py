"""Adaptador de TokenService: implementa la emisión de JWT usando src.auth."""
from src.domain.entities import Usuario


class JwtTokenService:
    """Implementa el puerto TokenService usando auth.crear_token."""

    def emitir(self, usuario: Usuario) -> str:
        from src.auth import crear_token
        return crear_token({
            "id": usuario.id,
            "negocioId": usuario.negocioId,
            "rol": usuario.rol,
            "email": usuario.email,
        })
