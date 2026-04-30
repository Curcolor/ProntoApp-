import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class InventoryRepository {
  final SharedPreferences _prefs;
  static const String _productsKey = 'inventory_products_v3';
  static const String _categoriesKey = 'inventory_categories_v3';

  InventoryRepository(this._prefs);

  Future<void> clearAllData() async {
    await _prefs.remove(_productsKey);
    await _prefs.remove(_categoriesKey);
  }

  // --- Categories ---
  List<Category> getCategories() {
    final String? jsonStr = _prefs.getString(_categoriesKey);
    if (jsonStr == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((json) => Category.fromJson(json)).toList();
  }

  Future<void> _saveCategories(List<Category> categories) async {
    final String jsonStr = jsonEncode(categories.map((c) => c.toJson()).toList());
    await _prefs.setString(_categoriesKey, jsonStr);
  }

  Future<Category> addCategory(String name, String emoji) async {
    final categories = getCategories();
    final newCategory = Category(
      id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      emoji: emoji,
    );
    categories.add(newCategory);
    await _saveCategories(categories);
    return newCategory;
  }

  // --- Products ---
  List<Product> getProducts() {
    final String? jsonStr = _prefs.getString(_productsKey);
    if (jsonStr == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> _saveProducts(List<Product> products) async {
    final String jsonStr = jsonEncode(products.map((p) => p.toJson()).toList());
    await _prefs.setString(_productsKey, jsonStr);
  }

  Future<Product> addProduct(Product product) async {
    final products = getProducts();
    products.add(product);
    await _saveProducts(products);
    return product;
  }

  Future<void> updateProduct(Product product) async {
    final products = getProducts();
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
      await _saveProducts(products);
    }
  }

  Future<void> saveAllData(List<Category> categories, List<Product> products) async {
    await _saveCategories(categories);
    await _saveProducts(products);
  }

  Future<void> deleteProduct(String id) async {
    final products = getProducts();
    products.removeWhere((p) => p.id == id);
    await _saveProducts(products);
  }
}
