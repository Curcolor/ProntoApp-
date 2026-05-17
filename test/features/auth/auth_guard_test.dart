/// F6.5 — smoke tests del AuthGuard.
///
/// Cubre el árbol de fallbacks:
///   1. Firebase Auth aún no inicializado → spinner.
///   2. Firebase Auth inicializado pero sin usuario → fallbackLogin.
///   3. Usuario Firebase logueado pero `obtenerMiPerfil` devuelve null
///      → fallbackOnboarding.
///   4. Usuario + perfil resueltos + cargo permitido → builder.
///   5. Usuario + perfil resueltos + cargo NO permitido → fallbackNoAutorizado.
///
/// Usa `firebase_auth_mocks` para Firebase Auth y un fake del
/// `PerfilUsuarioAdminService` para evitar tocar Data Connect real.
library;

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/services/firebase_auth_service.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/features/auth/widgets/auth_guard.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

/// Fake del service de perfil que no toca Data Connect — la suite de prueba
/// controla qué devuelve `obtenerMiPerfil` y qué guarda en cache.
class _FakePerfilService extends PerfilUsuarioAdminService {
  _FakePerfilService({this.perfilADevolver, this.lanzarError = false})
      : super(_DummyConnector());

  final PerfilUsuarioAdmin? perfilADevolver;
  final bool lanzarError;
  int llamadas = 0;

  @override
  Future<PerfilUsuarioAdmin?> obtenerMiPerfil() async {
    llamadas++;
    if (lanzarError) {
      throw StateError('boom');
    }
    return perfilADevolver;
  }
}

/// Connector inerte — el fake nunca usa el SDK real, pero `PerfilUsuarioAdminService`
/// lo requiere en el constructor.
class _DummyConnector implements ProntoappConnector {
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

PerfilUsuarioAdmin _perfilPropietario() => PerfilUsuarioAdmin(
      id: 'u-1',
      nombre: 'Juana',
      email: 'juana@example.com',
      cargo: const Known(RolAdmin.PROPIETARIO),
      negocioId: 'n-1',
      negocioNombre: 'Panadería de prueba',
      tipoNegocio: const Known(TipoNegocio.PANADERIA),
      formatoEntrega: const Known(FormatoEntrega.DOMICILIO),
      zonaHoraria: 'America/Bogota',
      monedaIso: 'COP',
    );

PerfilUsuarioAdmin _perfilSupervisor() => PerfilUsuarioAdmin(
      id: 'u-2',
      nombre: 'Pedro',
      email: 'pedro@example.com',
      cargo: const Known(RolAdmin.SUPERVISOR),
      negocioId: 'n-1',
      negocioNombre: 'Panadería de prueba',
      tipoNegocio: const Known(TipoNegocio.PANADERIA),
      formatoEntrega: const Known(FormatoEntrega.DOMICILIO),
      zonaHoraria: 'America/Bogota',
      monedaIso: 'COP',
    );

Widget _envolver({
  required FirebaseAuthService auth,
  required PerfilUsuarioAdminService perfil,
  required Widget child,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: auth),
      ChangeNotifierProvider.value(value: perfil),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  group('AuthGuard', () {
    testWidgets('sin sesión Firebase muestra fallbackLogin custom', (tester) async {
      final mockAuth = MockFirebaseAuth(signedIn: false);
      final authService = FirebaseAuthService(auth: mockAuth);
      final perfil = _FakePerfilService();

      await tester.pumpWidget(_envolver(
        auth: authService,
        perfil: perfil,
        child: AuthGuard(
          fallbackLogin: (_) => const Text('LOGIN_FALLBACK'),
          builder: (_) => const Text('PROTEGIDA'),
        ),
      ));
      // authStateChanges() es asíncrono, dejamos correr el listener.
      await tester.pump();

      expect(find.text('LOGIN_FALLBACK'), findsOneWidget);
      expect(find.text('PROTEGIDA'), findsNothing);
      expect(perfil.llamadas, 0, reason: 'no debe consultar perfil sin login');
    });

    testWidgets('logueado + perfil null → onboarding fallback', (tester) async {
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'firebase-uid-1', email: 'a@b.com'),
      );
      final authService = FirebaseAuthService(auth: mockAuth);
      final perfil = _FakePerfilService(perfilADevolver: null);

      await tester.pumpWidget(_envolver(
        auth: authService,
        perfil: perfil,
        child: AuthGuard(
          fallbackOnboarding: (_) => const Text('ONBOARDING'),
          builder: (_) => const Text('PROTEGIDA'),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('ONBOARDING'), findsOneWidget);
      expect(perfil.llamadas, 1);
    });

    testWidgets('cargo permitido → renderiza builder con el perfil', (tester) async {
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'firebase-uid-2'),
      );
      final authService = FirebaseAuthService(auth: mockAuth);
      final perfil = _FakePerfilService(perfilADevolver: _perfilPropietario());

      await tester.pumpWidget(_envolver(
        auth: authService,
        perfil: perfil,
        child: AuthGuard(
          cargosPermitidos: const [RolAdmin.PROPIETARIO, RolAdmin.GERENTE],
          builder: (p) => Text('OK_${p.nombre}'),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('OK_Juana'), findsOneWidget);
    });

    testWidgets('cargo no permitido → fallback no autorizado', (tester) async {
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'firebase-uid-3'),
      );
      final authService = FirebaseAuthService(auth: mockAuth);
      final perfil = _FakePerfilService(perfilADevolver: _perfilSupervisor());

      await tester.pumpWidget(_envolver(
        auth: authService,
        perfil: perfil,
        child: AuthGuard(
          cargosPermitidos: const [RolAdmin.PROPIETARIO, RolAdmin.GERENTE],
          fallbackNoAutorizado: (_) => const Text('NO_AUTORIZADO'),
          builder: (_) => const Text('PROTEGIDA'),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('NO_AUTORIZADO'), findsOneWidget);
      expect(find.text('PROTEGIDA'), findsNothing);
    });

    testWidgets('error consultando perfil → muestra error', (tester) async {
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'firebase-uid-4'),
      );
      final authService = FirebaseAuthService(auth: mockAuth);
      final perfil = _FakePerfilService(lanzarError: true);

      await tester.pumpWidget(_envolver(
        auth: authService,
        perfil: perfil,
        child: AuthGuard(builder: (_) => const Text('PROTEGIDA')),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Error cargando perfil'), findsOneWidget);
    });
  });
}
