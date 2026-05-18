import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/ui/components/auth/login_components.dart';

void main() {
  testWidgets('renders LoginHeroHeader', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginHeroHeader()),
    );

    expect(find.byType(LoginHeroHeader), findsOneWidget);
  });
}
