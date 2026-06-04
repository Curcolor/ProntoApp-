"""Emisión y validación de JWT (HS256) para la auth de la app."""
import os
from datetime import datetime, timedelta, timezone

import jwt  # PyJWT

_ALG = "HS256"
_VIDA = timedelta(days=30)


class TokenInvalidoError(Exception):
    """El token no es válido (firma incorrecta o expirado)."""


def _secret() -> str:
    s = os.getenv("JWT_SECRET", "")
    if len(s) < 32:
        raise RuntimeError("JWT_SECRET no está configurada o es demasiado corta (mínimo 32 bytes)")
    return s


def crear_token(user: dict) -> str:
    """Firma un JWT con el negocio/rol del usuario. Vida: 30 días."""
    ahora = datetime.now(timezone.utc)
    payload = {
        "sub": user["id"],
        "negocio_id": user["negocioId"],
        "rol": user["rol"],
        "email": user["email"],
        "iat": ahora,
        "exp": ahora + _VIDA,
    }
    return jwt.encode(payload, _secret(), algorithm=_ALG)


def decodificar_token(token: str) -> dict:
    """Valida firma + expiración + claims requeridos; devuelve los claims. Lanza TokenInvalidoError si no."""
    try:
        return jwt.decode(
            token, _secret(), algorithms=[_ALG],
            options={"require": ["exp", "negocio_id"]},
        )
    except jwt.PyJWTError as e:
        raise TokenInvalidoError(str(e))
