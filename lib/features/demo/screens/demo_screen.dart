import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'package:prontoapp/data/repositories/negocio_repository.dart';
import 'package:prontoapp/data/repositories/usuario_repository.dart';
import 'package:prontoapp/data/repositories/plantilla_ia_repository.dart';
import 'package:prontoapp/features/manager/screens/manager_main_screen.dart';
import 'package:prontoapp/features/kitchen/screens/kitchen_main_screen.dart';
import 'package:prontoapp/features/delivery/screens/delivery_main_screen.dart';
import 'package:prontoapp/features/demo/data/demo_api_client.dart';
import 'package:prontoapp/features/demo/data/demo_data.dart';
import 'package:prontoapp/features/demo/screens/demo_whatsapp_screen.dart';
import 'package:prontoapp/features/demo/screens/demo_tutorial.dart';

const Duration kDemoDuracion = Duration(minutes: 5);

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});
  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  int _rol = 0;
  late Duration _restante;
  Timer? _timer;
  // ApiClient aislado del demo, creado una sola vez (no en cada build).
  late final _demoApi = crearDemoApiClient();
  // Tutorial guiado (coach marks).
  final List<GlobalKey> _tabKeys = List.generate(4, (_) => GlobalKey());
  final GlobalKey _countdownKey = GlobalKey();
  final GlobalKey _bodyKey = GlobalKey(); // área del módulo (para resaltar zonas)
  final List<GlobalKey> _waKeys = List.generate(8, (_) => GlobalKey());
  bool _tutorialActivo = true;
  int _idx = 0; // paso actual del tour
  int? _waVisibles = 0; // mensajes de WhatsApp visibles en el paso actual

  late final List<_PasoTour> _tour = [
    // Intro: tarjeta centrada (sin objetivo) sobre fondo oscuro.
    _PasoTour(rol: 0, waTope: 0,
        titulo: '¡Bienvenido a ProntoApp! 👋',
        desc:
            'Esto es una demo SOLO visual, con datos de ejemplo — no se usa nada real. En un minuto te muestro cómo funciona tu negocio con ProntoApp.'),
    _PasoTour(rol: 0, waTope: 1, waSpotlight: 0,
        titulo: 'El cliente pide por WhatsApp',
        desc: 'Tu cliente escribe como a cualquier contacto, sin instalar nada.'),
    _PasoTour(rol: 0, waTope: 4, waSpotlight: 3,
        titulo: 'El asistente toma el pedido',
        desc: 'Entiende qué quiere y arma el pedido solo, sin que hagas nada.'),
    _PasoTour(rol: 0, waTope: 6, waSpotlight: 5,
        titulo: 'Pide los datos que faltan',
        desc: 'Nombre, y si es a domicilio o para recoger — todo por chat.'),
    _PasoTour(rol: 0, waTope: 8, waSpotlight: 7,
        titulo: 'Pedido confirmado ✅',
        desc:
            'Se confirma al cliente y aparece al instante en el panel del negocio.'),
    _PasoTour(rol: 1, zona: _zonaTop,
        titulo: 'Panel del Gerente — resumen',
        desc: 'El dueño ve ventas, pedidos y métricas del día de un vistazo.'),
    _PasoTour(rol: 1, zona: _zonaMedio,
        titulo: 'Pedidos en vivo',
        desc:
            'Los pedidos entran en tiempo real, agrupados por día y con su código.'),
    _PasoTour(rol: 1, zona: _zonaNav,
        titulo: 'Navegación del gerente',
        desc: 'Inicio, Pedidos, KPIs, Perfil y Configuración del negocio.'),
    _PasoTour(rol: 2, zona: _zonaMedio,
        titulo: 'Vista de Cocina',
        desc:
            'La cocina ve la cola de pedidos y su urgencia, lista para preparar.'),
    _PasoTour(rol: 2, zona: _zonaNav,
        titulo: 'Flujo de cocina',
        desc: 'Cola → En curso → Listos: marca cada pedido a medida que avanza.'),
    _PasoTour(rol: 3, zona: _zonaMedio,
        titulo: 'Vista del Repartidor',
        desc: 'Ve sus entregas, la dirección del cliente y el monto a cobrar.'),
    _PasoTour(rol: 3, zona: _zonaNav,
        titulo: 'Reparto y entrega',
        desc:
            'Toma el pedido, sigue la ruta y confirma la entrega con un toque.'),
    _PasoTour(rol: 3, objetivoKey: _countdownKey,
        titulo: 'Es una demo de 5 minutos',
        desc:
            'Datos de ejemplo, nada real. Explora libremente; toca el (?) para repetir esta guía.'),
    // Outro: tarjeta centrada (sin objetivo).
    _PasoTour(rol: 1,
        titulo: '¿List@ para empezar? 🚀',
        desc:
            'Esperamos que te haya gustado. Crea tu cuenta y activa tu primer plan para recibir pedidos por WhatsApp con ProntoApp. ¡Te esperamos!'),
  ];

  @override
  void initState() {
    super.initState();
    _restante = kDemoDuracion;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_tutorialActivo) return; // el countdown se pausa durante la guía
      if (_restante.inSeconds <= 1) {
        _salir();
      } else {
        setState(() => _restante -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _salir() {
    _timer?.cancel();
    if (mounted) Navigator.of(context).pop();
  }

  String get _mmss {
    final m = _restante.inMinutes;
    final s = _restante.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _barraDemo(),
                Expanded(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                          create: (_) =>
                              OrderProvider.preview(pedidos: demoPedidos)),
                      ChangeNotifierProvider(
                          create: (_) => InventoryProvider.preview(
                              products: demoProductos,
                              categories: demoCategorias)),
                      ChangeNotifierProvider(
                          create: (_) => NotificationProvider()),
                      Provider<NegocioRepository>.value(
                          value: NegocioRepository(_demoApi)),
                      Provider<UsuarioRepository>.value(
                          value: UsuarioRepository(_demoApi)),
                      Provider<PlantillaIaRepository>.value(
                          value: PlantillaIaRepository(_demoApi)),
                    ],
                    child: IndexedStack(
                      key: _bodyKey,
                      index: _rol,
                      children: [
                        DemoWhatsappScreen(
                          tope: _tutorialActivo ? _waVisibles : null,
                          claves: _waKeys,
                        ),
                        const ManagerMainScreen(),
                        const KitchenMainScreen(),
                        const DeliveryMainScreen(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_tutorialActivo) _overlayTutorial(),
        ],
      ),
    );
  }

  Widget _overlayTutorial() {
    final paso = _tour[_idx];
    final rect = _resolverRect(paso);
    if (rect == null) {
      // El objetivo aún no está medido: reintenta el próximo frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _tutorialActivo) setState(() {});
      });
    }
    return DemoTutorial(
      objetivo: rect,
      titulo: paso.titulo,
      descripcion: paso.desc,
      indice: _idx,
      total: _tour.length,
      onSiguiente: _siguientePaso,
      onSaltar: () => setState(() => _tutorialActivo = false),
    );
  }

  void _siguientePaso() {
    if (_idx < _tour.length - 1) {
      _aplicarPaso(_idx + 1);
      // Tras cambiar de rol/mensajes, re-leer el rect del nuevo objetivo.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _tutorialActivo) setState(() {});
      });
    } else {
      setState(() => _tutorialActivo = false);
    }
  }

  void _aplicarPaso(int idx) {
    final p = _tour[idx];
    setState(() {
      _idx = idx;
      _rol = p.rol;
      _waVisibles = p.waTope;
    });
  }

  Rect? _resolverRect(_PasoTour p) {
    if (p.waSpotlight != null) return _rectDeKey(_waKeys[p.waSpotlight!]);
    if (p.objetivoKey != null) return _rectDeKey(p.objetivoKey!);
    if (p.zona != null) {
      final c = _rectDeKey(_bodyKey);
      return c == null ? null : p.zona!(c);
    }
    return null;
  }

  Rect? _rectDeKey(GlobalKey k) {
    final box = k.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Widget _barraDemo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF25D366), Color(0xFF128C7E)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.circlePlay,
                  size: 13, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Demo · datos de ejemplo, sin conexión real',
                  style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                key: _countdownKey,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const FaIcon(FontAwesomeIcons.clock, size: 11, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(_mmss,
                      style: GoogleFonts.inter(
                          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ]),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() => _tutorialActivo = true);
                  _aplicarPaso(0);
                },
                child: const FaIcon(FontAwesomeIcons.circleQuestion,
                    size: 15, color: Colors.white),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _salir,
                child: const FaIcon(FontAwesomeIcons.xmark,
                    size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _segmentado(),
        ],
      ),
    );
  }

  Widget _segmentado() {
    const etiquetas = ['WhatsApp', 'Gerente', 'Cocina', 'Reparto'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: List.generate(etiquetas.length, (i) {
          final activo = i == _rol;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _rol = i),
              child: Container(
                key: _tabKeys[i],
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                    color: activo ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text(etiquetas[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        color: activo ? const Color(0xFF128C7E) : Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Un paso del tour guiado del demo.
class _PasoTour {
  final int rol; // 0=WhatsApp, 1=Gerente, 2=Cocina, 3=Reparto
  final String titulo;
  final String desc;
  final int? waTope; // si rol==0: cuántos mensajes mostrar
  final int? waSpotlight; // si rol==0: índice del mensaje a enfocar
  final Rect Function(Rect cuerpo)? zona; // si rol 1-3: zona a enfocar
  final GlobalKey? objetivoKey; // objetivo por key (p.ej. el countdown)
  const _PasoTour({
    required this.rol,
    required this.titulo,
    required this.desc,
    this.waTope,
    this.waSpotlight,
    this.zona,
    this.objetivoKey,
  });
}

// Zonas a resaltar dentro del área del módulo (relativas al rect del cuerpo).
// Teselan el cuerpo en 3 bandas para que el recorte englobe bien cada parte:
// resumen (arriba), contenido/pedidos (medio) y navegación (barra inferior).
const double _altoNav = 80; // alto aprox. de la barra de navegación inferior

Rect _zonaTop(Rect c) =>
    Rect.fromLTWH(c.left + 8, c.top + 6, c.width - 16, (c.height - _altoNav) * 0.46);
Rect _zonaMedio(Rect c) {
  final double yTop = c.top + 6 + (c.height - _altoNav) * 0.46 + 8;
  return Rect.fromLTWH(c.left + 8, yTop, c.width - 16, c.bottom - _altoNav - yTop - 2);
}
Rect _zonaNav(Rect c) =>
    Rect.fromLTWH(c.left + 4, c.bottom - _altoNav, c.width - 8, _altoNav - 4);
