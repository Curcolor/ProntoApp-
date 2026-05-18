import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/ui/components/manager/editar_perfil_components.dart';

void main() {
  testWidgets('renders CambioPasswordSection', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: CambioPasswordSection()),
    );

    expect(find.byType(CambioPasswordSection), findsOneWidget);
  });
}
