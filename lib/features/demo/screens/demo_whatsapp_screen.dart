import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Mensaje del guion del chat simulado.
class _Msg {
  final String texto;
  final bool delCliente; // true = burbuja derecha (cliente); false = bot (izquierda)
  const _Msg(this.texto, {required this.delCliente});
}

/// Simulación de WhatsApp para el demo: un chatbot genérico scripteado que
/// recibe un pedido (sin IA, sin backend). Auto-reproduce el guion con
/// indicador de "escribiendo…". Muestra a los visitantes cómo llegan los
/// pedidos por WhatsApp y se confirman solos.
class DemoWhatsappScreen extends StatefulWidget {
  /// Si [tope] != null, muestra exactamente [tope] mensajes SIN auto-play
  /// (lo controla el tutorial, así la animación se detiene en cada paso).
  /// [claves] keyea cada burbuja para que el tutorial la pueda enfocar.
  final int? tope;
  final List<GlobalKey>? claves;
  const DemoWhatsappScreen({super.key, this.tope, this.claves});

  @override
  State<DemoWhatsappScreen> createState() => _DemoWhatsappScreenState();
}

class _DemoWhatsappScreenState extends State<DemoWhatsappScreen> {
  static const List<_Msg> _guion = [
    _Msg('Hola! Quiero hacer un pedido 🥖', delCliente: true),
    _Msg('¡Hola! 👋 Soy el asistente de Panadería El Trigo Dorado. '
        '¿Qué te gustaría pedir hoy?', delCliente: false),
    _Msg('2 pan de bono y 1 café tinto', delCliente: true),
    _Msg('Perfecto 📝\n• 2× Pan de bono\n• 1× Café tinto\n\n¿A nombre de quién?',
        delCliente: false),
    _Msg('María García', delCliente: true),
    _Msg('Gracias, María 😊 ¿Es a domicilio o recoges en tienda?',
        delCliente: false),
    _Msg('Domicilio — Cll 72 #45-12, El Prado', delCliente: true),
    _Msg('¡Listo! ✅ Pedido confirmado\nTotal: \$8.000 · Llega en ~20 min 🛵\n\n'
        'Tu pedido ya aparece en el panel del negocio.', delCliente: false),
  ];

  final ScrollController _scroll = ScrollController();
  int _visibles = 0;
  bool _escribiendo = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.tope == null) _reproducir();
  }

  @override
  void didUpdateWidget(DemoWhatsappScreen old) {
    super.didUpdateWidget(old);
    if (old.tope != null && widget.tope == null) {
      // Salió del tutorial → reanuda el auto-play.
      _reproducir();
    } else if (widget.tope != null && widget.tope != old.tope) {
      _bajar(); // el tutorial reveló otro mensaje
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _reproducir() {
    setState(() {
      _visibles = 0;
      _escribiendo = false;
    });
    _agendarSiguiente();
  }

  void _agendarSiguiente() {
    if (_visibles >= _guion.length) return;
    final msg = _guion[_visibles];
    // El bot "escribe" antes de responder; el cliente aparece directo.
    if (!msg.delCliente) {
      _timer = Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() => _escribiendo = true);
        _bajar();
        _timer = Timer(const Duration(milliseconds: 1100), _mostrar);
      });
    } else {
      _timer = Timer(const Duration(milliseconds: 900), _mostrar);
    }
  }

  void _mostrar() {
    if (!mounted) return;
    setState(() {
      _escribiendo = false;
      _visibles++;
    });
    _bajar();
    _agendarSiguiente();
  }

  void _bajar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final destino = _scroll.position.maxScrollExtent;
      if (widget.tope != null) {
        // En el tutorial el scroll es instantáneo: así el rect de la burbuja
        // queda estable cuando el spotlight lo mide (no animándose).
        _scroll.jumpTo(destino);
      } else {
        _scroll.animateTo(destino,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Key? _claveDe(int i) =>
      (widget.claves != null && i < widget.claves!.length)
          ? widget.claves![i]
          : null;

  @override
  Widget build(BuildContext context) {
    final bool tutorial = widget.tope != null;
    final int n = widget.tope ?? _visibles;
    final bool fin = !tutorial && _visibles >= _guion.length && !_escribiendo;
    return Column(
      children: [
        _cabecera(),
        Expanded(
          child: Container(
            color: const Color(0xFFECE5DD), // fondo WhatsApp
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              children: [
                _fechaChip(),
                for (int i = 0; i < n && i < _guion.length; i++)
                  _burbuja(_guion[i], _claveDe(i)),
                if (!tutorial && _escribiendo) _escribiendoBurbuja(),
                if (fin) _reiniciar(),
              ],
            ),
          ),
        ),
        _barraEntrada(),
      ],
    );
  }

  Widget _cabecera() {
    return Container(
      color: const Color(0xFF075E54), // header WhatsApp
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFF25D366),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const FaIcon(FontAwesomeIcons.store, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Panadería El Trigo Dorado',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                Text('en línea',
                    style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11)),
              ],
            ),
          ),
          const FaIcon(FontAwesomeIcons.video, color: Colors.white, size: 16),
          const SizedBox(width: 18),
          const FaIcon(FontAwesomeIcons.phone, color: Colors.white, size: 15),
        ],
      ),
    );
  }

  Widget _fechaChip() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFD9E7DD),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('HOY',
            style: GoogleFonts.inter(
                color: const Color(0xFF5C6B66),
                fontSize: 10,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _burbuja(_Msg m, [Key? clave]) {
    final bg = m.delCliente ? const Color(0xFFDCF8C6) : Colors.white;
    return Align(
      alignment: m.delCliente ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        key: clave,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: Radius.circular(m.delCliente ? 10 : 2),
            bottomRight: Radius.circular(m.delCliente ? 2 : 10),
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x14000000), blurRadius: 1, offset: Offset(0, 1)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(m.texto,
                style: GoogleFonts.inter(
                    color: const Color(0xFF111B21), fontSize: 13, height: 1.35)),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('12:0${(_guion.indexOf(m) + 1)}',
                    style: GoogleFonts.inter(
                        color: const Color(0xFF8696A0), fontSize: 9)),
                if (m.delCliente) ...[
                  const SizedBox(width: 3),
                  const FaIcon(FontAwesomeIcons.checkDouble,
                      size: 9, color: Color(0xFF34B7F1)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _escribiendoBurbuja() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Text('escribiendo…',
            style: GoogleFonts.inter(
                color: const Color(0xFF8696A0),
                fontSize: 12,
                fontStyle: FontStyle.italic)),
      ),
    );
  }

  Widget _reiniciar() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: GestureDetector(
          onTap: _reproducir,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.rotateRight,
                    size: 11, color: Colors.white),
                const SizedBox(width: 6),
                Text('Ver de nuevo',
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _barraEntrada() {
    return Container(
      color: const Color(0xFFF0F0F0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Mensaje',
                        style: GoogleFonts.inter(
                            color: const Color(0xFF8696A0), fontSize: 13)),
                  ),
                  const FaIcon(FontAwesomeIcons.faceSmile,
                      size: 15, color: Color(0xFF8696A0)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFF075E54),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const FaIcon(FontAwesomeIcons.microphone,
                size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
