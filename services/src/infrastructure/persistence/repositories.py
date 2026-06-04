"""Adaptadores SQLAlchemy de los puertos del inventario y pedidos.

Replican las consultas de `crud` (filtro por negocio_id, reemplazo = borrar e
insertar, descuento de stock por nombre case-insensitive sin bajar de 0). Cada
método mutador hace commit, igual que el `crud` original."""
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from src.domain.entities import Categoria, Cliente, DetallePedido, Pedido, Producto
from src.domain.ids import nuevo_id
from src.infrastructure.persistence import models


def _a_categoria(c: "models.Categoria") -> Categoria:
    return Categoria(id=c.id, name=c.name, emoji=c.emoji)


def _a_producto(p: "models.Producto") -> Producto:
    return Producto(
        id=p.id, categoryId=p.categoria_id, name=p.name, price=p.price,
        stock=p.stock, minStock=p.min_stock, prepTimeMinutes=p.prep_time_minutes,
        isAvailable=p.is_available, description=p.description, aiContext=p.ai_context,
        aiActive=p.ai_active, imageUrl=p.image_url, emoji=p.emoji,
    )


class SqlAlchemyCategoriaRepository:
    def __init__(self, db: Session):
        self._db = db

    def listar(self, negocio_id: str) -> list[Categoria]:
        cats = self._db.scalars(select(models.Categoria).where(
            models.Categoria.negocio_id == negocio_id)).all()
        return [_a_categoria(c) for c in cats]

    def obtener(self, cat_id: str, negocio_id: str) -> Categoria | None:
        cat = self._db.scalars(select(models.Categoria).where(
            models.Categoria.id == cat_id, models.Categoria.negocio_id == negocio_id)).first()
        return _a_categoria(cat) if cat is not None else None

    def agregar(self, categoria: Categoria, negocio_id: str) -> None:
        self._db.add(models.Categoria(
            id=categoria.id, name=categoria.name, emoji=categoria.emoji,
            negocio_id=negocio_id))
        self._db.commit()

    def actualizar(self, categoria: Categoria, negocio_id: str) -> None:
        cat = self._db.scalars(select(models.Categoria).where(
            models.Categoria.id == categoria.id,
            models.Categoria.negocio_id == negocio_id)).first()
        if cat is None:
            return
        cat.name = categoria.name
        cat.emoji = categoria.emoji
        self._db.commit()

    def eliminar(self, cat_id: str, negocio_id: str) -> None:
        cat = self._db.scalars(select(models.Categoria).where(
            models.Categoria.id == cat_id, models.Categoria.negocio_id == negocio_id)).first()
        if cat is None:
            return
        self._db.delete(cat)
        self._db.commit()

    def reemplazar_todas(self, categorias: list[Categoria], negocio_id: str) -> None:
        self._db.query(models.Categoria).filter(
            models.Categoria.negocio_id == negocio_id).delete()
        self._db.flush()
        for c in categorias:
            self._db.add(models.Categoria(
                id=c.id, name=c.name, emoji=c.emoji, negocio_id=negocio_id))
        self._db.commit()


class SqlAlchemyProductoRepository:
    def __init__(self, db: Session):
        self._db = db

    def listar(self, negocio_id: str) -> list[Producto]:
        prods = self._db.scalars(select(models.Producto).where(
            models.Producto.negocio_id == negocio_id)).all()
        return [_a_producto(p) for p in prods]

    def obtener(self, prod_id: str, negocio_id: str) -> Producto | None:
        prod = self._db.scalars(select(models.Producto).where(
            models.Producto.id == prod_id, models.Producto.negocio_id == negocio_id)).first()
        return _a_producto(prod) if prod is not None else None

    def agregar(self, producto: Producto, negocio_id: str) -> None:
        self._db.add(self._modelo(producto, negocio_id))
        self._db.commit()

    def actualizar(self, producto: Producto, negocio_id: str) -> None:
        prod = self._db.scalars(select(models.Producto).where(
            models.Producto.id == producto.id,
            models.Producto.negocio_id == negocio_id)).first()
        if prod is None:
            return
        prod.categoria_id = producto.categoryId
        prod.name = producto.name
        prod.price = producto.price
        prod.stock = producto.stock
        prod.min_stock = producto.minStock
        prod.prep_time_minutes = producto.prepTimeMinutes
        prod.is_available = producto.isAvailable
        prod.description = producto.description
        prod.ai_context = producto.aiContext
        prod.ai_active = producto.aiActive
        prod.image_url = producto.imageUrl
        prod.emoji = producto.emoji
        self._db.commit()

    def eliminar(self, prod_id: str, negocio_id: str) -> None:
        prod = self._db.scalars(select(models.Producto).where(
            models.Producto.id == prod_id, models.Producto.negocio_id == negocio_id)).first()
        if prod is None:
            return
        self._db.delete(prod)
        self._db.commit()

    def hay_en_categoria(self, cat_id: str, negocio_id: str) -> bool:
        prod = self._db.scalars(select(models.Producto).where(
            models.Producto.categoria_id == cat_id,
            models.Producto.negocio_id == negocio_id)).first()
        return prod is not None

    def descontar_stock(self, items: list[dict], negocio_id: str) -> None:
        for item in items:
            nombre = str(item.get("nombre", "")).lower()
            prod = self._db.scalars(select(models.Producto).where(
                models.Producto.negocio_id == negocio_id,
                func.lower(models.Producto.name) == nombre,
            )).first()
            if prod is not None:
                prod.stock = max(0, prod.stock - int(item.get("cantidad", 0)))
        self._db.commit()

    def reemplazar_todos(self, productos: list[Producto], negocio_id: str) -> None:
        self._db.query(models.Producto).filter(
            models.Producto.negocio_id == negocio_id).delete()
        self._db.flush()
        for p in productos:
            self._db.add(self._modelo(p, negocio_id))
        self._db.commit()

    @staticmethod
    def _modelo(p: Producto, negocio_id: str) -> "models.Producto":
        return models.Producto(
            id=p.id, categoria_id=p.categoryId, name=p.name, price=p.price,
            stock=p.stock, min_stock=p.minStock, prep_time_minutes=p.prepTimeMinutes,
            is_available=p.isAvailable, description=p.description, ai_context=p.aiContext,
            ai_active=p.aiActive, image_url=p.imageUrl, emoji=p.emoji,
            negocio_id=negocio_id,
        )


