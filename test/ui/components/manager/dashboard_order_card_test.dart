import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/ui/components/manager/dashboard_components.dart';

void main() {
  testWidgets('renders DashboardOrderCard', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DashboardOrderCard()),
    );

    expect(find.byType(DashboardOrderCard), findsOneWidget);
  });
}
