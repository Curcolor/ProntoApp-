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
  tearDown(() async => AuthService().logout());

  test('login ok guarda sesión, currentUser y token', () async {
    final mock = MockClient((req) async => http.Response(
        jsonEncode({'id': '1', 'nombre': 'Carlos', 'email': 'g@p.com', 'telefono': null, 'rol': 'gerente', 'negocioId': 'main', 'token': 'jwt-xyz'}),
        200, headers: _utf8));
    await AuthService().initialize(_api(mock));
    final u = await AuthService().login('g@p.com', 'password123');
    expect(u, isNotNull);
    expect(AuthService().currentUser!.name, 'Carlos');
    expect(AuthService().currentUser!.role, RoleType.gerente);
    expect(AuthService().currentToken, 'jwt-xyz');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('prontoapp_session'), isNotNull);
    expect(prefs.getString('prontoapp_token'), 'jwt-xyz');
  });

  test('login 401 devuelve null', () async {
    final mock = MockClient((req) async => http.Response('bad', 401));
    await AuthService().initialize(_api(mock));
    expect(await AuthService().login('x', 'y'), isNull);
  });

  test('register ok hace auto-login con POST /registro', () async {
    String? pathLlamado;
    final mock = MockClient((req) async {
      pathLlamado = req.url.path;
      return http.Response(
          jsonEncode({'id': '9', 'nombre': 'Ana Gómez', 'email': 'a@p.com', 'telefono': null, 'rol': 'gerente', 'negocioId': 'N1', 'token': 'jwt-reg'}),
          201, headers: _utf8);
    });
    await AuthService().initialize(_api(mock));
    final ok = await AuthService().register(name: 'Ana', lastName: 'Gómez', businessName: 'X', email: 'a@p.com', password: '123');
    expect(ok, true);
    expect(pathLlamado, '/registro');
    expect(AuthService().currentUser!.name, 'Ana Gómez');
    expect(AuthService().currentUser!.negocioId, 'N1');
    expect(AuthService().currentToken, 'jwt-reg');
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
        jsonEncode({'id': '1', 'nombre': 'C', 'email': 'g@p.com', 'telefono': null, 'rol': 'gerente', 'negocioId': 'main', 'token': 'jwt-xyz'}),
        200, headers: _utf8));
    await AuthService().initialize(_api(mock));
    await AuthService().login('g@p.com', 'x');
    await AuthService().logout();
    expect(AuthService().currentUser, isNull);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('prontoapp_session'), isNull);
    expect(AuthService().currentToken, isNull);
    expect(prefs.getString('prontoapp_token'), isNull);
  });

  test('initialize restaura el token cacheado', () async {
    SharedPreferences.setMockInitialValues({'prontoapp_token': 'jwt-cache'});
    final mock = MockClient((req) async => http.Response('', 200));
    await AuthService().initialize(_api(mock));
    expect(AuthService().currentToken, 'jwt-cache');
  });
}
