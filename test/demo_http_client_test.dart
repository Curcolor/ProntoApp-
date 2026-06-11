import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/features/demo/data/demo_http_client.dart';
import 'package:prontoapp/features/demo/data/demo_api_client.dart';

void main() {
  test('DemoHttpClient: GET devuelve lista vacía sin red', () async {
    final api = crearDemoApiClient();
    final r = await api.get('/equipo');
    expect(r, isA<List>());
    expect((r as List).isEmpty, true);
  });

  test('DemoHttpClient: POST no-op devuelve mapa', () async {
    final api = crearDemoApiClient();
    final r = await api.post('/negocio', {'x': 1});
    expect(r, isA<Map>());
  });
}
