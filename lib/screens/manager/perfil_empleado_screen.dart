import 'package:flutter/material.dart';
import 'package:google_fonts/GoogleFonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PerfilEmpleadoScreen extends StatefulWidget {
  const PerfilEmpleadoScreen({super.key});

  @override
  State<PerfilEmpleadoScreen> createState() => _PerfilEmpleadoScreenState();
}

class _PerfilEmpleadoScreenState extends State<PerfilEmpleadoScreen> {
  bool _verPedidos = true;
  bool _gestionarPedidos = true;
  bool _verInventario = true;
  bool _editarInventario = true;
  bool _verReportes = false;
  bool _iaConfig = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Informacion de contacto'),
                  _buildContactInfoGroup(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Permisos de acceso'),
                  _buildPermissionsGroup(),
                  const SizedBox(height: 24),
                  _buildBottomActions(),
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
              child: const Icon(
                FontAwesomeIcons.arrowLeft,
                color: Color(0xFF334155),
                size: 16,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sofia Herrera',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F172A),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Cocinera · activa desde Mar 2025',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Options
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                FontAwesomeIcons.ellipsisVertical,
                color: Color(0xFF475569),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'S',
                style: GoogleFonts.inter(
                  color: const Color(0xFFB45309),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sofia Herrera',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF78350F),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '+57 316 456 7890',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF92400E),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(FontAwesomeIcons.fireBurner, color: Color(0xFFB45309), size: 9),
                          const SizedBox(width: 4),
                          Text(
                            'Cocinera',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFB45309),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Activa',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
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

  Widget _buildContactInfoGroup() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          _buildContactRow(
            icon: FontAwesomeIcons.whatsapp,
            iconColor: const Color(0xFF15803D),
            iconBgColor: const Color(0xFFDCFCE7),
            label: 'WhatsApp',
            value: '+57 316 456 7890',
            showDivider: true,
          ),
          _buildContactRow(
            icon: FontAwesomeIcons.envelope,
            iconColor: const Color(0xFF1D4ED8),
            iconBgColor: const Color(0xFFDBEAFE),
            label: 'Correo',
            value: 'sofia.h@gmail.com',
            showDivider: true,
          ),
          _buildContactRow(
            icon: FontAwesomeIcons.idCard,
            iconColor: const Color(0xFFB45309),
            iconBgColor: const Color(0xFFFEF3C7),
            label: 'Rol',
            value: 'Cocinera',
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1E293B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                FontAwesomeIcons.chevronRight,
                color: Color(0xFF94A3B8),
                size: 12,
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F5F9),
          ),
      ],
    );
  }

  Widget _buildPermissionsGroup() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPermissionRow(
            icon: FontAwesomeIcons.receipt,
            iconColor: const Color(0xFF15803D),
            iconBgColor: const Color(0xFFDCFCE7),
            title: 'Ver pedidos',
            subtitle: 'Cola de cocina y estados',
            value: _verPedidos,
            onChanged: (val) => setState(() => _verPedidos = val),
            showDivider: true,
          ),
          _buildPermissionRow(
            icon: FontAwesomeIcons.listCheck,
            iconColor: const Color(0xFF15803D),
            iconBgColor: const Color(0xFFDCFCE7),
            title: 'Gestionar pedidos',
            subtitle: 'Marcar listos, cambiar estado',
            value: _gestionarPedidos,
            onChanged: (val) => setState(() => _gestionarPedidos = val),
            showDivider: true,
          ),
          _buildPermissionRow(
            icon: FontAwesomeIcons.boxesStacked,
            iconColor: const Color(0xFFB45309),
            iconBgColor: const Color(0xFFFEF3C7),
            title: 'Ver inventario',
            subtitle: 'Consultar stock',
            value: _verInventario,
            onChanged: (val) => setState(() => _verInventario = val),
            showDivider: true,
          ),
          _buildPermissionRow(
            icon: FontAwesomeIcons.pen,
            iconColor: const Color(0xFFB45309),
            iconBgColor: const Color(0xFFFEF3C7),
            title: 'Editar inventario',
            subtitle: 'Modificar stock y productos',
            value: _editarInventario,
            onChanged: (val) => setState(() => _editarInventario = val),
            showDivider: true,
          ),
          _buildPermissionRow(
            icon: FontAwesomeIcons.chartSimple,
            iconColor: const Color(0xFF94A3B8),
            iconBgColor: const Color(0xFFF1F5F9),
            title: 'Ver reportes KPI',
            subtitle: 'Solo dueño / admin',
            value: _verReportes,
            onChanged: (val) => setState(() => _verReportes = val),
            showDivider: true,
            isDisabled: true,
          ),
          _buildPermissionRow(
            icon: FontAwesomeIcons.robot,
            iconColor: const Color(0xFF94A3B8),
            iconBgColor: const Color(0xFFF1F5F9),
            title: 'IA y configuracion',
            subtitle: 'Solo dueño / admin',
            value: _iaConfig,
            onChanged: (val) => setState(() => _iaConfig = val),
            showDivider: false,
            isDisabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showDivider,
    bool isDisabled = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        color: isDisabled ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: isDisabled ? null : onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF25D366),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFF1F5F9),
          ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Action
            },
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.rightLeft, color: Color(0xFF334155), size: 13),
                  const SizedBox(width: 6),
                  Text(
                    'Cambiar rol',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF334155),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Action
            },
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(FontAwesomeIcons.ban, color: Color(0xFFB91C1C), size: 13),
                  const SizedBox(width: 6),
                  Text(
                    'Suspender acceso',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB91C1C),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
