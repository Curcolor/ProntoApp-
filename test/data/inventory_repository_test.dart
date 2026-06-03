import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prontoapp/data/services/api_client.dart';
import 'package:prontoapp/data/repositories/inventory_repository.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('fetchInventario llama GET /inventario y cachea', () async {
    final mock = MockClient((req) async => http.Response(jsonEncode({
          'categorias': [{'id': 'c', 'name': 'Bebidas', 'emoji': '☕'}],
          'productos': [{'id': 'p', 'name': 'Café', 'categoryId': 'c', 'price': 5000,
            'stock': 1, 'minStock': 0, 'prepTimeMinutes': 0, 'isAvailable': true,
            'description': '', 'aiContext': '', 'aiActive': true, 'imageUrl': null, 'emoji': '☕'}],
        }), 200, headers: {'content-type': 'application/json; charset=utf-8'}));
    final prefs = await SharedPreferences.getInstance();
    final repo = InventoryRepository(ApiClient(baseUrl: 'http://x', secreto: '', client: mock), prefs);
    final inv = await repo.fetchInventario();
    expect(inv.productos.first.name, 'Café');
    // tras fetch, readCache devuelve lo mismo
    expect(repo.readCache().productos.first.id, 'p');
  });

  test('createProduct hace POST /productos', () async {
    var llamado = '';
    final mock = MockClient((req) async {
      llamado = '${req.method} ${req.url.path}';
      return http.Response(jsonEncode({'id': 'prod-1', 'name': 'Té', 'categoryId': 'c',
        'price': 1, 'stock': 0, 'minStock': 0, 'prepTimeMinutes': 0, 'isAvailable': true,
        'description': '', 'aiContext': '', 'aiActive': true, 'imageUrl': null, 'emoji': '🍵'}), 201,
        headers: {'content-type': 'application/json; charset=utf-8'});
    });
    final prefs = await SharedPreferences.getInstance();
    final repo = InventoryRepository(ApiClient(baseUrl: 'http://x', secreto: '', client: mock), prefs);
    final p = await repo.createProduct({'name': 'Té', 'categoryId': 'c', 'price': 1});
    expect(llamado, 'POST /productos');
    expect(p.id, 'prod-1');
  });
}
