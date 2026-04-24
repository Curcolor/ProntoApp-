import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'agente_ia_contexto_screen.dart';

class AgentesIaScreen extends StatefulWidget {
  const AgentesIaScreen({super.key});

  @override
  State<AgentesIaScreen> createState() => _AgentesIaScreenState();
}

class _AgentesIaScreenState extends State<AgentesIaScreen> {
  int _modeloSeleccionado = 0;

  final List<Map<String, String>> _modelos = [
    {'emoji': '⚡', 'nombre': 'GPT-4o Mini', 'desc': 'Rápido · Barato'},
    {'emoji': '🧠', 'nombre': 'GPT-4o', 'desc': 'Avanzado'},
    {'emoji': '🤖', 'nombre': 'Claude Haiku', 'desc': '3.5'},
    {'emoji': '✨', 'nombre': 'Gemini Flash', 'desc': '1.5'},
  ];

  final List<Map<String, dynamic>> _plantillas = [
    {
      'emoji': '🛒',
      'titulo': 'Tomador de Pedidos',
      'desc': 'Toma y confirma pedidos por WhatsApp. Conoce el menú, precios, combos y disponibilidad en tiempo real.',
      'activo': true,
      'interacciones': '1,203 interacciones hoy',
      'tags': ['Pedidos', 'Menú', 'WhatsApp'],
    },
    {
      'emoji': '🎯',
      'titulo': 'Asesor de Ventas',
      'desc': 'Recomienda productos según el perfil del cliente. Sugiere combos y promociones activas para aumentar el ticket promedio.',
      'activo': false,
      'interacciones': 'No activado',
      'tags': ['Ventas', 'Recomendaciones'],
    },
    {
      'emoji': '🚚',
      'titulo': 'Seguimiento de Entrega',
      'desc': 'Informa el estado del pedido al cliente en tiempo real. Notifica retrasos y confirma la entrega exitosa.',
      'activo': false,
      'interacciones': 'No activado',
      'tags': ['Delivery', 'Tracking'],
    },
    {
      'emoji': '💬',
      'titulo': 'Atención al Cliente',
      'desc': 'Responde preguntas frecuentes, gestiona quejas y escala casos complejos al equipo humano.',
      'activo': false,
      'interacciones': 'No activado',
      'tags': ['Soporte', 'FAQ'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHero(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                _buildSectionTitle('Modelo de IA'),
                const SizedBox(height: 8),
                _buildModelSelector(),
                const SizedBox(height: 20),
                _buildSectionTitle('Plantillas de agente'),
                const SizedBox(height: 8),
                ..._plantillas.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPlantillaCard(p),
                    )),
                const SizedBox(height: 8),
                _buildContextoButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final modeloActivo = _modelos[_modeloSeleccionado];
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Agente IA', style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                        Text('Plantilla, modelo y contexto del negocio', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: const FaIcon(FontAwesomeIcons.sliders, color: Colors.white, size: 15),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text(modeloActivo['emoji']!, style: const TextStyle(fontSize: 18))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tomador de Pedidos', style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          Text('${modeloActivo['nombre']} · 1,203 interacciones hoy', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.65), fontSize: 9)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(999)),
                      child: Text('ACTIVO', style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String titulo) {
    return Text(titulo.toUpperCase(), style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8));
  }

  Widget _buildModelSelector() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _modelos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, indice) {
          final modelo = _modelos[indice];
          final seleccionado = _modeloSeleccionado == indice;
          return GestureDetector(
            onTap: () => setState(() => _modeloSeleccionado = indice),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: seleccionado ? const Color(0xFFFAF7FF) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: seleccionado ? const Color(0xFF8B5CF6) : const Color(0xFFE2E8F0)),
                boxShadow: const [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 1), blurRadius: 3)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(modelo['emoji']!, style: const TextStyle(fontSize: 17)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(modelo['nombre']!, style: GoogleFonts.inter(color: seleccionado ? const Color(0xFF8B5CF6) : const Color(0xFF334155), fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(modelo['desc']!, style: GoogleFonts.inter(color: seleccionado ? const Color(0xFF8B5CF6) : const Color(0xFF94A3B8), fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlantillaCard(Map<String, dynamic> plantilla) {
    final activo = plantilla['activo'] as bool;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: activo ? const Color(0xFFFAF7FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: activo ? const Color(0xFF8B5CF6) : const Color(0xFFE2E8F0), width: activo ? 2 : 1),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 1), blurRadius: 3)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(plantilla['emoji'] as String, style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(plantilla['titulo'] as String, style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold))),
                          if (activo)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(999)),
                              child: Text('ACTIVO', style: GoogleFonts.inter(color: const Color(0xFF6D28D9), fontSize: 9, fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(plantilla['desc'] as String, style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11, height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              children: (plantilla['tags'] as List<String>).map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: activo ? const Color(0xFFEDE9FE) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(tag, style: GoogleFonts.inter(color: activo ? const Color(0xFF6D28D9) : const Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.w600)),
              )).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!activo) {
                        setState(() {
                          for (var p in _plantillas) {
                            p['activo'] = false;
                          }
                          plantilla['activo'] = true;
                        });
                      }
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: activo ? const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]) : null,
                        color: activo ? null : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          activo ? 'Plantilla activa' : 'Activar plantilla',
                          style: GoogleFonts.inter(color: activo ? Colors.white : const Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
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

  Widget _buildContextoButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AgenteIaContextoScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF5F0FF), Color(0xFFEDE9FE)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFC4B5FD)),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: const Color(0xFF8B5CF6), borderRadius: BorderRadius.circular(12)),
              child: const FaIcon(FontAwesomeIcons.robot, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contexto del negocio', style: GoogleFonts.inter(color: const Color(0xFF5B21B6), fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('Editar la información que usa la IA para responder', style: GoogleFonts.inter(color: const Color(0xFF7C3AED), fontSize: 11)),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight, color: Color(0xFF8B5CF6), size: 13),
          ],
        ),
      ),
    );
  }
}
