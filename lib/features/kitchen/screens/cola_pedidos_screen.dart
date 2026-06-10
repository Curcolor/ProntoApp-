import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';

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
                _buildHeader(nombreCocinero),
                Expanded(
                  child: colaCocina.isEmpty
                      ? _buildColaVacia()
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          children: [
                            _buildMetricsRow(provider),
                            const SizedBox(height: 32),

                            _buildSectionTitle(colaCocina.length),
                            const SizedBox(height: 16),

                            // Lista de tarjetas (fiel al diseño Figma 2256:3717)
                            ...colaCocina.map(
                              (pedido) => _buildOrderCard(
                                context,
                                pedido,
                                provider,
                              ),
                            ),

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

  // ─── Header y Métricas (Fiel a Figma) ──────────────────────────────────

  Widget _buildHeader(String nombre) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                ),
              ),
              Text(
                nombre,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
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
                const Icon(Icons.circle, color: AppColors.warningIcon, size: 6),
                const SizedBox(width: 6),
                const FaIcon(
                  FontAwesomeIcons.fire,
                  color: Color(0xFF92400E),
                  size: 11,
                ),
                const SizedBox(width: 6),
                Text(
                  'Cocina',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF92400E),
                    fontSize: 11,
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

  Widget _buildMetricsRow(OrderProvider provider) {
    return Row(
      children: [
        _buildMetricCard(
          '${provider.recibidos.length}',
          'Urgentes',
          AppColors.dangerDark,
        ),
        const SizedBox(width: 8),
        _buildMetricCard(
          '${provider.enPreparacion.length}',
          'En cola',
          AppColors.warningText,
        ),
        const SizedBox(width: 8),
        _buildMetricCard(
          '${provider.listos.length}',
          'Listos',
          AppColors.primaryDark,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textTertiary,
                fontSize: 9,
              ),
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
          style: GoogleFonts.inter(
            color: const Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Ordenar ↕',
          style: GoogleFonts.inter(
            color: const Color(0xFF1DB954),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─── Tarjeta de pedido (fiel al diseño Figma 2256:3717) ─────────────────
  // Variantes por estado: Nuevo (verde), ¡Urgente! (rojo, recibido >=10 min),
  // En prep. (amber con acento izquierdo).

  Widget _buildOrderCard(
    BuildContext context,
    OrderModel pedido,
    OrderProvider provider,
  ) {
    final bool enPrep = pedido.estado == EstadoPedido.enPreparacion;
    final bool urgente = !enPrep && pedido.minutosTranscurridos >= 10;

    // Paleta por estado: fondo suave (tintBg) + texto/acento (tintText).
    final Color tintBg;
    final Color tintText;
    final String badgeText;
    if (enPrep) {
      tintBg = const Color(0xFFFEF3C7);
      tintText = const Color(0xFFB45309);
      badgeText = 'En prep.';
    } else if (urgente) {
      tintBg = const Color(0xFFFEE2E2);
      tintText = const Color(0xFFDC2626);
      badgeText = '¡Urgente!';
    } else {
      tintBg = const Color(0xFFDCFCE7);
      tintText = const Color(0xFF15803D);
      badgeText = 'Nuevo';
    }

    final String idMostrar =
        pedido.id.startsWith('#') ? pedido.id : '#${pedido.id}';
    final int? numero =
        int.tryParse(pedido.id.replaceAll(RegExp(r'[^0-9]'), ''));
    final String numTile = numero != null ? '#$numero' : '#';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Borde UNIFORME (no uniforme + borderRadius = assert en paint → tarjeta en blanco).
        border: Border.all(
          color: enPrep ? const Color(0xFFF59E0B) : const Color(0xFFF1F5F9),
          width: enPrep ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 1.5,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado: número + título/canal + badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tintBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  numTile,
                  style: GoogleFonts.inter(
                    color: tintText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido $idMostrar',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F172A),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'vía WhatsApp · ${pedido.cliente}',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: tintBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    color: tintText,
                    fontSize: 11.95,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items con viñeta gris
          ...pedido.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${item.cantidad}× ${item.nombre}',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF334155),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Footer: pill de tiempo + acciones por estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: tintBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(FontAwesomeIcons.clock, color: tintText, size: 11),
                    const SizedBox(width: 5),
                    Text(
                      pedido.tiempoTranscurridoFormat,
                      style: GoogleFonts.inter(
                        color: tintText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: _accionesPorEstado(pedido, provider, enPrep),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Botones de acción según el estado del pedido (estilo Figma).
  List<Widget> _accionesPorEstado(
    OrderModel pedido,
    OrderProvider provider,
    bool enPrep,
  ) {
    if (enPrep) {
      return [
        _kitchenBtn('Marcar listo', FontAwesomeIcons.check,
            const Color(0xFF1E293B), () => provider.avanzarEstado(pedido.id)),
      ];
    }
    // Recibido (Nuevo o ¡Urgente!) → empieza preparación.
    return [
      _kitchenBtn('Empezar', FontAwesomeIcons.play, const Color(0xFF25D366),
          () => provider.avanzarEstado(pedido.id)),
    ];
  }

  Widget _kitchenBtn(
      String label, FaIconData icon, Color bg, VoidCallback onTap) {
    return SizedBox(
      height: 34,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: FaIcon(icon, size: 12, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }

  Widget _buildColaVacia() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍳', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Cola vacía',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los pedidos nuevos del bot aparecerán aquí\nlistos para preparar.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'Cola de pedidos', group: 'Kitchen', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget colaPedidosScreenPreview() => const ColaPedidosScreen();

