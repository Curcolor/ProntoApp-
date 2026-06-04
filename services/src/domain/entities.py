"""Entidades de dominio del inventario y pedidos. Dataclasses puras (sin
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
