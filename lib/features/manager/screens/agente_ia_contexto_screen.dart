import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/core/constants/app_colors.dart';

class AgenteIaContextoScreen extends StatefulWidget {
  const AgenteIaContextoScreen({super.key});

  @override
  State<AgenteIaContextoScreen> createState() => _AgenteIaContextoScreenState();
}

class _AgenteIaContextoScreenState extends State<AgenteIaContextoScreen> {
  final _controladores = List.generate(5, (_) => TextEditingController());

  final List<Map<String, String>> _pasos = [
    {'titulo': 'Descripción general del negocio', 'desc': 'Tipo de negocio, especialidad, antigüedad, zona.', 'valor': 'Somos una panadería artesanal con 8 años en el mercado, ubicada en el norte de Barranquilla. Nos especializamos en pan de masa madre, pastelería francesa y bebidas de café de origen.'},
    {'titulo': 'Horario y datos de contacto', 'desc': 'Horario real, días de cierre, número de contacto.', 'valor': 'Abrimos lunes a sábado de 6:30 am a 8:00 pm y domingos de 7:00 am a 1:00 pm. No laboramos festivos. Pedidos al 300-111-2233.'},
    {'titulo': 'Políticas de pedido y entrega', 'desc': 'Pedido mínimo, zonas de cobertura, tiempos, pagos.', 'valor': 'Pedido mínimo \$15,000 para domicilio. Entregamos en un radio de 5 km aprox. 30-45 min. Aceptamos efectivo, Nequi y transferencia bancaria. No manejamos tarjetas de crédito.'},
    {'titulo': 'Promociones y ofertas frecuentes', 'desc': 'Descuentos, combos, días especiales.', 'valor': 'Martes: bebidas al 20%. Viernes: combo desayuno \$11,000. Tarjeta de fidelidad: 10 compras = 1 gratis.', 'ejemplo': 'Ejemplo: "Los martes todas las bebidas tienen 20% de descuento. Los viernes hay combo desayuno (café + croissant) por \$11,000."'},
    {'titulo': 'Restricciones y respuestas especiales', 'desc': 'Qué NO puede ofrecer o responder la IA.', 'valor': 'La IA no debe confirmar disponibilidad de tortas especiales (pedido previo 24h). No dar descuentos adicionales a los establecidos. Siempre disculparse si un producto se agota.'},
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _pasos.length; i++) {
      _controladores[i].text = _pasos[i]['valor'] ?? '';
    }
  }

  @override
  void dispose() {
    for (final c in _controladores) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHero(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  children: [
                    _buildSectionTitle('¿Qué le cuentas a la IA?'),
                    const SizedBox(height: 12),
                    ..._pasos.asMap().entries.map((entry) {
                      final paso = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildPasoCard(
                          numero: entry.key + 1,
                          titulo: paso['titulo']!,
                          descripcion: paso['desc']!,
                          controlador: _controladores[entry.key],
                          ejemplo: paso['ejemplo'],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          _buildBotonGuardar(),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
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
                      child: const FaIcon(FontAwesomeIcons.arrowLeft, color: AppColors.surface, size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contexto del negocio', style: GoogleFonts.inter(color: AppColors.surface, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                        Text('Plantilla personalizada · ✏️', style: GoogleFonts.inter(color: AppColors.surface.withValues(alpha: 0.7), fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surface.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.robot, color: AppColors.surface, size: 11),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Toda esta información la usa la IA para responder con precisión a tus clientes por WhatsApp.',
                        style: GoogleFonts.inter(color: AppColors.surface.withValues(alpha: 0.8), fontSize: 11, height: 1.5),
                      ),
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
    return Text(
      titulo.toUpperCase(),
      style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8),
    );
  }

  Widget _buildPasoCard({required int numero, required String titulo, required String descripcion, required TextEditingController controlador, String? ejemplo}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), offset: const Offset(0, 1), blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.aiGradientEnd, AppColors.aiGradientStart], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text('$numero', style: GoogleFonts.inter(color: AppColors.surface, fontSize: 13, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(descripcion, style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 11, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (ejemplo != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 12, 10),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(left: BorderSide(color: AppColors.aiGradientEnd, width: 3)),
                borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
              ),
              child: Text(ejemplo, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 11, fontStyle: FontStyle.italic, height: 1.6)),
            ),
            const SizedBox(height: 10),
          ],
          Container(
            constraints: const BoxConstraints(minHeight: 80),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: controlador,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(13),
                border: InputBorder.none,
                hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
              ),
              style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonGuardar() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0.0)],
            stops: const [0.7, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.successIcon, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.successIcon.withValues(alpha: 0.35), offset: const Offset(0, 4), blurRadius: 14)],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const FaIcon(FontAwesomeIcons.floppyDisk, color: AppColors.surface, size: 16),
                const SizedBox(width: 8),
                Text('Guardar contexto del negocio', style: GoogleFonts.inter(color: AppColors.surface, fontSize: 16, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
