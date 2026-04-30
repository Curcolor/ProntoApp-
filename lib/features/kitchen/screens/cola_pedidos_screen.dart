import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/features/manager/data/models/order_model.dart';
import 'package:prontoapp/features/manager/data/providers/order_provider.dart';

/// Pantalla principal de cocina que sigue fielmente el diseño de Figma.
/// Muestra métricas del turno y una cola de pedidos con estados visuales claros.
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
                _buildHeader(nombreCocinero, provider),
                Expanded(
                  child: colaCocina.isEmpty
                      ? _buildColaVacia()
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          children: [
                            _buildMetricsRow(provider),
                            const SizedBox(height: 32),
                            _buildSectionTitle(colaCocina.length),
                            const SizedBox(height: 16),
                            ...colaCocina.map((pedido) => _buildOrderCard(context, pedido, provider)),
                            const SizedBox(height: 40),
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

  // ─── Header de la pantalla ──────────────────────────────────────────────────

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
                style: GoogleFonts.inter(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
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
                  decoration: const BoxDecoration(
                    color: AppColors.warningIcon,
                    shape: BoxShape.circle,
                  ),
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

  // ─── Fila de Métricas ───────────────────────────────────────────────────────

  Widget _buildMetricsRow(OrderProvider provider) {
    return Row(
      children: [
        _buildMetricCard(
          '${provider.recibidos.where((p) => p.minutosTranscurridos > 10).length}',
          '🔴 Urgentes',
          AppColors.dangerDark,
        ),
        const SizedBox(width: 8),
        _buildMetricCard(
          '${provider.enPreparacion.length}',
          '🟡 En cola',
          AppColors.warningText,
        ),
        const SizedBox(width: 8),
        _buildMetricCard(
          '${provider.listos.length}',
          '✅ Listos',
          AppColors.primaryDark,
        ),
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
              style: GoogleFonts.inter(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textTertiary,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Título de la Sección ──────────────────────────────────────────────────

  Widget _buildSectionTitle(int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '📋 Cola activa',
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Ordenar ↕',
          style: GoogleFonts.inter(
            color: AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─── Tarjeta de Pedido (Fiel a Figma) ──────────────────────────────────────

  Widget _buildOrderCard(BuildContext context, OrderModel pedido, OrderProvider provider) {
    final esUrgente = pedido.minutosTranscurridos > 10;
    final estaPreparando = pedido.estado == EstadoPedido.enPreparacion;

    Color statusColor = AppColors.primary;
    Color statusBg = AppColors.successBg;
    Color statusText = AppColors.successText;
    String statusLabel = 'Nuevo';
    String avatarNum = '#${pedido.id.split('-').last.substring(0, 2)}'; // Simulación de número de orden

    if (esUrgente) {
      statusColor = AppColors.dangerDark;
      statusBg = AppColors.dangerBg;
      statusText = AppColors.dangerText;
      statusLabel = '¡Urgente!';
    } else if (estaPreparando) {
      statusColor = AppColors.warningIcon;
      statusBg = AppColors.warningBg;
      statusText = AppColors.warningText;
      statusLabel = 'En prep.';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: statusColor, width: 4),
          top: const BorderSide(color: AppColors.borderLight),
          right: const BorderSide(color: AppColors.borderLight),
          bottom: const BorderSide(color: AppColors.borderLight),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, ID y Badge
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      avatarNum,
                      style: GoogleFonts.inter(
                        color: statusText,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido #${pedido.id}',
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'vía Telegram · ${pedido.cliente}',
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusLabel,
                    style: GoogleFonts.inter(
                      color: statusText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Lista de Ítems
            ...pedido.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item.cantidad}× ${item.nombre}',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF334155),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 16),

            // Footer: Timer y Acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.clock, color: statusText, size: 11),
                      const SizedBox(width: 5),
                      Text(
                        '${pedido.minutosTranscurridos} min',
                        style: GoogleFonts.inter(
                          color: statusText,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (!estaPreparando)
                      GestureDetector(
                        onTap: () => provider.avanzarEstado(pedido.id),
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: esUrgente ? AppColors.warningIcon : AppColors.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                esUrgente ? FontAwesomeIcons.fire : FontAwesomeIcons.play,
                                color: Colors.white,
                                size: 11,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                esUrgente ? 'Preparando' : 'Empezar',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (estaPreparando || esUrgente) ...[
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => provider.avanzarEstado(pedido.id),
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.check, color: Colors.white, size: 11),
                              const SizedBox(width: 6),
                              Text(
                                estaPreparando ? 'Marcar listo' : 'Listo',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
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
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
