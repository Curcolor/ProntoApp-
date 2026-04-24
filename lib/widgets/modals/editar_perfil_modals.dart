import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditarPerfilModals {
  static void showEditarCorreo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BaseEditBottomSheet(
        title: 'Editar correo electrónico',
        subtitle: 'El correo es tu identificador de acceso a Prontoa.',
        currentLabel: 'Correo actual',
        currentValue: 'carlos.mendoza@correo.com',
        currentIcon: FontAwesomeIcons.solidEnvelope,
        inputLabel1: 'Nuevo correo electrónico',
        inputHint1: 'nuevo@correo.com',
        inputIcon1: FontAwesomeIcons.solidEnvelope,
        inputLabel2: 'Confirmar nuevo correo',
        inputHint2: 'nuevo@correo.com',
        inputIcon2: FontAwesomeIcons.solidCheckCircle,
        infoText: 'Te enviaremos un enlace de verificación al nuevo correo antes de aplicar el cambio.',
        submitText: 'Enviar verificación',
        submitIcon: FontAwesomeIcons.paperPlane,
      ),
    );
  }

  static void showEditarTelefono(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BaseEditBottomSheet(
        title: 'Editar teléfono',
        subtitle: 'Tu número es usado para contactarte y para iniciar sesión.',
        currentLabel: 'Teléfono actual',
        currentValue: '+57 315 888 4422',
        currentIcon: FontAwesomeIcons.phoneAlt,
        inputLabel1: 'Nuevo número de teléfono',
        inputHint1: '+57 300 000 0000',
        inputIcon1: FontAwesomeIcons.phoneAlt,
        inputLabel2: 'Confirmar nuevo número',
        inputHint2: '+57 300 000 0000',
        inputIcon2: FontAwesomeIcons.solidCheckCircle,
        infoText: 'Se requerirá confirmación vía SMS.',
        submitText: 'Guardar cambios',
        submitIcon: FontAwesomeIcons.save,
      ),
    );
  }

  // Pop 06 — Cambiar contraseña (nodo 2234:887)
  static void showCambiarContrasena(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CambiarContrasenaSheet(),
    );
  }

  // Pop 03 — Editar Ubicación (nodo 2234:536)
  static void showEditarUbicacion(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BaseEditBottomSheet(
        title: 'Ubicación del negocio',
        subtitle: 'Dirección donde operas y recibes domicilios.',
        currentLabel: 'Dirección actual',
        currentValue: 'Barrio El Prado, Barranquilla',
        currentIcon: FontAwesomeIcons.locationDot,
        inputLabel1: 'Dirección',
        inputHint1: 'Cll 72 #45-12',
        inputIcon1: FontAwesomeIcons.locationDot,
        inputLabel2: 'Punto de referencia',
        inputHint2: 'Ej: Frente al Parque Bolívar',
        inputIcon2: FontAwesomeIcons.infoCircle,
        infoText: 'Esta dirección será visible para tus repartidores.',
        submitText: 'Guardar ubicación',
        submitIcon: FontAwesomeIcons.locationDot,
      ),
    );
  }

  // Pop 04 — Editar Negocio (nodo 2234:624)
  static void showEditarNegocio(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _EditarNegocioSheet(),
    );
  }

  // Pop 05 — WhatsApp Business (nodo 2234:703)
  static void showWhatsappBusiness(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _WhatsAppBusinessSheet(),
    );
  }
}


