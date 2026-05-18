import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/ui/components/manager/inventory_components.dart';

void main() {
  testWidgets('renders InventoryHeader', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: InventoryHeader()),
    );

    expect(find.byType(InventoryHeader), findsOneWidget);
  });
}
