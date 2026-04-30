import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/features/manager/data/models/order_model.dart';
import 'package:prontoapp/features/manager/data/providers/order_provider.dart';

class ColaPedidosScreen extends StatelessWidget {
  const ColaPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final colaCocina = [...provider.recibidos, ...provider.enPreparacion];
        final nombreCocinero =
            context.watch<AuthService>().currentUser?.name ?? 'Cocinero';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(nombreCocinero, provider),
          body: colaCocina.isEmpty
              ? _buildColaVacia()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Métricas simplificadas
                      Row(
                        children: [
                          _buildShiftMetric(
                            '${provider.recibidos.length}',
                            'Urgentes',
                            AppColors.dangerDark,
                          ),
                          _buildShiftMetric(
                            '${provider.enPreparacion.length}',
                            'En cola',
                            AppColors.warningText,
                          ),
                          _buildShiftMetric(
                            '${provider.listos.length}',
                            'Listos',
                            AppColors.primaryDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Text(
                        '📋 Cola activa (${colaCocina.length})',
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Lista de tarjetas
                      ...colaCocina.map((pedido) => _buildOrderCard(context, pedido, provider)),
                      
                      // Espacio extra al final para scroll
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(String nombreCocinero, OrderProvider provider) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hola, ${nombreCocinero.split(' ').first}',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.fire, color: Color(0xFF92400E), size: 12),
                const SizedBox(width: 6),
                Text(
                  'COCINA',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF92400E),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColaVacia() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(
            '¡Todo al día!',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel pedido, OrderProvider provider) {
    final estaPreparando = pedido.estado == EstadoPedido.enPreparacion;
    final color = estaPreparando ? AppColors.warningIcon : AppColors.primary;
    final bg = estaPreparando ? AppColors.warningBg : AppColors.successBg;
    final text = estaPreparando ? AppColors.warningText : AppColors.successText;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ID y Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pedido.id,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  estaPreparando ? 'PREPARANDO' : 'NUEVO',
                  style: GoogleFonts.inter(
                    color: text,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            pedido.cliente,
            style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
          ),
          const Divider(height: 24),
          
          // Items
          ...pedido.items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              '• ${item.cantidad}x ${item.nombre}',
              style: GoogleFonts.inter(
                fontSize: 13, 
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
          
          const SizedBox(height: 16),
          
          // Acciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hace ${pedido.minutosTranscurridos} min',
                style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 11),
              ),
              ElevatedButton.icon(
                onPressed: () => provider.avanzarEstado(pedido.id),
                icon: FaIcon(estaPreparando ? FontAwesomeIcons.check : FontAwesomeIcons.play, size: 12),
                label: Text(estaPreparando ? 'LISTO' : 'EMPEZAR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShiftMetric(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(color: color, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
