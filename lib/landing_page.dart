import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:prontoapp/screens/auth/login_screen.dart';
import 'package:prontoapp/screens/auth/register_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF25D366),
              Color(0xFF128C7E),
              Color(0xFF075E54),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Círculos de luz decorativos de fondo
            Positioned(
              left: -50,
              top: -80,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha((0.06 * 255).toInt()),
                ),
              ),
            ),
            Positioned(
              left: -120,
              bottom: 100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha((0.04 * 255).toInt()),
                ),
              ),
            ),
            
            // Contenido principal
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Prontoa!
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.7, sigmaY: 8.7),
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha((0.15 * 255).toInt()),
                              ),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Prontoa!',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 26,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Celulares superpuestos (Phone mockups)
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Celular de atrás
                        Positioned(
                          right: -10,
                          top: 20,
                          child: Transform.rotate(
                            angle: -0.18, // Ángulo ligero a la izquierda
                            child: _buildPhoneMockup(
                              opacity: 0.08,
                              height: 360,     // Mucho más alto, como un celular real
                              messages: [
                                const SizedBox(height: 10),
                                _buildChatBubble("¿Hacen domicilios?", isMe: false),
                                _buildChatBubble("Sí, llegará en 20\nmin 🛵", isMe: true),
                              ],
                            ),
                          ),
                        ),
                        // Celular de adelante (superpuesto sobre el de atrás)
                        Positioned(
                          right: 80,       // Más a la izquierda para superponerse
                          top: 110,        // Más abajo
                          child: Transform.rotate(
                            angle: -0.09,  // Ligeramente doblado, pero menos que el de atrás
                            child: _buildPhoneMockup(
                              opacity: 0.15,
                              height: 380,
                              messages: [
                                const SizedBox(height: 20),
                                _buildChatBubble("Hola, quiero pedir 2\npan de bono 🍞", isMe: false),
                                _buildChatBubble("¡Listo! Tu pedido\nestá confirmado ✅", isMe: true),
                                _buildChatBubble("Perfecto!", isMe: false),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sección inferior (Textos y Botones)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // La viñeta de "IA para negocios locales" justo arriba del título
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.7, sigmaY: 8.7),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha((0.2 * 255).toInt()),
                                border: Border.all(color: Colors.white.withAlpha(50), width: 1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const FaIcon(FontAwesomeIcons.robot, color: Colors.white, size: 12),
                                  const SizedBox(width: 8),
                                  Text(
                                    'IA para negocios locales — Barranquilla',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Título
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w800,
                              fontSize: 34,
                              height: 1.15,
                              letterSpacing: -0.5,
                              color: Colors.white,
                            ),
                            children: const [
                              TextSpan(text: 'Automatiza tus\npedidos de '),
                              TextSpan(
                                text: 'WhatsApp',
                                style: TextStyle(color: Color(0xFFFFD15C)), // WhatsApp en amarillo
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Descripción
                        Text(
                          'Reduce los tiempos de respuesta de 18 a menos de 5 minutos. Sin complicaciones, sin código.',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            height: 1.5,
                            color: Colors.white.withAlpha(220),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Caja de Estadísticas
                        ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.7, sigmaY: 8.7),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha((0.15 * 255).toInt()),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatItem('31K+', 'Negocios'),
                                  _buildVerticalDivider(),
                                  _buildStatItem('<5min', 'Respuesta'),
                                  _buildVerticalDivider(),
                                  _buildStatItem('52%', 'Adopción IA'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Botón CTA: "Comenzar Gratis" (Lleva al registro)
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            icon: const FaIcon(FontAwesomeIcons.play, color: Color(0xFF075E54), size: 16),
                            label: Text(
                              'Comenzar Gratis',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF075E54),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF075E54),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Botón secundario: Iniciar sesión
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              '¿Ya tienes cuenta? Inicia sesión',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Botón "Ver Demo"
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const FaIcon(FontAwesomeIcons.eye, color: Colors.white, size: 16),
                            label: Text(
                              'Ver Demo',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white.withAlpha(128)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withAlpha(40),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // Celular Mockup mejorado
  Widget _buildPhoneMockup({required List<Widget> messages, required double opacity, required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32), // Esquinas bien redondeadas estilo iPhone
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0), // Blur potente
        child: Container(
          width: 180, // Ligeramente más ancho
          height: height,
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((opacity * 255).toInt()),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withAlpha((opacity * 0.8 * 255).toInt()), // Borde translúcido
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Muesca / Isla dinámica del celular
              Center(
                child: Container(
                  width: 65,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(60), // Grisáceo brillante
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Burbujas
              ...messages.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: m,
              )),
              // Para empujar el contenido hacia arriba dando efecto de cortado por abajo
              const Spacer(), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, {required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isMe 
              ? const Color(0xFF25D366).withAlpha((0.85 * 255).toInt()) // Verde vibrante
              : Colors.white.withAlpha((0.35 * 255).toInt()),           // Blanco más sólido
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 3),
            bottomRight: Radius.circular(isMe ? 3 : 12),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
