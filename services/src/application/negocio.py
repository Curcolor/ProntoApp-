"""Casos de uso del contexto Negocio. Sin dependencias de infraestructura."""
from src.domain.entities import Negocio
from src.domain.ports import NegocioRepository


class LeerNegocio:
    def __init__(self, repo: NegocioRepository):
        self._repo = repo

    def execute(self, negocio_id: str) -> Negocio | None:
        return self._repo.obtener(negocio_id)


class ActualizarNegocio:
    def __init__(self, repo: NegocioRepository):
        self._repo = repo

    def execute(self, datos: dict, negocio_id: str) -> Negocio:
        return self._repo.actualizar(datos, negocio_id)
