"""Presentadores: entidad de dominio → dict del contrato JSON.

Reproducen exactamente `crud._categoria_a_dict` / `crud._producto_a_dict`."""
from src.domain.entities import Categoria, Producto


def categoria_a_dict(c: Categoria) -> dict:
    return {"id": c.id, "name": c.name, "emoji": c.emoji}


def producto_a_dict(p: Producto) -> dict:
    return {"id": p.id, "name": p.name, "categoryId": p.categoryId, "price": p.price,
            "stock": p.stock, "minStock": p.minStock, "prepTimeMinutes": p.prepTimeMinutes,
            "isAvailable": p.isAvailable, "description": p.description, "aiContext": p.aiContext,
            "aiActive": p.aiActive, "imageUrl": p.imageUrl, "emoji": p.emoji}
