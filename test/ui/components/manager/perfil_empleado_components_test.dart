import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prontoapp/data/models/user_model.dart';
import 'package:prontoapp/ui/components/manager/perfil_empleado_components.dart';

class MockVoidCallback extends Mock {
  void call();
}

class MockBoolChanged extends Mock {
  void call(bool value);
}

void main() {
  testWidgets('EmployeeProfileHeader renders employee name', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: EmployeeProfileHeader(usuario: _user, meta: _meta),
      ),
    );

    expect(find.byType(EmployeeProfileHeader), findsOneWidget);
    expect(find.text('Ana Cocina'), findsWidgets);
    expect(find.text('Cocinera · Activo/a'), findsOneWidget);
  });

  testWidgets('EmployeeProfileHeader invokes back callback', (tester) async {
    final onBack = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(
        home: EmployeeProfileHeader(
          usuario: _user,
          meta: _meta,
          onBack: onBack.call,
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector).first);

    verify(() => onBack()).called(1);
  });

  testWidgets('EmployeeProfileBody renders contact and permissions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmployeeProfileBody(
            usuario: _user,
            meta: _meta,
            permissions: [_permission()],
          ),
        ),
      ),
    );

    expect(find.byType(EmployeeProfileBody), findsOneWidget);
    expect(find.text('ana@pronto.test'), findsWidgets);
    expect(find.text('Ver pedidos'), findsOneWidget);
  });

  testWidgets('EmployeeProfileBody forwards permission changes', (
    tester,
  ) async {
    final onChanged = MockBoolChanged();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmployeeProfileBody(
            usuario: _user,
            meta: _meta,
            permissions: [_permission(onChanged: onChanged.call)],
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch));

    verify(() => onChanged(false)).called(1);
  });

  testWidgets('EmployeeActionsRow renders actions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EmployeeActionsRow())),
    );

    expect(find.byType(EmployeeActionsRow), findsOneWidget);
    expect(find.text('Cambiar rol'), findsOneWidget);
    expect(find.text('Suspender acceso'), findsOneWidget);
  });

  testWidgets('EmployeeActionsRow invokes suspend callback', (tester) async {
    final onSuspend = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: EmployeeActionsRow(onSuspend: onSuspend.call)),
      ),
    );

    await tester.tap(find.text('Suspender acceso'));

    verify(() => onSuspend()).called(1);
  });
}

final _user = UserModel(
  id: 'u1',
  email: 'ana@pronto.test',
  name: 'Ana Cocina',
  role: RoleType.cocinero,
);

final _meta = {
  'role': 'Cocinera',
  'initial': 'A',
  'roleIcon': FontAwesomeIcons.fireBurner,
  'gradientColors': [const Color(0xFFFEF3C7), const Color(0xFFFDE68A)],
};

EmployeePermissionItem _permission({ValueChanged<bool>? onChanged}) {
  return EmployeePermissionItem(
    icon: FontAwesomeIcons.receipt,
    iconColor: const Color(0xFF15803D),
    iconBgColor: const Color(0xFFDCFCE7),
    title: 'Ver pedidos',
    subtitle: 'Cola de cocina y estados',
    value: true,
    onChanged: onChanged ?? (_) {},
  );
}
