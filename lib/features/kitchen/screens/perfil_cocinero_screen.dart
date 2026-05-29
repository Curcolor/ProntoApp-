import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/providers/order_provider.dart';

/// Pantalla de perfil del cocinero con datos dinámicos.
/// Muestra el nombre real del usuario autenticado, estadísticas de pedidos
/// en tiempo real y la gráfica de barras conectada al provider.
class PerfilCocineroScreen extends StatelessWidget {
  const PerfilCocineroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthService, OrderProvider>(
      builder: (context, auth, provider, _) {
        final usuario = auth.currentUser;
        final nombre = usuario?.name ?? 'Cocinero';
        final inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : 'C';
        final pedidosHoy = provider.pedidosHoy;
        final entregadosHoy = provider.entregados.length;
        final listosHoy = provider.listos.length;
        final barData = provider.pedidosPorDia;
        final maxBar = barData.values.isEmpty
            ? 1
            : barData.values.reduce((a, b) => a > b ? a : b);
        final diaHoy =
            ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                [DateTime.now().weekday - 1];

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ── Cabecera con avatar ──────────────────────────────────────
                SizedBox(
                  height: 200,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 108,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFEF3C7),
                                  Color(0xFFFDE68A)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withAlpha((0.15 * 255).toInt()),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                inicial,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF92400E),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ── Nombre y rol ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        nombre,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F172A),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cocinero · ProntoApp',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildBadge(
                            FontAwesomeIcons.fireBurner,
                            'Cocina',
                            const Color(0xFF92400E),
                            const Color(0xFFFEF3C7),
                          ),
                          const SizedBox(width: 8),
                          _buildBadge(
                            FontAwesomeIcons.circle,
                            'En turno',
                            const Color(0xFF15803D),
                            const Color(0xFFDCFCE7),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Estadísticas dinámicas ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildStatCard(
                        '$pedidosHoy',
                        'Pedidos hoy',
                        const Color(0xFF0F172A),
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        '$listosHoy',
                        'Listos',
                        const Color(0xFF1DB954),
                      ),
                      const SizedBox(width: 8),
                      _buildStatCard(
                        '$entregadosHoy',
                        'Entregados',
                        const Color(0xFF1D4ED8),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Mi información ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MI INFORMACIÓN',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withAlpha((0.08 * 255).toInt()),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: FontAwesomeIcons.userAstronaut,
                              iconColor: const Color(0xFF15803D),
                              iconBgColor: const Color(0xFFDCFCE7),
                              label: 'Rol',
                              value: 'Cocinero',
                              showBorder: true,
                            ),
                            _buildInfoRow(
                              icon: FontAwesomeIcons.envelope,
                              iconColor: const Color(0xFF1D4ED8),
                              iconBgColor: const Color(0xFFDBEAFE),
                              label: 'Correo',
                              value: usuario?.email ?? 'Sin correo',
                              showBorder: true,
                            ),
                            _buildInfoRow(
                              icon: FontAwesomeIcons.chartBar,
                              iconColor: const Color(0xFFB45309),
                              iconBgColor: const Color(0xFFFEF3C7),
                              label: 'Total pedidos procesados',
                              value:
                                  '${provider.pedidos.where((p) => p.estado.index >= 2).length}',
                              showBorder: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Gráfica de barras: pedidos por día ───────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PEDIDOS ESTA SEMANA',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.fromLTRB(17, 14, 17, 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withAlpha((0.08 * 255).toInt()),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: barData.entries.map((entry) {
                              final alturaMax = 65.0;
                              final altura = maxBar == 0
                                  ? 8.0
                                  : (entry.value / maxBar) * alturaMax;
                              final esHoy = entry.key == diaHoy;
                              return _buildChartBar(
                                entry.key,
                                altura < 8 ? 8 : altura,
                                esHoy,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Finalizar turno ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: InkWell(
                    onTap: () async {
                      await AuthService().logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withAlpha((0.08 * 255).toInt()),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: FaIcon(
                                  FontAwesomeIcons.arrowRightFromBracket,
                                  color: Color(0xFFB91C1C),
                                  size: 14),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Finalizar turno',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFB91C1C),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const FaIcon(FontAwesomeIcons.chevronRight,
                              color: Color(0xFF94A3B8), size: 12),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Widgets auxiliares ───────────────────────────────────────────────────────

  Widget _buildBadge(FaIconData icon, String label, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.08 * 255).toInt()),
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
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required FaIconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    required bool showBorder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(
                bottom: BorderSide(color: Color(0xFFF1F5F9)))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: FaIcon(icon, color: iconColor, size: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const FaIcon(FontAwesomeIcons.chevronRight,
              color: Color(0xFF94A3B8), size: 12),
        ],
      ),
    );
  }

  Widget _buildChartBar(String day, double height, bool isToday) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 22,
          height: height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            gradient: isToday
                ? const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: GoogleFonts.inter(
            color: isToday
                ? const Color(0xFF128C7E)
                : const Color(0xFF94A3B8),
            fontSize: 9,
            fontWeight:
                isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