# ─── Pedidos ──────────────────────────────────────────────────────────────────

def _a_cliente(c: "models.Cliente") -> Cliente:
    return Cliente(
        id=c.id, nombre=c.nombre, numeroWhatsapp=c.numero_whatsapp, email=c.email,
    )


def _a_pedido(p: "models.Pedido") -> Pedido:
    return Pedido(
        id=p.id,
        cliente=_a_cliente(p.cliente),
        items=[
            DetallePedido(
                nombre=d.nombre,
                cantidad=d.cantidad,
                precioUnitario=d.precio_unitario,
                productoId=d.producto_id,
            )
            for d in p.items
        ],
        total=p.total,
        estado=p.estado,
        tipo=p.tipo,
        direccion=p.direccion,
        creadoEn=p.creado_en,
    )


class SqlAlchemyClienteRepository:
    def __init__(self, db: Session):
        self._db = db

    def upsert(self, nombre: str, numero_whatsapp: str, negocio_id: str) -> Cliente:
        cliente = self._db.scalars(select(models.Cliente).where(
            models.Cliente.negocio_id == negocio_id,
            models.Cliente.numero_whatsapp == numero_whatsapp,
        )).first()
        if cliente is None:
            cliente = models.Cliente(
                id=nuevo_id("C"), nombre=nombre,
                numero_whatsapp=numero_whatsapp, negocio_id=negocio_id,
            )
            self._db.add(cliente)
            self._db.flush()
        return _a_cliente(cliente)


class SqlAlchemyPedidoRepository:
    def __init__(self, db: Session):
        self._db = db

    def listar(self, negocio_id: str) -> list[Pedido]:
        rows = self._db.scalars(select(models.Pedido).where(
            models.Pedido.negocio_id == negocio_id,
        ).order_by(models.Pedido.creado_en.desc())).all()
        return [_a_pedido(p) for p in rows]

    def obtener(self, pedido_id: str, negocio_id: str) -> Pedido | None:
        row = self._db.scalars(select(models.Pedido).where(
            models.Pedido.id == pedido_id,
            models.Pedido.negocio_id == negocio_id,
        )).first()
        return _a_pedido(row) if row is not None else None

    def crear(self, cliente: Cliente, items: list[dict], datos: dict, negocio_id: str) -> Pedido:
        # Necesitamos el ORM Cliente para la FK; lo re-obtenemos por id.
        pedido = models.Pedido(
            id=nuevo_id("P"),
            cliente_id=cliente.id,
            total=datos["total"],
            estado="recibido",
            tipo=datos["tipo"],
            direccion=datos.get("direccion"),
            negocio_id=negocio_id,
        )
        self._db.add(pedido)
        self._db.flush()
        for it in items:
            self._db.add(models.DetallePedido(
                id=nuevo_id("D"),
                pedido_id=pedido.id,
                producto_id=None,
                nombre=it["nombre"],
                cantidad=it["cantidad"],
                precio_unitario=it["precio"],
            ))
        self._db.flush()  # el commit lo da descontar_stock (mismo unit-of-work que el crud original)
        self._db.refresh(pedido)
        return _a_pedido(pedido)

    def cambiar_estado(self, pedido_id: str, estado: str, negocio_id: str) -> Pedido | None:
        row = self._db.scalars(select(models.Pedido).where(
            models.Pedido.id == pedido_id,
            models.Pedido.negocio_id == negocio_id,
        )).first()
        if row is None:
            return None
        row.estado = estado
        self._db.commit()
        self._db.refresh(row)
        return _a_pedido(row)

    def eliminar(self, pedido_id: str, negocio_id: str) -> bool:
        row = self._db.scalars(select(models.Pedido).where(
            models.Pedido.id == pedido_id,
            models.Pedido.negocio_id == negocio_id,
        )).first()
        if row is None:
            return False
        self._db.delete(row)
        self._db.commit()
        return True
