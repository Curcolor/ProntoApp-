import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';

void main() {
  test('InventoryProvider.preview seeds data and starts no timer', () {
    final p = InventoryProvider.preview(
      products: [
        Product(
          id: 'PR-1', name: 'Pizza', categoryId: 'c1', price: 18000,
          stock: 10, minStock: 2, prepTimeMinutes: 15, isAvailable: true,
          description: '', aiContext: '', aiActive: true, emoji: '🍕',
        ),
      ],
      categories: [Category(id: 'c1', name: 'Pizzas', emoji: '🍕')],
    );

    expect(p.products, hasLength(1));
    expect(p.categories, hasLength(1));
    // No debe lanzar: dispose sin timer activo.
    p.dispose();
  });
}
