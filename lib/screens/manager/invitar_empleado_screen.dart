import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/modals/invitacion_enviada_modal.dart';

class InvitarEmpleadoScreen extends StatefulWidget {
  const InvitarEmpleadoScreen({super.key});

  @override
  State<InvitarEmpleadoScreen> createState() => _InvitarEmpleadoScreenState();
}

class _InvitarEmpleadoScreenState extends State<InvitarEmpleadoScreen> {
  int _rolSeleccionado = 0;
  final _controladorNombre = TextEditingController();
  final _controladorTelefono = TextEditingController();
  final _controladorCorreo = TextEditingController();

  final List<Map<String, dynamic>> _roles = [
    {
      'titulo': 'Cocinero',
      'descripcion': 'Ve y gestiona los pedidos. Puede actualizar el inventario de cocina. No accede a reportes ni configuracion.',
      'icono': FontAwesomeIcons.fireBurner,
      'colorIcono': const Color(0xFFB45309),
      'bgIcono': const Color(0xFFFEF3C7),
    },
    {
      'titulo': 'Repartidor',
      'descripcion': 'Ve pedidos listos para entrega. Confirma entregas y actualiza estado. Sin acceso a inventario ni reportes.',
      'icono': FontAwesomeIcons.motorcycle,
      'colorIcono': const Color(0xFF1D4ED8),
      'bgIcono': const Color(0xFFDBEAFE),
    },
    {
      'titulo': 'Administrador',
      'descripcion': 'Acceso completo: pedidos, inventario, reportes y configuracion. Comparte privilegios con el dueno.',
      'icono': FontAwesomeIcons.userTie,
      'colorIcono': const Color(0xFF6D28D9),
      'bgIcono': const Color(0xFFEDE9FE),
    },
  ];

