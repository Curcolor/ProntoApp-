import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'perfil_empleado_screen.dart';
import 'invitar_empleado_screen.dart';

class EquipoScreen extends StatefulWidget {
  const EquipoScreen({super.key});

  @override
  State<EquipoScreen> createState() => _EquipoScreenState();
}

class _EquipoScreenState extends State<EquipoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStats(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  _buildSectionTitle('Administradores'),
                  _buildEmployeeCard(
                    context: context,
                    initial: 'C',
                    gradientColors: const [Color(0xFF25D366), Color(0xFF128C7E)],
                    name: 'Carlos Martinez',
                    phone: '+57 300 111 2233',
                    role: 'Dueño',
                    roleIcon: FontAwesomeIcons.crown,
                    roleColor: const Color(0xFF15803D),
                    roleBg: const Color(0xFFDCFCE7),
                    statusText: 'En linea',
                    statusColor: const Color(0xFF64748B),
                    statusDotColor: const Color(0xFF25D366),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Cocina'),
                  _buildEmployeeCard(
                    context: context,
                    initial: 'S',
                    initialColor: const Color(0xFFB45309),
                    gradientColors: const [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                    name: 'Sofia Herrera',
                    phone: '+57 316 456 7890',
                    role: 'Cocinera',
                    roleIcon: FontAwesomeIcons.fireBurner,
                    roleColor: const Color(0xFFB45309),
                    roleBg: const Color(0xFFFEF3C7),
                    statusText: 'En turno',
                    statusColor: const Color(0xFF64748B),
                    statusDotColor: const Color(0xFF25D366),
                  ),
                  const SizedBox(height: 12),
                  _buildEmployeeCard(
                    context: context,
                    initial: 'A',
                    initialColor: const Color(0xFFB45309),
                    gradientColors: const [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                    name: 'Andres Lopez',
                    phone: '+57 310 987 6543',
                    role: 'Cocinero',
                    roleIcon: FontAwesomeIcons.fireBurner,
                    roleColor: const Color(0xFFB45309),
                    roleBg: const Color(0xFFFEF3C7),
                    statusText: 'Sin turno',
                    statusColor: const Color(0xFF94A3B8),
                    statusDotColor: const Color(0xFFCBD5E1),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Delivery'),
                  _buildEmployeeCard(
                    context: context,
                    initial: 'D',
                    initialColor: const Color(0xFF1D4ED8),
                    gradientColors: const [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
                    name: 'Diego Castillo',
                    phone: '+57 316 234 5678',
                    role: 'Repartidor',
                    roleIcon: FontAwesomeIcons.motorcycle,
                    roleColor: const Color(0xFF1D4ED8),
                    roleBg: const Color(0xFFDBEAFE),
                    statusText: 'En ruta',
                    statusColor: const Color(0xFF64748B),
                    statusDotColor: const Color(0xFF25D366),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Invitaciones pendientes'),
                  _buildPendingCard(context),
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
                'Mi equipo',
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
                  builder: (context) => const InvitarEmpleadoScreen(),
                ),
              );
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 11),
                  const SizedBox(width: 6),
                  Text(
                    'Invitar',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('4', 'Activos', const Color(0xFF0F172A)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('2', 'Cocineros', const Color(0xFFF59E0B)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('1', 'Delivery', const Color(0xFF1D4ED8)),
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
            color: Color(0x14000000),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Color(0x0A000000),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          color: const Color(0xFF94A3B8),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildEmployeeCard({
    required BuildContext context,
    required String initial,
    required List<Color> gradientColors,
    Color initialColor = Colors.white,
    required String name,
    required String phone,
    required String role,
    required FaIconData roleIcon,
    required Color roleColor,
    required Color roleBg,
    required String statusText,
    required Color statusColor,
    required Color statusDotColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PerfilEmpleadoScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: GoogleFonts.inter(
                    color: initialColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
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
                  ),
                  const SizedBox(height: 2),
                  Text(
                    phone,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: roleBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            FaIcon(roleIcon, color: roleColor, size: 9),
                            const SizedBox(width: 4),
                            Text(
                              role,
                              style: GoogleFonts.inter(
                                color: roleColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusDotColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: GoogleFonts.inter(
                          color: statusColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const FaIcon(
                FontAwesomeIcons.chevronRight,
                color: Color(0xFF475569),
                size: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle pending invitation tap
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Opacity(
          opacity: 0.7,
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Laura Gomez',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF475569),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+57 315 888 4422',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(FontAwesomeIcons.clock, color: Color(0xFF475569), size: 9),
                          const SizedBox(width: 4),
                          Text(
                            'Pendiente de aceptar',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF475569),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.arrowsRotate,
                  color: Color(0xFFB45309),
                  size: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
