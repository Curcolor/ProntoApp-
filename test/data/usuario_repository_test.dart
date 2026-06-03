import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:prontoapp/data/services/api_client.dart';
import 'package:prontoapp/data/repositories/usuario_repository.dart';
import 'package:prontoapp/data/models/user_model.dart';

ApiClient _api(MockClient m) => ApiClient(baseUrl: 'http://x', secreto: '', client: m);
const _utf8 = {'content-type': 'application/json; charset=utf-8'};

void main() {
  test('listar GET /usuarios mapea', () async {
    final mock = MockClient((req) async => http.Response(jsonEncode([
          {'id': '1', 'nombre': 'Carlos', 'email': 'g@p.com', 'telefono': null, 'rol': 'gerente'},
          {'id': '2', 'nombre': 'Ana', 'email': 'c@p.com', 'telefono': null, 'rol': 'cocinero'},
        ]), 200, headers: _utf8));
    final us = await UsuarioRepository(_api(mock)).listar();
    expect(us.length, 2);
    expect(us[1].role, RoleType.cocinero);
  });

  test('crear POST /usuarios', () async {
    var metodo = '';
    final mock = MockClient((req) async {
      metodo = '${req.method} ${req.url.path}';
      return http.Response(jsonEncode({'id': '9', 'nombre': 'Ana', 'email': 'a@p.com', 'telefono': null, 'rol': 'cocinero'}), 201, headers: _utf8);
    });
    final u = await UsuarioRepository(_api(mock)).crear(nombre: 'Ana', email: 'a@p.com', telefono: '300', rol: 'cocinero', password: 'prontoa123');
    expect(metodo, 'POST /usuarios');
    expect(u.role, RoleType.cocinero);
  });

  test('actualizar PATCH y eliminar DELETE', () async {
    var ultimo = '';
    final mock = MockClient((req) async {
      ultimo = '${req.method} ${req.url.path}';
      return http.Response(jsonEncode({'id': '9', 'nombre': 'X', 'email': 'a@p.com', 'telefono': null, 'rol': 'repartidor'}), 200, headers: _utf8);
    });
    final repo = UsuarioRepository(_api(mock));
    await repo.actualizar('9', {'rol': 'repartidor'});
    expect(ultimo, 'PATCH /usuarios/9');
    await repo.eliminar('9');
    expect(ultimo, 'DELETE /usuarios/9');
  });
}
