import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prontoapp/data/services/api_client.dart';

void main() {
  test('get adjunta X-Secret y parsea JSON', () async {
    final mock = MockClient((req) async {
      expect(req.headers['X-Secret'], 'sec');
      expect(req.url.path, '/inventario');
      return http.Response(jsonEncode({'ok': true}), 200);
    });
    final api = ApiClient(baseUrl: 'http://x', secreto: 'sec', client: mock);
    final r = await api.get('/inventario');
    expect(r['ok'], true);
  });

  test('lanza ApiException en 4xx', () async {
    final mock = MockClient((req) async => http.Response('nope', 404));
    final api = ApiClient(baseUrl: 'http://x', secreto: '', client: mock);
    expect(() => api.get('/pedidos'), throwsA(isA<ApiException>()));
  });

  test('post devuelve body parseado', () async {
    final mock = MockClient((req) async => http.Response(jsonEncode({'id': 'prod-1'}), 201));
    final api = ApiClient(baseUrl: 'http://x', secreto: '', client: mock);
    final r = await api.post('/productos', {'name': 'Café'});
    expect(r['id'], 'prod-1');
  });

  test('manda X-Negocio-Id desde el callback', () async {
    final mock = MockClient((req) async {
      expect(req.headers['X-Negocio-Id'], 'NEG1');
      return http.Response(jsonEncode({'ok': true}), 200);
    });
    final api = ApiClient(baseUrl: 'http://x', secreto: '', client: mock, negocioId: () => 'NEG1');
    await api.get('/x');
  });
}
