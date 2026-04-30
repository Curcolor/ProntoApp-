class Product {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final int stock;
  final int minStock;
  final int prepTimeMinutes;
  final bool isAvailable;
  final String description;
  final String aiContext;
  final bool aiActive;
  final String? imageUrl;
  final String emoji;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    required this.minStock,
    required this.prepTimeMinutes,
    required this.isAvailable,
    required this.description,
    required this.aiContext,
    required this.aiActive,
    this.imageUrl,
    required this.emoji,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      categoryId: json['categoryId'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      minStock: json['minStock'] ?? 0,
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      description: json['description'] ?? '',
      aiContext: json['aiContext'] ?? '',
      aiActive: json['aiActive'] ?? true,
      imageUrl: json['imageUrl'],
      emoji: json['emoji'] ?? '📦',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'stock': stock,
      'minStock': minStock,
      'prepTimeMinutes': prepTimeMinutes,
      'isAvailable': isAvailable,
      'description': description,
      'aiContext': aiContext,
      'aiActive': aiActive,
      'imageUrl': imageUrl,
      'emoji': emoji,
    };
  }
}
