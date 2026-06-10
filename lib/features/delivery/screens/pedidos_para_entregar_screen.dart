import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'detalle_entrega_screen.dart';
import 'en_ruta_screen.dart';

class PedidosParaEntregarScreen extends StatelessWidget {
  const PedidosParaEntregarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final listos = provider.listos;
        final enRuta = provider.enCamino;
        final nombreRepartidor =
            context.watch<AuthService>().currentUser?.name ?? 'Repartidor';

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(nombreRepartidor, provider),
                Expanded(
                  child: (listos.isEmpty && enRuta.isEmpty)
                      ? _buildEstadoVacio()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildMetricsRow(provider),
                              const SizedBox(height: 24),

                              if (enRuta.isNotEmpty) ...[
                                _buildSectionTitle(
                                  'PEDIDOS EN RUTA',
                                  enRuta.length,
                                  const Color(0xFF1D4ED8),
                                ),
                                const SizedBox(height: 16),
                                ...enRuta.map(
                                  (pedido) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _buildOrderCard(
                                      context,
                                      pedido,
                                      provider,
                                      true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],

                              if (listos.isNotEmpty) ...[
                                _buildSectionTitle(
                                  'PARA RECOLECTAR',
                                  listos.length,
                                  const Color(0xFF128C7E),
                                ),
                                const SizedBox(height: 16),
                                ...listos.map(
                                  (pedido) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _buildOrderCard(
                                      context,
                                      pedido,
                                      provider,
                                      false,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(String nombreRepartidor, OrderProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 16.0,
        bottom: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buenos días 👋',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                nombreRepartidor.split(' ').first,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: provider.estaConectado
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                const FaIcon(
                  FontAwesomeIcons.motorcycle,
                  size: 11,
                  color: Color(0xFF1D4ED8),
                ),
                const SizedBox(width: 4),
                Text(
                  'Delivery',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D4ED8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Métricas ─────────────────────────────────────────────────────────────

  Widget _buildMetricsRow(OrderProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricCard(
          '${provider.listos.length}',
          'Listos',
          const Color(0xFF128C7E),
        ),
        _buildMetricCard(
          '${provider.enCamino.length}',
          'En ruta',
          const Color(0xFF1D4ED8),
        ),
        _buildMetricCard(
          '${provider.entregados.length}',
          'Entregados',
          const Color(0xFF0F172A),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Sección ──────────────────────────────────────────────────────────────

  Widget _buildSectionTitle(String title, int count, Color color) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Tarjeta de Pedido ────────────────────────────────────────────────────

  Widget _buildOrderCard(
    BuildContext context,
    OrderModel pedido,
    OrderProvider provider,
    bool yaEnRuta,
  ) {
    final Color accent =
        yaEnRuta ? const Color(0xFF1D4ED8) : const Color(0xFF15803D);
    final Color badgeBg =
        yaEnRuta ? const Color(0xFFDBEAFE) : const Color(0xFFDCFCE7);
    final List<Color> avGrad = yaEnRuta
        ? [const Color(0xFFDBEAFE), const Color(0xFFBFDBFE)]
        : [const Color(0xFFDCFCE7), const Color(0xFFBBF7D0)];

    void abrir() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => yaEnRuta
              ? EnRutaScreen(pedido: pedido)
              : DetalleEntregaScreen(pedido: pedido),
        ),
      );
    }

    return GestureDetector(
      onTap: abrir,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera: id + cliente·canal | badge | avatar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido del día #${provider.numeroDelDia(pedido)}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${pedido.cliente} · vía WhatsApp',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    yaEnRuta ? 'En ruta' : 'Listo',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: accent,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: avGrad,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pedido.inicialCliente,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Caja de dirección
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FaIcon(FontAwesomeIcons.locationDot,
                      color: accent, size: 12),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pedido.direccion ?? 'Recoger en tienda',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Items
            Text(
              pedido.resumenItems,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 12),
            // Footer: monto + acciones (distancia/ruta real = Ciclo 14)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${pedido.total.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: abrir,
                        icon: FaIcon(
                          yaEnRuta
                              ? FontAwesomeIcons.route
                              : FontAwesomeIcons.motorcycle,
                          size: 12,
                          color: Colors.white,
                        ),
                        label: Text(
                          yaEnRuta ? 'Ver ruta' : 'Tomar',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // WhatsApp — solo visual (contactar al cliente = ciclo futuro)
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: const FaIcon(FontAwesomeIcons.whatsapp,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Estado Vacío ─────────────────────────────────────────────────────────

  Widget _buildEstadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.checkDouble,
                size: 30,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '¡Todo entregado!',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No hay pedidos pendientes de entrega.',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

@Preview(name: 'Pedidos para entregar', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget pedidosParaEntregarScreenPreview() => const PedidosParaEntregarScreen();

