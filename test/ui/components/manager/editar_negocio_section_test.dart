import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/ui/components/manager/editar_perfil_components.dart';

void main() {
  testWidgets('renders EditarNegocioSection', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: EditarNegocioSection()),
    );

    expect(find.byType(EditarNegocioSection), findsOneWidget);
  });
}
