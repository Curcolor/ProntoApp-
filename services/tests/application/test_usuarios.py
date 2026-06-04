"""Tests unitarios de los casos de uso del contexto Usuarios.

Usan fakes en memoria; no tocan la base de datos."""
import pytest

from src.application.usuarios import (
    ActualizarUsuario, CrearUsuario, EliminarUsuario, ListarUsuarios,
)
from src.domain.entities import Usuario
from src.domain.errors import EmailDuplicadoError, NoEncontradoError


# ─── Fakes ────────────────────────────────────────────────────────────────────

class FakePasswordHasher:
    def hash(self, password: str) -> str:
        return f"h:{password}"

    def verify(self, password: str, hash: str) -> bool:
        return hash == f"h:{password}"


class FakeUsuarioRepo:
    def __init__(self):
        # (usuario_id, negocio_id) -> Usuario
        self._data: dict[tuple[str, str], Usuario] = {}
        # email -> (usuario_id, negocio_id)
        self._by_email: dict[str, tuple[str, str]] = {}
        # (usuario_id, negocio_id) -> contrasena_hash
        self._hashes: dict[tuple[str, str], str] = {}
        self._counter = 0

    def por_email(self, email: str) -> tuple[Usuario, str] | None:
        key = self._by_email.get(email)
        if key is None:
            return None
        return (self._data[key], self._hashes[key])

    def crear(self, datos: dict, contrasena_hash: str, negocio_id: str) -> Usuario:
        email = datos["email"]
        if email in self._by_email:
            raise EmailDuplicadoError(email)
        self._counter += 1
        uid = f"U-{self._counter:04d}"
        usuario = Usuario(
            id=uid,
            nombre=datos["nombre"],
            email=email,
            rol=datos["rol"],
            negocioId=negocio_id,
            telefono=datos.get("telefono"),
        )
        key = (uid, negocio_id)
        self._data[key] = usuario
        self._hashes[key] = contrasena_hash
        self._by_email[email] = key
        return usuario

    def listar(self, negocio_id: str) -> list[Usuario]:
        return [u for (uid, nid), u in self._data.items() if nid == negocio_id]

    def actualizar(self, usuario_id: str, datos: dict, negocio_id: str) -> Usuario | None:
        key = (usuario_id, negocio_id)
        if key not in self._data:
            return None
        u = self._data[key]
        for campo in ("nombre", "telefono", "rol"):
            if campo in datos:
                setattr(u, campo, datos[campo])
        return u

    def eliminar(self, usuario_id: str, negocio_id: str) -> bool:
        key = (usuario_id, negocio_id)
        if key not in self._data:
            return False
        u = self._data.pop(key)
        self._hashes.pop(key, None)
        self._by_email.pop(u.email, None)
        return True


# ─── Tests CrearUsuario ───────────────────────────────────────────────────────

def test_crear_usuario_hashea_y_persiste():
    repo = FakeUsuarioRepo()
    hasher = FakePasswordHasher()
    datos = {"nombre": "Ana", "email": "ana@p.com", "password": "secreto", "rol": "cocinero"}
    u = CrearUsuario(repo, hasher).execute(datos, "N-0001")
    assert isinstance(u, Usuario)
    assert u.email == "ana@p.com"
    assert u.negocioId == "N-0001"
    # el hash se guardó (no la contraseña en claro)
    stored = repo.por_email("ana@p.com")
    assert stored is not None
    assert stored[1] == "h:secreto"


def test_crear_usuario_acotado_por_negocio():
    repo = FakeUsuarioRepo()
    hasher = FakePasswordHasher()
    datos_a = {"nombre": "Ana", "email": "ana@p.com", "password": "x", "rol": "cocinero"}
    datos_b = {"nombre": "Bob", "email": "bob@p.com", "password": "y", "rol": "repartidor"}
    CrearUsuario(repo, hasher).execute(datos_a, "A")
    CrearUsuario(repo, hasher).execute(datos_b, "B")
    assert len(repo.listar("A")) == 1
    assert repo.listar("A")[0].email == "ana@p.com"
    assert len(repo.listar("B")) == 1


def test_crear_usuario_email_duplicado_lanza_error():
    repo = FakeUsuarioRepo()
    hasher = FakePasswordHasher()
    datos = {"nombre": "Ana", "email": "ana@p.com", "password": "x", "rol": "gerente"}
    CrearUsuario(repo, hasher).execute(datos, "N-0001")
    with pytest.raises(EmailDuplicadoError):
        CrearUsuario(repo, hasher).execute(datos, "N-0001")


# ─── Tests ListarUsuarios ─────────────────────────────────────────────────────

def test_listar_usuarios_acotado_por_negocio():
    repo = FakeUsuarioRepo()
    hasher = FakePasswordHasher()
    CrearUsuario(repo, hasher).execute(
        {"nombre": "Ga", "email": "ga@p.com", "password": "x", "rol": "gerente"}, "A"
    )
    CrearUsuario(repo, hasher).execute(
        {"nombre": "Gb", "email": "gb@p.com", "password": "x", "rol": "gerente"}, "B"
    )
    lista_a = ListarUsuarios(repo).execute("A")
    assert len(lista_a) == 1
    assert lista_a[0].email == "ga@p.com"
    lista_b = ListarUsuarios(repo).execute("B")
    assert len(lista_b) == 1
    assert lista_b[0].email == "gb@p.com"


# ─── Tests ActualizarUsuario ──────────────────────────────────────────────────

def test_actualizar_usuario_aplica_nombre_y_rol():
    repo = FakeUsuarioRepo()
    hasher = FakePasswordHasher()
    u = CrearUsuario(repo, hasher).execute(
        {"nombre": "Ana", "email": "ana@p.com", "password": "x", "rol": "cocinero"}, "N"
    )
    actualizado = ActualizarUsuario(repo).execute(u.id, {"nombre": "Ana María", "rol": "repartidor"}, "N")
    assert actualizado.nombre == "Ana María"
    assert actualizado.rol == "repartidor"


def test_actualizar_usuario_no_encontrado_lanza_error():
    repo = FakeUsuarioRepo()
    with pytest.raises(NoEncontradoError):
        ActualizarUsuario(repo).execute("U-NOPE", {"nombre": "X"}, "N")


# ─── Tests EliminarUsuario ────────────────────────────────────────────────────

def test_eliminar_usuario_no_encontrado_lanza_error():
    repo = FakeUsuarioRepo()
    with pytest.raises(NoEncontradoError):
        EliminarUsuario(repo).execute("U-NOPE", "N")


def test_eliminar_usuario_lo_borra():
    repo = FakeUsuarioRepo()
    hasher = FakePasswordHasher()
    u = CrearUsuario(repo, hasher).execute(
        {"nombre": "Tmp", "email": "tmp@p.com", "password": "x", "rol": "cocinero"}, "N"
    )
    EliminarUsuario(repo).execute(u.id, "N")
    assert repo.listar("N") == []
