"""Casos de uso del contexto Usuarios.

Dependencias inyectadas por constructor; cada caso expone `execute(...)`.
Operan sobre entidades de dominio y lanzan errores de dominio (nunca HTTPException)."""
from src.domain.entities import Usuario
from src.domain.errors import NoEncontradoError
from src.domain.ports import PasswordHasher, UsuarioRepository


class ListarUsuarios:
    def __init__(self, repo: UsuarioRepository):
        self._repo = repo

    def execute(self, negocio_id: str) -> list[Usuario]:
        return self._repo.listar(negocio_id)


class CrearUsuario:
    def __init__(self, repo: UsuarioRepository, hasher: PasswordHasher):
        self._repo = repo
        self._hasher = hasher

    def execute(self, datos: dict, negocio_id: str) -> Usuario:
        hash_ = self._hasher.hash(datos["password"])
        return self._repo.crear(
            {
                "nombre": datos["nombre"],
                "email": datos["email"],
                "telefono": datos.get("telefono"),
                "rol": datos["rol"],
            },
            hash_,
            negocio_id,
        )


class ActualizarUsuario:
    def __init__(self, repo: UsuarioRepository):
        self._repo = repo

    def execute(self, usuario_id: str, datos: dict, negocio_id: str) -> Usuario:
        u = self._repo.actualizar(usuario_id, datos, negocio_id)
        if u is None:
            raise NoEncontradoError(usuario_id)
        return u


class EliminarUsuario:
    def __init__(self, repo: UsuarioRepository):
        self._repo = repo

    def execute(self, usuario_id: str, negocio_id: str) -> None:
        if not self._repo.eliminar(usuario_id, negocio_id):
            raise NoEncontradoError(usuario_id)
