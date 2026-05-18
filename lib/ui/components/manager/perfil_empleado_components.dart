import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/data/models/user_model.dart';

class EmployeeProfileHeader extends StatelessWidget {
  final UserModel usuario;
  final Map<String, dynamic> meta;
  final VoidCallback? onBack;
  final VoidCallback? onOptions;

  const EmployeeProfileHeader({
    super.key,
    required this.usuario,
    required this.meta,
    this.onBack,
    this.onOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HeaderIconButton(icon: FontAwesomeIcons.arrowLeft, onTap: onBack),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    usuario.name,
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
                    '${meta['role']} · Activo/a',
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
          _HeaderIconButton(
            icon: FontAwesomeIcons.ellipsisVertical,
            onTap: onOptions,
          ),
        ],
      ),
    );
  }
}

class EmployeeProfileBody extends StatelessWidget {
  final UserModel usuario;
  final Map<String, dynamic> meta;
  final List<EmployeePermissionItem> permissions;
  final Widget? actions;

  const EmployeeProfileBody({
    super.key,
    required this.usuario,
    required this.meta,
    required this.permissions,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        _EmployeeProfileCard(usuario: usuario, meta: meta),
        const SizedBox(height: 24),
        const _SectionTitle('Informacion de contacto'),
        _ContactInfoGroup(usuario: usuario, meta: meta),
        const SizedBox(height: 24),
        const _SectionTitle('Permisos de acceso'),
        _PermissionsGroup(permissions: permissions),
        const SizedBox(height: 24),
        if (actions != null) actions!,
        if (actions != null) const SizedBox(height: 40),
      ],
    );
  }
}

class EmployeeActionsRow extends StatelessWidget {
  final VoidCallback? onChangeRole;
  final VoidCallback? onSuspend;

  const EmployeeActionsRow({super.key, this.onChangeRole, this.onSuspend});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _EmployeeActionButton(
            label: 'Cambiar rol',
            icon: FontAwesomeIcons.rightLeft,
            color: const Color(0xFF334155),
            background: const Color(0xFFF1F5F9),
            onTap: onChangeRole,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _EmployeeActionButton(
            label: 'Suspender acceso',
            icon: FontAwesomeIcons.ban,
            color: const Color(0xFFB91C1C),
            background: const Color(0xFFFEE2E2),
            onTap: onSuspend,
          ),
        ),
      ],
    );
  }
}

class EmployeePermissionItem {
  final FaIconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDisabled;

  const EmployeePermissionItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isDisabled = false,
  });
}

class _HeaderIconButton extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback? onTap;

  const _HeaderIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: FaIcon(icon, color: const Color(0xFF334155), size: 16),
        ),
      ),
    );
  }
}

class _EmployeeProfileCard extends StatelessWidget {
  final UserModel usuario;
  final Map<String, dynamic> meta;

  const _EmployeeProfileCard({required this.usuario, required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              meta['gradientColors'] ??
              [const Color(0xFFFEF3C7), const Color(0xFFFDE68A)],
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
                meta['initial'] ?? 'U',
                style: GoogleFonts.inter(
                  color: meta['initialColor'] ?? const Color(0xFFB45309),
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
                  usuario.name,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF78350F),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  usuario.email,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF92400E),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _RoleBadge(meta: meta),
                    const SizedBox(width: 6),
                    _StatusBadge(meta: meta),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final Map<String, dynamic> meta;

  const _RoleBadge({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: meta['roleBg'] ?? const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            meta['roleIcon'] ?? FontAwesomeIcons.fireBurner,
            color: meta['roleColor'] ?? const Color(0xFFB45309),
            size: 9,
          ),
          const SizedBox(width: 4),
          Text(
            meta['role'] ?? 'Cocinera',
            style: GoogleFonts.inter(
              color: meta['roleColor'] ?? const Color(0xFFB45309),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Map<String, dynamic> meta;

  const _StatusBadge({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: meta['statusDotColor'] ?? const Color(0xFF25D366),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            meta['statusText'] ?? 'Activa',
            style: GoogleFonts.inter(
              color: const Color(0xFF15803D),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
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
}

class _ContactInfoGroup extends StatelessWidget {
  final UserModel usuario;
  final Map<String, dynamic> meta;

  const _ContactInfoGroup({required this.usuario, required this.meta});

  @override
  Widget build(BuildContext context) {
    return _EmployeeGroup(
      children: [
        _InfoRow(
          icon: FontAwesomeIcons.whatsapp,
          iconColor: const Color(0xFF15803D),
          iconBgColor: const Color(0xFFDCFCE7),
          label: 'ID de usuario',
          value: usuario.id,
          showDivider: true,
        ),
        _InfoRow(
          icon: FontAwesomeIcons.envelope,
          iconColor: const Color(0xFF1D4ED8),
          iconBgColor: const Color(0xFFDBEAFE),
          label: 'Correo',
          value: usuario.email,
          showDivider: true,
        ),
        _InfoRow(
          icon: FontAwesomeIcons.idCard,
          iconColor: const Color(0xFFB45309),
          iconBgColor: const Color(0xFFFEF3C7),
          label: 'Rol',
          value: meta['role'] ?? 'Cocinera',
          showDivider: false,
        ),
      ],
    );
  }
}

class _PermissionsGroup extends StatelessWidget {
  final List<EmployeePermissionItem> permissions;

  const _PermissionsGroup({required this.permissions});

  @override
  Widget build(BuildContext context) {
    return _EmployeeGroup(
      withShadow: true,
      children: [
        for (var index = 0; index < permissions.length; index++)
          _PermissionRow(
            item: permissions[index],
            showDivider: index != permissions.length - 1,
          ),
      ],
    );
  }
}

class _EmployeeGroup extends StatelessWidget {
  final List<Widget> children;
  final bool withShadow;

  const _EmployeeGroup({required this.children, this.withShadow = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: withShadow
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ]
            : null,
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final FaIconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String value;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.value,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _IconTile(
                icon: icon,
                iconColor: iconColor,
                iconBgColor: iconBgColor,
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
              const FaIcon(
                FontAwesomeIcons.chevronRight,
                color: Color(0xFF94A3B8),
                size: 12,
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFF1F5F9)),
      ],
    );
  }
}

class _PermissionRow extends StatelessWidget {
  final EmployeePermissionItem item;
  final bool showDivider;

  const _PermissionRow({required this.item, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _IconTile(
                icon: item.icon,
                iconColor: item.iconColor,
                iconBgColor: item.iconBgColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        color: item.isDisabled
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF1E293B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: item.value,
                onChanged: item.isDisabled ? null : item.onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF25D366),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xFFF1F5F9)),
      ],
    );
  }
}

class _IconTile extends StatelessWidget {
  final FaIconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const _IconTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: iconBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: FaIcon(icon, color: iconColor, size: 14)),
    );
  }
}

class _EmployeeActionButton extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final Color color;
  final Color background;
  final VoidCallback? onTap;

  const _EmployeeActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: color, size: 13),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
