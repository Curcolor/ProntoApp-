import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Overlay presentacional del tutorial guiado ("coach marks"): oscurece la
/// pantalla con un recorte (spotlight) sobre [objetivo] + una tarjeta con
/// [titulo]/[descripcion] y controles. El paso a paso lo maneja el padre
/// (DemoScreen), que resuelve el rect y los textos de cada paso.
class DemoTutorial extends StatelessWidget {
  final Rect? objetivo;
  final String titulo;
  final String descripcion;
  final int indice; // 0-based
  final int total;
  final VoidCallback onSiguiente;
  final VoidCallback onSaltar;

  const DemoTutorial({
    super.key,
    required this.objetivo,
    required this.titulo,
    required this.descripcion,
    required this.indice,
    required this.total,
    required this.onSiguiente,
    required this.onSaltar,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hueco = objetivo?.inflate(6);
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onSiguiente,
            child: CustomPaint(painter: _SpotlightPainter(hueco)),
          ),
        ),
        _tarjeta(hueco, size),
      ],
    );
  }

  Widget _tarjeta(Rect? hueco, Size size) {
    final esUltimo = indice >= total - 1;
    // Si hay objetivo: tarjeta arriba o abajo de él (donde quepa). Si no: centrada.
    double? top, bottom;
    if (hueco != null) {
      final objetivoArriba = hueco.center.dy < size.height * 0.55;
      top = objetivoArriba ? hueco.bottom + 14 : null;
      bottom = objetivoArriba ? null : size.height - hueco.top + 14;
    } else {
      top = size.height * 0.5 - 90;
    }

    return Positioned(
      left: 20,
      right: 20,
      top: top,
      bottom: bottom,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 8)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                titulo,
                style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                descripcion,
                style: GoogleFonts.inter(
                    color: const Color(0xFF475569), fontSize: 13, height: 1.45),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Puntos de progreso
                  Row(
                    children: List.generate(total, (i) {
                      final activo = i == indice;
                      return Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: activo ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: activo
                              ? const Color(0xFF25D366)
                              : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: onSaltar,
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10)),
                        child: Text('Saltar',
                            style: GoogleFonts.inter(
                                color: const Color(0xFF64748B),
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: onSiguiente,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999)),
                        ),
                        child: Text(esUltimo ? 'Entendido' : 'Siguiente',
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect? hueco;
  _SpotlightPainter(this.hueco);

  @override
  void paint(Canvas canvas, Size size) {
    final fondo = Paint()..color = Colors.black.withValues(alpha: 0.76);
    final rectPantalla = Offset.zero & size;
    if (hueco == null) {
      canvas.drawRect(rectPantalla, fondo);
      return;
    }
    final rrect = RRect.fromRectAndRadius(hueco!, const Radius.circular(12));
    final completo = Path()..addRect(rectPantalla);
    final agujero = Path()..addRRect(rrect);
    canvas.drawPath(
      Path.combine(PathOperation.difference, completo, agujero),
      fondo,
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0xFF25D366)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.hueco != hueco;
}
