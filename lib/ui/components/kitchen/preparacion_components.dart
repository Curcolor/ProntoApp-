import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/models/order_model.dart';

class PreparacionEmptyState extends StatelessWidget {
  const PreparacionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍳', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Nada en preparación',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los pedidos que aceptes desde la cola\naparecerán aquí.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class PedidoPreparacionCard extends StatefulWidget {
  final OrderModel? pedido;
  final Future<void> Function(String id)? onMarkReady;

  const PedidoPreparacionCard({
    super.key,
    this.pedido,
    this.onMarkReady,
  });

  @override
  State<PedidoPreparacionCard> createState() => _PedidoPreparacionCardState();
}

class _PedidoPreparacionCardState extends State<PedidoPreparacionCard> {
  late List<bool> _checked;

  OrderModel get _pedido => widget.pedido ?? _sampleOrder();
  bool get _todoListo => _checked.every((c) => c);
  int get _checkedCount => _checked.where((c) => c).length;
  double get _progreso => _checked.isEmpty ? 0 : _checkedCount / _checked.length;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(_pedido.items.length, false);
  }

  @override
  void didUpdateWidget(covariant PedidoPreparacionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldLength = oldWidget.pedido?.items.length ?? _sampleOrder().items.length;
    if (oldLength != _pedido.items.length) {
      _checked = List.filled(_pedido.items.length, false);
    }
  }

  Future<void> _marcarListo(BuildContext context) async {
    if (_pedido.estado.siguiente == null) return;

    try {
      await (widget.onMarkReady?.call(_pedido.id) ?? Future<void>.value());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${_pedido.id} marcado como Listo'),
            backgroundColor: AppColors.primaryDark,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar pedido: $e'),
            backgroundColor: AppColors.dangerIcon,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedido = _pedido;

    return Stack(
      children: [
        Container(
          height: 140,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.warningIcon, AppColors.warningDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PreparationHeader(pedido: pedido),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  children: [
                    _PreparationChecklist(
                      pedido: pedido,
                      checked: _checked,
                      checkedCount: _checkedCount,
                      progress: _progreso,
                      onToggle: (index) =>
                          setState(() => _checked[index] = !_checked[index]),
                    ),
                    if (pedido.tipo == TipoPedido.domicilio &&
                        pedido.direccion != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _PreparationAddressNote(pedido: pedido),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: _PreparationClientInfo(pedido: pedido),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                  AppColors.surface,
                  AppColors.surface.withAlpha((0.9 * 255).toInt()),
                  AppColors.surface.withAlpha(0),
                ],
              ),
            ),
            child: Semantics(
              label: _todoListo
                  ? 'Marcar pedido como listo'
                  : 'Marca todos los items primero',
              button: true,
              enabled: _todoListo,
              child: GestureDetector(
                onTap: _todoListo ? () => _marcarListo(context) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _todoListo
                          ? [AppColors.primary, AppColors.primaryDark]
                          : [AppColors.toggleInactiveBg, AppColors.textMuted],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _todoListo
                        ? [
                            BoxShadow(
                              color: AppColors.primary
                                  .withAlpha((0.35 * 255).toInt()),
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
                        color: AppColors.surface,
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _todoListo
                            ? 'Marcar pedido como Listo'
                            : 'Marca todos los ítems primero',
                        style: GoogleFonts.inter(
                          color: AppColors.surface,
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
        ),
      ],
    );
  }
}

class _PreparationHeader extends StatelessWidget {
  final OrderModel pedido;

  const _PreparationHeader({required this.pedido});

  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.surface,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${pedido.cliente} · vía Telegram',
                  style: GoogleFonts.inter(
                    color: AppColors.surface.withAlpha((0.8 * 255).toInt()),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        pedido.tipo == TipoPedido.domicilio
                            ? FontAwesomeIcons.motorcycle
                            : FontAwesomeIcons.store,
                        color: AppColors.surface,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pedido.tipo == TipoPedido.domicilio
                            ? 'Domicilio · ${pedido.direccion ?? 'Sin dirección'}'
                            : 'Para recoger en tienda',
                        style: GoogleFonts.inter(
                          color: AppColors.surface,
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
              color: AppColors.textPrimary.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  pedido.tiempoTranscurridoFormat,
                  style: GoogleFonts.inter(
                    color: AppColors.surface,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'en cola',
                  style: GoogleFonts.inter(
                    color: AppColors.surface.withAlpha((0.7 * 255).toInt()),
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
}

class _PreparationChecklist extends StatelessWidget {
  final OrderModel pedido;
  final List<bool> checked;
  final int checkedCount;
  final double progress;
  final ValueChanged<int> onToggle;

  const _PreparationChecklist({
    required this.pedido,
    required this.checked,
    required this.checkedCount,
    required this.progress,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withAlpha((0.08 * 255).toInt()),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.listCheck,
                  color: AppColors.successIcon,
                  size: 15,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ítems a preparar',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(pedido.items.length, (index) {
            final item = pedido.items[index];
            final marcado = checked[index];
            return Semantics(
              label: 'Marcar ${item.nombre}',
              button: true,
              selected: marcado,
              child: GestureDetector(
                onTap: () => onToggle(index),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.borderLight)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: marcado ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: marcado
                                ? AppColors.primary
                                : AppColors.toggleInactiveBg,
                            width: 2,
                          ),
                        ),
                        child: marcado
                            ? const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.check,
                                  color: AppColors.surface,
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
                                ? AppColors.textMuted
                                : AppColors.textPrimary,
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
                          color: AppColors.borderLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '×${item.cantidad}',
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso de preparación',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$checkedCount de ${checked.length} listos',
                      style: GoogleFonts.inter(
                        color: AppColors.primaryDark,
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
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.borderLight,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreparationAddressNote extends StatelessWidget {
  final OrderModel pedido;

  const _PreparationAddressNote({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warningIcon.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: FaIcon(
              FontAwesomeIcons.locationDot,
              color: AppColors.warningIcon,
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
                    color: AppColors.warningText,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pedido.direccion!,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
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
}

class _PreparationClientInfo extends StatelessWidget {
  final OrderModel pedido;

  const _PreparationClientInfo({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.successBg,
                  AppColors.successIcon.withValues(alpha: 0.35),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                pedido.inicialCliente,
                style: GoogleFonts.inter(
                  color: AppColors.primaryDark,
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
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${pedido.items.length} producto${pedido.items.length != 1 ? 's' : ''} · \$${pedido.total.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    color: AppColors.textTertiary,
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
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.telegram,
                color: AppColors.surface,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

OrderModel _sampleOrder() {
  return OrderModel(
    id: 'P-TEST',
    cliente: 'Cliente demo',
    telefono: 'tg:1',
    items: const [
      ItemPedido(nombre: 'Producto demo', cantidad: 1, precio: 12000),
      ItemPedido(nombre: 'Bebida demo', cantidad: 2, precio: 5000),
    ],
    total: 22000,
    estado: EstadoPedido.enPreparacion,
    tipo: TipoPedido.recoger,
    creadoEn: DateTime.now().subtract(const Duration(minutes: 12)),
  );
}
