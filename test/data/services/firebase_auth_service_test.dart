/// F6.5 — tests del wrapper FirebaseAuthService usando firebase_auth_mocks.
library;

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/data/services/firebase_auth_service.dart';

void main() {
  group('FirebaseAuthService', () {
    test('estaLogueado refleja signedIn=true del mock', () async {
      final auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'u-1', email: 'a@b.com'),
      );
      final service = FirebaseAuthService(auth: auth);
      await Future<void>.delayed(Duration.zero);
      expect(service.estaLogueado, isTrue);
      expect(service.usuarioActual?.email, 'a@b.com');
      expect(service.inicializado, isTrue);
    });

    test('signInWithEmailAndPassword devuelve AuthExito con MockUser', () async {
      final mockUser = MockUser(uid: 'u-2', email: 'pedro@example.com');
      final auth = MockFirebaseAuth(mockUser: mockUser);
      final service = FirebaseAuthService(auth: auth);
      final r = await service.iniciarSesionEmail(email: 'pedro@example.com', password: 'x');
      expect(r, isA<AuthExito>());
      expect((r as AuthExito).usuario.uid, 'u-2');
    });

    test('cerrarSesion deja estaLogueado en false', () async {
      final auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'u-3'),
      );
      final service = FirebaseAuthService(auth: auth);
      await Future<void>.delayed(Duration.zero);
      expect(service.estaLogueado, isTrue);
      await service.cerrarSesion();
      await Future<void>.delayed(Duration.zero);
      expect(service.estaLogueado, isFalse);
    });

    test('obtenerIdToken devuelve null cuando no hay usuario', () async {
      final auth = MockFirebaseAuth(signedIn: false);
      final service = FirebaseAuthService(auth: auth);
      final token = await service.obtenerIdToken();
      expect(token, isNull);
    });
  });
}
