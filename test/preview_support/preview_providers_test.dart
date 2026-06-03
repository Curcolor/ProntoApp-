import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/services/auth_service.dart';

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

  test('OrderProvider.preview seeds orders and starts no timer', () {
    final p = OrderProvider.preview(
      pedidos: [
        OrderModel(
          id: 'P-1', cliente: 'Ana', telefono: 'tg:1', items: const [],
          total: 1000, estado: EstadoPedido.recibido,
          tipo: TipoPedido.recoger, creadoEn: DateTime(2026, 6, 3),
        ),
      ],
    );

    expect(p.pedidos, hasLength(1));
    p.dispose();
  });

  test('NotificationProvider.preview seeds sample notifications', () {
    final p = NotificationProvider.preview();
    expect(p.notifications, isNotEmpty);
  });

  test('AuthService.preview sets a current user', () {
    final auth = AuthService.preview();
    expect(auth.currentUser, isNotNull);
    expect(auth.isInitialized, isTrue);
  });
}
