import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prontoapp/ui/components/manager/profile_components.dart';

class MockVoidCallback extends Mock {
  void call();
}

void main() {
  testWidgets('ProfileHeroSummary renders identity and metrics', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProfileHeroSummary(
              name: 'Carlos Gerente',
              isManager: true,
              aiConnected: true,
              totalOrders: 10,
              deliveredOrders: 8,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ProfileHeroSummary), findsOneWidget);
    expect(find.text('Carlos Gerente'), findsOneWidget);
    expect(find.text('IA Activa'), findsOneWidget);
    expect(find.text('80%'), findsOneWidget);
  });

  testWidgets('ProfileHeroSummary renders disconnected AI badge', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProfileHeroSummary(
              name: 'Luis',
              isManager: false,
              aiConnected: false,
              totalOrders: 0,
              deliveredOrders: 0,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Empleado · Mi negocio'), findsOneWidget);
    expect(find.text('IA No Activa'), findsOneWidget);
  });

  testWidgets('ProfileBusinessSection renders incoming order status', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileBusinessSection(aiConnected: true, incomingOrders: 3),
        ),
      ),
    );

    expect(find.byType(ProfileBusinessSection), findsOneWidget);
    expect(find.text('IA Activa · 3 pedidos entrantes'), findsOneWidget);
  });

  testWidgets('ProfileBusinessSection invokes navigation callback', (
    tester,
  ) async {
    final onTeamTap = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileBusinessSection(
            aiConnected: false,
            incomingOrders: 0,
            onTeamTap: onTeamTap.call,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Administrar equipo'));

    verify(() => onTeamTap()).called(1);
  });

  testWidgets('ProfileSettingsSection renders profile data', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProfileSettingsSection(
              email: 'owner@pronto.test',
              businessName: 'Panadería Pronto',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ProfileSettingsSection), findsOneWidget);
    expect(find.text('owner@pronto.test'), findsOneWidget);
    expect(find.text('Panadería Pronto'), findsOneWidget);
  });

  testWidgets('ProfileSettingsSection invokes logout callback', (tester) async {
    final onLogout = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProfileSettingsSection(
              email: 'owner@pronto.test',
              businessName: 'Panadería Pronto',
              onLogoutTap: onLogout.call,
            ),
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cerrar sesión'));

    verify(() => onLogout()).called(1);
  });
}
