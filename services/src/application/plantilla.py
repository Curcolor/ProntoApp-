"""Casos de uso del contexto Plantilla IA. Sin dependencias de infraestructura."""
from src.domain.entities import PlantillaIa
from src.domain.ports import PlantillaIaRepository


class LeerPlantillaIa:
    def __init__(self, repo: PlantillaIaRepository):
        self._repo = repo

    def execute(self, negocio_id: str) -> PlantillaIa | None:
        return self._repo.obtener(negocio_id)


class ActualizarPlantillaIa:
    def __init__(self, repo: PlantillaIaRepository):
        self._repo = repo

    def execute(self, datos: dict, negocio_id: str) -> PlantillaIa:
        return self._repo.actualizar(datos, negocio_id)
