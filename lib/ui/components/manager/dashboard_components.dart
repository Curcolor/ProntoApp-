import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/models/order_model.dart';

class DashboardHeader extends StatelessWidget {
  final String firstName;
  final String businessName;
  final bool isConnected;
  final int incomingCount;
  final int unreadCount;
  final VoidCallback? onNotificationsTap;

  const DashboardHeader({
    super.key,
    this.firstName = 'Manager',
    this.businessName = 'Mi negocio',
    this.isConnected = true,
    this.incomingCount = 0,
    this.unreadCount = 0,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 16),
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
                    'Buenos días, $firstName 👋',
                    style: GoogleFonts.inter(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    businessName,
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
                  Semantics(
                    label: 'Abrir notificaciones',
                    button: true,
                    child: GestureDetector(
                      onTap: onNotificationsTap,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.bell,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.dangerIcon,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          isConnected
              ? _DashboardStatusPill(
                  text: incomingCount > 0
                      ? 'IA Activa · $incomingCount pedidos entrantes'
                      : 'IA Activa · Sin pedidos nuevos',
                  color: AppColors.successBg,
                  textColor: AppColors.successText,
                  iconColor: AppColors.successIcon,
                )
              : const _DashboardDisconnectedPill(),
        ],
      ),
    );
  }
}

class DashboardMetricsGrid extends StatelessWidget {
  final int pedidosHoy;
  final int activos;
  final int enPreparacion;
  final int listos;
  final double ventasHoy;
  final int entregados;
  final int enCamino;

  const DashboardMetricsGrid({
    super.key,
    this.pedidosHoy = 0,
    this.activos = 0,
    this.enPreparacion = 0,
    this.listos = 0,
    this.ventasHoy = 0,
    this.entregados = 0,
    this.enCamino = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.35,
      children: [
        _DashboardMetricCard(
          icon: FontAwesomeIcons.bagShopping,
          iconColor: AppColors.successText,
          iconBg: AppColors.successBg,
          label: 'Pedidos hoy',
          value: '$pedidosHoy',
          subText: '$activos activos',
          subColor: AppColors.successText,
        ),
        _DashboardMetricCard(
          icon: FontAwesomeIcons.clock,
          iconColor: AppColors.infoText,
          iconBg: AppColors.infoBg,
          label: 'En preparación',
          value: '$enPreparacion',
          subText: '$listos listos',
          subColor: AppColors.infoText,
        ),
        _DashboardMetricCard(
          icon: FontAwesomeIcons.dollarSign,
          iconColor: AppColors.aiText,
          iconBg: AppColors.aiBg,
          label: 'Ventas del día',
          value: _formatMoney(ventasHoy),
          subText: '$entregados entregados',
          subColor: AppColors.aiText,
        ),
        _DashboardMetricCard(
          icon: FontAwesomeIcons.motorcycle,
          iconColor: AppColors.warningText,
          iconBg: AppColors.warningBg,
          label: 'En camino',
          value: '$enCamino',
          subText: 'domicilios activos',
          subColor: AppColors.warningText,
        ),
      ],
    );
  }
}

class DashboardOrderTabs extends StatelessWidget {
  final List<String> labels;
  final List<int> counts;
  final int activeIndex;
  final ValueChanged<int>? onTabSelected;

  const DashboardOrderTabs({
    super.key,
    this.labels = const [
      'Recibidos',
      'Preparando',
      'Listos',
      'En camino',
      'Entregados',
    ],
    this.counts = const [0, 0, 0, 0, 0],
    this.activeIndex = 0,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: labels.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final count = index < counts.length ? counts[index] : 0;
              return Semantics(
                label: 'Filtrar pedidos ${labels[index]}',
                button: true,
                selected: index == activeIndex,
                child: GestureDetector(
                  onTap: () => onTabSelected?.call(index),
                  child: Center(
                    child: _DashboardTabChip(
                      label: labels[index],
                      count: '$count',
                      isActive: index == activeIndex,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DashboardEmptyState extends StatelessWidget {
  final String labelTab;

  const DashboardEmptyState({super.key, this.labelTab = 'Recibidos'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 40),
      child: Column(
        children: [
          const FaIcon(
            FontAwesomeIcons.inbox,
            color: AppColors.textTertiary,
            size: 40,
          ),
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
}

class DashboardOrderCard extends StatelessWidget {
  final OrderModel? pedido;
  final VoidCallback? onAceptar;

  const DashboardOrderCard({super.key, this.pedido, this.onAceptar});

  @override
  Widget build(BuildContext context) {
    final order = pedido ?? _sampleOrder();
    final gradients = _gradientForInitial(order.inicialCliente);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    order.inicialCliente,
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
                      order.cliente,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.id} · ${order.tipo.etiqueta}',
                      style: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  order.estado.etiqueta,
                  style: GoogleFonts.inter(
                    color: AppColors.warningText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.resumenItems,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatMoney(order.total),
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.clock,
                        color: AppColors.textMuted,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Hace ${order.tiempoTranscurridoFormat}',
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (onAceptar != null && order.estado.siguiente != null)
                Semantics(
                  label: 'Avanzar pedido ${order.id}',
                  button: true,
                  child: ElevatedButton(
                    onPressed: onAceptar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      minimumSize: const Size(0, 33),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      '${order.estado.siguiente?.etiqueta ?? 'Listo'} →',
                      style: GoogleFonts.inter(
                        color: AppColors.surface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardStatusPill extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Color iconColor;

  const _DashboardStatusPill({
    required this.text,
    required this.color,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardDisconnectedPill extends StatelessWidget {
  const _DashboardDisconnectedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(
            FontAwesomeIcons.triangleExclamation,
            color: AppColors.warningText,
            size: 12,
          ),
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
}

class _DashboardMetricCard extends StatelessWidget {
  final FaIconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final String subText;
  final Color subColor;

  const _DashboardMetricCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.subText,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
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
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subText,
            style: GoogleFonts.inter(color: subColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DashboardTabChip extends StatelessWidget {
  final String label;
  final String count;
  final bool isActive;

  const _DashboardTabChip({
    required this.label,
    required this.count,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
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
                  color: isActive ? AppColors.surface : AppColors.textSecondary,
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
}

String _formatMoney(double valor) {
  if (valor == 0) return '\$0';
  if (valor >= 1000000) {
    return '\$${(valor / 1000000).toStringAsFixed(1)}M';
  }
  if (valor >= 1000) {
    return '\$${(valor / 1000).toStringAsFixed(0)}K';
  }
  return '\$${valor.toStringAsFixed(0)}';
}

List<Color> _gradientForInitial(String inicial) {
  final paleta = [
    [AppColors.successBg, AppColors.successIcon.withValues(alpha: 0.35)],
    [AppColors.aiBg, AppColors.aiGradientEnd.withValues(alpha: 0.35)],
    [AppColors.infoBg, AppColors.infoBorder],
    [AppColors.warningBg, AppColors.warningIcon.withValues(alpha: 0.35)],
  ];
  final index = inicial.codeUnitAt(0) % paleta.length;
  return paleta[index];
}

OrderModel _sampleOrder() {
  return OrderModel(
    id: 'P-TEST',
    cliente: 'Carlos Mendoza',
    telefono: 'tg:1',
    items: const [
      ItemPedido(nombre: 'Producto demo', cantidad: 1, precio: 12000),
    ],
    total: 12000,
    estado: EstadoPedido.recibido,
    tipo: TipoPedido.recoger,
    creadoEn: DateTime.now(),
  );
}
