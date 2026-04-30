import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'perfil_empleado_screen.dart';
import 'invitar_empleado_screen.dart';

class EquipoScreen extends StatefulWidget {
  const EquipoScreen({super.key});

  @override
  State<EquipoScreen> createState() => _EquipoScreenState();
}

class _EquipoScreenState extends State<EquipoScreen> {
  final List<Map<String, dynamic>> _admins = [
    {
      'initial': 'C',
      'gradientColors': [AppColors.primary, AppColors.primaryDark],
      'name': 'Carlos Martinez',
      'phone': '+57 300 111 2233',
      'role': 'Dueño',
      'roleIcon': FontAwesomeIcons.crown,
      'roleColor': AppColors.successText,
      'roleBg': AppColors.successBg,
      'statusText': 'En linea',
      'statusColor': AppColors.textTertiary,
      'statusDotColor': AppColors.successIcon,
    }
  ];

  final List<Map<String, dynamic>> _kitchen = [
    {
      'initial': 'S',
      'initialColor': AppColors.warningText,
      'gradientColors': [AppColors.warningBg, const Color(0xFFFDE68A)],
      'name': 'Sofia Herrera',
      'phone': '+57 316 456 7890',
      'role': 'Cocinera',
      'roleIcon': FontAwesomeIcons.fireBurner,
      'roleColor': AppColors.warningText,
      'roleBg': AppColors.warningBg,
      'statusText': 'En turno',
      'statusColor': AppColors.textTertiary,
      'statusDotColor': AppColors.successIcon,
    },
    {
      'initial': 'A',
      'initialColor': AppColors.warningText,
      'gradientColors': [AppColors.warningBg, const Color(0xFFFDE68A)],
      'name': 'Andres Lopez',
      'phone': '+57 310 987 6543',
      'role': 'Cocinero',
      'roleIcon': FontAwesomeIcons.fireBurner,
      'roleColor': AppColors.warningText,
      'roleBg': AppColors.warningBg,
      'statusText': 'Sin turno',
      'statusColor': AppColors.textMuted,
      'statusDotColor': AppColors.toggleInactiveBg,
    }
  ];

  final List<Map<String, dynamic>> _delivery = [
    {
      'initial': 'D',
      'initialColor': AppColors.infoText,
      'gradientColors': [AppColors.infoBg, AppColors.infoBorder],
      'name': 'Diego Castillo',
      'phone': '+57 316 234 5678',
      'role': 'Repartidor',
      'roleIcon': FontAwesomeIcons.motorcycle,
      'roleColor': AppColors.infoText,
      'roleBg': AppColors.infoBg,
      'statusText': 'En ruta',
      'statusColor': AppColors.textTertiary,
      'statusDotColor': AppColors.successIcon,
    }
  ];

  final List<Map<String, dynamic>> _pending = [
    {
      'name': 'Laura Gomez',
      'phone': '+57 315 888 4422',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildStats(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  if (_admins.isNotEmpty) ...[
                    _buildSectionTitle('Administradores'),
                    ..._admins.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildEmployeeCard(e),
                    )),
                    const SizedBox(height: 4),
                  ],
                  if (_kitchen.isNotEmpty) ...[
                    _buildSectionTitle('Cocina'),
                    ..._kitchen.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildEmployeeCard(e),
                    )),
                    const SizedBox(height: 4),
                  ],
                  if (_delivery.isNotEmpty) ...[
                    _buildSectionTitle('Delivery'),
                    ..._delivery.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildEmployeeCard(e),
                    )),
                    const SizedBox(height: 4),
                  ],
                  if (_pending.isNotEmpty) ...[
                    _buildSectionTitle('Invitaciones pendientes'),
                    ..._pending.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPendingCard(context, e),
                    )),
                    const SizedBox(height: 40),
                  ],
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
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  color: AppColors.textSecondary, // 334155 close to 475569
                  size: 16,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Panadería El Trigo Dorado',
                style: GoogleFonts.inter(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Mi equipo',
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
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
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.plus, color: AppColors.surface, size: 11),
                  const SizedBox(width: 6),
                  Text(
                    'Invitar',
                    style: GoogleFonts.inter(
                      color: AppColors.surface,
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
            child: _buildStatCard('4', 'Activos', AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('2', 'Cocineros', AppColors.warningIcon),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('1', 'Delivery', AppColors.infoText),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 1),
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
              color: AppColors.textTertiary,
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
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> data) {
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 1),
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
                  colors: data['gradientColors'] as List<Color>,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  data['initial'] as String,
                  style: GoogleFonts.inter(
                    color: data['initialColor'] ?? AppColors.surface,
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
                    data['name'] as String,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data['phone'] as String,
                    style: GoogleFonts.inter(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: data['roleBg'] as Color,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            FaIcon(data['roleIcon'] as FaIconData, color: data['roleColor'] as Color, size: 9),
                            const SizedBox(width: 4),
                            Text(
                              data['role'] as String,
                              style: GoogleFonts.inter(
                                color: data['roleColor'] as Color,
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
                          color: data['statusDotColor'] as Color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['statusText'] as String,
                        style: GoogleFonts.inter(
                          color: data['statusColor'] as Color,
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
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: AppColors.textSecondary,
                  size: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingCard(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        // Handle pending invitation tap
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 1),
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
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: GoogleFonts.inter(
                      color: AppColors.textMuted,
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
                      data['name'] as String,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data['phone'] as String,
                      style: GoogleFonts.inter(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(FontAwesomeIcons.clock, color: AppColors.textSecondary, size: 9),
                          const SizedBox(width: 4),
                          Text(
                            'Pendiente de aceptar',
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
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
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.arrowsRotate,
                    color: AppColors.warningText,
                    size: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
