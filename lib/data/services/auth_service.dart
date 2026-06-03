import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prontoapp/data/models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Constructor solo para widget previews: deja el singleton con un usuario
  /// de ejemplo, sin tocar SharedPreferences ni la red.
  factory AuthService.preview({UserModel? user}) {
    _instance._currentUser = user ??
        UserModel(
          id: 'preview',
          email: 'ana@pronto.co',
          name: 'Ana Gómez',
          role: RoleType.gerente,
        );
    _instance._isInitialized = true;
    return _instance;
  }

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  static const String _usersKey = 'prontoapp_users';
  static const String _sessionKey = 'prontoapp_session';

  // Inicializa el servicio, carga usuarios guardados y verifica si hay sesión
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Si no hay usuarios, creamos los por defecto
    if (!prefs.containsKey(_usersKey)) {
      final defaultUsers = [
        UserModel(
          id: '1',
          email: 'gerente@prontoa.com',
          name: 'Carlos Gerente',
          role: RoleType.gerente,
          password: 'password123',
        ),
        UserModel(
          id: '2',
          email: 'cocina@prontoa.com',
          name: 'Ana Cocinera',
          role: RoleType.cocinero,
          password: 'password123',
        ),
        UserModel(
          id: '3',
          email: 'reparto@prontoa.com',
          name: 'Luis Repartidor',
          role: RoleType.repartidor,
          password: 'password123',
        ),
      ];
      await _saveUsers(defaultUsers, prefs);
    }

    // Verificar si hay sesión activa
    if (prefs.containsKey(_sessionKey)) {
      final sessionJson = prefs.getString(_sessionKey);
      if (sessionJson != null) {
        _currentUser = UserModel.fromJson(jsonDecode(sessionJson));
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveUsers(List<UserModel> users, SharedPreferences prefs) async {
    final List<Map<String, dynamic>> jsonList = users.map((u) => u.toJson()).toList();
    await prefs.setString(_usersKey, jsonEncode(jsonList));
  }

  Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_usersKey);
    if (jsonStr == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }

  /// Retorna todos los usuarios registrados (para la pantalla de equipo).
  Future<List<UserModel>> obtenerTodosLosUsuarios() => _getUsers();

  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simular red

    try {
      final users = await _getUsers();
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      
      // Guardar sesión
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionKey, jsonEncode(user.toJson()));
      
      _currentUser = user;
      notifyListeners();
      return user;
    } catch (e) {
      return null; // Usuario no encontrado o contraseña incorrecta
    }
  }

  Future<bool> register({
    required String name,
    required String lastName,
    required String businessName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simular red
    
    final users = await _getUsers();
    
    // Verificar si ya existe
    if (users.any((u) => u.email == email)) {
      return false; // Email ya registrado
    }

    // Por defecto, un nuevo registro es Gerente
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: '$name $lastName',
      role: RoleType.gerente,
      password: password,
    );

    users.add(newUser);
    final prefs = await SharedPreferences.getInstance();
    await _saveUsers(users, prefs);

    // Iniciar sesión automáticamente
    await prefs.setString(_sessionKey, jsonEncode(newUser.toJson()));
    _currentUser = newUser;
    notifyListeners();
    
    return true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    
    _currentUser = null;
    notifyListeners();
  }
}
