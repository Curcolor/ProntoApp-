/// F6.4 — Pantalla CRUD perfil del negocio (Negocio.update).
/// Consume `ObtenerNegocio` + `ActualizarNegocio` del SDK Data Connect.
/// Solo PROPIETARIO/GERENTE entran (validado server-side por @check del SDL).
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

class PerfilNegocioScreen extends StatefulWidget {
  const PerfilNegocioScreen({super.key});

  @override
  State<PerfilNegocioScreen> createState() => _PerfilNegocioScreenState();
}

class _PerfilNegocioScreenState extends State<PerfilNegocioScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombre;
  late TextEditingController _direccion;
  late TextEditingController _horaApertura;
  late TextEditingController _horaCierre;
  late TextEditingController _numeroWhatsapp;
  late TextEditingController _zonaHoraria;
  late TextEditingController _monedaIso;
  late TextEditingController _minutosSla;
  late TextEditingController _logoUrl;
  FormatoEntrega? _formatoEntrega;

  ObtenerNegocioNegocio? _negocio;
  bool _cargando = true;
  String? _error;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController();
    _direccion = TextEditingController();
    _horaApertura = TextEditingController();
    _horaCierre = TextEditingController();
    _numeroWhatsapp = TextEditingController();
    _zonaHoraria = TextEditingController();
    _monedaIso = TextEditingController();
    _minutosSla = TextEditingController();
    _logoUrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  @override
  void dispose() {
    _nombre.dispose();
    _direccion.dispose();
    _horaApertura.dispose();
    _horaCierre.dispose();
    _numeroWhatsapp.dispose();
    _zonaHoraria.dispose();
    _monedaIso.dispose();
    _minutosSla.dispose();
    _logoUrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final perfil = context.read<PerfilUsuarioAdminService>().perfil;
      if (perfil == null) {
        throw Exception('Perfil de usuario no disponible.');
      }
      final connector = context.read<ProntoappConnector>();
      final result = await connector
          .obtenerNegocio(negocioId: perfil.negocioId)
          .execute();
      final n = result.data.negocio;
      if (n == null) {
        throw Exception('Negocio no encontrado.');
      }
      _negocio = n;
      _nombre.text = n.nombre;
      _direccion.text = n.direccion ?? '';
      _horaApertura.text = n.horaApertura ?? '';
      _horaCierre.text = n.horaCierre ?? '';
      _numeroWhatsapp.text = n.numeroWhatsapp ?? '';
      _zonaHoraria.text = n.zonaHoraria;
      _monedaIso.text = n.monedaIso;
      _minutosSla.text = n.minutosGraciaSla.toString();
      _logoUrl.text = n.logoUrl ?? '';
      _formatoEntrega = n.formatoEntrega.maybeWhen(orElse: () => null);
      setState(() => _cargando = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_formatoEntrega == null) return;
    final negocio = _negocio;
    if (negocio == null) return;
    setState(() => _guardando = true);
    try {
      final connector = context.read<ProntoappConnector>();
      await connector
          .actualizarNegocio(
            negocioId: negocio.id,
            nombre: _nombre.text.trim(),
            formatoEntrega: _formatoEntrega!,
            zonaHoraria: _zonaHoraria.text.trim(),
            monedaIso: _monedaIso.text.trim(),
            minutosGraciaSla: int.parse(_minutosSla.text.trim()),
          )
          .direccion(_textOrNull(_direccion))
          .horaApertura(_textOrNull(_horaApertura))
          .horaCierre(_textOrNull(_horaCierre))
          .numeroWhatsapp(_textOrNull(_numeroWhatsapp))
          .logoUrl(_textOrNull(_logoUrl))
          .execute();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil del negocio actualizado.')),
      );
      // Refresca cache del perfil del usuario para que el nuevo nombre se
      // refleje en headers del manager.
      await context.read<PerfilUsuarioAdminService>().obtenerMiPerfil();
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _guardando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error guardando: $e')),
      );
    }
  }

  String? _textOrNull(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del negocio')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _campo('Nombre del negocio', _nombre, requerido: true),
                        _campo('Dirección', _direccion),
                        _campo('Hora apertura (HH:MM:SS)', _horaApertura),
                        _campo('Hora cierre (HH:MM:SS)', _horaCierre),
                        DropdownButtonFormField<FormatoEntrega>(
                          initialValue: _formatoEntrega,
                          decoration: const InputDecoration(labelText: 'Formato de entrega'),
                          items: FormatoEntrega.values
                              .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
                              .toList(),
                          onChanged: (v) => setState(() => _formatoEntrega = v),
                          validator: (v) => v == null ? 'Requerido' : null,
                        ),
                        _campo('WhatsApp del negocio', _numeroWhatsapp),
                        _campo('Zona horaria (ej. America/Bogota)', _zonaHoraria, requerido: true),
                        _campo('Moneda ISO (ej. COP)', _monedaIso, requerido: true),
                        _campo('Minutos de gracia SLA', _minutosSla, requerido: true, esEntero: true),
                        _campo('URL del logo', _logoUrl),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _guardando ? null : _guardar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(_guardando ? 'Guardando…' : 'Guardar cambios'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _campo(String label, TextEditingController c,
      {bool requerido = false, bool esEntero = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: c,
        keyboardType: esEntero ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
        validator: (v) {
          if (requerido && (v == null || v.trim().isEmpty)) {
            return 'Requerido';
          }
          if (esEntero && v != null && v.trim().isNotEmpty && int.tryParse(v.trim()) == null) {
            return 'Debe ser un entero';
          }
          return null;
        },
      ),
    );
  }
}

extension on EnumValue<FormatoEntrega> {
  T maybeWhen<T>({required T Function() orElse}) {
    return switch (this) {
      Known<FormatoEntrega>(:final value) => value as T,
      _ => orElse(),
    };
  }
}
