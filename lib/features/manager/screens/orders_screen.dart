import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header & Search
          Padding(
            padding: const EdgeInsets.only(left: 21.73, right: 21.73, top: 20.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pedidos',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F172A),
                        fontSize: 23.90,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.33,
                      ),
                    ),
                    Container(
                      width: 41.29,
                      height: 41.29,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13.04),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.09),
                      ),
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.sliders, color: Color(0xFF475569), size: 16.30),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.21),
                // Search Input
                Container(
                  height: 47.81,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17.38),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.09),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15.21),
                  child: Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.magnifyingGlass, color: Color(0xFF94A3B8), size: 15.21),
                      const SizedBox(width: 15.21),
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.inter(fontSize: 14.12, color: const Color(0xFF0F172A)),
                          decoration: InputDecoration(
                            hintText: 'Buscar pedido o cliente…',
                            hintStyle: GoogleFonts.inter(color: const Color(0xFF757575), fontSize: 14.12),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.21),
                // Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTabChip('Todos', false),
                      const SizedBox(width: 8),
                      _buildTabChip('Recibidos', true),
                      const SizedBox(width: 8),
                      _buildTabChip('Preparando', false),
                      const SizedBox(width: 8),
                      _buildTabChip('Listos', false),
                      const SizedBox(width: 8),
                      _buildTabChip('En camino', false),
                      const SizedBox(width: 8),
                      _buildTabChip('Pagados', false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Order Cards List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 21.73, vertical: 8.0),
              children: [
                _buildExpandedOrderCard(
                  avatarLetter: 'M',
                  avatarGradient: const [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
                  avatarColor: const Color(0xFF1D4ED8),
                  name: 'María García',
                  phone: '+57 300 111 2233',
                  status: 'Recibido',
                  items: [
                    {'qty': '2', 'name': 'Pan de bono', 'price': '\$6,000'},
                    {'qty': '1', 'name': 'Almojábana', 'price': '\$3,500'},
                    {'qty': '1', 'name': 'Café tinto', 'price': '\$2,000'},
                  ],
                  total: '\$18,500',
                  deliveryTypeIcon: FontAwesomeIcons.locationDot,
                  deliveryTypeColor: const Color(0xFF25D366),
                  deliveryTypeText: 'Cll 72 #45-12, El Prado — Domicilio',
                ),
                const SizedBox(height: 13.04),
                _buildExpandedOrderCard(
                  avatarLetter: 'J',
                  avatarGradient: const [Color(0xFFEDE9FE), Color(0xFFDDD6FE)],
                  avatarColor: const Color(0xFF6D28D9),
                  name: 'Juan Rodríguez',
                  phone: '+57 313 444 5566',
                  status: 'Recibido',
                  items: [
                    {'qty': '3', 'name': 'Croissant de jamón', 'price': '\$21,000'},
                    {'qty': '2', 'name': 'Jugo de naranja', 'price': '\$11,000'},
                  ],
                  total: '\$32,000',
                  deliveryTypeIcon: FontAwesomeIcons.shop,
                  deliveryTypeColor: const Color(0xFF3B82F6),
                  deliveryTypeText: 'Para recoger en tienda',
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.30, vertical: 7.61),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF25D366) : Colors.white,
        borderRadius: BorderRadius.circular(1085.41),
        border: Border.all(
          color: isActive ? const Color(0xFF25D366) : const Color(0xFFE2E8F0),
          width: 1.09,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isActive ? Colors.white : const Color(0xFF475569),
          fontSize: 11.95,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExpandedOrderCard({
    required String avatarLetter,
    required List<Color> avatarGradient,
    required Color avatarColor,
    required String name,
    required String phone,
    required String status,
    required List<Map<String, String>> items,
    required String total,
    required FaIconData deliveryTypeIcon,
    required Color deliveryTypeColor,
    required String deliveryTypeText,
  }) {
    return Container(
      padding: const EdgeInsets.all(17.38),
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
          // Top Row: Avatar & Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45.63,
                height: 45.63,
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
                    const SizedBox(height: 2),
                    Text(
                      phone,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
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
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(1085.41),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF15803D),
                    fontSize: 11.95,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Items List
          Container(
            padding: const EdgeInsets.only(top: 11.95),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.09)),
            ),
            child: Column(
              children: [
                ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.43),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 23.90,
                            height: 23.90,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8.69),
                            ),
                            child: Center(
                              child: Text(
                                '×${item['qty']}',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF334155),
                                  fontSize: 11.95,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.69),
                          Text(
                            item['name']!,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF334155),
                              fontSize: 14.12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        item['price']!,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1E293B),
                          fontSize: 14.12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )),
                // Total
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.only(top: 9.78),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1.09, style: BorderStyle.solid)), // Should be dashed ideally
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF475569),
                          fontSize: 14.12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        total,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F172A),
                          fontSize: 17.38,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Delivery info
          Row(
            children: [
              FaIcon(deliveryTypeIcon, color: deliveryTypeColor, size: 11.95),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  deliveryTypeText,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11.95,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.check, size: 14.12, color: Colors.white),
                  label: Text(
                    'Pasar a En Preparación',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14.12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    elevation: 0,
                    minimumSize: const Size(0, 43.46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.04),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.69),
              Container(
                width: 43.46,
                height: 43.46,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(13.04),
                ),
                child: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 19.56),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
