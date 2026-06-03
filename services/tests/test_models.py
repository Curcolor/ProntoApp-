from src import models


def test_crear_producto_y_categoria(db):
    cat = models.Categoria(id="cat_1", name="Bebidas", emoji="☕")
    prod = models.Producto(
        id="prod_1", categoria_id="cat_1", name="Café", price=5000,
        stock=10, min_stock=2, prep_time_minutes=3, is_available=True,
        description="", ai_context="", ai_active=True, image_url=None, emoji="☕",
    )
    db.add(cat); db.add(prod); db.flush()
    got = db.get(models.Producto, "prod_1")
    assert got.name == "Café"
    assert got.categoria.emoji == "☕"
