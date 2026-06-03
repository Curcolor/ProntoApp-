import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prontoapp/data/services/api_client.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/models/user_model.dart';

ApiClient _api(MockClient mock) => ApiClient(baseUrl: 'http://x', secreto: '', client: mock);
const _utf8 = {'content-type': 'application/json; charset=utf-8'};

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('login ok guarda sesión y currentUser', () async {
    final mock = MockClient((req) async => http.Response(
        jsonEncode({'id': '1', 'nombre': 'Carlos', 'email': 'g@p.com', 'telefono': null, 'rol': 'gerente'}),
        200, headers: _utf8));
    await AuthService().initialize(_api(mock));
    final u = await AuthService().login('g@p.com', 'password123');
    expect(u, isNotNull);
    expect(AuthService().currentUser!.name, 'Carlos');
    expect(AuthService().currentUser!.role, RoleType.gerente);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('prontoapp_session'), isNotNull);
  });

  test('login 401 devuelve null', () async {
    final mock = MockClient((req) async => http.Response('bad', 401));
    await AuthService().initialize(_api(mock));
    expect(await AuthService().login('x', 'y'), isNull);
  });

  test('register ok hace auto-login', () async {
    final mock = MockClient((req) async => http.Response(
        jsonEncode({'id': '9', 'nombre': 'Ana Gómez', 'email': 'a@p.com', 'telefono': null, 'rol': 'gerente'}),
        201, headers: _utf8));
    await AuthService().initialize(_api(mock));
    final ok = await AuthService().register(name: 'Ana', lastName: 'Gómez', businessName: 'X', email: 'a@p.com', password: '123');
    expect(ok, true);
    expect(AuthService().currentUser!.name, 'Ana Gómez');
  });

  test('register 409 devuelve false', () async {
    final mock = MockClient((req) async => http.Response('dup', 409));
    await AuthService().initialize(_api(mock));
    expect(await AuthService().register(name: 'A', lastName: 'B', businessName: 'X', email: 'a@p.com', password: '1'), false);
  });

  test('initialize resume sesión cacheada sin red', () async {
    final user = UserModel(id: '1', email: 'g@p.com', name: 'Carlos', role: RoleType.gerente);
    SharedPreferences.setMockInitialValues({'prontoapp_session': jsonEncode(user.toJson())});
    var llamado = false;
    final mock = MockClient((req) async { llamado = true; return http.Response('', 200); });
    await AuthService().initialize(_api(mock));
    expect(AuthService().currentUser!.name, 'Carlos');
    expect(llamado, false);
  });

  test('logout limpia sesión', () async {
    final mock = MockClient((req) async => http.Response(
        jsonEncode({'id': '1', 'nombre': 'C', 'email': 'g@p.com', 'telefono': null, 'rol': 'gerente'}),
        200, headers: _utf8));
    await AuthService().initialize(_api(mock));
    await AuthService().login('g@p.com', 'x');
    await AuthService().logout();
    expect(AuthService().currentUser, isNull);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('prontoapp_session'), isNull);
  });
}
