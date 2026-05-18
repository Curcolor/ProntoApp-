import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/ui/components/delivery/detalle_entrega_components.dart';

class MockVoidCallback extends Mock {
  void call();
}

void main() {
  testWidgets('DeliveryDetailHeader renders order identity', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: DeliveryDetailHeader(pedido: _order())),
    );

    expect(find.byType(DeliveryDetailHeader), findsOneWidget);
    expect(find.text('Pedido #P-100'), findsOneWidget);
    expect(find.text('Recoge en: Central de Cocina'), findsOneWidget);
  });

  testWidgets('DeliveryDetailHeader invokes back callback', (tester) async {
    final onBack = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(
        home: DeliveryDetailHeader(pedido: _order(), onBack: onBack.call),
      ),
    );

    await tester.tap(find.byType(GestureDetector).first);

    verify(() => onBack()).called(1);
  });

  testWidgets('DeliveryDetailContent renders client and items', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DeliveryDetailContent(pedido: _order())),
      ),
    );

    expect(find.byType(DeliveryDetailContent), findsOneWidget);
    expect(find.text('Ana Cliente'), findsOneWidget);
    expect(find.text('Croissant'), findsOneWidget);
    expect(find.text('Contenido del pedido'), findsOneWidget);
  });

  testWidgets('DeliveryDetailContent hides note without address', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeliveryDetailContent(pedido: _order(address: null)),
        ),
      ),
    );

    expect(find.text('Recoger en tienda'), findsOneWidget);
    expect(find.text('Instrucciones de entrega'), findsNothing);
  });

  testWidgets('DeliveryActionBar renders delivery label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(children: [DeliveryActionBar(pedido: _order())]),
        ),
      ),
    );

    expect(find.byType(DeliveryActionBar), findsOneWidget);
    expect(find.text('Salir a entregar'), findsOneWidget);
  });

  testWidgets('DeliveryActionBar invokes start callback', (tester) async {
    final onStart = MockVoidCallback();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              DeliveryActionBar(
                pedido: _order(estado: EstadoPedido.enCamino),
                onStartDelivery: onStart.call,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ver mapa de entrega'));

    verify(() => onStart()).called(1);
  });
}

OrderModel _order({
  EstadoPedido estado = EstadoPedido.listo,
  String? address = 'Calle 12',
}) {
  return OrderModel(
    id: 'P-100',
    cliente: 'Ana Cliente',
    telefono: '3001234567',
    items: const [
      ItemPedido(nombre: 'Croissant', cantidad: 2, precio: 8000),
      ItemPedido(nombre: 'Café', cantidad: 1, precio: 5000),
    ],
    total: 21000,
    estado: estado,
    tipo: address == null ? TipoPedido.recoger : TipoPedido.domicilio,
    direccion: address,
    creadoEn: DateTime.now().subtract(const Duration(minutes: 12)),
  );
}
