import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/api_client.dart';

typedef Inventario = ({List<Category> categorias, List<Product> productos});

/// Acceso al inventario: remoto (ApiClient) como fuente de verdad + cache de
/// solo-lectura en SharedPreferences para mostrar algo si el server cae.
class InventoryRepository {
  final ApiClient _api;
  final SharedPreferences _prefs;
  static const String _productsKey = 'inventory_products_v3';
  static const String _categoriesKey = 'inventory_categories_v3';

  InventoryRepository(this._api, this._prefs);

  // ─── Lectura ──────────────────────────────────────────────────────────────
  Future<Inventario> fetchInventario() async {
    final data = await _api.get('/inventario') as Map<String, dynamic>;
    final cats = (data['categorias'] as List).map((e) => Category.fromJson(e)).toList();
    final prods = (data['productos'] as List).map((e) => Product.fromJson(e)).toList();
    await _saveCache(cats, prods);
    return (categorias: cats, productos: prods);
  }

  Inventario readCache() {
    try {
      final cs = _prefs.getString(_categoriesKey);
      final ps = _prefs.getString(_productsKey);
      final cats = cs == null ? <Category>[]
          : (jsonDecode(cs) as List).map((e) => Category.fromJson(e)).toList();
      final prods = ps == null ? <Product>[]
          : (jsonDecode(ps) as List).map((e) => Product.fromJson(e)).toList();
      return (categorias: cats, productos: prods);
    } catch (_) {
      return (categorias: <Category>[], productos: <Product>[]);
    }
  }

  Future<void> _saveCache(List<Category> categorias, List<Product> productos) async {
    await _prefs.setString(_categoriesKey, jsonEncode(categorias.map((c) => c.toJson()).toList()));
    await _prefs.setString(_productsKey, jsonEncode(productos.map((p) => p.toJson()).toList()));
  }

  // ─── Escritura (servidor = fuente de verdad) ────────────────────────────────
  Future<Product> createProduct(Map<String, dynamic> datos) async =>
      Product.fromJson(await _api.post('/productos', datos) as Map<String, dynamic>);

  Future<Product> updateProduct(String id, Map<String, dynamic> datos) async =>
      Product.fromJson(await _api.patch('/productos/$id', datos) as Map<String, dynamic>);

  Future<void> deleteProduct(String id) => _api.delete('/productos/$id');

  Future<Category> createCategory(String name, String emoji) async =>
      Category.fromJson(await _api.post('/categorias', {'name': name, 'emoji': emoji}) as Map<String, dynamic>);

  Future<Category> updateCategory(String id, Map<String, dynamic> datos) async =>
      Category.fromJson(await _api.patch('/categorias/$id', datos) as Map<String, dynamic>);

  Future<void> deleteCategory(String id) => _api.delete('/categorias/$id');
}
