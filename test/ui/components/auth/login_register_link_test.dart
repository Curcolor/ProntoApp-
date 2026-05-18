import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/ui/components/auth/login_components.dart';

void main() {
  testWidgets('renders LoginRegisterLink', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginRegisterLink()),
    );

    expect(find.byType(LoginRegisterLink), findsOneWidget);
  });
}
