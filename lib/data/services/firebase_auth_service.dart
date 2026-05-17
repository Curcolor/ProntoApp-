/// Wrapper sobre Firebase Auth — única fuente de identidad post F6.2.
///
/// Reemplazará `auth_service.dart` (users fake plaintext) cuando se complete la
/// migración. Por ahora coexisten: este expone API limpia para AuthGuard +
/// código nuevo, mientras providers viejos siguen consumiendo el legacy hasta
/// F6.3.
///
/// **Cero shared secrets cliente-backend.** Backend verifica el ID token JWT.
/// Ver `docs/arquitectura/SEGURIDAD_PLAN.md` y ADR 0001 Flutter.
library;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Resultado normalizado de las operaciones de auth.
sealed class AuthResultado {
  const AuthResultado();
}

final class AuthExito extends AuthResultado {
  const AuthExito(this.usuario);
  final User usuario;
}

final class AuthError extends AuthResultado {
  const AuthError(this.codigo, this.mensaje);
  final String codigo;
  final String mensaje;
}

/// Service singleton que expone Firebase Auth como `ChangeNotifier`.
class FirebaseAuthService extends ChangeNotifier {
  FirebaseAuthService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance {
    _suscribirCambios();
  }

  final FirebaseAuth _auth;
  User? _usuarioActual;
  bool _inicializado = false;

  User? get usuarioActual => _usuarioActual;
  bool get estaLogueado => _usuarioActual != null;
  bool get inicializado => _inicializado;

  void _suscribirCambios() {
    _auth.authStateChanges().listen((User? user) {
      _usuarioActual = user;
      _inicializado = true;
      notifyListeners();
    });
  }

  /// Login con email + password (V1 — único método).
  Future<AuthResultado> iniciarSesionEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        return const AuthError('null_user', 'Firebase devolvió usuario null.');
      }
      return AuthExito(user);
    } on FirebaseAuthException catch (e) {
      return AuthError(e.code, e.message ?? 'Error desconocido');
    }
  }

  /// Crear cuenta nueva. Devuelve user pero NO crea automáticamente el
  /// `UsuarioAdmin` en BD — eso es paso aparte (onboarding manager o invite).
  Future<AuthResultado> registrarEmail({
    required String email,
    required String password,
    String? nombreVisible,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        return const AuthError('null_user', 'Firebase devolvió usuario null.');
      }
      if (nombreVisible != null && nombreVisible.trim().isNotEmpty) {
        await user.updateDisplayName(nombreVisible.trim());
      }
      return AuthExito(user);
    } on FirebaseAuthException catch (e) {
      return AuthError(e.code, e.message ?? 'Error desconocido');
    }
  }

  /// Enviar correo de reset.
  Future<AuthResultado> enviarReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthExito(_usuarioActual ?? _auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      return AuthError(e.code, e.message ?? 'Error desconocido');
    }
  }

  /// Logout local + invalida sesión en Firebase.
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  /// ID token JWT para enviar como `Authorization: Bearer <token>` al backend.
  /// Force refresh si está cerca de expirar.
  Future<String?> obtenerIdToken({bool forzarRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return user.getIdToken(forzarRefresh);
  }
}
