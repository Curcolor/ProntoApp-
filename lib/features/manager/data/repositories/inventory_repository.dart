import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class InventoryRepository {
  final SharedPreferences _prefs;
  static const String _productsKey = 'inventory_products_v2';
  static const String _categoriesKey = 'inventory_categories_v2';

  InventoryRepository(this._prefs) {
    _initializeDefaultData();
  }

  void _initializeDefaultData() {
    if (!_prefs.containsKey(_categoriesKey)) {
      final defaultCategories = [
        Category(id: 'cat_1', name: 'Panadería', emoji: '🍞'),
        Category(id: 'cat_2', name: 'Bebidas', emoji: '☕'),
        Category(id: 'cat_3', name: 'Repostería', emoji: '🍰'),
        Category(id: 'cat_4', name: 'Ensaladas', emoji: '🥗'),
      ];
      _saveCategories(defaultCategories);
    }

    if (!_prefs.containsKey(_productsKey)) {
      final defaultProducts = [
        Product(
          id: 'prod_1',
          name: 'Croissant de jamón y queso',
          categoryId: 'cat_1',
          price: 8500,
          stock: 40,
          minStock: 10,
          prepTimeMinutes: 5,
          isAvailable: true,
          description: 'Delicioso croissant hecho de hojaldre con relleno de jamón ibérico y queso gouda. Servido tibio.',
          aiContext: 'Menciona alergenos, ingredientes alternativos o restricciones dietéticas.',
          aiActive: true,
          emoji: '🥐',
        ),
        Product(
          id: 'prod_2',
          name: 'Café latte especial',
          categoryId: 'cat_2',
          price: 5000,
          stock: 5,
          minStock: 10,
          prepTimeMinutes: 3,
          isAvailable: true,
          description: 'Café de origen con leche espumada.',
          aiContext: 'Indica horarios especiales o promociones.',
          aiActive: true,
          emoji: '☕',
        ),
        Product(
          id: 'prod_3',
          name: 'Torta de tres leches',
          categoryId: 'cat_3',
          price: 12000,
          stock: 0,
          minStock: 2,
          prepTimeMinutes: 10,
          isAvailable: true,
          description: 'Torta húmeda de tres leches.',
          aiContext: 'Menciona que es ideal para cumpleaños.',
          aiActive: false,
          emoji: '🍰',
        ),
        Product(
          id: 'prod_4',
          name: 'Pan de bono x6',
          categoryId: 'cat_1',
          price: 9000,
          stock: 32,
          minStock: 5,
          prepTimeMinutes: 5,
          isAvailable: true,
          description: 'Pan de bono tradicional calientito.',
          aiContext: 'Agrega maridajes o productos recomendados.',
          aiActive: true,
          emoji: '🧀',
        ),
      ];
      _saveProducts(defaultProducts);
    }
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

  Future<void> deleteProduct(String id) async {
    final products = getProducts();
    products.removeWhere((p) => p.id == id);
    await _saveProducts(products);
  }
}
