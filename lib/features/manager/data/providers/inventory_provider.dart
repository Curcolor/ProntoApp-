import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../repositories/inventory_repository.dart';

/// Provider reactivo del inventario de productos.
/// Además de gestionar el estado local, sincroniza el inventario con el
/// servidor FastAPI cada vez que hay un cambio, para que el bot de Telegram
/// pueda responder con el menú real actualizado.
class InventoryProvider extends ChangeNotifier {
  final InventoryRepository _repository;

  List<Category> _categories = [];
  List<Product> _products = [];

  /// Callback para sincronizar con el FastAPI (inyectado desde main).
  /// Se invoca cada vez que el inventario cambia.
  Future<void> Function({
    required List<Map<String, dynamic>> categorias,
    required List<Map<String, dynamic>> productos,
  })? onInventarioActualizado;

  InventoryProvider(this._repository) {
    _loadData();
  }

  List<Category> get categories => _categories;
  List<Product> get products => _products;

  void _loadData() {
    _categories = _repository.getCategories();
    _products = _repository.getProducts();
    notifyListeners();
  }

  /// Notifica al FastAPI sobre el cambio en el inventario.
  Future<void> _sincronizarConApi() async {
    final callback = onInventarioActualizado;
    if (callback == null) return;

    try {
      await callback(
        categorias: _categories.map((c) => c.toJson()).toList(),
        productos: _products.map((p) => p.toJson()).toList(),
      );
    } catch (_) {
      // Falla silenciosa: el inventario local ya está actualizado
    }
  }

  Future<void> addCategory(String name, String emoji) async {
    await _repository.addCategory(name, emoji);
    _loadData();
    await _sincronizarConApi();
  }

  Future<void> addProduct(Product product) async {
    await _repository.addProduct(product);
    _loadData();
    await _sincronizarConApi();
  }

  Future<void> updateProduct(Product product) async {
    await _repository.updateProduct(product);
    _loadData();
    await _sincronizarConApi();
  }

  Future<void> deleteProduct(String id) async {
    await _repository.deleteProduct(id);
    _loadData();
    await _sincronizarConApi();
  }
}
