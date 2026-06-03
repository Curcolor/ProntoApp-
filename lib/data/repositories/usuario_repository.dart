import '../models/user_model.dart';
import '../services/api_client.dart';

/// Gestión de usuarios (empleados) vía FastAPI.
class UsuarioRepository {
  final ApiClient _api;
  UsuarioRepository(this._api);

  UserModel _fromServer(Map<String, dynamic> d) => UserModel(
        id: d['id'] as String,
        email: d['email'] as String,
        name: d['nombre'] as String,
        role: RoleType.values.firstWhere(
          (e) => e.toString().split('.').last == d['rol'],
          orElse: () => RoleType.gerente,
        ),
      );

  Future<List<UserModel>> listar() async {
    final lista = await _api.get('/usuarios') as List<dynamic>;
    return lista.map((e) => _fromServer(e as Map<String, dynamic>)).toList();
  }

  Future<UserModel> crear({
    required String nombre,
    required String email,
    required String telefono,
    required String rol,
    required String password,
  }) async =>
      _fromServer(await _api.post('/usuarios', {
        'nombre': nombre, 'email': email, 'telefono': telefono, 'rol': rol, 'password': password,
      }) as Map<String, dynamic>);

  Future<UserModel> actualizar(String id, Map<String, dynamic> datos) async =>
      _fromServer(await _api.patch('/usuarios/$id', datos) as Map<String, dynamic>);

  Future<void> eliminar(String id) => _api.delete('/usuarios/$id');
}
