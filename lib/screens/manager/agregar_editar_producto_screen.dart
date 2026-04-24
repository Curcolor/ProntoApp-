import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgregarEditarProductoScreen extends StatefulWidget {
  const AgregarEditarProductoScreen({super.key});

  @override
  State<AgregarEditarProductoScreen> createState() => _AgregarEditarProductoScreenState();
}

class _AgregarEditarProductoScreenState extends State<AgregarEditarProductoScreen> {
  bool _isAvailable = true;
  bool _aiActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    children: [
                      _buildImageUpload(),
                      const SizedBox(height: 24),
                      _buildInputField(
                        label: 'Nombre del producto *',
                        hintText: 'Ej: Croissant de jamón y queso',
                        icon: FontAwesomeIcons.tag,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Categoría *',
                              value: '🥐 Panadería',
                              icon: FontAwesomeIcons.layerGroup,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPriceField(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Stock inicial',
                              hintText: '0',
                              icon: FontAwesomeIcons.boxesStacked,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInputField(
                              label: 'Alerta mínima',
                              hintText: 'Ej: 5',
                              icon: FontAwesomeIcons.triangleExclamation,
                              iconColor: const Color(0xFFF59E0B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInputField(
                              label: 'Tiempo preparación',
                              hintText: 'Ej: 10 min',
                              icon: FontAwesomeIcons.clock,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSwitchField(
                              label: 'Disponibilidad',
                              text: _isAvailable ? 'Activo' : 'Inactivo',
                              value: _isAvailable,
                              onChanged: (val) => setState(() => _isAvailable = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextAreaField(
                        label: 'Descripción del producto',
                        text: 'Delicioso croissant hecho de hojaldre con relleno de jamón ibérico y queso gouda. Servido tibio.',
                      ),
                      const SizedBox(height: 24),
                      _buildAiContextSection(),
                      const SizedBox(height: 16),
                      _buildAiActiveToggle(),
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ],
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
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
          const SizedBox(width: 12),
          Text(
            'Nuevo producto',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto del producto',
          style: GoogleFonts.inter(
            color: const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 138,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFCBD5E1),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.camera,
                color: Color(0xFF94A3B8),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                'Agregar foto',
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'JPG, PNG · Máx. 5 MB',
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required FaIconData icon,
    Color iconColor = const Color(0xFF94A3B8),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              FaIcon(icon, color: iconColor, size: 16),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF757575),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required FaIconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              FaIcon(icon, color: const Color(0xFF94A3B8), size: 16),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 15,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Precio *',
          style: GoogleFonts.inter(
            color: const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Text(
                '\$',
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: GoogleFonts.inter(
                      color: const Color(0xFF757575),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchField({
    required String label,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 15, right: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: GoogleFonts.inter(
                  color: const Color(0xFF334155),
                  fontSize: 13,
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF25D366),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFE2E8F0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextAreaField({
    required String label,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(minHeight: 90),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFF1E293B),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiContextSection() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F0FF), Color(0xFFEDE9FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC4B5FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Center(
                  child: FaIcon(FontAwesomeIcons.robot, color: Colors.white, size: 14),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contexto para la IA',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF5B21B6),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ayuda al agente a responder mejor sobre este\nproducto',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7C3AED),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 100,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC4B5FD)),
            ),
            child: Text(
              'Producto estrella de la tienda. Es apto para personas con intolerancia leve a la lactosa si se pide sin queso. Va bien con el café latte especial. Los lunes trae descuento. Disponible solo hasta las 12 pm porque se hornea temprano en la mañana.',
              style: GoogleFonts.inter(
                color: const Color(0xFF1E293B),
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildAiTip('Menciona alergenos, ingredientes alternativos o restricciones dietéticas.'),
          const SizedBox(height: 6),
          _buildAiTip('Indica horarios especiales o promociones frecuentes.'),
          const SizedBox(height: 6),
          _buildAiTip('Agrega maridajes o productos recomendados junto a este.'),
        ],
      ),
    );
  }

  Widget _buildAiTip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: FaIcon(FontAwesomeIcons.lightbulb, color: Color(0xFF8B5CF6), size: 11),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFF6D28D9),
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiActiveToggle() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.robot, color: Color(0xFF8B5CF6), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IA activa para este producto',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'La IA puede recomendarlo activamente en\nconversaciones',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _aiActive,
            onChanged: (val) => setState(() => _aiActive = val),
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF25D366),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE2E8F0),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x5925D366), // 0.35 alpha
                    offset: Offset(0, 4),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.floppyDisk, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Guardar producto',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
