"""Compat: los modelos viven en infrastructure/persistence/models.py.
Re-export para no romper `from src import models` / `import src.models`."""
from src.infrastructure.persistence.models import (  # noqa: F401
    Negocio, Usuario, Categoria, Producto, Cliente, Pedido, DetallePedido, PlantillaIa,
)
