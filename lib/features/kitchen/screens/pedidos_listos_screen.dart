import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';

/// Pantalla "Listos" de la vista cocina.
/// Muestra pedidos en estado [listo] y el historial de [entregados] del día.
class PedidosListosScreen extends StatelessWidget {
  const PedidosListosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final listos = provider.listos;
        final entregados = provider.entregados;
        final totalPreparadosHoy = listos.length + entregados.length;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8FAFC),
            elevation: 0,
            title: Text(
              'Listos para delivery',
              style: GoogleFonts.inter(
                color: const Color(0xFF0F172A),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Banner resumen dinámico ──────────────────────────────────
                _buildBannerResumen(
                  totalPreparadosHoy,
                  listos.length,
                  provider,
                ),

                const SizedBox(height: 24),

                // ── Sección: esperando repartidor ────────────────────────────
                if (listos.isNotEmpty) ...[
                  _buildSectionHeader(
                    'Esperando repartidor',
                    '${listos.length} en espera',
                    const Color(0xFFFEF3C7),
                    const Color(0xFFB45309),
                  ),
                  const SizedBox(height: 14),
                  ...listos.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildListoCard(p, provider, context),
                    ),
                  ),
                ] else ...[
                  _buildSeccionVacia(
                    '🛵',
                    'Sin pedidos esperando',
                    'Cuando el cocinero marque un pedido como listo aparecerá aquí.',
                  ),
                ],

                const SizedBox(height: 24),

                // ── Sección: completados hoy ─────────────────────────────────
                _buildSectionHeader(
                  'Completados hoy',
                  '${entregados.length} total',
                  const Color(0xFFDCFCE7),
                  const Color(0xFF15803D),
                ),
                const SizedBox(height: 14),

                if (entregados.isEmpty)
                  _buildSeccionVacia(
                    '✅',
                    'Sin entregas aún',
                    'Los pedidos entregados se mostrarán aquí al final del día.',
                  )
                else
                  ...entregados.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildEntregadoCard(p),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Banner superior con conteo real ─────────────────────────────────────────

  Widget _buildBannerResumen(int total, int enEspera, OrderProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF25D366), Color(0xFF075E54)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mi turno de hoy',
            style: GoogleFonts.inter(
              color: Colors.white.withAlpha((0.8 * 255).toInt()),
              fontSize: 13,
            ),
          ),
          Text(
            '$total',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'pedido${total != 1 ? 's' : ''} preparado${total != 1 ? 's' : ''} hoy',
            style: GoogleFonts.inter(
              color: Colors.white.withAlpha((0.7 * 255).toInt()),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 59,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.12 * 255).toInt()),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildStat('${provider.pedidosHoy}', 'Hoy'),
                _buildStatDivider(),
                _buildStat('$enEspera', 'En espera'),
                _buildStatDivider(),
                _buildStat('${provider.entregados.length}', 'Entregados'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String lbl) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            val,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            lbl,
            style: GoogleFonts.inter(
              color: Colors.white.withAlpha((0.7 * 255).toInt()),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: double.infinity,
      color: Colors.white.withAlpha((0.15 * 255).toInt()),
    );
  }

  // ── Encabezados de sección ───────────────────────────────────────────────────

  Widget _buildSectionHeader(
    String titulo,
    String badge,
    Color badgeBg,
    Color badgeText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            badge,
            style: GoogleFonts.inter(
              color: badgeText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ── Tarjeta de pedido listo esperando repartidor ──────────────────────────

  Widget _buildListoCard(
    OrderModel pedido,
    OrderProvider provider,
    BuildContext context,
  ) {
    final minutos = pedido.minutosTranscurridos;
    final urgente = minutos > 15;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: urgente ? const Color(0xFFF59E0B) : const Color(0xFF25D366),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${pedido.id} · ${pedido.cliente}',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: urgente
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      urgente ? FontAwesomeIcons.clock : FontAwesomeIcons.check,
                      color: urgente
                          ? const Color(0xFFB45309)
                          : const Color(0xFF15803D),
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      urgente
                          ? '${pedido.tiempoTranscurridoFormat} esperando'
                          : 'Listo',
                      style: GoogleFonts.inter(
                        color: urgente
                            ? const Color(0xFFB45309)
                            : const Color(0xFF15803D),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            pedido.resumenItems,
            style: GoogleFonts.inter(
              color: const Color(0xFF475569),
              fontSize: 11,
            ),
          ),
          if (pedido.tipo == TipoPedido.domicilio &&
              pedido.direccion != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.locationDot,
                  color: Color(0xFF25D366),
                  size: 10,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    pedido.direccion!,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          // Botón para avanzar a "En camino"
          GestureDetector(
            onTap: () async {
              await provider.avanzarEstado(pedido.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🛵 ${pedido.id} marcado como En camino'),
                    backgroundColor: const Color(0xFF128C7E),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.motorcycle,
                    color: Colors.white,
                    size: 13,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pasar a En camino',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tarjeta de pedido entregado ──────────────────────────────────────────────

  Widget _buildEntregadoCard(OrderModel pedido) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 13, 17, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.check,
                color: Color(0xFF128C7E),
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pedido.id} · ${pedido.cliente}',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  pedido.resumenItems,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '\$${pedido.total.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              color: const Color(0xFF128C7E),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ── Estado vacío de sección ──────────────────────────────────────────────────

  Widget _buildSeccionVacia(String emoji, String titulo, String subtitulo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'Pedidos listos', group: 'Kitchen', wrapper: previewWrapper, theme: previewTheme)
Widget pedidosListosScreenPreview() => const PedidosListosScreen();

