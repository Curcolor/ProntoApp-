/// F6.4 — CRUD pasos del flujo de pedido. Define el orden y SLA por estado
/// del pedido en cada negocio (panadería vs restaurante difieren).
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

class PasosFlujoPedidoScreen extends StatefulWidget {
  const PasosFlujoPedidoScreen({super.key});

  @override
  State<PasosFlujoPedidoScreen> createState() => _PasosFlujoPedidoScreenState();
}

class _PasosFlujoPedidoScreenState extends State<PasosFlujoPedidoScreen> {
  late Future<List<ObtenerPasosFlujoPedidoAdminPasosFlujoPedido>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _cargar();
  }

  Future<List<ObtenerPasosFlujoPedidoAdminPasosFlujoPedido>> _cargar() async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) throw Exception('Perfil no disponible.');
    final connector = context.read<ProntoappConnector>();
    final r = await connector
        .obtenerPasosFlujoPedidoAdmin(negocioId: perfil.negocioId)
        .execute();
    return r.data.pasosFlujoPedido;
  }

  void _refrescar() => setState(() => _futuro = _cargar());

  Future<void> _abrirModal({ObtenerPasosFlujoPedidoAdminPasosFlujoPedido? existente}) async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) return;
    final connector = context.read<ProntoappConnector>();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _PasoFormSheet(
        connector: connector,
        negocioId: perfil.negocioId,
        existente: existente,
      ),
    );
    if (ok == true) _refrescar();
  }

  Future<void> _archivar(ObtenerPasosFlujoPedidoAdminPasosFlujoPedido p) async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) return;
    final connector = context.read<ProntoappConnector>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desactivar paso'),
        content: Text('¿Desactivar paso "${p.etiqueta}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Desactivar')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await connector
          .desactivarPasoFlujoPedido(negocioId: perfil.negocioId, id: p.id)
          .execute();
      _refrescar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flujo de pedidos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirModal(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: FutureBuilder(
        future: _futuro,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final lista = snap.data ?? [];
          if (lista.isEmpty) {
            return const Center(child: Text('Sin pasos configurados. Crea el primero.'));
          }
          return ListView.separated(
            itemCount: lista.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, idx) {
              final p = lista[idx];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text('${p.orden}'),
                ),
                title: Text(p.etiqueta,
                    style: TextStyle(decoration: p.activo ? null : TextDecoration.lineThrough)),
                subtitle: Text(
                  '${p.estado.stringValue} · disparo ${p.disparador.stringValue}'
                  '${p.minutosSla != null ? ' · SLA ${p.minutosSla}min' : ''}'
                  '${p.activo ? '' : ' · inactivo'}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _abrirModal(existente: p)),
                    if (p.activo)
                      IconButton(icon: const Icon(Icons.archive_outlined), onPressed: () => _archivar(p)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PasoFormSheet extends StatefulWidget {
  const _PasoFormSheet({
    required this.connector,
    required this.negocioId,
    this.existente,
  });

  final ProntoappConnector connector;
  final String negocioId;
  final ObtenerPasosFlujoPedidoAdminPasosFlujoPedido? existente;

  @override
  State<_PasoFormSheet> createState() => _PasoFormSheetState();
}

class _PasoFormSheetState extends State<_PasoFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _etiqueta;
  late TextEditingController _orden;
  late TextEditingController _minutosSla;
  EstadoPedido? _estado;
  DisparadorFlujo? _disparador;
  bool _activo = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    _etiqueta = TextEditingController(text: e?.etiqueta ?? '');
    _orden = TextEditingController(text: (e?.orden ?? 0).toString());
    _minutosSla = TextEditingController(text: e?.minutosSla?.toString() ?? '');
    _activo = e?.activo ?? true;
    if (e != null) {
      _estado = switch (e.estado) {
        Known<EstadoPedido>(:final value) => value,
        _ => null,
      };
      _disparador = switch (e.disparador) {
        Known<DisparadorFlujo>(:final value) => value,
        _ => null,
      };
    } else {
      _disparador = DisparadorFlujo.ESTADO_CAMBIADO;
    }
  }

  @override
  void dispose() {
    _etiqueta.dispose();
    _orden.dispose();
    _minutosSla.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_disparador == null) return;
    if (widget.existente == null && _estado == null) return;
    setState(() => _guardando = true);
    try {
      final etiqueta = _etiqueta.text.trim();
      final orden = int.parse(_orden.text.trim());
      final sla = _minutosSla.text.trim().isEmpty ? null : int.parse(_minutosSla.text.trim());
      if (widget.existente == null) {
        await widget.connector
            .crearPasoFlujoPedido(
              negocioId: widget.negocioId,
              estado: _estado!,
              etiqueta: etiqueta,
              orden: orden,
              disparador: _disparador!,
            )
            .minutosSla(sla)
            .execute();
      } else {
        await widget.connector
            .actualizarPasoFlujoPedido(
              negocioId: widget.negocioId,
              id: widget.existente!.id,
              etiqueta: etiqueta,
              orden: orden,
              disparador: _disparador!,
              activo: _activo,
            )
            .minutosSla(sla)
            .execute();
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _guardando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.existente != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(esEdicion ? 'Editar paso' : 'Nuevo paso',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (!esEdicion)
                DropdownButtonFormField<EstadoPedido>(
                  initialValue: _estado,
                  decoration: const InputDecoration(labelText: 'Estado del pedido *'),
                  items: EstadoPedido.values
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _estado = v),
                  validator: (v) => v == null ? 'Requerido' : null,
                ),
              TextFormField(
                controller: _etiqueta,
                decoration: const InputDecoration(labelText: 'Etiqueta visible *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _orden,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Orden *'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  if (int.tryParse(v.trim()) == null) return 'Debe ser entero';
                  return null;
                },
              ),
              TextFormField(
                controller: _minutosSla,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'SLA (minutos, opcional)'),
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty && int.tryParse(v.trim()) == null) {
                    return 'Debe ser entero';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<DisparadorFlujo>(
                initialValue: _disparador,
                decoration: const InputDecoration(labelText: 'Disparador'),
                items: DisparadorFlujo.values
                    .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
                    .toList(),
                onChanged: (v) => setState(() => _disparador = v),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              if (esEdicion)
                SwitchListTile(
                  title: const Text('Activo'),
                  value: _activo,
                  onChanged: (v) => setState(() => _activo = v),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(_guardando ? 'Guardando…' : (esEdicion ? 'Actualizar' : 'Crear')),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
