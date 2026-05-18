import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/features/manager/screens/notificaciones_screen.dart';
import 'package:prontoapp/ui/components/manager/dashboard_components.dart';

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
        final nombreUsuario =
            context.watch<AuthService>().currentUser?.name ?? 'Manager';
        final primerNombre = nombreUsuario.split(' ').first;
        final negocioNombre =
            context.watch<PerfilUsuarioAdminService>().perfil?.negocioNombre ??
                'Mi negocio';
        final unreadCount = context.watch<NotificationProvider>().unreadCount;
        final tabActivo = _tabsDef[_activeTabIndex];
        final pedidosTab = orderProvider.pedidos
            .where((p) => p.estado == tabActivo.estado)
            .toList();
        final tabCounts = _tabsDef
            .map(
              (tab) =>
                  orderProvider.pedidos.where((p) => p.estado == tab.estado).length,
            )
            .toList();

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: DashboardHeader(
                  firstName: primerNombre,
                  businessName: negocioNombre,
                  isConnected: orderProvider.estaConectado,
                  incomingCount: orderProvider.recibidos.length,
                  unreadCount: unreadCount,
                  onNotificationsTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificacionesScreen(),
                      ),
                    );
                  },
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: DashboardMetricsGrid(
                    pedidosHoy: orderProvider.pedidosHoy,
                    activos: orderProvider.activos.length,
                    enPreparacion: orderProvider.enPreparacion.length,
                    listos: orderProvider.listos.length,
                    ventasHoy: orderProvider.ventasHoy,
                    entregados: orderProvider.entregados.length,
                    enCamino: orderProvider.enCamino.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: DashboardOrderTabs(
                    labels: _tabsDef.map((tab) => tab.label).toList(),
                    counts: tabCounts,
                    activeIndex: _activeTabIndex,
                    onTabSelected: (index) =>
                        setState(() => _activeTabIndex = index),
                  ),
                ),
              ),
              if (pedidosTab.isEmpty)
                SliverToBoxAdapter(
                  child: DashboardEmptyState(labelTab: tabActivo.label),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  sliver: SliverList.builder(
                    itemCount: pedidosTab.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidosTab[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DashboardOrderCard(
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
}

class _TabInfo {
  final String label;
  final EstadoPedido estado;

  const _TabInfo(this.label, this.estado);
}
