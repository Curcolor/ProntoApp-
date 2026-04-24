import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PedidosListosScreen extends StatelessWidget {
  const PedidosListosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            // Banner Resumen
            Container(
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
                    '12',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'pedidos preparados · turno 7:00 – 3:00 pm',
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
                        _buildStat('4.8m', 'Prom. prep.'),
                        _buildStatDivider(),
                        _buildStat('3', 'En espera'),
                        _buildStatDivider(),
                        _buildStat('98%', 'Precisión'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Esperando Repartidor Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Esperando repartidor',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '3 en espera',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB45309),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            
            // Waiting Card
            _buildWaitingCard(),
            const SizedBox(height: 14),
            
            // Completed today section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completados hoy',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ver todos →',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1DB954),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            
            // Another Waiting Card (from Figma it seems to be completed but with #P-0035 design)
            _buildCompletedRecentlyCard(),
            const SizedBox(height: 14),
            
            // Completed Cards List
            _buildCompletedCard('#P-0034 · Luis Pérez', '3× Croissant de jamón · 2× Jugo naranja', '3:20 m'),
            const SizedBox(height: 14),
            _buildCompletedCard('#P-0033 · Ana Torres', '1× Pan de bono · 1× Almojábana', '2:45 m'),
            const SizedBox(height: 14),
            _buildCompletedCard('#P-0032 · Carlos Ramos', '2× Medialunas · 1× Café', '5:10 m'),
          ],
        ),
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

  Widget _buildWaitingCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF59E0B), width: 2),
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
              Text(
                '#P-0036 · María García',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F172A),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.clock, color: Color(0xFFB45309), size: 11),
                    const SizedBox(width: 4),
                    Text(
                      '8 min esperando',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFB45309),
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
            '2× Pan de bono · 1× Café tinto',
            style: GoogleFonts.inter(
              color: const Color(0xFF475569),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedRecentlyCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
              Text(
                '#P-0035 · Juan López',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F172A),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.check, color: Color(0xFF15803D), size: 11),
                    const SizedBox(width: 4),
                    Text(
                      'Listo',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF15803D),
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
            '1× Torta de queso · 2× Jugo natural',
            style: GoogleFonts.inter(
              color: const Color(0xFF475569),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard(String title, String subtitle, String time) {
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
              child: FaIcon(FontAwesomeIcons.check, color: Color(0xFF128C7E), size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
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
}
