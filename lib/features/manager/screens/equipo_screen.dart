import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/models/user_model.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'perfil_empleado_screen.dart';
import 'invitar_empleado_screen.dart';

class EquipoScreen extends StatefulWidget {
  const EquipoScreen({super.key});

  @override
  State<EquipoScreen> createState() => _EquipoScreenState();
}

class _EquipoScreenState extends State<EquipoScreen> {
  late Future<List<UserModel>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _futureUsuarios = AuthService().obtenerTodosLosUsuarios();
  }

  /// Configura los metadatos visuales según el rol del usuario.
  Map<String, dynamic> _metaDatos(UserModel usuario) {
    switch (usuario.role) {
      case RoleType.gerente:
        return {
          'initial': usuario.name.isNotEmpty ? usuario.name[0].toUpperCase() : 'G',
          'gradientColors': [AppColors.primary, AppColors.primaryDark],
          'initialColor': AppColors.successText,
          'role': 'Gerente',
          'roleIcon': FontAwesomeIcons.crown,
          'roleColor': AppColors.successText,
          'roleBg': AppColors.successBg,
          'statusText': 'En línea',
          'statusDotColor': AppColors.successIcon,
        };
      case RoleType.cocinero:
        return {
          'initial': usuario.name.isNotEmpty ? usuario.name[0].toUpperCase() : 'C',
          'gradientColors': [AppColors.warningBg, const Color(0xFFFDE68A)],
          'initialColor': AppColors.warningText,
          'role': 'Cocinero',
          'roleIcon': FontAwesomeIcons.fireBurner,
          'roleColor': AppColors.warningText,
          'roleBg': AppColors.warningBg,
          'statusText': 'En turno',
          'statusDotColor': AppColors.successIcon,
        };
      case RoleType.repartidor:
        return {
          'initial': usuario.name.isNotEmpty ? usuario.name[0].toUpperCase() : 'R',
          'gradientColors': [AppColors.infoBg, AppColors.infoBorder],
          'initialColor': AppColors.infoText,
          'role': 'Repartidor',
          'roleIcon': FontAwesomeIcons.motorcycle,
          'roleColor': AppColors.infoText,
          'roleBg': AppColors.infoBg,
          'statusText': 'Disponible',
          'statusDotColor': AppColors.successIcon,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: _futureUsuarios,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final todos = snapshot.data ?? [];
                  final gerentes = todos.where((u) => u.role == RoleType.gerente).toList();
                  final cocineros = todos.where((u) => u.role == RoleType.cocinero).toList();
                  final repartidores = todos.where((u) => u.role == RoleType.repartidor).toList();

                  return Column(
                    children: [
                      _buildStats(todos.length, cocineros.length, repartidores.length),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          children: [
                            if (gerentes.isNotEmpty) ...[
                              _buildSectionTitle('Administradores'),
                              ...gerentes.map((u) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildEmployeeCard(_metaDatos(u), u),
                              )),
                              const SizedBox(height: 4),
                            ],
                            if (cocineros.isNotEmpty) ...[
                              _buildSectionTitle('Cocina'),
                              ...cocineros.map((u) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildEmployeeCard(_metaDatos(u), u),
                              )),
                              const SizedBox(height: 4),
                            ],
                            if (repartidores.isNotEmpty) ...[
                              _buildSectionTitle('Delivery'),
                              ...repartidores.map((u) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildEmployeeCard(_metaDatos(u), u),
                              )),
                              const SizedBox(height: 40),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
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

  Widget _buildStats(int total, int cocineros, int repartidores) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('$total', 'Activos', AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('$cocineros', 'Cocineros', AppColors.warningIcon),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard('$repartidores', 'Delivery', AppColors.infoText),
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

  Widget _buildEmployeeCard(Map<String, dynamic> meta, UserModel usuario) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PerfilEmpleadoScreen(
              usuario: usuario,
              meta: meta,
            ),
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
                  colors: meta['gradientColors'] as List<Color>,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  meta['initial'] as String,
                  style: GoogleFonts.inter(
                    color: meta['initialColor'] ?? AppColors.surface,
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
                    usuario.name,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    usuario.email,
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
                          color: meta['roleBg'] as Color,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            FaIcon(meta['roleIcon'] as FaIconData, color: meta['roleColor'] as Color, size: 9),
                            const SizedBox(width: 4),
                            Text(
                              meta['role'] as String,
                              style: GoogleFonts.inter(
                                color: meta['roleColor'] as Color,
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
                          color: meta['statusDotColor'] as Color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        meta['statusText'] as String,
                        style: GoogleFonts.inter(
                          color: AppColors.textTertiary,
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
}

@Preview(name: 'Equipo', group: 'Manager', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget equipoScreenPreview() => const EquipoScreen();

