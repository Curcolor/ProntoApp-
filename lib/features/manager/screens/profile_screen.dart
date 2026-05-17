import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/data/models/user_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'inventario_screen.dart';
import 'equipo_screen.dart';
import 'agentes_ia_screen.dart';
import '../widgets/editar_perfil_modals.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthService>().currentUser;
    final nombre = usuario?.name ?? 'Usuario';
    final email = usuario?.email ?? '';
    final inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U';
    final esGerente = usuario?.role == RoleType.gerente;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero Section with Avatar
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 217.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF075E54)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                bottom: -6,
                left: 0,
                right: 0,
                child: Container(
                  height: 43.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(43.46),
                      topRight: Radius.circular(43.46),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -20, // Adjusted to place avatar overlapping
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 91.27,
                      height: 91.27,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4.35),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA7F3D0), Color(0xFF6EE7B7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.15 * 255).toInt()),
                            blurRadius: 17.38,
                            offset: const Offset(0, 4.35),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          inicial,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF128C7E),
                            fontSize: 34.77,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -4,
                      child: Container(
                        width: 30.42,
                        height: 30.42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.17),
                        ),
                        child: const Center(
                          child: FaIcon(FontAwesomeIcons.camera, color: Colors.white, size: 11.95),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Identity Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.73),
            child: Column(
              children: [
                Text(
                  nombre,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 23.90,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.33,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  esGerente ? 'Propietario · Mi negocio' : 'Empleado · Mi negocio',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 14.12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBadge(const Color(0xFFDCFCE7), const Color(0xFF15803D), FontAwesomeIcons.shop, 'Panadería'),
                    const SizedBox(width: 8.69),
                    Consumer<OrderProvider>(
                      builder: (context, orderProvider, child) {
                        final bool conectada = orderProvider.estaConectado;
                        return _buildBadge(
                          conectada ? const Color(0xFFDBEAFE) : const Color(0xFFFEF3C7), // warningBg
                          conectada ? const Color(0xFF1D4ED8) : const Color(0xFFB45309), // warningText
                          FontAwesomeIcons.robot,
                          conectada ? 'IA Activa' : 'IA No Activa',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick Metrics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.73),
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, child) {
                final int totalPedidos = orderProvider.pedidos.length;
                // Calculamos un tiempo promedio ficticio basado en órdenes para que sea dinámico
                final double tiempoResp = totalPedidos > 0 ? (3.0 + (totalPedidos % 5)) : 0.0;
                // Satisfacción calculada basada en entregados
                final int entregados = orderProvider.entregados.length;
                final String satisfaccion = totalPedidos > 0 
                    ? '${((entregados / totalPedidos) * 100).toInt()}%' 
                    : '0%';

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickMetric('${tiempoResp}m', 'T. Respuesta', const Color(0xFF0F172A)),
                    _buildQuickMetric('$totalPedidos', 'Pedidos total', const Color(0xFF0F172A)),
                    _buildQuickMetric(satisfaccion, 'Satisfacción', const Color(0xFF1DB954)),
                  ],
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Settings Lists
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.73),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('NEGOCIO'),
                const SizedBox(height: 8),
                // Sección NEGOCIO: filas con fondo de color sólido y texto blanco (Figma node 2256:5009)
                Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    final int entrantes = orderProvider.recibidos.length;
                    final String aiStatusText = !orderProvider.estaConectado 
                        ? 'IA No Activa · Sin conexión'
                        : entrantes > 0 
                            ? 'IA Activa · $entrantes pedidos entrantes'
                            : 'IA Activa · Sin pedidos nuevos';

                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.38),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 2.17,
                            offset: const Offset(0, 1.09),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildBusinessRow(
                            bgColor: const Color(0xFF1DB954),
                            icon: FontAwesomeIcons.users,
                            iconBgColor: const Color(0xFFDCFCE7),
                            iconColor: const Color(0xFF1DB954),
                            label: 'Equipo de trabajo',
                            value: 'Administrar equipo',
                            isFirst: true,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EquipoScreen())),
                          ),
                          _buildBusinessRow(
                            bgColor: const Color(0xFFF59E0B),
                            icon: FontAwesomeIcons.boxOpen,
                            iconBgColor: const Color(0xFFFEF3C7),
                            iconColor: const Color(0xFFF59E0B),
                            label: 'Inventario',
                            value: 'Administrar inventario',
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InventarioScreen())),
                          ),
                          _buildBusinessRow(
                            bgColor: const Color(0xFF6D28D9),
                            icon: FontAwesomeIcons.robot,
                            iconBgColor: const Color(0xFFEDE9FE),
                            iconColor: const Color(0xFF6D28D9),
                            label: 'Agente de IA',
                            value: aiStatusText,
                            isLast: true,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgentesIaScreen())),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                _buildSectionTitle('INFORMACIÓN'),
                const SizedBox(height: 8),
                _buildSettingsList([
                  _buildSettingsRow(
                    icon: FontAwesomeIcons.envelope,
                    iconBgColor: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF15803D),
                    label: 'Correo',
                    value: email.isNotEmpty ? email : 'Sin correo registrado',
                    onTap: () => EditarPerfilModals.showEditarCorreo(context),
                  ),
                  _buildSettingsRow(
                    icon: FontAwesomeIcons.phone,
                    iconBgColor: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF1D4ED8),
                    label: 'Teléfono',
                    value: '+57 300 123 4567',
                    onTap: () => EditarPerfilModals.showEditarTelefono(context),
                  ),
                  _buildSettingsRow(
                    icon: FontAwesomeIcons.locationDot,
                    iconBgColor: const Color(0xFFEDE9FE),
                    iconColor: const Color(0xFF6D28D9),
                    label: 'Ubicación',
                    value: 'Barrio El Prado, Barranquilla',
                    onTap: () => EditarPerfilModals.showEditarUbicacion(context),
                  ),
                  Builder(
                    builder: (ctx) {
                      final perfil = ctx.watch<PerfilUsuarioAdminService>().perfil;
                      return _buildSettingsRow(
                        icon: FontAwesomeIcons.shop,
                        iconBgColor: const Color(0xFFFEF3C7),
                        iconColor: const Color(0xFFB45309),
                        label: 'Negocio',
                        value: perfil?.negocioNombre ?? 'Sin negocio asociado',
                        isLast: true,
                        onTap: () => EditarPerfilModals.showEditarNegocio(context),
                      );
                    },
                  ),
                ]),
                
                const SizedBox(height: 24),
                _buildSectionTitle('CUENTA'),
                const SizedBox(height: 8),
                _buildSettingsList([
                  _buildSettingsRow(
                    icon: FontAwesomeIcons.whatsapp,
                    iconBgColor: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF15803D),
                    label: 'WhatsApp Business',
                    value: 'Conectado ✓',
                    onTap: () => EditarPerfilModals.showWhatsappBusiness(context),
                  ),
                  _buildSettingsRow(
                    icon: FontAwesomeIcons.lock,
                    iconBgColor: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF1D4ED8),
                    label: 'Seguridad',
                    value: 'Cambiar contraseña',
                    onTap: () => EditarPerfilModals.showCambiarContrasena(context),
                  ),
                  _buildSettingsRow(
                    icon: FontAwesomeIcons.arrowRightFromBracket,
                    iconBgColor: const Color(0xFFFEE2E2),
                    iconColor: const Color(0xFFB91C1C),
                    label: 'Cerrar sesión',
                    value: '',
                    valueColor: const Color(0xFFB91C1C),
                    isLast: true,
                    onTap: () async {
                      await AuthService().logout();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      }
                    },
                  ),
                ]),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fila de navegación de la sección NEGOCIO con fondo sólido de color (según Figma).
  Widget _buildBusinessRow({
    required Color bgColor,
    required FaIconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.only(
        topLeft: isFirst ? const Radius.circular(17.38) : Radius.zero,
        topRight: isFirst ? const Radius.circular(17.38) : Radius.zero,
        bottomLeft: isLast ? const Radius.circular(17.38) : Radius.zero,
        bottomRight: isLast ? const Radius.circular(17.38) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17.38, vertical: 15.21),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(17.38) : Radius.zero,
            topRight: isFirst ? const Radius.circular(17.38) : Radius.zero,
            bottomLeft: isLast ? const Radius.circular(17.38) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(17.38) : Radius.zero,
          ),
          border: isLast ? null : const Border(
            bottom: BorderSide(color: Color(0x33FFFFFF), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36.94,
              height: 36.94,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8.69),
              ),
              child: Center(
                child: FaIcon(icon, color: iconColor, size: 15.21),
              ),
            ),
            const SizedBox(width: 13.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11.95,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14.12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight, color: Colors.white, size: 13.04),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(Color bgColor, Color textColor, FaIconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.87, vertical: 3.26),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(1085.41),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: textColor, size: 11.95),
          const SizedBox(width: 4.34),
          Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 11.95,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMetric(String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 9.78, vertical: 14.12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13.04),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.09),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.08 * 255).toInt()),
              blurRadius: 3.26,
              offset: const Offset(0, 1.09),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: valueColor,
                fontSize: 19.56,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 10.86,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.35),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: const Color(0xFF94A3B8),
          fontSize: 11.95,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.87,
        ),
      ),
    );
  }

  Widget _buildSettingsList(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.38),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.09),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
            blurRadius: 2.17,
            offset: const Offset(0, 1.09),
          ),
        ],
      ),
      child: Column(
        children: rows,
      ),
    );
  }

  Widget _buildSettingsRow({
    required FaIconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17.38, vertical: 15.21),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.09)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.94,
              height: 36.94,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8.69),
              ),
              child: Center(
                child: FaIcon(icon, color: iconColor, size: 15.21),
              ),
            ),
            const SizedBox(width: 13.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (value.isNotEmpty && label != 'Cerrar sesión')
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11.95,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (label == 'Cerrar sesión')
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        color: valueColor ?? const Color(0xFF1E293B),
                        fontSize: 14.12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (value.isNotEmpty)
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        color: valueColor ?? const Color(0xFF1E293B),
                        fontSize: 14.12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight, color: Color(0xFF94A3B8), size: 13.04),
          ],
        ),
      ),
    );
  }
}
