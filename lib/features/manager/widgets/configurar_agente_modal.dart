import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigurarAgenteModal extends StatefulWidget {
  const ConfigurarAgenteModal({super.key});

  @override
  State<ConfigurarAgenteModal> createState() => _ConfigurarAgenteModalState();
}

class _ConfigurarAgenteModalState extends State<ConfigurarAgenteModal> {
  String _modoRespuesta = 'automatico'; // automatico, semi, manual
  bool _modoNocturno = true;
  final TextEditingController _mensajeController = TextEditingController(
    text: '¡Hola! 👋 Gracias por escribirnos. Soy Prontoa, tu asistente virtual. ¿Qué deseas pedir hoy?',
  );

  @override
  void initState() {
    super.initState();
    _cargarConfiguracion();
  }

  Future<void> _cargarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _modoRespuesta = prefs.getString('ia_modo_respuesta') ?? 'automatico';
      _modoNocturno = prefs.getBool('ia_modo_nocturno') ?? true;
      _mensajeController.text = prefs.getString('ia_mensaje_bienvenida') ?? _mensajeController.text;
    });
  }

  Future<void> _guardarConfiguracion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ia_modo_respuesta', _modoRespuesta);
    await prefs.setBool('ia_modo_nocturno', _modoNocturno);
    await prefs.setString('ia_mensaje_bienvenida', _mensajeController.text);
    
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _mensajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configurar Agente IA',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Personaliza cómo tu IA interactúa con los clientes.',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Modo de respuesta
                    Text(
                      'Modo de respuesta',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildModoBoton(
                            id: 'automatico',
                            titulo: 'Automático',
                            icono: FontAwesomeIcons.robot,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildModoBoton(
                            id: 'semi',
                            titulo: 'Semi-auto',
                            icono: FontAwesomeIcons.userClock,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildModoBoton(
                            id: 'manual',
                            titulo: 'Manual',
                            icono: FontAwesomeIcons.user,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Modo nocturno
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Modo nocturno',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Respuestas fuera de horario',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textTertiary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _modoNocturno,
                            onChanged: (val) => setState(() => _modoNocturno = val),
                            activeColor: AppColors.surface,
                            activeTrackColor: AppColors.primary,
                            inactiveThumbColor: AppColors.toggleInactiveThumb,
                            inactiveTrackColor: AppColors.toggleInactiveBg,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Mensaje de bienvenida
                    Text(
                      'Mensaje de bienvenida',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _mensajeController,
                        maxLines: 4,
                        minLines: 3,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Botones
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.borderLight, // #f1f5f9
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  offset: const Offset(0, 4),
                                  blurRadius: 7,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _guardarConfiguracion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(FontAwesomeIcons.robot, color: Colors.white, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Guardar config.',
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
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModoBoton({
    required String id,
    required String titulo,
    required FaIconData icono,
  }) {
    final activo = _modoRespuesta == id;
    
    return GestureDetector(
      onTap: () => setState(() => _modoRespuesta = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: activo ? AppColors.successBg : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: activo ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            FaIcon(
              icono,
              color: activo ? AppColors.primaryDark : AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: GoogleFonts.inter(
                color: activo ? AppColors.primaryDark : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
