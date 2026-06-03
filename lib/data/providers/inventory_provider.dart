import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/category_model.dart';
import '../repositories/inventory_repository.dart';

/// Provider reactivo del inventario de productos.
/// Además de gestionar el estado local, sincroniza el inventario con el
/// servidor FastAPI cada vez que hay un cambio, para que el bot de Telegram
/// pueda responder con el menú real actualizado.
class InventoryProvider extends ChangeNotifier {
  final InventoryRepository? _repository;

  List<Category> _categories = [];
  List<Product> _products = [];

  // Se eliminó el callback obsoleto

  final String _baseUrl;
  final String _secreto;
  Timer? _timer;

  InventoryProvider(
    InventoryRepository repository, {
    String baseUrl = 'http://localhost:5050',
    String secreto = '',
  })  : _repository = repository,
        _baseUrl = baseUrl,
        _secreto = secreto {
    _loadData();
    _iniciarPolling();
  }

  /// Constructor solo para widget previews: siembra datos en memoria y NO
  /// arranca polling ni red.
  InventoryProvider.preview({
    List<Product>? products,
    List<Category>? categories,
  })  : _repository = null,
        _baseUrl = '',
        _secreto = '' {
    _products = products ?? <Product>[];
    _categories = categories ?? <Category>[];
  }

  void _iniciarPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchDelServidor());
    // Primera carga inmediata
    _fetchDelServidor();
  }

  Future<void> _fetchDelServidor() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/inventario'),
        headers: {'x-secret': _secreto},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        final List<dynamic> catList = data['categorias'] ?? [];
        final List<dynamic> prodList = data['productos'] ?? [];

        final newCategories = catList.map((e) => Category.fromJson(e)).toList();
        final newProducts = prodList.map((e) => Product.fromJson(e)).toList();

        // Para evitar refrescos constantes si no hay cambios, comparamos cantidad
        // (idealmente deberíamos comparar hashes o timestamps, esto es una aproximación simple)
        bool hasChanges = _categories.length != newCategories.length || 
                          _products.length != newProducts.length;
        
        if (!hasChanges) {
          for (int i = 0; i < newProducts.length; i++) {
            if (_products[i].stock != newProducts[i].stock || _products[i].isAvailable != newProducts[i].isAvailable) {
              hasChanges = true;
              break;
            }
          }
        }

        if (hasChanges && newCategories.isNotEmpty) {
          _categories = newCategories;
          _products = newProducts;
          // Guardar en cache local
          await _repository!.saveAllData(newCategories, newProducts);
          notifyListeners();
        }
      }
    } catch (_) {
      // Si falla, seguimos con cache
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Category> get categories => _categories;
  List<Product> get products => _products;

  void _loadData() {
    final repository = _repository!;
    _categories = repository.getCategories();
    _products = repository.getProducts();
    notifyListeners();
  }

  Future<void> _sincronizarConApi() async {
    try {
      final body = {
        'categorias': _categories.map((c) => c.toJson()).toList(),
        'productos': _products.map((p) => p.toJson()).toList(),
      };
      await http.put(
        Uri.parse('$_baseUrl/inventario'),
        headers: {
          'x-secret': _secreto,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
    } catch (_) {
      // Falla silenciosa: el inventario local ya está actualizado
    }
  }

  Future<void> addCategory(String name, String emoji) async {
    await _repository!.addCategory(name, emoji);
    _loadData();
    await _sincronizarConApi();
  }

  Future<void> addProduct(Product product) async {
    await _repository!.addProduct(product);
    _loadData();
    await _sincronizarConApi();
  }

  Future<void> updateProduct(Product product) async {
    await _repository!.updateProduct(product);
    _loadData();
    await _sincronizarConApi();
  }

  Future<void> deleteProduct(String id) async {
    await _repository!.deleteProduct(id);
    _loadData();
    await _sincronizarConApi();
  }
}
