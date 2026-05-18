import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/ui/components/kitchen/preparacion_components.dart';

void main() {
  testWidgets('renders PedidoPreparacionCard', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PedidoPreparacionCard()),
    );

    expect(find.byType(PedidoPreparacionCard), findsOneWidget);
  });
}
