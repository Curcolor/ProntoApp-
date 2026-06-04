"""Entidades de dominio del inventario, pedidos y auth. Dataclasses puras (sin
SQLAlchemy ni Pydantic). Los nombres de atributo coinciden con el contrato JSON."""
from __future__ import annotations

from dataclasses import dataclass


@dataclass
class Categoria:
    id: str
    name: str
    emoji: str = ""


@dataclass
class Producto:
    id: str
    categoryId: str
    name: str
    price: float
    stock: int = 0
    minStock: int = 0
    prepTimeMinutes: int = 0
    isAvailable: bool = True
    description: str = ""
    aiContext: str = ""
    aiActive: bool = True
    imageUrl: str | None = None
    emoji: str = "📦"


# ─── Pedidos ──────────────────────────────────────────────────────────────────

@dataclass
class Cliente:
    id: str
    nombre: str
    numeroWhatsapp: str
    email: str | None = None


@dataclass
class DetallePedido:
    nombre: str
    cantidad: int
    precioUnitario: float
    productoId: str | None = None


@dataclass
class Pedido:
    id: str
    cliente: Cliente
    items: list[DetallePedido]
    total: float
    estado: str
    tipo: str
    direccion: str | None
    creadoEn: object | None  # datetime; el presenter hace .isoformat()


# ─── Auth ─────────────────────────────────────────────────────────────────────

@dataclass
class Usuario:
    id: str
    nombre: str
    email: str
    rol: str
    negocioId: str
    telefono: str | None = None


# ─── Negocio / Plantilla ──────────────────────────────────────────────────────

@dataclass
class Negocio:
    id: str
    nombre: str
    tipoNegocio: str | None = None
    direccion: str | None = None
    horaApertura: str | None = None
    horaCierre: str | None = None
    formatoEntrega: str | None = None
    terminosEntrega: str | None = None
    numeroWhatsapp: str | None = None


@dataclass
class PlantillaIa:
    id: str
    prompt: str
    contexto: str
