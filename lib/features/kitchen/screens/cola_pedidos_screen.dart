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
        // Cocina ve: recibidos + en preparación
        final colaCocina = [...provider.recibidos, ...provider.enPreparacion];
        final nombreCocinero =
            context.watch<AuthService>().currentUser?.name ?? 'Cocinero';

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: _buildAppBar(nombreCocinero, provider),
          body: colaCocina.isEmpty
              ? _buildColaVacia()
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Métricas del turno
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildShiftMetric(
                            '${provider.recibidos.length}',
                            '🔴 Urgentes',
                            AppColors.dangerDark,
                          ),
                          _buildShiftMetric(
                            '${provider.enPreparacion.length}',
                            '🟡 En cola',
                            AppColors.warningText,
                          ),
                          _buildShiftMetric(
                            '${provider.listos.length}',
                            '✅ Listos',
                            AppColors.primaryDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tabs urgencia
                      Row(
                        children: [
                          _buildUrgencyTab(
                            '${provider.recibidos.length}',
                            'Urgente',
                            const Color(0xFFFEF2F2),
                            AppColors.dangerIcon,
                            AppColors.dangerDark,
                          ),
                          const SizedBox(width: 8),
                          _buildUrgencyTab(
                            '${provider.enPreparacion.length}',
                            'Preparando',
                            const Color(0xFFFFFBEB),
                            AppColors.warningIcon,
                            AppColors.warningDark,
                          ),
                          const SizedBox(width: 8),
                          _buildUrgencyTab(
                            '${provider.listos.length}',
                            'Listos',
                            const Color(0xFFF0FDF4),
                            AppColors.primary,
                            AppColors.primaryDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Título sección
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '📋 Cola activa',
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${colaCocina.length} pedido${colaCocina.length != 1 ? 's' : ''}',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Lista de pedidos
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: colaCocina.length,
                        itemBuilder: (context, index) {
                          final pedido = colaCocina[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildOrderCard(context, pedido, provider),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(
      String nombreCocinero, OrderProvider provider) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
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
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                nombreCocinero.split(' ').first,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: provider.estaConectado
                        ? AppColors.warningIcon
                        : AppColors.dangerIcon,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                FaIcon(
                  FontAwesomeIcons.fireBurner,
                  color: AppColors.warningDarker,
                  size: 11,
                ),
                const SizedBox(width: 6),
                Text(
                  'Cocina',
                  style: GoogleFonts.inter(
                    color: AppColors.warningDarker,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  // ─── Estado vacío ─────────────────────────────────────────────────────────

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
            'Los pedidos del bot de Telegram\naparecerán aquí automáticamente.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: AppColors.textTertiary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ─── Widgets auxiliares ────────────────────────────────────────────────────

  Widget _buildShiftMetric(
      String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 3,
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

  Widget _buildUrgencyTab(String value, String label, Color bgColor,
      Color borderColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
      BuildContext context, OrderModel pedido, OrderProvider provider) {
    final esUrgente = pedido.minutosTranscurridos > 10;
    final estaPreparando = pedido.estado == EstadoPedido.enPreparacion;

    final borderColor = esUrgente
        ? AppColors.dangerIcon
        : estaPreparando
            ? AppColors.warningIcon
            : AppColors.primary;

    final statusLabel = esUrgente
        ? '¡Urgente!'
        : estaPreparando
            ? 'Preparando'
            : 'Nuevo';

    final statusBg = esUrgente
        ? AppColors.dangerBg
        : estaPreparando
            ? AppColors.warningBg
            : AppColors.successBg;

    final statusText = esUrgente
        ? AppColors.dangerText
        : estaPreparando
            ? AppColors.warningText
            : AppColors.successText;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 17, 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
          top: const BorderSide(color: AppColors.borderLight, width: 1),
          right: const BorderSide(color: AppColors.borderLight, width: 1),
          bottom: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                        pedido.inicialCliente,
                        style: GoogleFonts.inter(
                            color: statusText,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pedido.id,
                        style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pedido.cliente,
                        style: GoogleFonts.inter(
                            color: AppColors.textMuted,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                      color: statusText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Ítems
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pedido.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${item.cantidad}× ${item.nombre}',
                        style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Acciones + timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: esUrgente ? AppColors.dangerBg : AppColors.successBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.clock,
                      color: esUrgente
                          ? AppColors.dangerDark
                          : AppColors.primaryDark,
                      size: 9,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${pedido.minutosTranscurridos} min',
                      style: GoogleFonts.inter(
                        color: esUrgente
                            ? AppColors.dangerDark
                            : AppColors.primaryDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Botón de avance
              if (pedido.estado.siguiente != null)
                GestureDetector(
                  onTap: () => provider.avanzarEstado(pedido.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: estaPreparando
                          ? AppColors.primaryDark
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          estaPreparando
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.fire,
                          color: AppColors.surface,
                          size: 10,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          estaPreparando ? 'Marcar listo' : 'Empezar',
                          style: GoogleFonts.inter(
                              color: AppColors.surface,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
