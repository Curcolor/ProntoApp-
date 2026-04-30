import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/models/order_model.dart';
import '../data/providers/order_provider.dart';

class KpisScreen extends StatefulWidget {
  const KpisScreen({super.key});

  @override
  State<KpisScreen> createState() => _KpisScreenState();
}

class _KpisScreenState extends State<KpisScreen> {
  int _periodoIndex = 1; // 0=Hoy, 1=Semana, 2=Mes

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final pedidos7Dias = provider.pedidosUltimos7Dias;
        final ventas7Dias = provider.ventasUltimos7Dias;
        final barData = provider.pedidosPorDia;
        final maxBar =
            barData.values.isEmpty ? 1 : barData.values.reduce((a, b) => a > b ? a : b);
        final ratioTipos = provider.ratioTipos;

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 21.73, right: 21.73, top: 20.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Analíticas',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F172A),
                          fontSize: 23.90,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.33,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4.35),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17.38),
                          border: Border.all(
                              color: const Color(0xFFE2E8F0), width: 1.09),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildPeriodBtn('Hoy', 0),
                            _buildPeriodBtn('Semana', 1),
                            _buildPeriodBtn('Mes', 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Tarjeta hero: pedidos activos ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 21.73, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(17.38),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21.73),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedidos activos ahora',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14.12,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${provider.activos.length}',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 39.11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'pedidos',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14.12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.87, vertical: 4.35),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(1085.41),
                              ),
                              child: Text(
                                '${provider.pedidosHoy} hoy',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 11.95,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${provider.recibidos.length} esperando · '
                          '${provider.enPreparacion.length} preparando · '
                          '${provider.listos.length} listos',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11.95,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Mini KPIs 2×2 ────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 21.73, vertical: 8.0),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.25,
                  children: [
                    _buildMiniKpi(
                      '📦',
                      '$pedidos7Dias',
                      'Pedidos semana',
                      pedidos7Dias > 0 ? '↑ activos' : 'Sin datos aún',
                      pedidos7Dias > 0
                          ? const Color(0xFF15803D)
                          : const Color(0xFF94A3B8),
                    ),
                    _buildMiniKpi(
                      '💰',
                      _formatearPesos(ventas7Dias),
                      'Ingresos semana',
                      ventas7Dias > 0 ? 'De pedidos entregados' : 'Sin datos aún',
                      ventas7Dias > 0
                          ? const Color(0xFF15803D)
                          : const Color(0xFF94A3B8),
                    ),
                    _buildMiniKpi(
                      '🚚',
                      '${provider.enCamino.length + provider.entregados.length}',
                      'Total domicilios',
                      '${provider.enCamino.length} en ruta',
                      const Color(0xFF1D4ED8),
                    ),
                    _buildMiniKpi(
                      '✅',
                      '${provider.entregados.length}',
                      'Entregados',
                      provider.entregados.isNotEmpty
                          ? 'Completados'
                          : 'Sin entregas aún',
                      provider.entregados.isNotEmpty
                          ? const Color(0xFF15803D)
                          : const Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),

              // ── Gráfica de barras ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 21.73, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(18.47),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21.73),
                      border: Border.all(
                          color: const Color(0xFFF1F5F9), width: 1.09),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 3.26,
                          offset: const Offset(0, 1.09),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedidos por día (última semana)',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1E293B),
                            fontSize: 16.30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 140.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: barData.entries.map((entry) {
                              final alturaMax = 108.65;
                              final altura = maxBar == 0
                                  ? 8.0
                                  : (entry.value / maxBar) * alturaMax;
                              final esHoy = entry.key ==
                                  ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                                      [DateTime.now().weekday - 1];
                              return _buildBar(entry.key,
                                  altura < 8 ? 8 : altura, esHoy);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Donut de tipos ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 21.73, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(18.47),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21.73),
                      border: Border.all(
                          color: const Color(0xFFF1F5F9), width: 1.09),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 3.26,
                          offset: const Offset(0, 1.09),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 97.78,
                          height: 97.78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF25D366), width: 15),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${provider.pedidos.length}',
                                  style: GoogleFonts.inter(
                                    fontSize: 17.38,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  'pedidos',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.69,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegendItem(
                                const Color(0xFF25D366),
                                'Domicilio',
                                '${ratioTipos[TipoPedido.domicilio]?.toStringAsFixed(0) ?? 0}%',
                              ),
                              const SizedBox(height: 8.69),
                              _buildLegendItem(
                                const Color(0xFF3B82F6),
                                'Para recoger',
                                '${ratioTipos[TipoPedido.recoger]?.toStringAsFixed(0) ?? 0}%',
                              ),
                              const SizedBox(height: 8.69),
                              if (provider.pedidos.isEmpty)
                                Text(
                                  'Sin pedidos aún.\nLos datos aparecen cuando\nllegan pedidos del bot.',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        );
      },
    );
  }

  // ─── Widgets auxiliares ────────────────────────────────────────────────────

  Widget _buildPeriodBtn(String label, int index) {
    final isActive = _periodoIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _periodoIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 13.04, vertical: 5.43),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF25D366) : Colors.transparent,
          borderRadius: BorderRadius.circular(13.04),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isActive ? Colors.white : const Color(0xFF64748B),
            fontSize: 11.73,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniKpi(
      String emoji, String value, String label, String trend, Color trendColor) {
    return Container(
      padding: const EdgeInsets.all(15.21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.38),
        border: Border.all(
            color: const Color(0xFFF1F5F9), width: 1.09),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3.26,
            offset: const Offset(0, 1.09),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 21.73)),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
                color: const Color(0xFF64748B), fontSize: 11.95),
          ),
          const SizedBox(height: 6),
          Text(
            trend,
            style: GoogleFonts.inter(
                color: trendColor,
                fontSize: 11.95,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double height, bool isToday) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6.52),
              topRight: Radius.circular(6.52),
            ),
            gradient: isToday
                ? const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: isToday ? null : const Color(0xFFE2E8F0),
          ),
        ),
        const SizedBox(height: 4.35),
        Text(
          day,
          style: GoogleFonts.inter(
            color: isToday
                ? const Color(0xFF25D366)
                : const Color(0xFF94A3B8),
            fontSize: 9.78,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String name, String pct) {
    return Row(
      children: [
        Container(
          width: 10.87,
          height: 10.87,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.26),
          ),
        ),
        const SizedBox(width: 8.69),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.inter(
                color: const Color(0xFF475569), fontSize: 11.95),
          ),
        ),
        Text(
          pct,
          style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 11.95,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatearPesos(double valor) {
    if (valor == 0) return '\$0';
    if (valor >= 1000000) {
      return '\$${(valor / 1000000).toStringAsFixed(1)}M';
    }
    if (valor >= 1000) return '\$${(valor / 1000).toStringAsFixed(0)}K';
    return '\$${valor.toStringAsFixed(0)}';
  }
}
