import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Un paso del tutorial guiado: a qué elemento apunta + el texto.
class TutorialPaso {
  final GlobalKey objetivo;
  final String titulo;
  final String descripcion;
  const TutorialPaso({
    required this.objetivo,
    required this.titulo,
    required this.descripcion,
  });
}

/// Overlay de tutorial estilo "coach marks": oscurece la pantalla con un
/// recorte (spotlight) sobre el elemento objetivo + una tarjeta explicativa.
/// Avanza con "Siguiente" o tocando el fondo; "Saltar" cierra.
class DemoTutorial extends StatefulWidget {
  final List<TutorialPaso> pasos;
  final VoidCallback onCerrar;

  const DemoTutorial({super.key, required this.pasos, required this.onCerrar});

  @override
  State<DemoTutorial> createState() => _DemoTutorialState();
}

class _DemoTutorialState extends State<DemoTutorial> {
  int _i = 0;

  void _siguiente() {
    if (_i < widget.pasos.length - 1) {
      setState(() => _i++);
      // el rect del nuevo objetivo puede necesitar un frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    } else {
      widget.onCerrar();
    }
  }

  Rect? _rectObjetivo() {
    final ctx = widget.pasos[_i].objetivo.currentContext;
    final box = ctx?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  Widget build(BuildContext context) {
    final paso = widget.pasos[_i];
    final rect = _rectObjetivo();
    if (rect == null) {
      // Aún no hay layout del objetivo: reintenta el próximo frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
    final hueco = rect?.inflate(6);
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _siguiente,
            child: CustomPaint(painter: _SpotlightPainter(hueco)),
          ),
        ),
        if (hueco != null) _tarjeta(paso, hueco, size),
      ],
    );
  }

  Widget _tarjeta(TutorialPaso paso, Rect hueco, Size size) {
    // Si el objetivo está en la mitad superior, la tarjeta va debajo; si no, arriba.
    final objetivoArriba = hueco.center.dy < size.height * 0.5;
    final esUltimo = _i == widget.pasos.length - 1;

    return Positioned(
      left: 20,
      right: 20,
      top: objetivoArriba ? hueco.bottom + 14 : null,
      bottom: objetivoArriba ? null : size.height - hueco.top + 14,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 8)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                paso.titulo,
                style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                paso.descripcion,
                style: GoogleFonts.inter(
                    color: const Color(0xFF475569), fontSize: 13, height: 1.45),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_i + 1} / ${widget.pasos.length}',
                    style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: widget.onCerrar,
                        child: Text('Saltar',
                            style: GoogleFonts.inter(
                                color: const Color(0xFF64748B),
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: _siguiente,
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

/// Pinta negro semi-transparente sobre toda la pantalla, con un recorte
/// redondeado (spotlight) alrededor del objetivo + un borde verde.
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
