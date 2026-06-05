import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'notificaciones_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeTabIndex = 0;

  static const List<_TabInfo> _tabsDef = [
    _TabInfo('Recibidos', EstadoPedido.recibido),
    _TabInfo('Preparando', EstadoPedido.enPreparacion),
    _TabInfo('Listos', EstadoPedido.listo),
    _TabInfo('En camino', EstadoPedido.enCamino),
    _TabInfo('Entregados', EstadoPedido.entregado),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        final nombreUsuario = context.watch<AuthService>().currentUser?.name ?? 'Manager';
        final primerNombre = nombreUsuario.split(' ').first;

        // Pedidos visibles según tab activo
        final tabActivo = _tabsDef[_activeTabIndex];
        final pedidosTab = orderProvider.pedidos
            .where((p) => p.estado == tabActivo.estado)
            .toList();

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Buenos días, $primerNombre 👋',
                                style: GoogleFonts.inter(
                                  color: AppColors.textTertiary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                'Mi Panadería',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificacionesScreen())),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(13),
                                    border: Border.all(
                                        color: AppColors.border, width: 1),
                                  ),
                                  child: const Center(
                                    child: FaIcon(FontAwesomeIcons.bell,
                                        color: AppColors.textSecondary, size: 18),
                                  ),
                                ),
                              ),
                              Consumer<NotificationProvider>(
                                builder: (context, notifProvider, _) {
                                  if (notifProvider.unreadCount > 0) {
                                    return Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 9,
                                        height: 9,
                                        decoration: BoxDecoration(
                                          color: AppColors.dangerIcon,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.background, width: 2),
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Banner de estado de conexión / IA activa
                      if (!orderProvider.estaConectado)
                        _buildBannerDesconectado()
                      else
                        _buildPillIaActiva(orderProvider.recibidos.length),
                    ],
                  ),
                ),
              ),

              // ── Métricas ─────────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.15,
                  children: [
                    _buildMetricCard(
                      icon: FontAwesomeIcons.bagShopping,
                      iconColor: AppColors.successText,
                      iconBg: AppColors.successBg,
                      label: 'Pedidos hoy',
                      value: '${orderProvider.pedidosHoy}',
                      subText: '${orderProvider.activos.length} activos',
                      subColor: AppColors.successText,
                    ),
                    _buildMetricCard(
                      icon: FontAwesomeIcons.clock,
                      iconColor: AppColors.infoText,
                      iconBg: AppColors.infoBg,
                      label: 'En preparación',
                      value: '${orderProvider.enPreparacion.length}',
                      subText: '${orderProvider.listos.length} listos',
                      subColor: AppColors.infoText,
                    ),
                    _buildMetricCard(
                      icon: FontAwesomeIcons.dollarSign,
                      iconColor: AppColors.aiText,
                      iconBg: AppColors.aiBg,
                      label: 'Ventas del día',
                      value: _formatearPesos(orderProvider.ventasHoy),
                      subText: '${orderProvider.entregados.length} entregados',
                      subColor: AppColors.aiText,
                    ),
                    _buildMetricCard(
                      icon: FontAwesomeIcons.motorcycle,
                      iconColor: AppColors.warningText,
                      iconBg: AppColors.warningBg,
                      label: 'En camino',
                      value: '${orderProvider.enCamino.length}',
                      subText: 'domicilios activos',
                      subColor: AppColors.warningText,
                    ),
                  ],
                ),
              ),

              // ── Tabs de estado ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 24.0, bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Pedidos activos',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: _tabsDef.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final tab = _tabsDef[index];
                            final conteo = orderProvider.pedidos
                                .where((p) => p.estado == tab.estado)
                                .length;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _activeTabIndex = index),
                              child: _buildTabChip(
                                tab.label,
                                '$conteo',
                                isActive: index == _activeTabIndex,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Lista de pedidos ──────────────────────────────────────────────
              if (pedidosTab.isEmpty)
                SliverToBoxAdapter(
                  child: _buildEstadoVacio(tabActivo.label),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  sliver: SliverList.builder(
                    itemCount: pedidosTab.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidosTab[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildOrderCard(
                          pedido: pedido,
                          onAceptar: pedido.estado.siguiente != null
                              ? () => context
                                  .read<OrderProvider>()
                                  .avanzarEstado(pedido.id)
                              : null,
                        ),
                      );
                    },
                  ),
                ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        );
      },
    );
  }

  // ─── Widgets auxiliares ────────────────────────────────────────────────────

  Widget _buildPillIaActiva(int entrantes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.successIcon,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            entrantes > 0
                ? 'IA Activa · $entrantes pedidos entrantes'
                : 'IA Activa · Sin pedidos nuevos',
            style: GoogleFonts.inter(
              color: AppColors.successText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerDesconectado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(FontAwesomeIcons.triangleExclamation,
              color: AppColors.warningText, size: 12),
          const SizedBox(width: 6),
          Text(
            'Sin conexión al servidor — mostrando cache',
            style: GoogleFonts.inter(
              color: AppColors.warningText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoVacio(String labelTab) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 40),
      child: Column(
        children: [
          const FaIcon(FontAwesomeIcons.inbox,
              color: AppColors.textTertiary, size: 40),
          const SizedBox(height: 12),
          Text(
            'No hay pedidos en "$labelTab"',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required FaIconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    required String subText,
    required Color subColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: FaIcon(icon, color: iconColor, size: 14)),
          ),
          const Spacer(),
          Text(label,
              style: GoogleFonts.inter(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subText,
              style: GoogleFonts.inter(
                  color: subColor, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, String count,
      {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: isActive ? AppColors.surface : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.surface.withValues(alpha: 0.25)
                  : AppColors.borderLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                count,
                style: GoogleFonts.inter(
                  color: isActive
                      ? AppColors.surface
                      : AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required OrderModel pedido,
    VoidCallback? onAceptar,
  }) {
    final inicial = pedido.inicialCliente;
    final gradients = _gradientParaInicial(inicial);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
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
                width: 41,
                height: 41,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: LinearGradient(
                    colors: gradients,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    inicial,
                    style: GoogleFonts.inter(
                      color: AppColors.primaryDark,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pedido.cliente,
                      style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pedido.id} · ${pedido.tipo.etiqueta}',
                      style: GoogleFonts.inter(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 11, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  pedido.estado.etiqueta,
                  style: GoogleFonts.inter(
                      color: AppColors.warningText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items
          Text(
            pedido.resumenItems,
            style: GoogleFonts.inter(
                color: AppColors.textSecondary, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 12),

          // Bottom row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatearPesos(pedido.total),
                    style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.clock,
                          color: AppColors.textMuted, size: 11),
                      const SizedBox(width: 4),
                      Text(
                        'Hace ${pedido.tiempoTranscurridoFormat}',
                        style: GoogleFonts.inter(
                            color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              if (onAceptar != null)
                ElevatedButton(
                  onPressed: onAceptar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13),
                    minimumSize: const Size(0, 33),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                  ),
                  child: Text(
                    '${pedido.estado.siguiente?.etiqueta ?? 'Listo'} →',
                    style: GoogleFonts.inter(
                        color: AppColors.surface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  String _formatearPesos(double valor) {
    if (valor == 0) return '\$0';
    if (valor >= 1000000) {
      return '\$${(valor / 1000000).toStringAsFixed(1)}M';
    }
    if (valor >= 1000) {
      return '\$${(valor / 1000).toStringAsFixed(0)}K';
    }
    return '\$${valor.toStringAsFixed(0)}';
  }

  List<Color> _gradientParaInicial(String inicial) {
    const paleta = [
      [AppColors.successBg, Color(0xFFA7F3D0)],
      [AppColors.aiBg, Color(0xFFDDD6FE)],
      [AppColors.infoBg, Color(0xFFBFDBFE)],
      [AppColors.warningBg, Color(0xFFFDE68A)],
    ];
    final index = inicial.codeUnitAt(0) % paleta.length;
    return paleta[index];
  }
}

/// Datos estáticos de cada tab.
class _TabInfo {
  final String label;
  final EstadoPedido estado;
  const _TabInfo(this.label, this.estado);
}

@Preview(name: 'Dashboard', group: 'Manager', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget dashboardScreenPreview() => const DashboardScreen();

