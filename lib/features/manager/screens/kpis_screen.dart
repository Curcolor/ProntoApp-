import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KpisScreen extends StatelessWidget {
  const KpisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 21.73, right: 21.73, top: 20.0, bottom: 16.0),
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
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.09),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPeriodBtn('Hoy', false),
                        _buildPeriodBtn('Semana', true),
                        _buildPeriodBtn('Mes', false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Hero Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21.73, vertical: 8.0),
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
                      'Tiempo promedio de respuesta',
                      style: GoogleFonts.inter(
                        color: Colors.white.withAlpha(204),
                        fontSize: 14.12,
                        fontWeight: FontWeight.normal,
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
                              '4.2',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 39.11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'min',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14.12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.87, vertical: 4.35),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(1085.41),
                          ),
                          child: Text(
                            '↓ Mejoró 77%',
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
                      'Era 18 min antes de Prontoa!',
                      style: GoogleFonts.inter(
                        color: Colors.white.withAlpha(178),
                        fontSize: 11.95,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Mini KPIs 2x2
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 21.73, vertical: 8.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.25,
              children: [
                _buildMiniKpi('📦', '148', 'Pedidos semana', '↑ +23%', const Color(0xFF15803D)),
                _buildMiniKpi('💰', '\$1.9M', 'Ingresos semana', '↑ +18%', const Color(0xFF15803D)),
                _buildMiniKpi('⭐', '96%', 'Satisfacción', '↑ +2%', const Color(0xFF15803D)),
                _buildMiniKpi('🚫', '3.2%', 'Cancelaciones', '↑ +0.5%', const Color(0xFFB91C1C)),
              ],
            ),
          ),
          
          // Bar Chart Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21.73, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(18.47),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21.73),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.09),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.08 * 255).toInt()),
                      blurRadius: 3.26,
                      offset: const Offset(0, 1.09),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedidos por día',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1E293B),
                        fontSize: 16.30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 108.65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBar('Lun', 59.76, true),
                          _buildBar('Mar', 76.06, true),
                          _buildBar('Mié', 48.89, true),
                          _buildBar('Jue', 95.61, true),
                          _buildBar('Vie', 103.22, true),
                          _buildBar('Sáb', 108.65, true),
                          _buildBar('Dom', 32.60, false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Donut Chart Placeholder
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21.73, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(18.47),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(21.73),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.09),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.08 * 255).toInt()),
                      blurRadius: 3.26,
                      offset: const Offset(0, 1.09),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Fake Donut Chart
                    Container(
                      width: 97.78,
                      height: 97.78,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF25D366), width: 15), // Placeholder visual
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('148', style: GoogleFonts.inter(fontSize: 17.38, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                            Text('pedidos', style: GoogleFonts.inter(fontSize: 8.69, color: const Color(0xFF64748B))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Legend
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(const Color(0xFF25D366), 'Domicilio', '52%'),
                          const SizedBox(height: 8.69),
                          _buildLegendItem(const Color(0xFF3B82F6), 'Para recoger', '23%'),
                          const SizedBox(height: 8.69),
                          _buildLegendItem(const Color(0xFFF59E0B), 'Mesa', '15%'),
                          const SizedBox(height: 8.69),
                          _buildLegendItem(const Color(0xFFCBD5E1), 'Otros', '10%'),
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
  }

  Widget _buildPeriodBtn(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13.04, vertical: 5.43),
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
    );
  }

  Widget _buildMiniKpi(String emoji, String value, String label, String trend, Color trendColor) {
    return Container(
      padding: const EdgeInsets.all(15.21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.38),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.09),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
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
              fontSize: 23.90,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 11.95,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            trend,
            style: GoogleFonts.inter(
              color: trendColor,
              fontSize: 11.95,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double height, bool isGreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32, // Adjusted for screen fit
          height: height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(6.52), topRight: Radius.circular(6.52)),
            gradient: isGreen 
                ? const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                : null,
            color: isGreen ? null : const Color(0xFFE2E8F0),
          ),
        ),
        const SizedBox(height: 4.35),
        Text(
          day,
          style: GoogleFonts.inter(
            color: const Color(0xFF94A3B8),
            fontSize: 9.78,
            fontWeight: FontWeight.w500,
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
              color: const Color(0xFF475569),
              fontSize: 11.95,
            ),
          ),
        ),
        Text(
          pct,
          style: GoogleFonts.inter(
            color: const Color(0xFF1E293B),
            fontSize: 11.95,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
