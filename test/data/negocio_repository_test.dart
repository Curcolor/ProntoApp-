import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prontoapp/data/services/api_client.dart';
import 'package:prontoapp/data/repositories/negocio_repository.dart';

ApiClient _api(MockClient m) => ApiClient(baseUrl: 'http://x', secreto: '', client: m);
const _utf8 = {'content-type': 'application/json; charset=utf-8'};

void main() {
  test('fetchNegocio GET /negocio', () async {
    final mock = MockClient((req) async {
      expect(req.method, 'GET');
      expect(req.url.path, '/negocio');
      return http.Response(jsonEncode({'id': 'main', 'nombre': 'Pronto', 'numeroWhatsapp': '+57'}), 200, headers: _utf8);
    });
    final n = await NegocioRepository(_api(mock)).fetchNegocio();
    expect(n.nombre, 'Pronto');
    expect(n.numeroWhatsapp, '+57');
  });

  test('updateNegocio PUT /negocio', () async {
    var metodo = '';
    final mock = MockClient((req) async {
      metodo = '${req.method} ${req.url.path}';
      return http.Response(jsonEncode({'id': 'main', 'nombre': 'Nuevo'}), 200, headers: _utf8);
    });
    final n = await NegocioRepository(_api(mock)).updateNegocio({'nombre': 'Nuevo'});
    expect(metodo, 'PUT /negocio');
    expect(n.nombre, 'Nuevo');
  });
}
