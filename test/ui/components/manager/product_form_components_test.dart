import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/ui/components/manager/product_form_components.dart';

class MockVoidCallback extends Mock {
  void call();
}

class MockBoolChanged extends Mock {
  void call(bool value);
}

class MockCategoryChanged extends Mock {
  void call(String? value);
}

void main() {
  testWidgets('ProductFormHeader renders create title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProductFormHeader(isEditing: false)),
    );

    expect(find.byType(ProductFormHeader), findsOneWidget);
    expect(find.text('Nuevo producto'), findsOneWidget);
  });

  testWidgets('ProductFormHeader invokes back callback', (tester) async {
    final onBack = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(
        home: ProductFormHeader(isEditing: true, onBack: onBack.call),
      ),
    );

    await tester.tap(find.byType(GestureDetector).first);
    verify(() => onBack()).called(1);
    expect(find.text('Editar producto'), findsOneWidget);
  });

  testWidgets('ProductFormFields renders form inputs', (tester) async {
    final controllers = _ProductControllers();
    addTearDown(controllers.dispose);

    await tester.pumpWidget(
      _FormHarness(
        child: ProductFormFields(
          nameController: controllers.name,
          priceController: controllers.price,
          stockController: controllers.stock,
          minStockController: controllers.minStock,
          prepTimeController: controllers.prepTime,
          descriptionController: controllers.description,
          aiContextController: controllers.aiContext,
          categories: _categories,
          selectedCategoryId: 'bread',
          onCategoryChanged: (_) {},
          onAddCategory: () {},
          isAvailable: true,
          onAvailableChanged: (_) {},
          aiActive: true,
          onAiActiveChanged: (_) {},
        ),
      ),
    );

    expect(find.byType(ProductFormFields), findsOneWidget);
    expect(find.text('Nombre del producto *'), findsOneWidget);
    expect(find.text('Categoría *'), findsOneWidget);
    expect(find.text('Contexto para la IA'), findsOneWidget);
  });

  testWidgets('ProductFormFields forwards switch changes', (tester) async {
    final controllers = _ProductControllers();
    final onAvailableChanged = MockBoolChanged();
    addTearDown(controllers.dispose);

    await tester.pumpWidget(
      _FormHarness(
        child: ProductFormFields(
          nameController: controllers.name,
          priceController: controllers.price,
          stockController: controllers.stock,
          minStockController: controllers.minStock,
          prepTimeController: controllers.prepTime,
          descriptionController: controllers.description,
          aiContextController: controllers.aiContext,
          categories: _categories,
          selectedCategoryId: 'bread',
          onCategoryChanged: MockCategoryChanged().call,
          onAddCategory: () {},
          isAvailable: true,
          onAvailableChanged: onAvailableChanged.call,
          aiActive: true,
          onAiActiveChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(Switch).first);

    verify(() => onAvailableChanged(false)).called(1);
  });

  testWidgets('ProductSaveBar renders save action', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Stack(children: [ProductSaveBar()])),
      ),
    );

    expect(find.byType(ProductSaveBar), findsOneWidget);
    expect(find.text('Guardar producto'), findsOneWidget);
  });

  testWidgets('ProductSaveBar invokes save callback', (tester) async {
    final onSave = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(children: [ProductSaveBar(onSave: onSave.call)]),
        ),
      ),
    );

    await tester.tap(find.text('Guardar producto'));

    verify(() => onSave()).called(1);
  });
}

final _categories = [
  Category(id: 'bread', name: 'Panes', emoji: '🍞'),
  Category(id: 'drink', name: 'Bebidas', emoji: '🥤'),
];

class _FormHarness extends StatelessWidget {
  final Widget child;

  const _FormHarness({required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: SizedBox(width: 430, height: 1200, child: child)),
    );
  }
}

class _ProductControllers {
  final name = TextEditingController();
  final price = TextEditingController();
  final stock = TextEditingController();
  final minStock = TextEditingController();
  final prepTime = TextEditingController();
  final description = TextEditingController();
  final aiContext = TextEditingController();

  void dispose() {
    name.dispose();
    price.dispose();
    stock.dispose();
    minStock.dispose();
    prepTime.dispose();
    description.dispose();
    aiContext.dispose();
  }
}
