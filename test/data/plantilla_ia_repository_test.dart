import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prontoapp/data/services/api_client.dart';
import 'package:prontoapp/data/repositories/plantilla_ia_repository.dart';

ApiClient _api(MockClient m) => ApiClient(baseUrl: 'http://x', secreto: '', client: m);
const _utf8 = {'content-type': 'application/json; charset=utf-8'};

void main() {
  test('fetch GET /plantilla-ia', () async {
    final mock = MockClient((req) async {
      expect(req.method, 'GET');
      expect(req.url.path, '/plantilla-ia');
      return http.Response(jsonEncode({'id': 'main', 'prompt': 'P', 'contexto': '["a"]'}), 200, headers: _utf8);
    });
    final p = await PlantillaIaRepository(_api(mock)).fetch();
    expect(p.prompt, 'P');
    expect(p.contexto, '["a"]');
  });

  test('update PUT /plantilla-ia', () async {
    var metodo = '';
    final mock = MockClient((req) async {
      metodo = '${req.method} ${req.url.path}';
      return http.Response(jsonEncode({'id': 'main', 'prompt': 'P', 'contexto': '[]'}), 200, headers: _utf8);
    });
    await PlantillaIaRepository(_api(mock)).update({'contexto': '[]'});
    expect(metodo, 'PUT /plantilla-ia');
  });
}
