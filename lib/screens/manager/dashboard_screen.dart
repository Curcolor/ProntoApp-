import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 21.73, right: 21.73, top: 20.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buenos días, Carlos 👋',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF64748B),
                              fontSize: 14.12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            'Mi Panadería',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0F172A),
                              fontSize: 19.56,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.33,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 43.46,
                            height: 43.46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13.04),
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.09),
                            ),
                            child: const Center(
                              child: FaIcon(FontAwesomeIcons.bell, color: Color(0xFF475569), size: 18.47),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8.69,
                              height: 8.69,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFF8FAFC), width: 2.17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // IA Activa Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.87, vertical: 4.35),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(1085.41),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.52,
                          height: 6.52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            borderRadius: BorderRadius.circular(3.26),
                          ),
                        ),
                        const SizedBox(width: 5.43),
                        Text(
                          'IA Activa · 3 pedidos entrantes',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF15803D),
                            fontSize: 11.95,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Metrics Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 21.73),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.35, // Adjust based on Figma
              children: [
                _buildMetricCard(
                  icon: FontAwesomeIcons.bagShopping,
                  iconColor: const Color(0xFF15803D),
                  iconBg: const Color(0xFFDCFCE7),
                  label: 'Pedidos hoy',
                  value: '24',
                  subText: '↑ +6 vs ayer',
                  subColor: const Color(0xFF15803D),
                ),
                _buildMetricCard(
                  icon: FontAwesomeIcons.clock,
                  iconColor: const Color(0xFF1D4ED8),
                  iconBg: const Color(0xFFDBEAFE),
                  label: 'Tiempo prom.',
                  value: '4.2 min',
                  subText: '↓ -1.3 min',
                  subColor: const Color(0xFF1D4ED8),
                ),
                _buildMetricCard(
                  icon: FontAwesomeIcons.dollarSign,
                  iconColor: const Color(0xFF6D28D9),
                  iconBg: const Color(0xFFEDE9FE),
                  label: 'Ventas del día',
                  value: '\$284K',
                  subText: '↑ +18%',
                  subColor: const Color(0xFF6D28D9),
                ),
                _buildMetricCard(
                  icon: FontAwesomeIcons.solidStar,
                  iconColor: const Color(0xFFB45309),
                  iconBg: const Color(0xFFFEF3C7),
                  label: 'Satisfacción',
                  value: '96%',
                  subText: '↑ +2%',
                  subColor: const Color(0xFFB45309),
                ),
              ],
            ),
          ),
          
          // Tabs
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21.73),
                    child: Text(
                      'Pedidos activos',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1E293B),
                        fontSize: 17.38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 21.73),
                    child: Row(
                      children: [
                        _buildTabChip('Recibidos', '5', isActive: true),
                        const SizedBox(width: 8),
                        _buildTabChip('Preparando', '8'),
                        const SizedBox(width: 8),
                        _buildTabChip('Listos', '3'),
                        const SizedBox(width: 8),
                        _buildTabChip('En camino', '4'),
                        const SizedBox(width: 8),
                        _buildTabChip('Pagados', '4'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Order Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 21.73, vertical: 8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildOrderCard(
                  avatarLetter: 'M',
                  avatarGradient: const [Color(0xFFDCFCE7), Color(0xFFA7F3D0)],
                  avatarColor: const Color(0xFF128C7E),
                  name: 'María García',
                  idText: '#P-0041 · vía WhatsApp',
                  isNew: true,
                  items: '2× Pan de bono · 1× Almojábana · 1× Café tinto',
                  price: '\$18,500',
                  timeAgo: 'Hace 2 min',
                ),
                const SizedBox(height: 12),
                _buildOrderCard(
                  avatarLetter: 'J',
                  avatarGradient: const [Color(0xFFEDE9FE), Color(0xFFDDD6FE)],
                  avatarColor: const Color(0xFF6D28D9),
                  name: 'Juan Rodríguez',
                  idText: '#P-0040 · vía WhatsApp',
                  items: '3× Croissant de jamón · 2× Jugo naranja',
                  price: '\$32,000',
                  timeAgo: 'Hace 5 min',
                ),
                 const SizedBox(height: 12),
                _buildOrderCard(
                  avatarLetter: 'S',
                  avatarGradient: const [Color(0xFFFEE9E9), Color(0xFFFED6D7)],
                  avatarColor: const Color(0xFFD9282B),
                  name: 'Sara Sierra',
                  idText: '#P-0038 · vía WhatsApp',
                  items: '1× Croissant de jamón',
                  price: '\$10,000',
                  timeAgo: 'Hace 10 min',
                ),
              ]),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    required String subText,
    required Color subColor,
  }) {
    return Container(
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
      padding: const EdgeInsets.all(17.38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.42,
            height: 30.42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8.69),
            ),
            child: Center(
              child: FaIcon(icon, color: iconColor, size: 14.12),
            ),
          ),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 11.95,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 23.90,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subText,
            style: GoogleFonts.inter(
              color: subColor,
              fontSize: 11.95,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, String count, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.30, vertical: 8.69),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF25D366) : Colors.white,
        borderRadius: BorderRadius.circular(1085.41),
        border: Border.all(
          color: isActive ? const Color(0xFF25D366) : const Color(0xFFE2E8F0),
          width: 1.09,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? Colors.white : const Color(0xFF475569),
              fontSize: 11.95,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6.52),
          Container(
            width: 19.56,
            height: 19.56,
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withAlpha(64) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(9.78),
            ),
            child: Center(
              child: Text(
                count,
                style: GoogleFonts.inter(
                  color: isActive ? Colors.white : const Color(0xFF475569),
                  fontSize: 9.78,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required String avatarLetter,
    required List<Color> avatarGradient,
    required Color avatarColor,
    required String name,
    required String idText,
    bool isNew = false,
    required String items,
    required String price,
    required String timeAgo,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.47, vertical: 16.30),
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
          // Top Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 41.29,
                height: 41.29,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.04),
                  gradient: LinearGradient(
                    colors: avatarGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    avatarLetter,
                    style: GoogleFonts.inter(
                      color: avatarColor,
                      fontSize: 17.38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.87),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F172A),
                        fontSize: 14.12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2.17),
                    Text(
                      idText,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11.95,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.87, vertical: 3.26),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(1085.41),
                ),
                child: Text(
                  'Esperando',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFB45309),
                    fontSize: 11.95,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isNew) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.87, vertical: 3.26),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(1085.41),
                  ),
                  child: Text(
                    'Nuevo',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF15803D),
                      fontSize: 11.95,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 12),
          // Items
          Text(
            items,
            style: GoogleFonts.inter(
              color: const Color(0xFF475569),
              fontSize: 11.95,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F172A),
                      fontSize: 17.38,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.clock, color: Color(0xFF94A3B8), size: 10.87),
                      const SizedBox(width: 4),
                      Text(
                        timeAgo,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11.95,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 13.04),
                  minimumSize: const Size(0, 32.60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1085.41),
                  ),
                ),
                child: Text(
                  'Aceptar →',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11.73,
                    fontWeight: FontWeight.bold,
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
