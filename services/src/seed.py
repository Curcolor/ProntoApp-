"""Migración idempotente de los JSON actuales a Postgres.
Uso: python -m src.seed   (con DATABASE_URL configurada)."""
import json
from pathlib import Path
from passlib.hash import bcrypt
from sqlalchemy.orm import Session
from . import models, crud
from .db import SessionLocal
from .domain.ids import nuevo_id

_BASE = Path(__file__).resolve().parent.parent / "data"
_USUARIOS_DEFAULT = [
    {"id": "1", "nombre": "Carlos Gerente", "email": "gerente@prontoa.com", "rol": "gerente"},
    {"id": "2", "nombre": "Ana Cocinera", "email": "cocina@prontoa.com", "rol": "cocinero"},
    {"id": "3", "nombre": "Luis Repartidor", "email": "reparto@prontoa.com", "rol": "repartidor"},
]


def _upsert(db: Session, obj) -> None:
    db.merge(obj)


def run(db: Session, inventario_path: str | None = None, pedidos_path: str | None = None) -> None:
    inv_path = Path(inventario_path) if inventario_path else _BASE / "inventario.json"
    ped_path = Path(pedidos_path) if pedidos_path else _BASE / "pedidos.json"

    # Negocio (1 fila)
    _upsert(db, models.Negocio(id="main", nombre="ProntoApp", tipo_negocio="restaurante",
                               formato_entrega="ambos", numero_whatsapp=""))

    # Plantilla IA default (1 fila)
    _PERSONA_DEFAULT = (
        'Eres el asistente de pedidos de ProntoApp, una panadería y cafetería.\n'
        'Tu nombre es "Pronto" y eres amable, conciso y eficiente.'
    )
    _upsert(db, models.PlantillaIa(id="main", prompt=_PERSONA_DEFAULT, contexto="[]", negocio_id="main"))
    db.flush()

    # Usuarios default (idempotente por PK)
    for u in _USUARIOS_DEFAULT:
        _upsert(db, models.Usuario(
            id=u["id"], nombre=u["nombre"], email=u["email"], rol=u["rol"],
            contrasena_hash=bcrypt.hash("password123"), negocio_id="main",
        ))
    db.flush()

    # Inventario
    if inv_path.exists():
        inv = json.loads(inv_path.read_text(encoding="utf-8"))
        for c in inv.get("categorias", []):
            _upsert(db, models.Categoria(id=c["id"], name=c["name"], emoji=c.get("emoji", ""), negocio_id="main"))
        db.flush()
        for p in inv.get("productos", []):
            _upsert(db, models.Producto(
                id=p["id"], categoria_id=p["categoryId"], name=p["name"], price=p["price"],
                stock=p.get("stock", 0), min_stock=p.get("minStock", 0),
                prep_time_minutes=p.get("prepTimeMinutes", 0),
                is_available=p.get("isAvailable", True), description=p.get("description", ""),
                ai_context=p.get("aiContext", ""), ai_active=p.get("aiActive", True),
                image_url=p.get("imageUrl"), emoji=p.get("emoji", "📦"), negocio_id="main",
            ))
        db.flush()

    # Pedidos
    if ped_path.exists():
        pedidos = json.loads(ped_path.read_text(encoding="utf-8"))
        for ped in pedidos:
            cliente = crud._upsert_cliente(db, ped.get("cliente", "Cliente"), ped.get("telefono", ""), "main")
            _upsert(db, models.Pedido(
                id=ped["id"], cliente_id=cliente.id, total=ped.get("total", 0),
                estado=ped.get("estado", "recibido"), tipo=ped.get("tipo", "recoger"),
                direccion=ped.get("direccion"), negocio_id="main",
            ))
            db.flush()
            for it in ped.get("items", []):
                _upsert(db, models.DetallePedido(
                    id=nuevo_id("D"), pedido_id=ped["id"], producto_id=None,
                    nombre=it["nombre"], cantidad=it["cantidad"], precio_unitario=it["precio"],
                ))
    db.commit()


if __name__ == "__main__":
    db = SessionLocal()
    try:
        run(db)
        print("Seed completado.")
    finally:
        db.close()
