"""Modelos SQLAlchemy que espejan dataconnect/schema/schema.gql.
Mantener en sync con el .gql (mismos nombres de columna)."""
from datetime import datetime, timezone
from sqlalchemy import (
    Boolean, DateTime, Float, ForeignKey, Integer, String, UniqueConstraint,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from src.db import Base


class Negocio(Base):
    __tablename__ = "negocio"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    tipo_negocio: Mapped[str | None] = mapped_column(String)
    nombre: Mapped[str] = mapped_column(String, nullable=False)
    direccion: Mapped[str | None] = mapped_column(String)
    hora_apertura: Mapped[str | None] = mapped_column(String)
    hora_cierre: Mapped[str | None] = mapped_column(String)
    formato_entrega: Mapped[str | None] = mapped_column(String)
    terminos_entrega: Mapped[str | None] = mapped_column(String)
    numero_whatsapp: Mapped[str | None] = mapped_column(String)


class Usuario(Base):
    __tablename__ = "usuario"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    nombre: Mapped[str] = mapped_column(String, nullable=False)
    email: Mapped[str] = mapped_column(String, nullable=False, unique=True)
    contrasena_hash: Mapped[str] = mapped_column(String, nullable=False)
    telefono: Mapped[str | None] = mapped_column(String)
    rol: Mapped[str] = mapped_column(String, nullable=False)
    negocio_id: Mapped[str] = mapped_column(ForeignKey("negocio.id"), nullable=False, default="main")


class Categoria(Base):
    __tablename__ = "categoria"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    name: Mapped[str] = mapped_column(String, nullable=False)
    emoji: Mapped[str] = mapped_column(String, nullable=False)
    negocio_id: Mapped[str] = mapped_column(ForeignKey("negocio.id"), nullable=False, default="main")


class Producto(Base):
    __tablename__ = "producto"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    categoria_id: Mapped[str] = mapped_column(ForeignKey("categoria.id"), nullable=False)
    name: Mapped[str] = mapped_column(String, nullable=False)
    price: Mapped[float] = mapped_column(Float, nullable=False)
    stock: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    min_stock: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    prep_time_minutes: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    is_available: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    description: Mapped[str] = mapped_column(String, nullable=False, default="")
    ai_context: Mapped[str] = mapped_column(String, nullable=False, default="")
    ai_active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    image_url: Mapped[str | None] = mapped_column(String)
    emoji: Mapped[str] = mapped_column(String, nullable=False, default="📦")
    negocio_id: Mapped[str] = mapped_column(ForeignKey("negocio.id"), nullable=False, default="main")
    categoria: Mapped["Categoria"] = relationship()


class Cliente(Base):
    __tablename__ = "cliente"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    nombre: Mapped[str] = mapped_column(String, nullable=False)
    numero_whatsapp: Mapped[str] = mapped_column(String, nullable=False)
    email: Mapped[str | None] = mapped_column(String)
    negocio_id: Mapped[str] = mapped_column(ForeignKey("negocio.id"), nullable=False, default="main")
    __table_args__ = (UniqueConstraint("negocio_id", "numero_whatsapp", name="cliente_negocio_whatsapp_uidx"),)


class Pedido(Base):
    __tablename__ = "pedido"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    cliente_id: Mapped[str] = mapped_column(ForeignKey("cliente.id"), nullable=False)
    total: Mapped[float] = mapped_column(Float, nullable=False)
    estado: Mapped[str] = mapped_column(String, nullable=False, default="recibido")
    tipo: Mapped[str] = mapped_column(String, nullable=False)
    direccion: Mapped[str | None] = mapped_column(String)
    canal: Mapped[str] = mapped_column(String, nullable=False, default="whatsapp")
    usuario_asignado_id: Mapped[str | None] = mapped_column(ForeignKey("usuario.id"))
    creado_en: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=lambda: datetime.now(timezone.utc)
    )
    actualizado_en: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )
    negocio_id: Mapped[str] = mapped_column(ForeignKey("negocio.id"), nullable=False, default="main")
    cliente: Mapped["Cliente"] = relationship()
    items: Mapped[list["DetallePedido"]] = relationship(
        back_populates="pedido", cascade="all, delete-orphan"
    )


class DetallePedido(Base):
    __tablename__ = "detalle_pedido"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    pedido_id: Mapped[str] = mapped_column(ForeignKey("pedido.id", ondelete="CASCADE"), nullable=False)
    producto_id: Mapped[str | None] = mapped_column(ForeignKey("producto.id"))
    nombre: Mapped[str] = mapped_column(String, nullable=False)
    cantidad: Mapped[int] = mapped_column(Integer, nullable=False)
    precio_unitario: Mapped[float] = mapped_column(Float, nullable=False)
    pedido: Mapped["Pedido"] = relationship(back_populates="items")


class PlantillaIa(Base):
    __tablename__ = "plantilla_ia"
    id: Mapped[str] = mapped_column(String, primary_key=True)
    prompt: Mapped[str] = mapped_column(String, nullable=False, default="")
    contexto: Mapped[str] = mapped_column(String, nullable=False, default="[]")
    negocio_id: Mapped[str] = mapped_column(ForeignKey("negocio.id"), nullable=False, default="main")
