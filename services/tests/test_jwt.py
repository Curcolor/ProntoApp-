import os
from datetime import datetime, timedelta, timezone

import jwt
import pytest

from src import auth

USER = {"id": "U1", "negocioId": "N1", "rol": "gerente", "email": "g@p.com"}


def test_round_trip_devuelve_los_claims():
    claims = auth.decodificar_token(auth.crear_token(USER))
    assert claims["sub"] == "U1"
    assert claims["negocio_id"] == "N1"
    assert claims["rol"] == "gerente"
    assert claims["email"] == "g@p.com"


def test_firma_ajena_es_rechazada():
    tok = jwt.encode({"sub": "x"}, "otra-clave", algorithm="HS256")
    with pytest.raises(auth.TokenInvalidoError):
        auth.decodificar_token(tok)


def test_token_expirado_es_rechazado():
    pasado = datetime.now(timezone.utc) - timedelta(seconds=1)
    tok = jwt.encode({"sub": "x", "exp": pasado}, os.environ["JWT_SECRET"], algorithm="HS256")
    with pytest.raises(auth.TokenInvalidoError):
        auth.decodificar_token(tok)


def test_secret_corto_o_ausente_falla(monkeypatch):
    monkeypatch.setenv("JWT_SECRET", "corta")
    with pytest.raises(RuntimeError):
        auth.crear_token(USER)
