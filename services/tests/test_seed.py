from src import seed, models


def test_seed_carga_defaults(db, tmp_path):
    import json
    inv = tmp_path / "inventario.json"
    ped = tmp_path / "pedidos.json"
    inv.write_text(json.dumps({
        "categorias": [{"id": "cat_1", "name": "Bebidas", "emoji": "☕"}],
        "productos": [{"id": "prod_1", "name": "Café", "categoryId": "cat_1",
                       "price": 5000, "stock": 10, "minStock": 2, "prepTimeMinutes": 3,
                       "isAvailable": True, "description": "", "aiContext": "",
                       "aiActive": True, "imageUrl": None, "emoji": "☕"}],
    }), encoding="utf-8")
    ped.write_text(json.dumps([{
        "id": "P-1", "cliente": "Ana", "telefono": "tg:9|300",
        "items": [{"nombre": "Café", "cantidad": 1, "precio": 5000}],
        "total": 5000, "tipo": "recoger", "direccion": None,
        "estado": "entregado", "creado_en": "2026-04-30T05:00:00",
    }]), encoding="utf-8")

    seed.run(db, inventario_path=str(inv), pedidos_path=str(ped))

    assert db.query(models.Negocio).count() == 1
    assert db.query(models.Usuario).count() == 3
    assert db.get(models.Producto, "prod_1").name == "Café"
    assert db.query(models.Pedido).count() == 1
    assert db.query(models.Cliente).count() == 1
    assert db.query(models.PlantillaIa).count() == 1
    assert db.query(models.Producto).filter(models.Producto.negocio_id == "main").count() >= 1
