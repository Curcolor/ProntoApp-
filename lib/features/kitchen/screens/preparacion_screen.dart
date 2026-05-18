import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/ui/components/kitchen/preparacion_components.dart';

class PreparacionScreen extends StatelessWidget {
  const PreparacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final enPreparacion = provider.enPreparacion;

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: enPreparacion.isEmpty
              ? const PreparacionEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: enPreparacion.length,
                  itemBuilder: (context, index) {
                    return PedidoPreparacionCard(
                      pedido: enPreparacion[index],
                      onMarkReady: (id) async {
                        await provider.avanzarEstado(id);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
