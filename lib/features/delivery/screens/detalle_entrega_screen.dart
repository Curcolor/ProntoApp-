import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/ui/components/delivery/detalle_entrega_components.dart';

import 'en_ruta_screen.dart';

class DetalleEntregaScreen extends StatelessWidget {
  final OrderModel pedido;

  const DetalleEntregaScreen({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                DeliveryDetailHeader(
                  pedido: pedido,
                  onBack: () => Navigator.pop(context),
                ),
                Expanded(child: DeliveryDetailContent(pedido: pedido)),
              ],
            ),
            DeliveryActionBar(
              pedido: pedido,
              onStartDelivery: () => _startDelivery(context),
            ),
          ],
        ),
      ),
    );
  }

  void _startDelivery(BuildContext context) {
    if (pedido.estado == EstadoPedido.listo) {
      context.read<OrderProvider>().avanzarEstado(pedido.id);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EnRutaScreen(pedido: pedido)),
    );
  }
}
