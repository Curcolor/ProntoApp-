import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/repositories/inventory_repository.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';

class _FakeRepo implements InventoryRepository {
  bool createLlamado = false;
  bool fallar = false;
  @override
  Future<Inventario> fetchInventario() async => (
    categorias: [Category(id: 'c', name: 'Bebidas', emoji: '☕')],
    productos: [Product(id: 'p', name: 'Café', categoryId: 'c', price: 5000, stock: 1,
      minStock: 0, prepTimeMinutes: 0, isAvailable: true, description: '', aiContext: '',
      aiActive: true, emoji: '☕')],
  );
  @override
  Inventario readCache() => (categorias: const [], productos: const []);
  @override
  Future<Product> createProduct(Map<String, dynamic> d) async {
    createLlamado = true;
    if (fallar) throw Exception('boom');
    return Product(id: 'prod-1', name: d['name'], categoryId: d['categoryId'], price: 0,
      stock: 0, minStock: 0, prepTimeMinutes: 0, isAvailable: true, description: '',
      aiContext: '', aiActive: true, emoji: '📦');
  }
  @override
  noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  test('recargar usa fetchInventario', () async {
    final p = InventoryProvider(_FakeRepo());
    await p.recargar();
    expect(p.products.single.name, 'Café');
  });

  test('addProduct llama createProduct y refresca', () async {
    final repo = _FakeRepo();
    final p = InventoryProvider(repo);
    await p.addProduct(Product(id: '', name: 'Té', categoryId: 'c', price: 0, stock: 0,
      minStock: 0, prepTimeMinutes: 0, isAvailable: true, description: '', aiContext: '',
      aiActive: true, emoji: '🍵'));
    expect(repo.createLlamado, true);
    expect(p.ultimoError, isNull);
  });

  test('error de escritura setea ultimoError sin tirar', () async {
    final repo = _FakeRepo()..fallar = true;
    final p = InventoryProvider(repo);
    await p.addProduct(Product(id: '', name: 'Té', categoryId: 'c', price: 0, stock: 0,
      minStock: 0, prepTimeMinutes: 0, isAvailable: true, description: '', aiContext: '',
      aiActive: true, emoji: '🍵'));
    expect(p.ultimoError, isNotNull);
  });

  test('preview no usa repo', () {
    final p = InventoryProvider.preview(products: [], categories: []);
    expect(p.products, isEmpty);
  });
}
