"""Tests unitarios de los casos de uso del contexto Plantilla IA.

Usan fakes en memoria; no tocan la base de datos."""
import pytest

from src.application.plantilla import ActualizarPlantillaIa, LeerPlantillaIa
from src.domain.entities import PlantillaIa


# ─── Fake ─────────────────────────────────────────────────────────────────────

class FakePlantillaRepo:
    def __init__(self):
        # negocio_id -> PlantillaIa
        self._data: dict[str, PlantillaIa] = {}
        self._counter = 0

    def obtener(self, negocio_id: str) -> PlantillaIa | None:
        return self._data.get(negocio_id)

    def actualizar(self, datos: dict, negocio_id: str) -> PlantillaIa:
        p = self._data.get(negocio_id)
        if p is None:
            self._counter += 1
            p = PlantillaIa(
                id=f"pia-{self._counter:04d}",
                prompt=datos.get("prompt", ""),
                contexto=datos.get("contexto", "[]"),
            )
            self._data[negocio_id] = p
        if "prompt" in datos:
            p.prompt = datos["prompt"]
        if "contexto" in datos:
            p.contexto = datos["contexto"]
        return p


# ─── Tests LeerPlantillaIa ────────────────────────────────────────────────────

def test_leer_plantilla_devuelve_none_cuando_no_existe():
    repo = FakePlantillaRepo()
    p = LeerPlantillaIa(repo).execute("N-NOPE")
    assert p is None


def test_leer_plantilla_devuelve_entidad_existente():
    repo = FakePlantillaRepo()
    ActualizarPlantillaIa(repo).execute({"prompt": "Hola IA"}, "N-0001")
    p = LeerPlantillaIa(repo).execute("N-0001")
    assert p is not None
    assert p.prompt == "Hola IA"


# ─── Tests ActualizarPlantillaIa ──────────────────────────────────────────────

def test_actualizar_plantilla_crea_si_no_existe():
    repo = FakePlantillaRepo()
    p = ActualizarPlantillaIa(repo).execute({"prompt": "Soy un bot"}, "N-0002")
    assert isinstance(p, PlantillaIa)
    assert p.prompt == "Soy un bot"
    assert p.contexto == "[]"  # valor por defecto


def test_actualizar_plantilla_upsert_conserva_id():
    repo = FakePlantillaRepo()
    p1 = ActualizarPlantillaIa(repo).execute({"prompt": "v1"}, "N-0003")
    p2 = ActualizarPlantillaIa(repo).execute({"prompt": "v2"}, "N-0003")
    assert p1.id == p2.id
    assert p2.prompt == "v2"


def test_actualizar_plantilla_actualiza_solo_campos_presentes():
    repo = FakePlantillaRepo()
    ActualizarPlantillaIa(repo).execute({"prompt": "inicial", "contexto": "[1,2]"}, "N-0004")
    p = ActualizarPlantillaIa(repo).execute({"prompt": "modificado"}, "N-0004")
    assert p.prompt == "modificado"
    assert p.contexto == "[1,2]"  # no fue tocado


def test_actualizar_plantilla_aislamiento_por_negocio():
    repo = FakePlantillaRepo()
    ActualizarPlantillaIa(repo).execute({"prompt": "A"}, "N-A")
    ActualizarPlantillaIa(repo).execute({"prompt": "B"}, "N-B")
    assert LeerPlantillaIa(repo).execute("N-A").prompt == "A"
    assert LeerPlantillaIa(repo).execute("N-B").prompt == "B"
    assert LeerPlantillaIa(repo).execute("N-A").id != LeerPlantillaIa(repo).execute("N-B").id
