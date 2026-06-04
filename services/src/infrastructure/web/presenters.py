"""Presentadores: entidad de dominio → dict del contrato JSON.

Reproducen exactamente `crud._categoria_a_dict` / `crud._producto_a_dict` /
`crud._pedido_a_dict` / `crud._limpiar_telefono` / `crud._usuario_a_dict`."""
from src.domain.entities import Categoria, Pedido, Producto, Usuario


def categoria_a_dict(c: Categoria) -> dict:
    return {"id": c.id, "name": c.name, "emoji": c.emoji}


def producto_a_dict(p: Producto) -> dict:
    return {"id": p.id, "name": p.name, "categoryId": p.categoryId, "price": p.price,
            "stock": p.stock, "minStock": p.minStock, "prepTimeMinutes": p.prepTimeMinutes,
            "isAvailable": p.isAvailable, "description": p.description, "aiContext": p.aiContext,
            "aiActive": p.aiActive, "imageUrl": p.imageUrl, "emoji": p.emoji}


# ─── Pedidos ──────────────────────────────────────────────────────────────────

def limpiar_telefono(telefono: str) -> str:
    """tg:chat_id|telefono_real -> telefono_real (igual que crud._limpiar_telefono)."""
    if telefono.startswith("tg:"):
        partes = telefono.split("|", 1)
        return partes[1] if len(partes) > 1 else ""
    return telefono


# ─── Auth ─────────────────────────────────────────────────────────────────────

def usuario_a_dict(u: Usuario) -> dict:
    return {
        "id": u.id,
        "nombre": u.nombre,
        "email": u.email,
        "telefono": u.telefono,
        "rol": u.rol,
        "negocioId": u.negocioId,
    }


def pedido_a_dict(p: Pedido) -> dict:
    return {
        "id": p.id,
        "cliente": p.cliente.nombre,
        "telefono": limpiar_telefono(p.cliente.numeroWhatsapp),
        "items": [
            {"nombre": d.nombre, "cantidad": d.cantidad, "precio": d.precioUnitario}
            for d in p.items
        ],
        "total": p.total,
        "tipo": p.tipo,
        "direccion": p.direccion,
        "estado": p.estado,
        "creado_en": p.creadoEn.isoformat() if p.creadoEn else None,
    }
