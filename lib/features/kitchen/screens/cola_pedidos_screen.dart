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
        final user = context.watch<AuthService>().currentUser;
        final nombreCocinero = user?.name ?? 'Cocinero';

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header bonito (Figma)
                _buildHeader(nombreCocinero, provider),
                
                Expanded(
                  child: colaCocina.isEmpty
                      ? _buildColaVacia()
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          children: [
                            // Métricas bonitas (Figma)
                            _buildMetricsRow(provider),
                            const SizedBox(height: 32),
                            
                            // Título de sección
                            _buildSectionTitle(colaCocina.length),
                            const SizedBox(height: 16),
                            
                            // Lista de tarjetas (Versión Robusta)
                            ...colaCocina.map((pedido) => _buildOrderCardRobusto(context, pedido, provider)),
                            
                            const SizedBox(height: 80),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Widgets "Bonitos" (Header y Métricas) ────────────────────────────────

  Widget _buildHeader(String nombre, OrderProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buenos días 👋',
                style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 13),
              ),
              Text(
                nombre,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppColors.warningIcon, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                const FaIcon(FontAwesomeIcons.fireBurner, color: Color(0xFF92400E), size: 11),
                const SizedBox(width: 6),
                Text(
                  'Cocina',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF92400E),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(OrderProvider provider) {
    return Row(
      children: [
        _buildMetricCard(
          '${provider.recibidos.where((p) => p.minutosTranscurridos > 10).length}',
          '🔴 Urgentes',
          AppColors.dangerDark,
        ),
        const SizedBox(width: 8),
        _buildMetricCard('${provider.enPreparacion.length}', '🟡 En cola', AppColors.warningText),
        const SizedBox(width: 8),
        _buildMetricCard('${provider.listos.length}', '✅ Listos', AppColors.primaryDark),
      ],
    );
  }

  Widget _buildMetricCard(String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(color: valueColor, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '📋 Cola activa',
          style: GoogleFonts.inter(color: const Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(
          'Ordenar ↕',
          style: GoogleFonts.inter(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ─── Tarjeta "Robusta" (Versión que se ve bien) ──────────────────────────

  Widget _buildOrderCardRobusto(BuildContext context, OrderModel pedido, OrderProvider provider) {
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
        border: Border(
          left: BorderSide(color: color, width: 4),
          top: const BorderSide(color: AppColors.borderLight),
          right: const BorderSide(color: AppColors.borderLight),
          bottom: const BorderSide(color: AppColors.borderLight),
        ),
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
          // ID y Estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #${pedido.id}',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  estaPreparando ? 'PREPARANDO' : 'NUEVO',
                  style: GoogleFonts.inter(color: text, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Cliente: ${pedido.cliente}',
            style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
          ),
          const Divider(height: 24),
          
          // Items (Sin layouts complejos)
          ...pedido.items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              '• ${item.cantidad}x ${item.nombre}',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            ),
          )),
          
          const SizedBox(height: 16),
          
          // Footer y Botones
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

  Widget _buildColaVacia() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            '¡Sin pedidos en cola!',
            style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Los pedidos aparecerán aquí automáticamente.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
