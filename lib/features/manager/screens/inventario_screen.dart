import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/modals/ajustar_stock_modal.dart';
import 'agregar_editar_producto_screen.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Todos',
    '🥐 Panadería',
    '☕ Bebidas',
    '🍰 Repostería',
    '🥗 Ensaladas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStats(),
            _buildSearchBar(),
            _buildCategories(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  _buildStockAlert(),
                  const SizedBox(height: 10),
                  _buildProductCard(
                    context: context,
                    icon: '🥐',
                    name: 'Croissant de jamón y q...',
                    category: '🥐 Panadería',
                    price: '\$8,500',
                    stockLabel: 'Stock: 40 uds',
                    stockPercent: 0.8,
                    statusBadgeText: 'Disponible',
                    statusBadgeColor: const Color(0xFF15803D),
                    statusBadgeBg: const Color(0xFFDCFCE7),
                    stockFillColor: const Color(0xFF25D366),
                    aiStatusText: 'IA activa',
                    aiStatusIcon: FontAwesomeIcons.robot, // placeholder for robot
                  ),
                  const SizedBox(height: 12),
                  _buildProductCard(
                    context: context,
                    icon: '☕',
                    name: 'Café latte especial',
                    category: '☕ Bebidas',
                    price: '\$5,000',
                    stockLabel: 'Stock: 5 uds',
                    stockPercent: 0.2,
                    statusBadgeText: 'Stock bajo',
                    statusBadgeColor: const Color(0xFFB45309),
                    statusBadgeBg: const Color(0xFFFEF3C7),
                    stockFillColor: const Color(0xFFF59E0B),
                    aiStatusText: 'IA activa',
                    aiStatusIcon: FontAwesomeIcons.robot,
                    isStockLow: true,
                  ),
                  const SizedBox(height: 12),
                  _buildProductCard(
                    context: context,
                    icon: '🍰',
                    name: 'Torta de tres leches',
                    category: '🍰 Repostería',
                    price: '\$12,000',
                    stockLabel: 'Stock: 0 uds',
                    stockPercent: 0.0,
                    statusBadgeText: 'Agotado',
                    statusBadgeColor: const Color(0xFF991B1B),
                    statusBadgeBg: const Color(0xFFFEE2E2),
                    stockFillColor: const Color(0xFFE2E8F0),
                    aiStatusText: 'IA pausada',
                    aiStatusIcon: FontAwesomeIcons.robot,
                    isOutOfStock: true,
                  ),
                  const SizedBox(height: 12),
                  _buildProductCard(
                    context: context,
                    icon: '🥖',
                    name: 'Pan de bono x6',
                    category: '🥐 Panadería',
                    price: '\$9,000',
                    stockLabel: 'Stock: 32 uds',
                    stockPercent: 0.65,
                    statusBadgeText: 'Disponible',
                    statusBadgeColor: const Color(0xFF15803D),
                    statusBadgeBg: const Color(0xFFDCFCE7),
                    stockFillColor: const Color(0xFF25D366),
                    aiStatusText: 'IA activa',
                    aiStatusIcon: FontAwesomeIcons.robot,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: Color(0xFF334155),
                size: 16,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Panadería El Trigo Dorado',
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Inventario',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F172A),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AgregarEditarProductoScreen(),
                ),
              );
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('24', 'Productos', const Color(0xFF0F172A)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('3', 'Stock bajo', const Color(0xFFF59E0B)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('1', 'Agotado', const Color(0xFFEF4444)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // 0.08 alpha
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Color(0x0A000000), // 0.04 alpha
            offset: Offset(0, 1),
            blurRadius: 2,
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
              color: const Color(0xFF64748B),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Color(0xFF94A3B8),
              size: 14,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar producto...',
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xFF757575),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F172A),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const FaIcon(
                FontAwesomeIcons.sliders,
                color: Colors.white,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF25D366) : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF25D366)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  _categories[index],
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF475569),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStockAlert() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FaIcon(
            FontAwesomeIcons.triangleExclamation,
            color: Color(0xFFF59E0B),
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  color: const Color(0xFF92400E),
                  fontSize: 11,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '3 productos ',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: 'con stock bajo. Revisa y actualiza tu inventario para que la IA no ofrezca productos agotados.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required String icon,
    required String name,
    required String category,
    required String price,
    required String stockLabel,
    required double stockPercent,
    required String statusBadgeText,
    required Color statusBadgeColor,
    required Color statusBadgeBg,
    required Color stockFillColor,
    required String aiStatusText,
    required FaIconData aiStatusIcon,
    bool isStockLow = false,
    bool isOutOfStock = false,
  }) {
    Color borderColor = const Color(0xFFF1F5F9);
    if (isStockLow) borderColor = const Color(0xFFFDE68A);
    if (isOutOfStock) borderColor = const Color(0xFFFCA5A5);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isOutOfStock ? Colors.white.withOpacity(0.7) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // 0.08 alpha
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Color(0x0A000000), // 0.04 alpha
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9).withOpacity(isOutOfStock ? 0.5 : 1.0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF128C7E),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBadgeBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          if (isStockLow) ...[
                            FaIcon(
                              FontAwesomeIcons.triangleExclamation,
                              color: statusBadgeColor,
                              size: 11,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            statusBadgeText,
                            style: GoogleFonts.inter(
                              color: statusBadgeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: stockPercent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: stockFillColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          stockLabel,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF64748B),
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isOutOfStock ? const Color(0xFFF1F5F9) : const Color(0xFFEDE9FE),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                aiStatusIcon,
                                color: isOutOfStock ? const Color(0xFF64748B) : const Color(0xFF6D28D9),
                                size: 9,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                aiStatusText,
                                style: GoogleFonts.inter(
                                  color: isOutOfStock ? const Color(0xFF64748B) : const Color(0xFF6D28D9),
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AgregarEditarProductoScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.pen,
                    color: Color(0xFF475569),
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  AjustarStockModal.show(context);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: Color(0xFF475569),
                    size: 16,
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
