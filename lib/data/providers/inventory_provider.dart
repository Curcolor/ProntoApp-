import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../repositories/inventory_repository.dart';

/// Provider del inventario. Fuente de verdad = servidor (vía repo). Mantiene
/// poll cada 5s y un cache de solo-lectura para offline. Escrituras pesimistas.
class InventoryProvider extends ChangeNotifier {
  final InventoryRepository? _repository;
  List<Category> _categories = [];
  List<Product> _products = [];
  Timer? _timer;
  String? _ultimoError;

  InventoryProvider(InventoryRepository repository) : _repository = repository {
    recargar();
    _iniciarPolling();
  }

  /// Solo para widget previews: siembra datos, sin repo/timer/red.
  InventoryProvider.preview({List<Product>? products, List<Category>? categories})
      : _repository = null {
    _categories = categories ?? <Category>[];
    _products = products ?? <Product>[];
  }

  List<Category> get categories => _categories;
  List<Product> get products => _products;
  String? get ultimoError => _ultimoError;

  void _iniciarPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => recargar());
  }

  /// Recarga desde el servidor; si falla, cae al cache.
  Future<void> recargar() async {
    final repo = _repository;
    if (repo == null) return;
    try {
      final inv = await repo.fetchInventario();
      _categories = inv.categorias;
      _products = inv.productos;
      _ultimoError = null;
    } catch (e) {
      final cache = repo.readCache();
      _categories = cache.categorias;
      _products = cache.productos;
      _ultimoError = e.toString();
    }
    notifyListeners();
  }

  Future<void> addCategory(String name, String emoji) =>
      _escribir(() => _repository!.createCategory(name, emoji));

  Future<void> addProduct(Product product) =>
      _escribir(() => _repository!.createProduct(_productoAJson(product)));

  Future<void> updateProduct(Product product) =>
      _escribir(() => _repository!.updateProduct(product.id, _productoAJson(product)));

  Future<void> deleteProduct(String id) =>
      _escribir(() => _repository!.deleteProduct(id));

  Future<void> _escribir(Future<void> Function() accion) async {
    try {
      await accion();
      _ultimoError = null;
      await recargar();
    } catch (e) {
      _ultimoError = e.toString();
      notifyListeners();
    }
  }

  Map<String, dynamic> _productoAJson(Product p) => {
        'name': p.name, 'categoryId': p.categoryId, 'price': p.price, 'stock': p.stock,
        'minStock': p.minStock, 'prepTimeMinutes': p.prepTimeMinutes,
        'isAvailable': p.isAvailable, 'description': p.description,
        'aiContext': p.aiContext, 'aiActive': p.aiActive, 'imageUrl': p.imageUrl,
        'emoji': p.emoji,
      };

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
