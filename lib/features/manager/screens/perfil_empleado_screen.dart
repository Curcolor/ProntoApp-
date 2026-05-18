import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/data/models/user_model.dart';
import 'package:prontoapp/ui/components/manager/perfil_empleado_components.dart';

class PerfilEmpleadoScreen extends StatefulWidget {
  final UserModel usuario;
  final Map<String, dynamic> meta;

  const PerfilEmpleadoScreen({
    super.key,
    required this.usuario,
    required this.meta,
  });

  @override
  State<PerfilEmpleadoScreen> createState() => _PerfilEmpleadoScreenState();
}

class _PerfilEmpleadoScreenState extends State<PerfilEmpleadoScreen> {
  bool _verPedidos = true;
  bool _gestionarPedidos = true;
  bool _verInventario = true;
  bool _editarInventario = true;
  bool _verReportes = false;
  bool _iaConfig = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            EmployeeProfileHeader(
              usuario: widget.usuario,
              meta: widget.meta,
              onBack: () => Navigator.pop(context),
              onOptions: () {},
            ),
            Expanded(
              child: EmployeeProfileBody(
                usuario: widget.usuario,
                meta: widget.meta,
                permissions: _permissions(),
                actions: EmployeeActionsRow(
                  onChangeRole: () {},
                  onSuspend: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<EmployeePermissionItem> _permissions() {
    return [
      EmployeePermissionItem(
        icon: FontAwesomeIcons.receipt,
        iconColor: const Color(0xFF15803D),
        iconBgColor: const Color(0xFFDCFCE7),
        title: 'Ver pedidos',
        subtitle: 'Cola de cocina y estados',
        value: _verPedidos,
        onChanged: (value) => setState(() => _verPedidos = value),
      ),
      EmployeePermissionItem(
        icon: FontAwesomeIcons.listCheck,
        iconColor: const Color(0xFF15803D),
        iconBgColor: const Color(0xFFDCFCE7),
        title: 'Gestionar pedidos',
        subtitle: 'Marcar listos, cambiar estado',
        value: _gestionarPedidos,
        onChanged: (value) => setState(() => _gestionarPedidos = value),
      ),
      EmployeePermissionItem(
        icon: FontAwesomeIcons.boxesStacked,
        iconColor: const Color(0xFFB45309),
        iconBgColor: const Color(0xFFFEF3C7),
        title: 'Ver inventario',
        subtitle: 'Consultar stock',
        value: _verInventario,
        onChanged: (value) => setState(() => _verInventario = value),
      ),
      EmployeePermissionItem(
        icon: FontAwesomeIcons.pen,
        iconColor: const Color(0xFFB45309),
        iconBgColor: const Color(0xFFFEF3C7),
        title: 'Editar inventario',
        subtitle: 'Modificar stock y productos',
        value: _editarInventario,
        onChanged: (value) => setState(() => _editarInventario = value),
      ),
      EmployeePermissionItem(
        icon: FontAwesomeIcons.chartSimple,
        iconColor: const Color(0xFF94A3B8),
        iconBgColor: const Color(0xFFF1F5F9),
        title: 'Ver reportes KPI',
        subtitle: 'Solo dueño / admin',
        value: _verReportes,
        onChanged: (value) => setState(() => _verReportes = value),
        isDisabled: true,
      ),
      EmployeePermissionItem(
        icon: FontAwesomeIcons.robot,
        iconColor: const Color(0xFF94A3B8),
        iconBgColor: const Color(0xFFF1F5F9),
        title: 'IA y configuracion',
        subtitle: 'Solo dueño / admin',
        value: _iaConfig,
        onChanged: (value) => setState(() => _iaConfig = value),
        isDisabled: true,
      ),
    ];
  }
}
