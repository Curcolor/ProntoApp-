import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prontoapp/data/services/api_client.dart';
import 'package:prontoapp/data/repositories/order_repository.dart';

const _jsonHeaders = {'content-type': 'application/json; charset=utf-8'};

dynamic _pedidoJson(String id) => {
  'id': id, 'cliente': 'Ana', 'telefono': '300',
  'items': [{'nombre': 'Café', 'cantidad': 1, 'precio': 5000}],
  'total': 5000, 'tipo': 'recoger', 'direccion': null,
  'estado': 'recibido', 'creado_en': '2026-04-30T05:00:00',
};

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('fetchPedidos GET /pedidos y cachea', () async {
    final mock = MockClient((req) async =>
        http.Response(jsonEncode([_pedidoJson('P-1')]), 200, headers: _jsonHeaders));
    final prefs = await SharedPreferences.getInstance();
    final repo = OrderRepository(ApiClient(baseUrl: 'http://x', secreto: '', client: mock), prefs);
    final pedidos = await repo.fetchPedidos();
    expect(pedidos.single.id, 'P-1');
    expect(repo.readCache().single.id, 'P-1');
  });

  test('avanzarEstado PATCH', () async {
    var llamado = '';
    final mock = MockClient((req) async {
      llamado = '${req.method} ${req.url.path}';
      return http.Response(jsonEncode(_pedidoJson('P-1')), 200, headers: _jsonHeaders);
    });
    final prefs = await SharedPreferences.getInstance();
    final repo = OrderRepository(ApiClient(baseUrl: 'http://x', secreto: '', client: mock), prefs);
    await repo.avanzarEstado('P-1', 'listo');
    expect(llamado, 'PATCH /pedidos/P-1/estado');
  });
}
