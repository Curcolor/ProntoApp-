/// Widget guard — bloquea acceso a rutas protegidas según estado Firebase Auth
/// y cargo del `UsuarioAdmin` resuelto.
///
/// Uso:
///
/// ```dart
/// AuthGuard(
///   cargosPermitidos: const [Cargo.GERENTE, Cargo.PROPIETARIO],
///   builder: (perfil) => ManagerMainScreen(perfil: perfil),
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/services/firebase_auth_service.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

typedef PerfilBuilder = Widget Function(PerfilUsuarioAdmin perfil);

class AuthGuard extends StatefulWidget {
  const AuthGuard({
    super.key,
    required this.builder,
    this.cargosPermitidos,
    this.fallbackLogin,
    this.fallbackOnboarding,
    this.fallbackNoAutorizado,
  });

  final PerfilBuilder builder;
  final List<RolAdmin>? cargosPermitidos;

  /// Pantalla a mostrar si no hay sesión Firebase.
  final WidgetBuilder? fallbackLogin;

  /// Pantalla a mostrar si Firebase Auth ok pero no existe UsuarioAdmin (primer
  /// login = pendiente onboarding).
  final WidgetBuilder? fallbackOnboarding;

  /// Pantalla a mostrar si el cargo del UsuarioAdmin no está permitido.
  final WidgetBuilder? fallbackNoAutorizado;

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  PerfilUsuarioAdmin? _perfil;
  bool _cargando = false;
  bool _cargado = false;
  Object? _error;

  Future<void> _cargarPerfil() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final service = context.read<PerfilUsuarioAdminService>();
      final perfil = await service.obtenerMiPerfil();
      if (!mounted) return;
      setState(() {
        _perfil = perfil;
        _cargando = false;
        _cargado = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _cargando = false;
        _cargado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<FirebaseAuthService>();

    if (!auth.inicializado) {
      return const _Cargando();
    }
    if (!auth.estaLogueado) {
      return widget.fallbackLogin?.call(context) ?? const _LoginRequerido();
    }

    if (!_cargado && !_cargando && _error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _cargarPerfil());
      return const _Cargando();
    }
    if (_cargando) {
      return const _Cargando();
    }
    if (_error != null) {
      return _ErrorPantalla(error: _error!);
    }
    final perfil = _perfil;
    if (perfil == null) {
      return widget.fallbackOnboarding?.call(context) ?? const _OnboardingRequerido();
    }
    final cargosOk = widget.cargosPermitidos;
    if (cargosOk != null && !cargosOk.any((c) => c.name == perfil.cargo.stringValue)) {
      return widget.fallbackNoAutorizado?.call(context) ?? const _NoAutorizado();
    }

    return widget.builder(perfil);
  }
}

class _Cargando extends StatelessWidget {
  const _Cargando();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _LoginRequerido extends StatelessWidget {
  const _LoginRequerido();
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('Inicia sesión para continuar.')),
      );
}

class _OnboardingRequerido extends StatelessWidget {
  const _OnboardingRequerido();
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Tu cuenta aún no está asociada a un negocio. Pide invitación a tu administrador.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
}

class _NoAutorizado extends StatelessWidget {
  const _NoAutorizado();
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('No tienes permisos para acceder a esta pantalla.')),
      );
}

class _ErrorPantalla extends StatelessWidget {
  const _ErrorPantalla({required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error cargando perfil: $error'),
          ),
        ),
      );
}
