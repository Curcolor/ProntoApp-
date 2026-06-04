"""Entidades de dominio del inventario. Dataclasses puras (sin SQLAlchemy ni
Pydantic). Los nombres de atributo coinciden con el contrato JSON."""
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