  @override
  void dispose() {
    _controladorNombre.dispose();
    _controladorTelefono.dispose();
    _controladorCorreo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    children: [
                      _buildSectionTitle('Selecciona el rol'),
                      const SizedBox(height: 8),
                      ..._roles.asMap().entries.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildRoleCard(indice: e.key, rol: e.value),
                          )),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Datos del empleado'),
                      const SizedBox(height: 8),
                      _buildFormulario(),
                      const SizedBox(height: 16),
                      _buildWhatsAppInfo(),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Permisos del rol ${_roles[_rolSeleccionado]['titulo']}'),
                      const SizedBox(height: 8),
                      _buildPermisosPreview(),
                    ],
                  ),
                ),
              ],
            ),
            _buildBotonEnviar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
              child: const FaIcon(FontAwesomeIcons.arrowLeft, color: Color(0xFF334155), size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Invitar empleado', style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
              Text('Se enviara el acceso por WhatsApp', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(titulo.toUpperCase(), style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
    );
  }

  Widget _buildRoleCard({required int indice, required Map<String, dynamic> rol}) {
    final seleccionado = _rolSeleccionado == indice;
    return GestureDetector(
      onTap: () => setState(() => _rolSeleccionado = indice),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: seleccionado ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: seleccionado ? const Color(0xFF25D366) : const Color(0xFFE2E8F0), width: 2),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 1), blurRadius: 3)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(color: rol['bgIcono'] as Color, borderRadius: BorderRadius.circular(12)),
              child: FaIcon(rol['icono'] as FaIconData, color: rol['colorIcono'] as Color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rol['titulo'] as String, style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(rol['descripcion'] as String, style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: seleccionado ? const Color(0xFF25D366) : Colors.white,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: seleccionado ? const Color(0xFF25D366) : const Color(0xFFCBD5E1), width: 2),
              ),
              child: seleccionado ? const FaIcon(FontAwesomeIcons.check, color: Colors.white, size: 11) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCampo(label: 'Nombre completo *', hint: 'Ej: Sofia Herrera', icono: FontAwesomeIcons.user, controlador: _controladorNombre),
        const SizedBox(height: 14),
        Text('Telefono WhatsApp *', style: GoogleFonts.inter(color: const Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              width: 80, height: 52,
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Center(child: Text('🇨🇴 +57', style: GoogleFonts.inter(color: const Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.w600))),
            ),
            const SizedBox(width: 8),
            Expanded(child: _buildCampo(hint: '316 000 0000', icono: FontAwesomeIcons.whatsapp, iconoColor: const Color(0xFF25D366), controlador: _controladorTelefono, tipo: TextInputType.phone)),
          ],
        ),
        const SizedBox(height: 14),
        _buildCampo(label: 'Correo electronico', labelOpcional: '(opcional)', hint: 'correo@ejemplo.com', icono: FontAwesomeIcons.envelope, controlador: _controladorCorreo, tipo: TextInputType.emailAddress),
      ],
    );
  }

  Widget _buildCampo({String? label, String? labelOpcional, required String hint, required FaIconData icono, Color iconoColor = const Color(0xFF94A3B8), required TextEditingController controlador, TextInputType tipo = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(children: [
            Text(label, style: GoogleFonts.inter(color: const Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.w600)),
            if (labelOpcional != null) ...[const SizedBox(width: 4), Text(labelOpcional, style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 13))],
          ]),
          const SizedBox(height: 6),
        ],
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Row(children: [
            FaIcon(icono, color: iconoColor, size: 16),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: controlador, keyboardType: tipo, decoration: InputDecoration(hintText: hint, hintStyle: GoogleFonts.inter(color: const Color(0xFF757575), fontSize: 15), border: InputBorder.none, contentPadding: EdgeInsets.zero, isDense: true), style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 15))),
          ]),
        ),
      ],
    );
  }

  Widget _buildWhatsAppInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF86EFAC))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text('El empleado recibira un mensaje de WhatsApp con el enlace de acceso y las instrucciones para crear su cuenta.', style: GoogleFonts.inter(color: const Color(0xFF166534), fontSize: 11, height: 1.5))),
        ],
      ),
    );
  }

  Widget _buildPermisosPreview() {
    final permisosPorRol = [
      [
        {'nombre': 'Ver pedidos', 'desc': 'Cola de cocina y estados', 'activo': true, 'icono': FontAwesomeIcons.receipt, 'color': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
        {'nombre': 'Gestionar pedidos', 'desc': 'Marcar listos, cambiar estado', 'activo': true, 'icono': FontAwesomeIcons.listCheck, 'color': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
        {'nombre': 'Ver inventario', 'desc': 'Consultar stock de productos', 'activo': true, 'icono': FontAwesomeIcons.boxesStacked, 'color': const Color(0xFFB45309), 'bg': const Color(0xFFFEF3C7)},
        {'nombre': 'Ver reportes', 'desc': 'Solo dueño / admin', 'activo': false, 'icono': FontAwesomeIcons.chartSimple, 'color': const Color(0xFF94A3B8), 'bg': const Color(0xFFF1F5F9)},
      ],
      [
        {'nombre': 'Ver pedidos', 'desc': 'Solo pedidos para entrega', 'activo': true, 'icono': FontAwesomeIcons.receipt, 'color': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
        {'nombre': 'Confirmar entrega', 'desc': 'Marcar como entregado', 'activo': true, 'icono': FontAwesomeIcons.circleCheck, 'color': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
        {'nombre': 'Ver inventario', 'desc': 'Sin acceso', 'activo': false, 'icono': FontAwesomeIcons.boxesStacked, 'color': const Color(0xFF94A3B8), 'bg': const Color(0xFFF1F5F9)},
        {'nombre': 'Ver reportes', 'desc': 'Solo dueño / admin', 'activo': false, 'icono': FontAwesomeIcons.chartSimple, 'color': const Color(0xFF94A3B8), 'bg': const Color(0xFFF1F5F9)},
      ],
      [
        {'nombre': 'Ver pedidos', 'desc': 'Cola de cocina y estados', 'activo': true, 'icono': FontAwesomeIcons.receipt, 'color': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
        {'nombre': 'Gestionar pedidos', 'desc': 'Marcar listos, cambiar estado', 'activo': true, 'icono': FontAwesomeIcons.listCheck, 'color': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
        {'nombre': 'Ver inventario', 'desc': 'Acceso completo', 'activo': true, 'icono': FontAwesomeIcons.boxesStacked, 'color': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
        {'nombre': 'Ver reportes', 'desc': 'KPIs y métricas', 'activo': true, 'icono': FontAwesomeIcons.chartSimple, 'color': const Color(0xFF15803D), 'bg': const Color(0xFFDCFCE7)},
      ],
    ];
    final permisos = permisosPorRol[_rolSeleccionado];
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF1F5F9)), boxShadow: const [BoxShadow(color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 3)]),
      child: Column(children: permisos.asMap().entries.map((e) {
        final p = e.value;
        final esUltimo = e.key == permisos.length - 1;
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Container(width: 34, height: 34, decoration: BoxDecoration(color: p['bg'] as Color, borderRadius: BorderRadius.circular(8)), child: FaIcon(p['icono'] as FaIconData, color: p['color'] as Color, size: 14)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['nombre'] as String, style: GoogleFonts.inter(color: (p['activo'] as bool) ? const Color(0xFF1E293B) : const Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600)),
                Text(p['desc'] as String, style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
              ])),
              Container(
                width: 46, height: 26,
                decoration: BoxDecoration(color: (p['activo'] as bool) ? const Color(0xFF25D366) : const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(999)),
                child: Align(
                  alignment: (p['activo'] as bool) ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: Container(width: 20, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 3, offset: Offset(0, 1))]))),
                ),
              ),
            ]),
          ),
          if (!esUltimo) const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
        ]);
      }).toList()),
    );
  }

  Widget _buildBotonEnviar() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.white, Colors.white.withOpacity(0.0)], stops: const [0.7, 1.0])),
        child: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => InvitacionEnviadaModal.show(context),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Color(0x5925D366), offset: Offset(0, 4), blurRadius: 14)],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text('Enviar invitacion', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
