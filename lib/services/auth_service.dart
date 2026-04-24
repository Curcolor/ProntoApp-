import 'dart:async';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  // Usuarios simulados (Pseudo-backend)
  final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      email: 'gerente@prontoa.com',
      name: 'Carlos Gerente',
      role: RoleType.gerente,
    ),
    UserModel(
      id: '2',
      email: 'cocina@prontoa.com',
      name: 'Ana Cocinera',
      role: RoleType.cocinero,
    ),
    UserModel(
      id: '3',
      email: 'reparto@prontoa.com',
      name: 'Luis Repartidor',
      role: RoleType.repartidor,
    ),
  ];

  Future<UserModel?> login(String email, String password) async {
    // Simular tiempo de carga de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _mockUsers.firstWhere((u) => u.email == email);
      // Ignoramos el password en este mock
      _currentUser = user;
      return user;
    } catch (e) {
      // Si no encuentra el correo
      return null;
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }
}
