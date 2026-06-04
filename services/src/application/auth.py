"""Casos de uso del contexto Auth.

Dependencias inyectadas por constructor; cada caso expone `execute(...)`.
Replican el comportamiento de las funciones `crud.login` y `crud.registrar`
originales, pero lanzan errores de dominio (nunca HTTPException) y operan sobre
entidades de dominio."""
from src.domain.entities import Usuario
from src.domain.ports import NegocioRepository, PasswordHasher, UsuarioRepository


class Login:
    def __init__(self, usuario_repo: UsuarioRepository, hasher: PasswordHasher):
        self._usuario_repo = usuario_repo
        self._hasher = hasher

    def execute(self, email: str, password: str) -> Usuario | None:
        res = self._usuario_repo.por_email(email)
        if res is None:
            return None
        usuario, hash_ = res
        if not self._hasher.verify(password, hash_):
            return None
        return usuario


class RegistrarNegocio:
    def __init__(
        self,
        negocio_repo: NegocioRepository,
        usuario_repo: UsuarioRepository,
        hasher: PasswordHasher,
    ):
        self._negocio_repo = negocio_repo
        self._usuario_repo = usuario_repo
        self._hasher = hasher

    def execute(self, datos: dict) -> Usuario:
        negocio_id = self._negocio_repo.crear(datos["businessName"])
        usuario = self._usuario_repo.crear(
            {
                "nombre": datos["nombre"],
                "email": datos["email"],
                "telefono": datos.get("telefono"),
                "rol": "gerente",
            },
            self._hasher.hash(datos["password"]),
            negocio_id,
        )
        return usuario
