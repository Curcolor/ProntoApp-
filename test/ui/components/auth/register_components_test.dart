import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prontoapp/ui/components/auth/register_components.dart';

class MockVoidCallback extends Mock {
  void call();
}

class MockBoolChanged extends Mock {
  void call(bool value);
}

class MockSubmit extends Mock {
  Future<void> call();
}

void main() {
  testWidgets('RegisterIntroSection renders header and step', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: RegisterIntroSection(backPressed: false)),
    );

    expect(find.byType(RegisterIntroSection), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
    expect(_richTextContaining('Paso 2 de 3'), findsOneWidget);
  });

  testWidgets('RegisterIntroSection invokes back callbacks', (tester) async {
    final onBack = MockVoidCallback();
    final onPressedChanged = MockBoolChanged();
    await tester.pumpWidget(
      MaterialApp(
        home: RegisterIntroSection(
          backPressed: false,
          onBack: onBack.call,
          onBackPressedChanged: onPressedChanged.call,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.arrow_back));

    verify(() => onPressedChanged(true)).called(1);
    verify(() => onPressedChanged(false)).called(1);
    verify(() => onBack()).called(1);
  });

  testWidgets('RegisterFormSection renders expected fields', (tester) async {
    final controllers = _RegisterControllers();
    addTearDown(controllers.dispose);

    await tester.pumpWidget(_FormHarness(controllers: controllers));

    expect(find.byType(RegisterFormSection), findsOneWidget);
    expect(find.text('Nombre del negocio'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
  });

  testWidgets('RegisterFormSection invokes submit callback', (tester) async {
    final controllers = _RegisterControllers();
    final submit = MockSubmit();
    when(() => submit()).thenAnswer((_) async {});
    addTearDown(controllers.dispose);

    await tester.pumpWidget(
      _FormHarness(controllers: controllers, onSubmit: submit.call),
    );

    await tester.ensureVisible(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));

    verify(() => submit()).called(1);
  });

  testWidgets('RegisterFooterLinks renders terms and login text', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterFooterLinks()));

    expect(find.byType(RegisterFooterLinks), findsOneWidget);
    expect(_richTextContaining('Al continuar'), findsOneWidget);
    expect(_richTextContaining('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('RegisterFooterLinks invokes login callback', (tester) async {
    final onLogin = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(home: RegisterFooterLinks(onLoginTap: onLogin.call)),
    );

    await tester.tap(find.byType(TextButton));

    verify(() => onLogin()).called(1);
  });
}

Finder _richTextContaining(String text) {
  return find.byWidgetPredicate(
    (widget) => widget is RichText && widget.text.toPlainText().contains(text),
  );
}

class _FormHarness extends StatelessWidget {
  final _RegisterControllers controllers;
  final Future<void> Function()? onSubmit;

  const _FormHarness({required this.controllers, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: RegisterFormSection(
            formKey: GlobalKey<FormState>(),
            businessNameController: controllers.business,
            nameController: controllers.name,
            lastNameController: controllers.lastName,
            phoneController: controllers.phone,
            emailController: controllers.email,
            passwordController: controllers.password,
            passwordVisible: false,
            isLoading: false,
            onTogglePassword: () {},
            onSubmit: onSubmit ?? () async {},
          ),
        ),
      ),
    );
  }
}

class _RegisterControllers {
  final business = TextEditingController();
  final name = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void dispose() {
    business.dispose();
    name.dispose();
    lastName.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
  }
}
