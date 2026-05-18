import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeroSummary extends StatelessWidget {
  final String name;
  final bool isManager;
  final bool aiConnected;
  final int totalOrders;
  final int deliveredOrders;

  const ProfileHeroSummary({
    super.key,
    required this.name,
    required this.isManager,
    required this.aiConnected,
    required this.totalOrders,
    required this.deliveredOrders,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final responseTime = totalOrders > 0 ? (3.0 + (totalOrders % 5)) : 0.0;
    final satisfaction = totalOrders > 0
        ? '${((deliveredOrders / totalOrders) * 100).toInt()}%'
        : '0%';

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 217.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF25D366), Color(0xFF075E54)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              bottom: -6,
              left: 0,
              right: 0,
              child: Container(
                height: 43.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(43.46),
                    topRight: Radius.circular(43.46),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 91.27,
                    height: 91.27,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4.35),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA7F3D0), Color(0xFF6EE7B7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.15 * 255).toInt()),
                          blurRadius: 17.38,
                          offset: const Offset(0, 4.35),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF128C7E),
                          fontSize: 34.77,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -4,
                    child: Container(
                      width: 30.42,
                      height: 30.42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.17),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                          size: 11.95,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.73),
          child: Column(
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F172A),
                  fontSize: 23.90,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.33,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isManager
                    ? 'Propietario · Mi negocio'
                    : 'Empleado · Mi negocio',
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 14.12,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _ProfileBadge(
                    bgColor: Color(0xFFDCFCE7),
                    textColor: Color(0xFF15803D),
                    icon: FontAwesomeIcons.shop,
                    text: 'Panadería',
                  ),
                  const SizedBox(width: 8.69),
                  _ProfileBadge(
                    bgColor: aiConnected
                        ? const Color(0xFFDBEAFE)
                        : const Color(0xFFFEF3C7),
                    textColor: aiConnected
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFFB45309),
                    icon: FontAwesomeIcons.robot,
                    text: aiConnected ? 'IA Activa' : 'IA No Activa',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.73),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuickMetric(
                value: '${responseTime}m',
                label: 'T. Respuesta',
                valueColor: const Color(0xFF0F172A),
              ),
              _QuickMetric(
                value: '$totalOrders',
                label: 'Pedidos total',
                valueColor: const Color(0xFF0F172A),
              ),
              _QuickMetric(
                value: satisfaction,
                label: 'Satisfacción',
                valueColor: const Color(0xFF1DB954),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileBusinessSection extends StatelessWidget {
  final bool aiConnected;
  final int incomingOrders;
  final VoidCallback? onTeamTap;
  final VoidCallback? onInventoryTap;
  final VoidCallback? onAiTap;

  const ProfileBusinessSection({
    super.key,
    required this.aiConnected,
    required this.incomingOrders,
    this.onTeamTap,
    this.onInventoryTap,
    this.onAiTap,
  });

  @override
  Widget build(BuildContext context) {
    final aiStatusText = !aiConnected
        ? 'IA No Activa · Sin conexión'
        : incomingOrders > 0
        ? 'IA Activa · $incomingOrders pedidos entrantes'
        : 'IA Activa · Sin pedidos nuevos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ProfileSectionTitle('NEGOCIO'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.38),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 2.17,
                offset: const Offset(0, 1.09),
              ),
            ],
          ),
          child: Column(
            children: [
              _BusinessRow(
                bgColor: const Color(0xFF1DB954),
                icon: FontAwesomeIcons.users,
                iconBgColor: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF1DB954),
                label: 'Equipo de trabajo',
                value: 'Administrar equipo',
                isFirst: true,
                onTap: onTeamTap,
              ),
              _BusinessRow(
                bgColor: const Color(0xFFF59E0B),
                icon: FontAwesomeIcons.boxOpen,
                iconBgColor: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFF59E0B),
                label: 'Inventario',
                value: 'Administrar inventario',
                onTap: onInventoryTap,
              ),
              _BusinessRow(
                bgColor: const Color(0xFF6D28D9),
                icon: FontAwesomeIcons.robot,
                iconBgColor: const Color(0xFFEDE9FE),
                iconColor: const Color(0xFF6D28D9),
                label: 'Agente de IA',
                value: aiStatusText,
                isLast: true,
                onTap: onAiTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileSettingsSection extends StatelessWidget {
  final String email;
  final String businessName;
  final VoidCallback? onEmailTap;
  final VoidCallback? onPhoneTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onBusinessTap;
  final VoidCallback? onWhatsappTap;
  final VoidCallback? onSecurityTap;
  final VoidCallback? onLogoutTap;

  const ProfileSettingsSection({
    super.key,
    required this.email,
    required this.businessName,
    this.onEmailTap,
    this.onPhoneTap,
    this.onLocationTap,
    this.onBusinessTap,
    this.onWhatsappTap,
    this.onSecurityTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ProfileSectionTitle('INFORMACIÓN'),
        const SizedBox(height: 8),
        _SettingsList(
          rows: [
            _SettingsRow(
              icon: FontAwesomeIcons.envelope,
              iconBgColor: const Color(0xFFDCFCE7),
              iconColor: const Color(0xFF15803D),
              label: 'Correo',
              value: email.isNotEmpty ? email : 'Sin correo registrado',
              onTap: onEmailTap,
            ),
            _SettingsRow(
              icon: FontAwesomeIcons.phone,
              iconBgColor: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF1D4ED8),
              label: 'Teléfono',
              value: '+57 300 123 4567',
              onTap: onPhoneTap,
            ),
            _SettingsRow(
              icon: FontAwesomeIcons.locationDot,
              iconBgColor: const Color(0xFFEDE9FE),
              iconColor: const Color(0xFF6D28D9),
              label: 'Ubicación',
              value: 'Barrio El Prado, Barranquilla',
              onTap: onLocationTap,
            ),
            _SettingsRow(
              icon: FontAwesomeIcons.shop,
              iconBgColor: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFB45309),
              label: 'Negocio',
              value: businessName,
              isLast: true,
              onTap: onBusinessTap,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _ProfileSectionTitle('CUENTA'),
        const SizedBox(height: 8),
        _SettingsList(
          rows: [
            _SettingsRow(
              icon: FontAwesomeIcons.whatsapp,
              iconBgColor: const Color(0xFFDCFCE7),
              iconColor: const Color(0xFF15803D),
              label: 'WhatsApp Business',
              value: 'Conectado ✓',
              onTap: onWhatsappTap,
            ),
            _SettingsRow(
              icon: FontAwesomeIcons.lock,
              iconBgColor: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF1D4ED8),
              label: 'Seguridad',
              value: 'Cambiar contraseña',
              onTap: onSecurityTap,
            ),
            _SettingsRow(
              icon: FontAwesomeIcons.arrowRightFromBracket,
              iconBgColor: const Color(0xFFFEE2E2),
              iconColor: const Color(0xFFB91C1C),
              label: 'Cerrar sesión',
              value: '',
              valueColor: const Color(0xFFB91C1C),
              isLast: true,
              onTap: onLogoutTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final FaIconData icon;
  final String text;

  const _ProfileBadge({
    required this.bgColor,
    required this.textColor,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.87, vertical: 3.26),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(1085.41),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: textColor, size: 11.95),
          const SizedBox(width: 4.34),
          Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 11.95,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickMetric extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _QuickMetric({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 9.78, vertical: 14.12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13.04),
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
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: valueColor,
                fontSize: 19.56,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 10.86,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;

  const _ProfileSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.35),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: const Color(0xFF94A3B8),
          fontSize: 11.95,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.87,
        ),
      ),
    );
  }
}

class _BusinessRow extends StatelessWidget {
  final Color bgColor;
  final FaIconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String value;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  const _BusinessRow({
    required this.bgColor,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.only(
        topLeft: isFirst ? const Radius.circular(17.38) : Radius.zero,
        topRight: isFirst ? const Radius.circular(17.38) : Radius.zero,
        bottomLeft: isLast ? const Radius.circular(17.38) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(17.38) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17.38, vertical: 15.21),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(17.38) : Radius.zero,
            topRight: isFirst ? const Radius.circular(17.38) : Radius.zero,
            bottomLeft: isLast ? const Radius.circular(17.38) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(17.38) : Radius.zero,
          ),
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0x33FFFFFF), width: 1),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 36.94,
              height: 36.94,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8.69),
              ),
              child: Center(child: FaIcon(icon, color: iconColor, size: 15.21)),
            ),
            const SizedBox(width: 13.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11.95,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14.12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white,
              size: 13.04,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final List<Widget> rows;

  const _SettingsList({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.38),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.09),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
            blurRadius: 2.17,
            offset: const Offset(0, 1.09),
          ),
        ],
      ),
      child: Column(children: rows),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final FaIconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17.38, vertical: 15.21),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.09),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 36.94,
              height: 36.94,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8.69),
              ),
              child: Center(child: FaIcon(icon, color: iconColor, size: 15.21)),
            ),
            const SizedBox(width: 13.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (value.isNotEmpty && label != 'Cerrar sesión')
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11.95,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (label == 'Cerrar sesión')
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: valueColor ?? const Color(0xFF1E293B),
                        fontSize: 14.12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (value.isNotEmpty)
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        color: valueColor ?? const Color(0xFF1E293B),
                        fontSize: 14.12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: Color(0xFF94A3B8),
              size: 13.04,
            ),
          ],
        ),
      ),
    );
  }
}
