import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/features/manager/screens/dashboard_screen.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              // Glowing WhatsApp Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1BA672), // Custom vibrant green
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1BA672).withAlpha(100),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 50),
                ),
              ),
              const SizedBox(height: 40),
              // Titles
              Text(
                '¡Sincronizando \'Mi\nPanadería\'!',
                style: GoogleFonts.inter(
                  fontSize: 28, 
                  fontWeight: FontWeight.w800, 
                  color: const Color(0xFF0F172A), 
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Nuestra IA está configurando tu agente de\nWhatsApp...',
                style: GoogleFonts.inter(
                  fontSize: 15, 
                  color: const Color(0xFF64748B), 
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              
              // Checklist
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildChecklistItem('Activando Respuestas Inteligentes...'),
                    const SizedBox(height: 20),
                    _buildChecklistItem('Cargando Menú y Precios...'),
                    const SizedBox(height: 20),
                    _buildChecklistItem('Vinculando Chatbot...'),
                    const SizedBox(height: 20),
                    _buildChecklistItem('Preparando tu Dashboard...'),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Button
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withAlpha(80), 
                      blurRadius: 20, 
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (_) => const DashboardScreen())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¡Empieza a Vender!', 
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)
                      ),
                      const SizedBox(width: 8),
                      const FaIcon(FontAwesomeIcons.arrowRight, size: 16, color: Colors.white),
                    ]
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Row(
      children: [
        const FaIcon(FontAwesomeIcons.solidCircleCheck, color: Color(0xFF22C55E), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }
}

@Preview(name: 'Procesando', group: 'Auth', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget processingScreenPreview() => const ProcessingScreen();

