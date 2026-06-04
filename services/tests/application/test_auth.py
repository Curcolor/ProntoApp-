"""Tests unitarios de los casos de uso del contexto Auth.

Usan fakes en memoria; no tocan la base de datos."""
import pytest

from src.application.auth import Login, RegistrarNegocio
from src.domain.entities import Usuario
from src.domain.errors import EmailDuplicadoError


# ─── Fakes ────────────────────────────────────────────────────────────────────

class FakePasswordHasher:
    def hash(self, password: str) -> str:
        return f"h:{password}"

    def verify(self, password: str, hash: str) -> bool:
        return hash == f"h:{password}"


class FakeUsuarioRepo:
    def __init__(self):
        self.data: dict[str, tuple[Usuario, str]] = {}  # email → (usuario, hash)
        self._counter = 0

    def por_email(self, email: str) -> tuple[Usuario, str] | None:
        return self.data.get(email)

    def crear(self, datos: dict, contrasena_hash: str, negocio_id: str) -> Usuario:
        email = datos["email"]
        if email in self.data:
            raise EmailDuplicadoError(email)
        self._counter += 1
        usuario = Usuario(
            id=f"U-{self._counter:04d}",
            nombre=datos["nombre"],
            email=email,
            rol=datos["rol"],
            negocioId=negocio_id,
            telefono=datos.get("telefono"),
        )
        self.data[email] = (usuario, contrasena_hash)
        return usuario


class FakeNegocioRepo:
    def __init__(self):
        self._counter = 0

    def crear(self, nombre: str) -> str:
        self._counter += 1
        return f"N-{self._counter:04d}"


# ─── Tests Login ──────────────────────────────────────────────────────────────

def test_login_ok_devuelve_usuario():
    hasher = FakePasswordHasher()
    usuario_repo = FakeUsuarioRepo()
    usuario_repo.crear(
        {"nombre": "Carlos", "email": "c@p.com", "rol": "gerente"},
        hasher.hash("pass123"),
        "N-0001",
    )
    resultado = Login(usuario_repo, hasher).execute("c@p.com", "pass123")
    assert isinstance(resultado, Usuario)
    assert resultado.email == "c@p.com"
    assert resultado.rol == "gerente"


def test_login_password_incorrecta_devuelve_none():
    hasher = FakePasswordHasher()
    usuario_repo = FakeUsuarioRepo()
    usuario_repo.crear(
        {"nombre": "Carlos", "email": "c@p.com", "rol": "gerente"},
        hasher.hash("pass123"),
        "N-0001",
    )
    resultado = Login(usuario_repo, hasher).execute("c@p.com", "mala")
    assert resultado is None


def test_login_email_desconocido_devuelve_none():
    hasher = FakePasswordHasher()
    usuario_repo = FakeUsuarioRepo()
    resultado = Login(usuario_repo, hasher).execute("noexiste@p.com", "cualquier")
    assert resultado is None


# ─── Tests RegistrarNegocio ───────────────────────────────────────────────────

def test_registrar_negocio_crea_gerente_con_negocio():
    hasher = FakePasswordHasher()
    usuario_repo = FakeUsuarioRepo()
    negocio_repo = FakeNegocioRepo()

    datos = {
        "nombre": "Ana",
        "email": "ana@p.com",
        "password": "secreta",
        "businessName": "Café Central",
    }
    usuario = RegistrarNegocio(negocio_repo, usuario_repo, hasher).execute(datos)

    assert isinstance(usuario, Usuario)
    assert usuario.rol == "gerente"
    assert usuario.negocioId == "N-0001"
    assert usuario.email == "ana@p.com"
    # El negocio se creó
    assert negocio_repo._counter == 1
    # El usuario se guardó en el repo
    assert "ana@p.com" in usuario_repo.data


def test_registrar_negocio_email_duplicado_lanza_error():
    hasher = FakePasswordHasher()
    usuario_repo = FakeUsuarioRepo()
    negocio_repo = FakeNegocioRepo()

    datos = {
        "nombre": "Ana",
        "email": "ana@p.com",
        "password": "secreta",
        "businessName": "Café Central",
    }
    RegistrarNegocio(negocio_repo, usuario_repo, hasher).execute(datos)

    with pytest.raises(EmailDuplicadoError):
        RegistrarNegocio(negocio_repo, usuario_repo, hasher).execute(datos)
