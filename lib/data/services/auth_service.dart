import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prontoapp/data/models/user_model.dart';
import 'package:prontoapp/data/services/api_client.dart';

/// Servicio de autenticación. Fuente de verdad = servidor (vía ApiClient).
/// Solo cachea la sesión del usuario logueado en SharedPreferences para resume.
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Solo para widget previews: setea un usuario sin red.
  factory AuthService.preview({UserModel? user}) {
    _instance._currentUser = user ??
        UserModel(id: 'preview', email: 'ana@pronto.co', name: 'Ana Gómez', role: RoleType.gerente);
    _instance._isInitialized = true;
    return _instance;
  }

  ApiClient? _api;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  static const String _sessionKey = 'prontoapp_session';

  /// Guarda el ApiClient y resume la sesión cacheada (sin llamar al server).
  Future<void> initialize(ApiClient api) async {
    _api = api;
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_sessionKey);
    _currentUser = sessionJson != null
        ? UserModel.fromJson(jsonDecode(sessionJson) as Map<String, dynamic>)
        : null;
    _isInitialized = true;
    notifyListeners();
  }

  UserModel _userFromServer(Map<String, dynamic> d) => UserModel(
        id: d['id'] as String,
        email: d['email'] as String,
        name: d['nombre'] as String,
        role: RoleType.values.firstWhere(
          (e) => e.toString().split('.').last == d['rol'],
          orElse: () => RoleType.gerente,
        ),
      );

  Future<void> _guardarSesion(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(user.toJson()));
    _currentUser = user;
    notifyListeners();
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final data = await _api!.post('/auth/login', {'email': email, 'password': password})
          as Map<String, dynamic>;
      final user = _userFromServer(data);
      await _guardarSesion(user);
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<bool> register({
    required String name,
    required String lastName,
    required String businessName,
    required String email,
    required String password,
  }) async {
    try {
      final data = await _api!.post('/usuarios', {
        'nombre': '$name $lastName', 'email': email, 'password': password, 'rol': 'gerente',
      }) as Map<String, dynamic>;
      await _guardarSesion(_userFromServer(data));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<UserModel>> obtenerTodosLosUsuarios() async {
    try {
      final lista = await _api!.get('/usuarios') as List<dynamic>;
      return lista.map((e) => _userFromServer(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    _currentUser = null;
    notifyListeners();
  }
}
