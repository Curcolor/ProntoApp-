import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/models/user_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/ui/components/manager/profile_components.dart';

import '../widgets/editar_perfil_modals.dart';
import 'agentes_ia_screen.dart';
import 'equipo_screen.dart';
import 'inventario_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthService>().currentUser;
    final nombre = usuario?.name ?? 'Usuario';
    final email = usuario?.email ?? '';
    final esGerente = usuario?.role == RoleType.gerente;

    return SingleChildScrollView(
      child: Column(
        children: [
          Consumer<OrderProvider>(
            builder: (context, orderProvider, _) => ProfileHeroSummary(
              name: nombre,
              isManager: esGerente,
              aiConnected: orderProvider.estaConectado,
              totalOrders: orderProvider.pedidos.length,
              deliveredOrders: orderProvider.entregados.length,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.73),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) =>
                      ProfileBusinessSection(
                        aiConnected: orderProvider.estaConectado,
                        incomingOrders: orderProvider.recibidos.length,
                        onTeamTap: () => _push(context, const EquipoScreen()),
                        onInventoryTap: () =>
                            _push(context, const InventarioScreen()),
                        onAiTap: () => _push(context, const AgentesIaScreen()),
                      ),
                ),
                const SizedBox(height: 24),
                Builder(
                  builder: (context) {
                    final perfil = context
                        .watch<PerfilUsuarioAdminService>()
                        .perfil;

                    return ProfileSettingsSection(
                      email: email,
                      businessName:
                          perfil?.negocioNombre ?? 'Sin negocio asociado',
                      onEmailTap: () =>
                          EditarPerfilModals.showEditarCorreo(context),
                      onPhoneTap: () =>
                          EditarPerfilModals.showEditarTelefono(context),
                      onLocationTap: () =>
                          EditarPerfilModals.showEditarUbicacion(context),
                      onBusinessTap: () =>
                          EditarPerfilModals.showEditarNegocio(context),
                      onWhatsappTap: () =>
                          EditarPerfilModals.showWhatsappBusiness(context),
                      onSecurityTap: () =>
                          EditarPerfilModals.showCambiarContrasena(context),
                      onLogoutTap: () => _logout(context),
                    );
                  },
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }
}
