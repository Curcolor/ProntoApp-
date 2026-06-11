import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/core/widgets/dia_grupo_header.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _tabIndex = 0; // 0 = Todos
  String _busqueda = '';

  static const List<String> _tabs = [
    'Todos',
    'Recibidos',
    'Preparando',
    'Listos',
    'En camino',
    'Entregados',
  ];

  static const List<EstadoPedido?> _estadosPorTab = [
    null,
    EstadoPedido.recibido,
    EstadoPedido.enPreparacion,
    EstadoPedido.listo,
    EstadoPedido.enCamino,
    EstadoPedido.entregado,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        // Filtrar por tab y búsqueda
        List<OrderModel> pedidos = provider.pedidos;

        final estadoFiltro = _estadosPorTab[_tabIndex];
        if (estadoFiltro != null) {
          pedidos = pedidos.where((p) => p.estado == estadoFiltro).toList();
        }

        if (_busqueda.isNotEmpty) {
          final q = _busqueda.toLowerCase();
          pedidos = pedidos.where((p) =>
              p.cliente.toLowerCase().contains(q) ||
              p.id.toLowerCase().contains(q) ||
              p.resumenItems.toLowerCase().contains(q)).toList();
        }

        return SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(
                    left: 21.73, right: 21.73, top: 20.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pedidos',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0F172A),
                            fontSize: 23.90,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.33,
                          ),
                        ),
                        // Indicador de conexión
                        Container(
                          width: 41.29,
                          height: 41.29,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13.04),
                            border: Border.all(
                                color: const Color(0xFFE2E8F0), width: 1.09),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.arrowsRotate,
                              color: provider.estaConectado
                                  ? const Color(0xFF25D366)
                                  : const Color(0xFF94A3B8),
                              size: 16.30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.21),

                    // Buscador
                    Container(
                      height: 47.81,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17.38),
                        border: Border.all(
                            color: const Color(0xFFE2E8F0), width: 1.09),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 15.21),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.magnifyingGlass,
                              color: Color(0xFF94A3B8), size: 15.21),
                          const SizedBox(width: 15.21),
                          Expanded(
                            child: TextField(
                              style: GoogleFonts.inter(
                                  fontSize: 14.12,
                                  color: const Color(0xFF0F172A)),
                              onChanged: (val) =>
                                  setState(() => _busqueda = val),
                              decoration: InputDecoration(
                                hintText: 'Buscar pedido o cliente…',
                                hintStyle: GoogleFonts.inter(
                                    color: const Color(0xFF757575),
                                    fontSize: 14.12),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.21),

                    // Tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_tabs.length, (i) {
                          final conteo = _estadosPorTab[i] == null
                              ? provider.pedidos.length
                              : provider.pedidos
                                  .where((p) =>
                                      p.estado == _estadosPorTab[i])
                                  .length;
                          return Padding(
                            padding: EdgeInsets.only(
                                right: i < _tabs.length - 1 ? 8 : 0),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _tabIndex = i),
                              child: _buildTabChip(
                                _tabs[i],
                                conteo,
                                isActive: i == _tabIndex,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Lista ────────────────────────────────────────────────────────
              Expanded(
                child: pedidos.isEmpty
                    ? _buildEstadoVacio()
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 21.73, vertical: 8.0),
                        children: [
                          for (final grupo
                              in provider.agruparPorDia(pedidos)) ...[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4, bottom: 12),
                              child: DiaGrupoHeader(
                                label: OrderProvider.etiquetaDia(grupo.key),
                                count: grupo.value.length,
                              ),
                            ),
                            ...grupo.value.map(
                              (p) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 13.04),
                                child: _buildOrderCard(context, p, provider),
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Widgets auxiliares ────────────────────────────────────────────────────

  Widget _buildEstadoVacio() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(FontAwesomeIcons.clipboardList,
              color: Color(0xFF94A3B8), size: 48),
          const SizedBox(height: 16),
          Text(
            'No hay pedidos aquí',
            style: GoogleFonts.inter(
                color: const Color(0xFF64748B), fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            'Los pedidos del bot de Telegram\naparecerán aquí automáticamente.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, int conteo, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14.0, vertical: 7.61),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF25D366) : Colors.white,
        borderRadius: BorderRadius.circular(1085.41),
        border: Border.all(
          color: isActive
              ? const Color(0xFF25D366)
              : const Color(0xFFE2E8F0),
          width: 1.09,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? Colors.white : const Color(0xFF475569),
              fontSize: 11.95,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withValues(alpha: 0.3)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$conteo',
              style: GoogleFonts.inter(
                color: isActive
                    ? Colors.white
                    : const Color(0xFF475569),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
      BuildContext context, OrderModel pedido, OrderProvider provider) {
    final inicial = pedido.inicialCliente;

    return Container(
      padding: const EdgeInsets.all(17.38),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21.73),
        border: Border.all(
            color: const Color(0xFFF1F5F9), width: 1.09),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3.26,
            offset: const Offset(0, 1.09),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45.63,
                height: 45.63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.04),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    inicial,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1D4ED8),
                      fontSize: 17.38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.87),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pedido.cliente,
                      style: GoogleFonts.inter(
                          color: const Color(0xFF0F172A),
                          fontSize: 14.12,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pedido del día #${provider.numeroDelDia(pedido)} · Cód. ${pedido.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      pedido.telefono,
                      style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontSize: 11.95),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.87, vertical: 3.26),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(1085.41),
                ),
                child: Text(
                  pedido.estado.etiqueta,
                  style: GoogleFonts.inter(
                      color: const Color(0xFF15803D),
                      fontSize: 11.95,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Items
          Container(
            padding: const EdgeInsets.only(top: 11.95),
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Color(0xFFF1F5F9), width: 1.09)),
            ),
            child: Column(
              children: [
                ...pedido.items.map((item) => Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 5.43),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 23.90,
                                height: 23.90,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius:
                                      BorderRadius.circular(8.69),
                                ),
                                child: Center(
                                  child: Text(
                                    '×${item.cantidad}',
                                    style: GoogleFonts.inter(
                                        color: const Color(0xFF334155),
                                        fontSize: 11.95,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.69),
                              Text(
                                item.nombre,
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF334155),
                                    fontSize: 14.12),
                              ),
                            ],
                          ),
                          Text(
                            '\$${item.subtotal.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                                color: const Color(0xFF1E293B),
                                fontSize: 14.12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),

                // Total (separador punteado, como el diseño Figma)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      const _DashedLine(color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 9.78),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: GoogleFonts.inter(
                                  color: const Color(0xFF475569),
                                  fontSize: 14.12,
                                  fontWeight: FontWeight.w600)),
                          Text(
                            '\$${pedido.total.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                                color: const Color(0xFF0F172A),
                                fontSize: 17.38,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Delivery info
          Row(
            children: [
              FaIcon(
                pedido.tipo == TipoPedido.domicilio
                    ? FontAwesomeIcons.locationDot
                    : FontAwesomeIcons.shop,
                color: pedido.tipo == TipoPedido.domicilio
                    ? const Color(0xFF25D366)
                    : const Color(0xFF3B82F6),
                size: 11.95,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pedido.tipo == TipoPedido.domicilio
                      ? pedido.direccion ?? 'Domicilio'
                      : 'Para recoger en tienda',
                  style: GoogleFonts.inter(
                      color: const Color(0xFF94A3B8),
                      fontSize: 11.95),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Acción principal
          if (pedido.estado.siguiente != null)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => provider.avanzarEstado(pedido.id),
                    icon: const FaIcon(FontAwesomeIcons.check,
                        size: 14.12, color: Colors.white),
                    label: Text(
                      'Pasar a ${pedido.estado.siguiente!.etiqueta}',
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14.12,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      elevation: 0,
                      minimumSize: const Size(0, 43.46),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.04)),
                    ),
                  ),
                ),
                const SizedBox(width: 8.69),
                // Botón WhatsApp — solo visual (contactar al cliente = ciclo futuro)
                SizedBox(
                  width: 43.46,
                  height: 43.46,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.04)),
                    ),
                    child: const FaIcon(FontAwesomeIcons.whatsapp,
                        color: Colors.white, size: 19.56),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Línea horizontal punteada (separador del Total, como el diseño Figma).
class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1.09),
      painter: _DashedLinePainter(color),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 4;
    const double dashGap = 3;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.09;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

@Preview(name: 'Pedidos', group: 'Manager', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget ordersScreenPreview() => const OrdersScreen();

