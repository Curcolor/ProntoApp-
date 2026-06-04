"""Tests unitarios de los casos de uso del contexto Negocio.

Usan fakes en memoria; no tocan la base de datos."""
import pytest

from src.application.negocio import ActualizarNegocio, LeerNegocio
from src.domain.entities import Negocio


# ─── Fake ─────────────────────────────────────────────────────────────────────

class FakeNegocioRepo:
    def __init__(self):
        self._data: dict[str, Negocio] = {}

    def crear(self, nombre: str) -> str:
        raise NotImplementedError

    def obtener(self, negocio_id: str) -> Negocio | None:
        return self._data.get(negocio_id)

    def actualizar(self, datos: dict, negocio_id: str) -> Negocio:
        n = self._data.get(negocio_id)
        if n is None:
            n = Negocio(id=negocio_id, nombre=datos.get("nombre", "ProntoApp"))
            self._data[negocio_id] = n
        _CAMPOS = {
            "tipoNegocio": "tipoNegocio", "nombre": "nombre", "direccion": "direccion",
            "horaApertura": "horaApertura", "horaCierre": "horaCierre",
            "formatoEntrega": "formatoEntrega", "terminosEntrega": "terminosEntrega",
            "numeroWhatsapp": "numeroWhatsapp",
        }
        for clave_json, attr in _CAMPOS.items():
            if clave_json in datos:
                setattr(n, attr, datos[clave_json])
        return n


# ─── Tests LeerNegocio ────────────────────────────────────────────────────────

def test_leer_negocio_devuelve_none_cuando_no_existe():
    repo = FakeNegocioRepo()
    n = LeerNegocio(repo).execute("N-NOPE")
    assert n is None


def test_leer_negocio_devuelve_entidad_existente():
    repo = FakeNegocioRepo()
    ActualizarNegocio(repo).execute({"nombre": "Mi Tienda"}, "N-0001")
    n = LeerNegocio(repo).execute("N-0001")
    assert n is not None
    assert n.nombre == "Mi Tienda"


# ─── Tests ActualizarNegocio ──────────────────────────────────────────────────

def test_actualizar_negocio_crea_si_no_existe():
    repo = FakeNegocioRepo()
    n = ActualizarNegocio(repo).execute({"nombre": "Nuevo"}, "N-0002")
    assert isinstance(n, Negocio)
    assert n.id == "N-0002"
    assert n.nombre == "Nuevo"


def test_actualizar_negocio_usa_nombre_por_defecto_si_ausente():
    repo = FakeNegocioRepo()
    n = ActualizarNegocio(repo).execute({}, "N-0003")
    assert n.nombre == "ProntoApp"


def test_actualizar_negocio_actualiza_campos():
    repo = FakeNegocioRepo()
    ActualizarNegocio(repo).execute({"nombre": "Original"}, "N-0004")
    n = ActualizarNegocio(repo).execute({
        "tipoNegocio": "restaurante",
        "numeroWhatsapp": "+57300",
        "horaApertura": "08:00",
    }, "N-0004")
    assert n.tipoNegocio == "restaurante"
    assert n.numeroWhatsapp == "+57300"
    assert n.horaApertura == "08:00"
    assert n.nombre == "Original"  # no fue tocado


def test_actualizar_negocio_aislamiento_por_negocio():
    repo = FakeNegocioRepo()
    ActualizarNegocio(repo).execute({"nombre": "A"}, "N-A")
    ActualizarNegocio(repo).execute({"nombre": "B"}, "N-B")
    assert LeerNegocio(repo).execute("N-A").nombre == "A"
    assert LeerNegocio(repo).execute("N-B").nombre == "B"
