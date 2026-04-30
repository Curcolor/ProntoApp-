import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/core/constants/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'label': 'Recibidos', 'count': '5'},
    {'label': 'Preparando', 'count': '8'},
    {'label': 'Listos', 'count': '3'},
    {'label': 'En camino', 'count': '4'},
    {'label': 'Pagados', 'count': '4'},
  ];

  final List<Map<String, dynamic>> _activeOrders = [
    {
      'avatarLetter': 'M',
      'avatarGradient': [AppColors.successBg, const Color(0xFFA7F3D0)],
      'avatarColor': AppColors.primaryDark,
      'name': 'María García',
      'idText': '#P-0041 · vía WhatsApp',
      'isNew': true,
      'items': '2× Pan de bono · 1× Almojábana · 1× Café tinto',
      'price': '\$18,500',
      'timeAgo': 'Hace 2 min',
    },
    {
      'avatarLetter': 'J',
      'avatarGradient': [AppColors.aiBg, const Color(0xFFDDD6FE)],
      'avatarColor': AppColors.aiText,
      'name': 'Juan Rodríguez',
      'idText': '#P-0040 · vía WhatsApp',
      'isNew': false,
      'items': '3× Croissant de jamón · 2× Jugo naranja',
      'price': '\$32,000',
      'timeAgo': 'Hace 5 min',
    },
    {
      'avatarLetter': 'S',
      'avatarGradient': [AppColors.dangerBg, const Color(0xFFFED6D7)],
      'avatarColor': const Color(0xFFD9282B),
      'name': 'Sara Sierra',
      'idText': '#P-0038 · vía WhatsApp',
      'isNew': false,
      'items': '1× Croissant de jamón',
      'price': '\$10,000',
      'timeAgo': 'Hace 10 min',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 16.0),
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
                              color: AppColors.textTertiary,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            'Mi Panadería',
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(13),
                              border: Border.all(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.bell,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: AppColors.dangerIcon,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 2,
                                ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.successIcon,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'IA Activa · 3 pedidos entrantes',
                          style: GoogleFonts.inter(
                            color: AppColors.successText,
                            fontSize: 12,
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.35,
              children: [
                _buildMetricCard(
                  icon: FontAwesomeIcons.bagShopping,
                  iconColor: AppColors.successText,
                  iconBg: AppColors.successBg,
                  label: 'Pedidos hoy',
                  value: '24',
                  subText: '↑ +6 vs ayer',
                  subColor: AppColors.successText,
                ),
                _buildMetricCard(
                  icon: FontAwesomeIcons.clock,
                  iconColor: AppColors.infoText,
                  iconBg: AppColors.infoBg,
                  label: 'Tiempo prom.',
                  value: '4.2 min',
                  subText: '↓ -1.3 min',
                  subColor: AppColors.infoText,
                ),
                _buildMetricCard(
                  icon: FontAwesomeIcons.dollarSign,
                  iconColor: AppColors.aiText,
                  iconBg: AppColors.aiBg,
                  label: 'Ventas del día',
                  value: '\$284K',
                  subText: '↑ +18%',
                  subColor: AppColors.aiText,
                ),
                _buildMetricCard(
                  icon: FontAwesomeIcons.solidStar,
                  iconColor: AppColors.warningText,
                  iconBg: AppColors.warningBg,
                  label: 'Satisfacción',
                  value: '96%',
                  subText: '↑ +2%',
                  subColor: AppColors.warningText,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Pedidos activos',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary, // Changed to match theme
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: _tabs.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeTabIndex = index;
                            });
                          },
                          child: _buildTabChip(
                            _tabs[index]['label'] as String,
                            _tabs[index]['count'] as String,
                            isActive: index == _activeTabIndex,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Order Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            sliver: SliverList.builder(
              itemCount: _activeOrders.length,
              itemBuilder: (context, index) {
                final order = _activeOrders[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildOrderCard(
                    avatarLetter: order['avatarLetter'] as String,
                    avatarGradient: order['avatarGradient'] as List<Color>,
                    avatarColor: order['avatarColor'] as Color,
                    name: order['name'] as String,
                    idText: order['idText'] as String,
                    isNew: order['isNew'] as bool,
                    items: order['items'] as String,
                    price: order['price'] as String,
                    timeAgo: order['timeAgo'] as String,
                  ),
                );
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required FaIconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    required String subText,
    required Color subColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: FaIcon(icon, color: iconColor, size: 14),
            ),
          ),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subText,
            style: GoogleFonts.inter(
              color: subColor,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, String count, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? AppColors.surface : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.surface.withValues(alpha: 0.25)
                  : AppColors.borderLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                count,
                style: GoogleFonts.inter(
                  color: isActive ? AppColors.surface : AppColors.textSecondary,
                  fontSize: 10,
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
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
                width: 41,
                height: 41,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
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
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      idText,
                      style: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Esperando',
                  style: GoogleFonts.inter(
                    color: AppColors.warningText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isNew) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Nuevo',
                    style: GoogleFonts.inter(
                      color: AppColors.successText,
                      fontSize: 12,
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
              color: AppColors.textSecondary,
              fontSize: 12,
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
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.clock, color: AppColors.textMuted, size: 11),
                      const SizedBox(width: 4),
                      Text(
                        timeAgo,
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  minimumSize: const Size(0, 33),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  'Aceptar →',
                  style: GoogleFonts.inter(
                    color: AppColors.surface,
                    fontSize: 12,
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