class _BaseEditBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String currentLabel;
  final String currentValue;
  final IconData currentIcon;
  final String inputLabel1;
  final String inputHint1;
  final IconData inputIcon1;
  final String inputLabel2;
  final String inputHint2;
  final IconData inputIcon2;
  final String infoText;
  final String submitText;
  final IconData submitIcon;
  final bool obscureText;

  const _BaseEditBottomSheet({
    required this.title,
    required this.subtitle,
    required this.currentLabel,
    required this.currentValue,
    required this.currentIcon,
    required this.inputLabel1,
    required this.inputHint1,
    required this.inputIcon1,
    required this.inputLabel2,
    required this.inputHint2,
    required this.inputIcon2,
    required this.infoText,
    required this.submitText,
    required this.submitIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 24),
          
          // Current Value Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: const Color(0xFFBBF7D0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                FaIcon(currentIcon, size: 14, color: const Color(0xFF1DB954)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentValue,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF128C7E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Inputs
          _buildInputGroup(inputLabel1, inputHint1, inputIcon1),
          const SizedBox(height: 16),
          _buildInputGroup(inputLabel2, inputHint2, inputIcon2),
          
          const SizedBox(height: 20),
          
          // Info Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: FaIcon(FontAwesomeIcons.infoCircle, size: 14, color: Color(0xFF1DB954)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    infoText,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 28),
          
          // Buttons
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Color(0x5925D366), offset: Offset(0, 4), blurRadius: 14)],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(submitIcon, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          submitText,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputGroup(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: FaIcon(icon, size: 16, color: const Color(0xFF94A3B8)),
              ),
              Expanded(
                child: TextField(
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF757575),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pop 05 — WhatsApp Business sheet (nodo Figma: 2234:703)
class _WhatsAppBusinessSheet extends StatelessWidget {
  const _WhatsAppBusinessSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          Text(
            'WhatsApp Business',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), letterSpacing: -0.3),
          ),
          const SizedBox(height: 4),
          Text(
            'Gestiona la conexión de tu número empresarial.',
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 20),

          // Estado de conexión
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: const Color(0xFFBBF7D0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: const BoxDecoration(color: Color(0xFF25D366), shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conectado y activo',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF128C7E)),
                      ),
                      Text(
                        '+57 300 123 4567 · 3 sesiones activas',
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // QR Code placeholder
          Center(
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(FontAwesomeIcons.qrcode, size: 64, color: Color(0xFF334155)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Escanea para reconectar desde otro dispositivo',
              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // Botones
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF25D366)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const FaIcon(FontAwesomeIcons.rotate, size: 14, color: Color(0xFF25D366)),
                    label: Text('Reconectar', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF25D366))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const FaIcon(FontAwesomeIcons.linkSlash, size: 14, color: Color(0xFFB91C1C)),
                    label: Text('Desconectar', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFB91C1C))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Pop 06 — Cambiar contraseña (nodo 2234:887)
// ─────────────────────────────────────────────
class _CambiarContrasenaSheet extends StatefulWidget {
  const _CambiarContrasenaSheet();

  @override
  State<_CambiarContrasenaSheet> createState() => _CambiarContrasenaSheetState();
}

class _CambiarContrasenaSheetState extends State<_CambiarContrasenaSheet> {
  final _actualCtrl = TextEditingController();
  final _nuevaCtrl  = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _ocultarActual   = true;
  bool _ocultarNueva    = true;
  bool _ocultarConfirm  = true;

  /// Nivel de fortaleza: 0=vacío 1=débil 2=media 3=fuerte
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
      case 1: return 'Contraseña débil';
      case 2: return 'Contraseña media';
      case 3: return 'Contraseña segura ✓';
      default: return '';
    }
  }

  Color get _fortalezaColor {
    switch (_fortaleza) {
      case 1: return const Color(0xFFEF4444);
      case 2: return const Color(0xFFF59E0B);
      case 3: return const Color(0xFF25D366);
      default: return Colors.transparent;
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
        color: Colors.white,
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
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          Text(
            'Cambiar contraseña',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), letterSpacing: -0.3),
          ),
          const SizedBox(height: 4),
          Text(
            'Usa mínimo 8 caracteres, combina letras y números.',
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 24),

          // Campo: Contraseña actual
          _buildLabel('Contraseña actual'),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _actualCtrl,
            hint: '••••••••',
            icono: FontAwesomeIcons.lock,
            ocultar: _ocultarActual,
            onToggle: () => setState(() => _ocultarActual = !_ocultarActual),
          ),
          const SizedBox(height: 16),

          // Campo: Nueva contraseña
          _buildLabel('Nueva contraseña'),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _nuevaCtrl,
            hint: 'Mínimo 8 caracteres',
            icono: FontAwesomeIcons.lockOpen,
            ocultar: _ocultarNueva,
            onToggle: () => setState(() => _ocultarNueva = !_ocultarNueva),
            onChanged: _evaluarFortaleza,
          ),

          // Indicador de fortaleza
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

          // Campo: Confirmar contraseña
          _buildLabel('Confirmar contraseña'),
          const SizedBox(height: 8),
          _buildPasswordField(
            controller: _confirmCtrl,
            hint: 'Repite la nueva contraseña',
            icono: FontAwesomeIcons.solidCheckCircle,
            ocultar: _ocultarConfirm,
            onToggle: () => setState(() => _ocultarConfirm = !_ocultarConfirm),
            iconoColor: _confirmCtrl.text.isNotEmpty && _confirmCtrl.text == _nuevaCtrl.text
                ? const Color(0xFF25D366)
                : const Color(0xFF94A3B8),
          ),
          const SizedBox(height: 28),

          // Botones
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('Cancelar', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Color(0x5925D366), offset: Offset(0, 4), blurRadius: 14)],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const FaIcon(FontAwesomeIcons.shieldHalved, size: 15, color: Colors.white),
                    label: Text('Actualizar', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String texto) => Text(
    texto,
    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
  );

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required IconData icono,
    required bool ocultar,
    required VoidCallback onToggle,
    void Function(String)? onChanged,
    Color iconoColor = const Color(0xFF94A3B8),
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: FaIcon(icono, size: 15, color: iconoColor),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: ocultar,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
              ),
              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0F172A)),
            ),
          ),
          IconButton(
            icon: FaIcon(
              ocultar ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
              size: 15,
              color: const Color(0xFF94A3B8),
            ),
            onPressed: onToggle,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Pop 04 — Información del negocio (nodo 2234:624)
// ─────────────────────────────────────────────
class _EditarNegocioSheet extends StatefulWidget {
  const _EditarNegocioSheet();

  @override
  State<_EditarNegocioSheet> createState() => _EditarNegocioSheetState();
}

class _EditarNegocioSheetState extends State<_EditarNegocioSheet> {
  final _nombreCtrl = TextEditingController(text: 'Panadería El Trigo Dorado');
  final _descripCtrl = TextEditingController(
    text: 'Panadería artesanal con los mejores productos de la región, abiertos desde 1998.',
  );

  String _tipoNegocio = '🥐 Panadería';
  final List<String> _tiposNegocio = [
    '🥐 Panadería',
    '☕ Cafetería',
    '🍕 Restaurante',
    '🛒 Tienda',
    '💊 Farmacia',
    '📦 Otro',
  ];

  /// Días de la semana: índice 0=L, 1=Ma, 2=Mi, 3=J, 4=V, 5=S, 6=D
  final List<bool> _diasActivos = [true, true, true, true, true, true, false];
  final List<String> _diasLabel = ['L', 'Ma', 'Mi', 'J', 'V', 'S', 'D'];

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
        color: Colors.white,
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
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 24),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),

            Text(
              'Información del negocio',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), letterSpacing: -0.3),
            ),
            const SizedBox(height: 4),
            Text(
              'Datos que aparecen en tus mensajes de WhatsApp.',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 24),

            // Campo: Nombre del negocio
            _buildLabel('Nombre del negocio'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nombreCtrl,
              hint: 'Nombre de tu negocio',
              icono: FontAwesomeIcons.shop,
            ),
            const SizedBox(height: 16),

            // Dropdown: Tipo de negocio
            _buildLabel('Tipo de negocio'),
            const SizedBox(height: 8),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _tipoNegocio,
                  isExpanded: true,
                  icon: const FaIcon(FontAwesomeIcons.chevronDown, size: 13, color: Color(0xFF94A3B8)),
                  style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0F172A)),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  items: _tiposNegocio.map((tipo) => DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0F172A))),
                  )).toList(),
                  onChanged: (val) => setState(() => _tipoNegocio = val!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Textarea: Descripción corta
            _buildLabel('Descripción corta (para respuestas IA)'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: TextField(
                controller: _descripCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Describe brevemente tu negocio...',
                  hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0F172A), height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // Chips: Días activos
            _buildLabel('Días activos'),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_diasLabel.length, (i) {
                final activo = _diasActivos[i];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _diasActivos[i] = !_diasActivos[i]),
                    child: Container(
                      margin: EdgeInsets.only(right: i < _diasLabel.length - 1 ? 6 : 0),
                      height: 36,
                      decoration: BoxDecoration(
                        color: activo ? const Color(0xFF25D366) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _diasLabel[i],
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: activo ? Colors.white : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            // Botones
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: Text('Cancelar', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Color(0x5925D366), offset: Offset(0, 4), blurRadius: 14)],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk, size: 15, color: Colors.white),
                      label: Text('Guardar', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String texto) => Text(
    texto,
    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icono,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: FaIcon(icono, size: 15, color: const Color(0xFF94A3B8)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
              ),
              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0F172A)),
            ),
          ),
        ],
      ),
    );
  }
}
