import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';

/// Pantalla "En curso" de la vista cocina.
/// Muestra los pedidos en preparación con checklist dinámico de ítems
/// y permite marcar el pedido como listo actualizando el backend.
class PreparacionScreen extends StatelessWidget {
  const PreparacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final enPreparacion = provider.enPreparacion;

        return Scaffold(
          backgroundColor: Colors.white,
          body: enPreparacion.isEmpty
              ? _buildVacio()
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: enPreparacion.length,
                  itemBuilder: (context, index) {
                    return _PedidoPreparacionCard(
                      pedido: enPreparacion[index],
                      provider: provider,
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildVacio() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍳', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Nada en preparación',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los pedidos que aceptes desde la cola\naparecerán aquí.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta individual de un pedido en preparación.
/// Gestiona internamente el checklist de ítems con estado local.
class _PedidoPreparacionCard extends StatefulWidget {
  final OrderModel pedido;
  final OrderProvider provider;

  const _PedidoPreparacionCard({required this.pedido, required this.provider});

  @override
  State<_PedidoPreparacionCard> createState() => _PedidoPreparacionCardState();
}

class _PedidoPreparacionCardState extends State<_PedidoPreparacionCard> {
  /// Mapa de índice → marcado para los ítems del pedido.
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(widget.pedido.items.length, false);
  }

  bool get _todoListo => _checked.every((c) => c);
  int get _checkedCount => _checked.where((c) => c).length;
  double get _progreso =>
      _checked.isEmpty ? 0 : _checkedCount / _checked.length;

  Future<void> _marcarListo(BuildContext context) async {
    if (widget.pedido.estado.siguiente == null) return;

    try {
      await widget.provider.avanzarEstado(widget.pedido.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${widget.pedido.id} marcado como Listo'),
            backgroundColor: const Color(0xFF128C7E),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar pedido: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedido = widget.pedido;

    return Stack(
      children: [
        // Cabecera degradada
        Container(
          height: 140,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(pedido),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  children: [
                    _buildChecklist(),
                    if (pedido.tipo == TipoPedido.domicilio &&
                        pedido.direccion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _buildDireccionNote(pedido),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _buildClienteInfo(pedido),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Botón fijo en la parte inferior
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Colors.white.withAlpha((0.9 * 255).toInt()),
                  Colors.white.withAlpha(0),
                ],
              ),
            ),
            child: GestureDetector(
              onTap: _todoListo ? () => _marcarListo(context) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _todoListo
                        ? [const Color(0xFF25D366), const Color(0xFF128C7E)]
                        : [const Color(0xFFCBD5E1), const Color(0xFF94A3B8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _todoListo
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF25D366,
                            ).withAlpha((0.35 * 255).toInt()),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      _todoListo
                          ? FontAwesomeIcons.circleCheck
                          : FontAwesomeIcons.listCheck,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _todoListo
                          ? 'Marcar pedido como Listo'
                          : 'Marca todos los ítems primero',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(OrderModel pedido) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pedido.id,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${pedido.cliente} · vía Telegram',
                  style: GoogleFonts.inter(
                    color: Colors.white.withAlpha((0.8 * 255).toInt()),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        pedido.tipo == TipoPedido.domicilio
                            ? FontAwesomeIcons.motorcycle
                            : FontAwesomeIcons.store,
                        color: Colors.white,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pedido.tipo == TipoPedido.domicilio
                            ? 'Domicilio · ${pedido.direccion ?? 'Sin dirección'}'
                            : 'Para recoger en tienda',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  pedido.tiempoTranscurridoFormat,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'en cola',
                  style: GoogleFonts.inter(
                    color: Colors.white.withAlpha((0.7 * 255).toInt()),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.listCheck,
                  color: Color(0xFF1DB954),
                  size: 15,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ítems a preparar',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(widget.pedido.items.length, (index) {
            final item = widget.pedido.items[index];
            final marcado = _checked[index];
            return InkWell(
              onTap: () {
                setState(() {
                  _checked[index] = !marcado;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: marcado ? const Color(0xFF25D366) : Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: marcado
                              ? const Color(0xFF25D366)
                              : const Color(0xFFCBD5E1),
                          width: 2,
                        ),
                      ),
                      child: marcado
                          ? const Center(
                              child: FaIcon(
                                FontAwesomeIcons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.nombre,
                        style: GoogleFonts.inter(
                          color: marcado
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF1E293B),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: marcado
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '×${item.cantidad}',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF334155),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso de preparación',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF475569),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$_checkedCount de ${_checked.length} listos',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF128C7E),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: _progreso,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF25D366),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDireccionNote(OrderModel pedido) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: FaIcon(
              FontAwesomeIcons.locationDot,
              color: Color(0xFFF59E0B),
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dirección de entrega',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFB45309),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pedido.direccion!,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF475569),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClienteInfo(OrderModel pedido) {
    final inicial = pedido.inicialCliente;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFDCFCE7), Color(0xFFA7F3D0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                inicial,
                style: GoogleFonts.inter(
                  color: const Color(0xFF128C7E),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pedido.cliente,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${pedido.items.length} producto${pedido.items.length != 1 ? 's' : ''} · \$${pedido.total.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.telegram,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
