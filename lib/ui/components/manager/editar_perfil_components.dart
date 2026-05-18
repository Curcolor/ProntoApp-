import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/core/constants/app_colors.dart';

class EditarPerfilHeaderSheet extends StatelessWidget {
  final String title;
  final String subtitle;

  const EditarPerfilHeaderSheet({
    super.key,
    this.title = 'Editar correo electrónico',
    this.subtitle = 'El correo es tu identificador de acceso a Prontoa.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12, bottom: 24),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class EditarPerfilForm extends StatelessWidget {
  final String title;
  final String subtitle;
  final String currentLabel;
  final String currentValue;
  final FaIconData currentIcon;
  final String inputLabel1;
  final String inputHint1;
  final FaIconData inputIcon1;
  final String inputLabel2;
  final String inputHint2;
  final FaIconData inputIcon2;
  final String infoText;
  final String submitText;
  final FaIconData submitIcon;
  final bool obscureText;

  const EditarPerfilForm({
    super.key,
    this.title = 'Editar correo electrónico',
    this.subtitle = 'El correo es tu identificador de acceso a Prontoa.',
    this.currentLabel = 'Correo actual',
    this.currentValue = 'carlos.mendoza@correo.com',
    this.currentIcon = FontAwesomeIcons.solidEnvelope,
    this.inputLabel1 = 'Nuevo correo electrónico',
    this.inputHint1 = 'nuevo@correo.com',
    this.inputIcon1 = FontAwesomeIcons.solidEnvelope,
    this.inputLabel2 = 'Confirmar nuevo correo',
    this.inputHint2 = 'nuevo@correo.com',
    this.inputIcon2 = FontAwesomeIcons.solidCircleCheck,
    this.infoText =
        'Te enviaremos un enlace de verificación al nuevo correo antes de aplicar el cambio.',
    this.submitText = 'Enviar verificación',
    this.submitIcon = FontAwesomeIcons.paperPlane,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditarPerfilHeaderSheet(title: title, subtitle: subtitle),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              border: Border.all(color: AppColors.successIcon.withAlpha(80)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                FaIcon(currentIcon, size: 14, color: AppColors.successIcon),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentValue,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _EditarPerfilTextField(
            label: inputLabel1,
            hint: inputHint1,
            icon: inputIcon1,
            obscureText: obscureText,
          ),
          const SizedBox(height: 16),
          _EditarPerfilTextField(
            label: inputLabel2,
            hint: inputHint2,
            icon: inputIcon2,
            obscureText: obscureText,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: FaIcon(
                    FontAwesomeIcons.circleInfo,
                    size: 14,
                    color: AppColors.successIcon,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    infoText,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textTertiary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _SecondarySheetButton(
                  label: 'Cancelar',
                  semanticLabel: 'Cancelar edición de perfil',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _PrimarySheetButton(
                  label: submitText,
                  semanticLabel: submitText,
                  icon: submitIcon,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhatsappBusinessSection extends StatelessWidget {
  const WhatsappBusinessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EditarPerfilHeaderSheet(
            title: 'WhatsApp Business',
            subtitle: 'Gestiona la conexión de tu número empresarial.',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              border: Border.all(color: AppColors.successIcon.withAlpha(80)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conectado y activo',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        '+57 300 123 4567 · 3 sesiones activas',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.qrcode,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Escanea para reconectar desde otro dispositivo',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _OutlineSheetButton(
                  label: 'Reconectar',
                  semanticLabel: 'Reconectar WhatsApp Business',
                  icon: FontAwesomeIcons.rotate,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DangerSheetButton(
                  label: 'Desconectar',
                  semanticLabel: 'Desconectar WhatsApp Business',
                  icon: FontAwesomeIcons.linkSlash,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CambioPasswordSection extends StatefulWidget {
  const CambioPasswordSection({super.key});

  @override
  State<CambioPasswordSection> createState() => _CambioPasswordSectionState();
}

class _CambioPasswordSectionState extends State<CambioPasswordSection> {
  final _actualCtrl = TextEditingController();
  final _nuevaCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _ocultarActual = true;
  bool _ocultarNueva = true;
  bool _ocultarConfirm = true;
  int _fortaleza = 0;

  void _evaluarFortaleza(String valor) {
    int nivel = 0;
    if (valor.length >= 6) nivel = 1;
    if (valor.length >= 8 && RegExp(r'[A-Z]').hasMatch(valor)) nivel = 2;
    if (nivel == 2 && RegExp(r'[0-9!@#\$%^&*]').hasMatch(valor)) nivel = 3;
    setState(() => _fortaleza = nivel);
  }

  String get _fortalezaLabel {
    switch (_fortaleza) {
      case 1:
        return 'Contraseña débil';
      case 2:
        return 'Contraseña media';
      case 3:
        return 'Contraseña segura ✓';
      default:
        return '';
    }
  }

  Color get _fortalezaColor {
    switch (_fortaleza) {
      case 1:
        return AppColors.dangerIcon;
      case 2:
        return AppColors.warningIcon;
      case 3:
        return AppColors.primary;
      default:
        return Colors.transparent;
    }
  }

  @override
  void dispose() {
    _actualCtrl.dispose();
    _nuevaCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EditarPerfilHeaderSheet(
            title: 'Cambiar contraseña',
            subtitle: 'Usa mínimo 8 caracteres, combina letras y números.',
          ),
          const SizedBox(height: 24),
          _EditarPerfilTextField(
            label: 'Contraseña actual',
            hint: '••••••••',
            icon: FontAwesomeIcons.lock,
            controller: _actualCtrl,
            obscureText: _ocultarActual,
            trailing: _PasswordVisibilityButton(
              isHidden: _ocultarActual,
              semanticLabel: 'Mostrar u ocultar contraseña actual',
              onPressed: () => setState(() => _ocultarActual = !_ocultarActual),
            ),
          ),
          const SizedBox(height: 16),
          _EditarPerfilTextField(
            label: 'Nueva contraseña',
            hint: 'Mínimo 8 caracteres',
            icon: FontAwesomeIcons.lockOpen,
            controller: _nuevaCtrl,
            obscureText: _ocultarNueva,
            onChanged: _evaluarFortaleza,
            trailing: _PasswordVisibilityButton(
              isHidden: _ocultarNueva,
              semanticLabel: 'Mostrar u ocultar nueva contraseña',
              onPressed: () => setState(() => _ocultarNueva = !_ocultarNueva),
            ),
          ),
          if (_fortaleza > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: _fortalezaColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _fortalezaLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _fortalezaColor,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          _EditarPerfilTextField(
            label: 'Confirmar contraseña',
            hint: 'Repite la nueva contraseña',
            icon: FontAwesomeIcons.solidCircleCheck,
            controller: _confirmCtrl,
            obscureText: _ocultarConfirm,
            onChanged: (_) => setState(() {}),
            iconColor:
                _confirmCtrl.text.isNotEmpty && _confirmCtrl.text == _nuevaCtrl.text
                    ? AppColors.primary
                    : AppColors.textMuted,
            trailing: _PasswordVisibilityButton(
              isHidden: _ocultarConfirm,
              semanticLabel: 'Mostrar u ocultar confirmación de contraseña',
              onPressed: () => setState(() => _ocultarConfirm = !_ocultarConfirm),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _SecondarySheetButton(
                  label: 'Cancelar',
                  semanticLabel: 'Cancelar cambio de contraseña',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _PrimarySheetButton(
                  label: 'Actualizar',
                  semanticLabel: 'Actualizar contraseña',
                  icon: FontAwesomeIcons.shieldHalved,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditarNegocioSection extends StatefulWidget {
  const EditarNegocioSection({super.key});

  @override
  State<EditarNegocioSection> createState() => _EditarNegocioSectionState();
}

class _EditarNegocioSectionState extends State<EditarNegocioSection> {
  final _nombreCtrl = TextEditingController();
  final _descripCtrl = TextEditingController();

  String _tipoNegocio = '🥐 Panadería';
  final List<String> _tiposNegocio = const [
    '🥐 Panadería',
    '☕ Cafetería',
    '🍕 Restaurante',
    '🛒 Tienda',
    '💊 Farmacia',
    '📦 Otro',
  ];

  final List<bool> _diasActivos = [true, true, true, true, true, true, false];
  final List<String> _diasLabel = const ['L', 'Ma', 'Mi', 'J', 'V', 'S', 'D'];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 24,
        right: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EditarPerfilHeaderSheet(
              title: 'Información del negocio',
              subtitle: 'Datos que aparecen en tus mensajes de WhatsApp.',
            ),
            const SizedBox(height: 24),
            _EditarPerfilTextField(
              label: 'Nombre del negocio',
              hint: 'Nombre de tu negocio',
              icon: FontAwesomeIcons.shop,
              controller: _nombreCtrl,
            ),
            const SizedBox(height: 16),
            Text(
              'Tipo de negocio',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              label: 'Tipo de negocio',
              button: true,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _tipoNegocio,
                    isExpanded: true,
                    icon: const FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    dropdownColor: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    items: _tiposNegocio
                        .map(
                          (tipo) => DropdownMenuItem(
                            value: tipo,
                            child: Text(
                              tipo,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _tipoNegocio = val!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _EditarPerfilTextField(
              label: 'Descripción corta (para respuestas IA)',
              hint: 'Describe brevemente tu negocio...',
              icon: FontAwesomeIcons.circleInfo,
              controller: _descripCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Días activos',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_diasLabel.length, (i) {
                final activo = _diasActivos[i];
                return Expanded(
                  child: Semantics(
                    label: 'Alternar día ${_diasLabel[i]}',
                    button: true,
                    selected: activo,
                    child: GestureDetector(
                      onTap: () => setState(() => _diasActivos[i] = !activo),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: i < _diasLabel.length - 1 ? 6 : 0,
                        ),
                        height: 36,
                        decoration: BoxDecoration(
                          color: activo ? AppColors.primary : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _diasLabel[i],
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: activo ? AppColors.surface : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _SecondarySheetButton(
                    label: 'Cancelar',
                    semanticLabel: 'Cancelar edición del negocio',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _PrimarySheetButton(
                    label: 'Guardar',
                    semanticLabel: 'Guardar información del negocio',
                    icon: FontAwesomeIcons.solidFloppyDisk,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditarPerfilTextField extends StatelessWidget {
  final String label;
  final String hint;
  final FaIconData icon;
  final TextEditingController? controller;
  final bool obscureText;
  final int maxLines;
  final Color iconColor;
  final ValueChanged<String>? onChanged;
  final Widget? trailing;

  const _EditarPerfilTextField({
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.maxLines = 1,
    this.iconColor = AppColors.textMuted,
    this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: maxLines == 1 ? 52 : null,
          padding: maxLines == 1
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment:
                maxLines == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: maxLines == 1 ? 14 : 0,
                  right: 10,
                  top: maxLines == 1 ? 0 : 2,
                ),
                child: FaIcon(icon, size: 15, color: iconColor),
              ),
              Expanded(
                child: Semantics(
                  label: label,
                  textField: true,
                  child: TextField(
                    controller: controller,
                    obscureText: obscureText,
                    onChanged: onChanged,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: GoogleFonts.inter(
                        fontSize: maxLines == 1 ? 14 : 13,
                        color: AppColors.textMuted,
                      ),
                      isDense: maxLines > 1,
                      contentPadding: maxLines > 1 ? EdgeInsets.zero : null,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: maxLines == 1 ? 14 : 13,
                      color: AppColors.textPrimary,
                      height: maxLines == 1 ? null : 1.5,
                    ),
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ],
    );
  }
}

class _PasswordVisibilityButton extends StatelessWidget {
  final bool isHidden;
  final String semanticLabel;
  final VoidCallback onPressed;

  const _PasswordVisibilityButton({
    required this.isHidden,
    required this.semanticLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: IconButton(
        icon: FaIcon(
          isHidden ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
          size: 15,
          color: AppColors.textMuted,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _SecondarySheetButton extends StatelessWidget {
  final String label;
  final String semanticLabel;
  final VoidCallback onPressed;

  const _SecondarySheetButton({
    required this.label,
    required this.semanticLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.borderLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Semantics(
        label: semanticLabel,
        button: true,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimarySheetButton extends StatelessWidget {
  final String label;
  final String semanticLabel;
  final FaIconData icon;
  final VoidCallback onPressed;

  const _PrimarySheetButton({
    required this.label,
    required this.semanticLabel,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha((0.35 * 255).toInt()),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: Semantics(
        label: semanticLabel,
        button: true,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: FaIcon(icon, size: 15, color: AppColors.surface),
          label: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.surface,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }
}

class _OutlineSheetButton extends StatelessWidget {
  final String label;
  final String semanticLabel;
  final FaIconData icon;
  final VoidCallback onPressed;

  const _OutlineSheetButton({
    required this.label,
    required this.semanticLabel,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Semantics(
        label: semanticLabel,
        button: true,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: FaIcon(icon, size: 14, color: AppColors.primary),
          label: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _DangerSheetButton extends StatelessWidget {
  final String label;
  final String semanticLabel;
  final FaIconData icon;
  final VoidCallback onPressed;

  const _DangerSheetButton({
    required this.label,
    required this.semanticLabel,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Semantics(
        label: semanticLabel,
        button: true,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: FaIcon(icon, size: 14, color: AppColors.dangerText),
          label: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.dangerText,
            ),
          ),
        ),
      ),
    );
  }
}
