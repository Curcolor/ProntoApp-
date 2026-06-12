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
  // Tutorial guiado (coach marks) sobre los botones del demo.
  final List<GlobalKey> _tabKeys = List.generate(4, (_) => GlobalKey());
  final GlobalKey _countdownKey = GlobalKey();
  bool _tutorialActivo = true;

  @override
  void initState() {
    super.initState();
    _restante = kDemoDuracion;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
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
                      index: _rol,
                      children: const [
                        DemoWhatsappScreen(),
                        ManagerMainScreen(),
                        KitchenMainScreen(),
                        DeliveryMainScreen(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_tutorialActivo)
            DemoTutorial(
              pasos: _pasos(),
              onCerrar: () => setState(() => _tutorialActivo = false),
            ),
        ],
      ),
    );
  }

  List<TutorialPaso> _pasos() => [
        TutorialPaso(
          objetivo: _tabKeys[0],
          titulo: 'Los pedidos llegan por WhatsApp',
          descripcion:
              'Tus clientes piden por WhatsApp y un asistente toma el pedido automáticamente, sin que hagas nada. Aquí lo ves en vivo.',
        ),
        TutorialPaso(
          objetivo: _tabKeys[1],
          titulo: 'Panel del Gerente',
          descripcion:
              'El dueño ve las ventas del día, los pedidos en tiempo real, el inventario y la configuración del negocio.',
        ),
        TutorialPaso(
          objetivo: _tabKeys[2],
          titulo: 'Vista de Cocina',
          descripcion:
              'La cocina recibe la cola de pedidos y marca cada uno como listo cuando termina.',
        ),
        TutorialPaso(
          objetivo: _tabKeys[3],
          titulo: 'Vista del Repartidor',
          descripcion:
              'El repartidor ve sus entregas, la ruta hacia el cliente y confirma cada pedido.',
        ),
        TutorialPaso(
          objetivo: _countdownKey,
          titulo: 'Demo de 5 minutos',
          descripcion:
              'Estás en una demostración con datos de ejemplo — no se usa nada real. Explora libremente; toca el (?) para repetir esta guía.',
        ),
      ];

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
                onTap: () => setState(() => _tutorialActivo = true),
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
