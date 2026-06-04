import pytest
from src.application.inventario import (
    LeerInventario, CrearProducto, CrearCategoria, EliminarCategoria,
)
from src.domain.entities import Producto, Categoria
from src.domain.errors import CategoriaConProductosError


class FakeCategoriaRepo:
    def __init__(self): self.data = {}
    def listar(self, n): return [c for (cid, neg), c in self.data.items() if neg == n]
    def obtener(self, cid, n): return self.data.get((cid, n))
    def agregar(self, c, n): self.data[(c.id, n)] = c
    def actualizar(self, c, n): self.data[(c.id, n)] = c
    def eliminar(self, cid, n): self.data.pop((cid, n), None)
    def reemplazar_todas(self, cs, n):
        for k in [k for k in self.data if k[1] == n]: self.data.pop(k)
        for c in cs: self.data[(c.id, n)] = c


class FakeProductoRepo:
    def __init__(self): self.data = {}
    def listar(self, n): return [p for (pid, neg), p in self.data.items() if neg == n]
    def obtener(self, pid, n): return self.data.get((pid, n))
    def agregar(self, p, n): self.data[(p.id, n)] = p
    def actualizar(self, p, n): self.data[(p.id, n)] = p
    def eliminar(self, pid, n): self.data.pop((pid, n), None)
    def hay_en_categoria(self, cid, n): return any(p.categoryId == cid for (pid, neg), p in self.data.items() if neg == n)
    def descontar_stock(self, items, n): ...
    def reemplazar_todos(self, ps, n):
        for k in [k for k in self.data if k[1] == n]: self.data.pop(k)
        for p in ps: self.data[(p.id, n)] = p


def test_crear_producto_lo_persiste():
    prod = FakeProductoRepo()
    out = CrearProducto(prod).execute({"name": "Café", "categoryId": "c1", "price": 5000}, "main")
    assert out.name == "Café"
    assert prod.listar("main")[0].name == "Café"


def test_eliminar_categoria_con_productos_falla():
    cat, prod = FakeCategoriaRepo(), FakeProductoRepo()
    cat.agregar(Categoria(id="c1", name="Bebidas", emoji="☕"), "main")
    prod.agregar(Producto(id="p1", categoryId="c1", name="Café", price=1), "main")
    with pytest.raises(CategoriaConProductosError):
        EliminarCategoria(cat, prod).execute("c1", "main")


def test_inventario_aislado_por_negocio():
    cat, prod = FakeCategoriaRepo(), FakeProductoRepo()
    CrearCategoria(cat).execute({"id": "ca", "name": "A", "emoji": "x"}, "A")
    assert LeerInventario(cat, prod).execute("B") == ([], [])
