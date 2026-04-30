import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/features/manager/data/providers/order_provider.dart';
import 'agente_ia_contexto_screen.dart';

class AgentesIaScreen extends StatefulWidget {
  const AgentesIaScreen({super.key});

  @override
  State<AgentesIaScreen> createState() => _AgentesIaScreenState();
}

class _AgentesIaScreenState extends State<AgentesIaScreen> {
  int _modeloSeleccionado = 0;

  final List<Map<String, String>> _modelos = [
    {'emoji': '🐋', 'nombre': 'DeepSeek', 'desc': 'Bot de Telegram'},
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
      backgroundColor: AppColors.background,
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
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final bool conectada = orderProvider.estaConectado;
        final int interacciones = orderProvider.pedidos.length;

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.aiGradientStart, AppColors.aiGradientEnd],
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
                          decoration: BoxDecoration(color: AppColors.surface.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: const Center(child: FaIcon(FontAwesomeIcons.arrowLeft, color: AppColors.surface, size: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Agente IA', style: GoogleFonts.inter(color: AppColors.surface, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                            Text('Plantilla, modelo y contexto del negocio', 
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.inter(color: AppColors.surface.withValues(alpha: 0.7), fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(color: AppColors.surface.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                        child: const Center(child: FaIcon(FontAwesomeIcons.sliders, color: AppColors.surface, size: 15)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surface.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: AppColors.surface.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                          child: Center(child: Text(modeloActivo['emoji']!, style: const TextStyle(fontSize: 18))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tomador de Pedidos', 
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(color: AppColors.surface, fontSize: 13, fontWeight: FontWeight.bold)),
                              Text('${modeloActivo['nombre']} · $interacciones interacciones hoy', 
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(color: AppColors.surface.withValues(alpha: 0.65), fontSize: 9)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: conectada ? AppColors.primary : AppColors.warningBg, 
                            borderRadius: BorderRadius.circular(999)
                          ),
                          child: Text(conectada ? 'ACTIVO' : 'SIN CONEXIÓN', 
                              style: GoogleFonts.inter(
                                color: conectada ? AppColors.surface : AppColors.warningText, 
                                fontSize: 9, 
                                fontWeight: FontWeight.w800
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String titulo) {
    return Text(titulo.toUpperCase(), style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8));
  }

  Widget _buildModelSelector() {
    return SizedBox(
      height: 52,
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
                color: seleccionado ? AppColors.aiHighlight : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: seleccionado ? AppColors.aiGradientEnd : AppColors.border),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), offset: const Offset(0, 1), blurRadius: 3)],
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
                      Text(modelo['nombre']!, style: GoogleFonts.inter(color: seleccionado ? AppColors.aiGradientEnd : AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text(modelo['desc']!, style: GoogleFonts.inter(color: seleccionado ? AppColors.aiGradientEnd : AppColors.textMuted, fontSize: 9)),
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
          color: activo ? AppColors.aiHighlight : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: activo ? AppColors.aiGradientEnd : AppColors.border, width: activo ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), offset: const Offset(0, 1), blurRadius: 3)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.aiBg, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(plantilla['emoji'] as String, style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(plantilla['titulo'] as String, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold))),
                          if (activo)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.aiBg, borderRadius: BorderRadius.circular(999)),
                              child: Text('ACTIVO', style: GoogleFonts.inter(color: AppColors.aiText, fontSize: 9, fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(plantilla['desc'] as String, style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 11, height: 1.5)),
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
                  color: activo ? AppColors.aiBg : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(tag, style: GoogleFonts.inter(color: activo ? AppColors.aiText : AppColors.textTertiary, fontSize: 9, fontWeight: FontWeight.w600)),
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
                        gradient: activo ? const LinearGradient(colors: [AppColors.aiGradientEnd, AppColors.aiGradientStart]) : null,
                        color: activo ? null : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          activo ? 'Plantilla activa' : 'Activar plantilla',
                          style: GoogleFonts.inter(color: activo ? AppColors.surface : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
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
          gradient: const LinearGradient(colors: [AppColors.aiBg, AppColors.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.aiGradientStart.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: AppColors.aiGradientEnd, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: FaIcon(FontAwesomeIcons.robot, color: AppColors.surface, size: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contexto del negocio', style: GoogleFonts.inter(color: AppColors.aiGradientEnd, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('Editar la información que usa la IA para responder', style: GoogleFonts.inter(color: AppColors.aiGradientStart, fontSize: 11)),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight, color: AppColors.aiGradientEnd, size: 13),
          ],
        ),
      ),
    );
  }
}
