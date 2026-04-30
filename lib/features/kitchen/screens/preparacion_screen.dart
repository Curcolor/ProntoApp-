import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PreparacionScreen extends StatefulWidget {
  const PreparacionScreen({super.key});

  @override
  State<PreparacionScreen> createState() => _PreparacionScreenState();
}

class _PreparacionScreenState extends State<PreparacionScreen> {
  final List<Map<String, dynamic>> _items = [
    {'name': 'Pan de bono', 'qty': 2, 'checked': true},
    {'name': 'Almojábana', 'qty': 1, 'checked': true},
    {'name': 'Café tinto', 'qty': 1, 'checked': false},
    {'name': 'Jugo de naranja', 'qty': 2, 'checked': false},
  ];

  @override
  Widget build(BuildContext context) {
    int checkedCount = _items.where((i) => i['checked'] == true).length;
    double progress = _items.isEmpty ? 0 : checkedCount / _items.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Header
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // padding for FAB
                    child: Column(
                      children: [
                        _buildChecklist(checkedCount, progress),
                        const SizedBox(height: 16),
                        _buildClientNote(),
                        const SizedBox(height: 16),
                        _buildClientInfo(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withAlpha((0.8 * 255).toInt()),
                    Colors.white.withAlpha((0.0 * 255).toInt()),
                  ],
                ),
              ),
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withAlpha((0.35 * 255).toInt()),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.white, size: 15),
                        const SizedBox(width: 8),
                        Text(
                          'Marcar pedido como Listo',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pedido #P-0038',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ana Martínez · vía WhatsApp',
                  style: GoogleFonts.inter(
                    color: Colors.white.withAlpha((0.8 * 255).toInt()),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.motorcycle, color: Colors.white, size: 10),
                      const SizedBox(width: 4),
                      Text(
                        'Domicilio · Cll 72 #45-12',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '12:35',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'en cola',
                  style: GoogleFonts.inter(
                    color: Colors.white.withAlpha((0.7 * 255).toInt()),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist(int checkedCount, double progress) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.listCheck, color: Color(0xFF1DB954), size: 15),
                const SizedBox(width: 8),
                Text(
                  'Items a preparar',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(_items.length, (index) {
            final item = _items[index];
            return _buildCheckItem(item, index);
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso de preparación',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF475569),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$checkedCount de ${_items.length} listos',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF128C7E),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF25D366)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(Map<String, dynamic> item, int index) {
    bool isChecked = item['checked'];
    return InkWell(
      onTap: () {
        setState(() {
          _items[index]['checked'] = !isChecked;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF25D366) : Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: isChecked ? const Color(0xFF25D366) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Center(child: FaIcon(FontAwesomeIcons.check, color: Colors.white, size: 12))
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: GoogleFonts.inter(
                  color: isChecked ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '×${item['qty']}',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF334155),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientNote() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: FaIcon(FontAwesomeIcons.noteSticky, color: Color(0xFFF59E0B), size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nota del cliente',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFB45309),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sin endulzante en el café, por favor 🙏',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF475569),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFDCFCE7), Color(0xFFA7F3D0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'A',
                style: GoogleFonts.inter(
                  color: const Color(0xFF128C7E),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ana Martínez',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.locationDot, color: Color(0xFF25D366), size: 10),
                    const SizedBox(width: 4),
                    Text(
                      'Cll 72 #45-12, El Prado',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
