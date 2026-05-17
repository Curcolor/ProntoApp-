/// F6.4 — CRUD plantillas IA del negocio (PlantillaIa). Permite al
/// PROPIETARIO/GERENTE crear o ajustar prompts del agente sin tocar código.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

class PlantillasIaAdminScreen extends StatefulWidget {
  const PlantillasIaAdminScreen({super.key});

  @override
  State<PlantillasIaAdminScreen> createState() => _PlantillasIaAdminScreenState();
}

class _PlantillasIaAdminScreenState extends State<PlantillasIaAdminScreen> {
  late Future<List<ObtenerPlantillasIaAdminPlantillasIa>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _cargar();
  }

  Future<List<ObtenerPlantillasIaAdminPlantillasIa>> _cargar() async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) throw Exception('Perfil no disponible.');
    final connector = context.read<ProntoappConnector>();
    final r = await connector
        .obtenerPlantillasIaAdmin(negocioId: perfil.negocioId)
        .execute();
    return r.data.plantillasIa;
  }

  void _refrescar() => setState(() => _futuro = _cargar());

  Future<void> _abrirModal({ObtenerPlantillasIaAdminPlantillasIa? existente}) async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) return;
    final connector = context.read<ProntoappConnector>();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _PlantillaFormSheet(
        connector: connector,
        negocioId: perfil.negocioId,
        existente: existente,
      ),
    );
    if (ok == true) _refrescar();
  }

  Future<void> _archivar(ObtenerPlantillasIaAdminPlantillasIa p) async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) return;
    final connector = context.read<ProntoappConnector>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desactivar plantilla'),
        content: Text('¿Desactivar plantilla "${p.codigo} v${p.version}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Desactivar')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await connector
          .desactivarPlantillaIa(negocioId: perfil.negocioId, id: p.id)
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
      appBar: AppBar(title: const Text('Plantillas IA')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirModal(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
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
            return const Center(child: Text('Sin plantillas. Crea la primera.'));
          }
          return ListView.separated(
            itemCount: lista.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, idx) {
              final p = lista[idx];
              return ListTile(
                leading: const Icon(Icons.psychology),
                title: Text('${p.codigo} · v${p.version}',
                    style: TextStyle(decoration: p.activo ? null : TextDecoration.lineThrough)),
                subtitle: Text(
                  '${p.casoUso.stringValue} · ${p.proveedor.stringValue}/${p.modelo}'
                  '${p.activo ? '' : ' · inactiva'}',
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

class _PlantillaFormSheet extends StatefulWidget {
  const _PlantillaFormSheet({
    required this.connector,
    required this.negocioId,
    this.existente,
  });

  final ProntoappConnector connector;
  final String negocioId;
  final ObtenerPlantillasIaAdminPlantillasIa? existente;

  @override
  State<_PlantillaFormSheet> createState() => _PlantillaFormSheetState();
}

class _PlantillaFormSheetState extends State<_PlantillaFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codigo;
  late TextEditingController _version;
  late TextEditingController _modelo;
  late TextEditingController _promptSistema;
  late TextEditingController _promptUsuario;
  late TextEditingController _idioma;
  late TextEditingController _temperatura;
  late TextEditingController _maxTokens;
  CasoUsoPlantilla? _casoUso;
  ProveedorLlm? _proveedor;
  bool _activo = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    _codigo = TextEditingController(text: e?.codigo ?? '');
    _version = TextEditingController(text: (e?.version ?? 1).toString());
    _modelo = TextEditingController(text: e?.modelo ?? '');
    _promptSistema = TextEditingController(text: e?.promptSistema ?? '');
    _promptUsuario = TextEditingController(text: e?.promptUsuarioTemplate ?? '');
    _idioma = TextEditingController(text: e?.idioma ?? 'es');
    _temperatura = TextEditingController(text: e?.temperatura?.toString() ?? '0.2');
    _maxTokens = TextEditingController(text: e?.maxTokens?.toString() ?? '');
    _activo = e?.activo ?? true;
    if (e != null) {
      _casoUso = switch (e.casoUso) {
        Known<CasoUsoPlantilla>(:final value) => value,
        _ => null,
      };
      _proveedor = switch (e.proveedor) {
        Known<ProveedorLlm>(:final value) => value,
        _ => null,
      };
    } else {
      _proveedor = ProveedorLlm.ANTHROPIC;
    }
  }

  @override
  void dispose() {
    _codigo.dispose();
    _version.dispose();
    _modelo.dispose();
    _promptSistema.dispose();
    _promptUsuario.dispose();
    _idioma.dispose();
    _temperatura.dispose();
    _maxTokens.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_proveedor == null) return;
    if (widget.existente == null && _casoUso == null) return;
    setState(() => _guardando = true);
    try {
      final codigo = _codigo.text.trim();
      final version = int.parse(_version.text.trim());
      final modelo = _modelo.text.trim();
      final promptSistema = _promptSistema.text.trim();
      final promptUsuario = _promptUsuario.text.trim().isEmpty ? null : _promptUsuario.text.trim();
      final idioma = _idioma.text.trim();
      final temperatura = _temperatura.text.trim().isEmpty ? null : double.parse(_temperatura.text.trim());
      final maxTokens = _maxTokens.text.trim().isEmpty ? null : int.parse(_maxTokens.text.trim());

      if (widget.existente == null) {
        await widget.connector
            .crearPlantillaIa(
              negocioId: widget.negocioId,
              codigo: codigo,
              casoUso: _casoUso!,
              version: version,
              proveedor: _proveedor!,
              modelo: modelo,
              promptSistema: promptSistema,
              idioma: idioma,
            )
            .promptUsuarioTemplate(promptUsuario)
            .temperatura(temperatura)
            .maxTokens(maxTokens)
            .execute();
      } else {
        await widget.connector
            .actualizarPlantillaIa(
              negocioId: widget.negocioId,
              id: widget.existente!.id,
              codigo: codigo,
              version: version,
              proveedor: _proveedor!,
              modelo: modelo,
              promptSistema: promptSistema,
              idioma: idioma,
              activo: _activo,
            )
            .promptUsuarioTemplate(promptUsuario)
            .temperatura(temperatura)
            .maxTokens(maxTokens)
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
              Text(esEdicion ? 'Editar plantilla' : 'Nueva plantilla IA',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (!esEdicion)
                DropdownButtonFormField<CasoUsoPlantilla>(
                  initialValue: _casoUso,
                  decoration: const InputDecoration(labelText: 'Caso de uso *'),
                  items: CasoUsoPlantilla.values
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _casoUso = v),
                  validator: (v) => v == null ? 'Requerido' : null,
                ),
              TextFormField(
                controller: _codigo,
                decoration: const InputDecoration(labelText: 'Código (ej. recepcion_v3) *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _version,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Versión *'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  if (int.tryParse(v.trim()) == null) return 'Debe ser entero';
                  return null;
                },
              ),
              DropdownButtonFormField<ProveedorLlm>(
                initialValue: _proveedor,
                decoration: const InputDecoration(labelText: 'Proveedor *'),
                items: ProveedorLlm.values
                    .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                    .toList(),
                onChanged: (v) => setState(() => _proveedor = v),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _modelo,
                decoration: const InputDecoration(labelText: 'Modelo (ej. claude-3-5-sonnet) *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _promptSistema,
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(labelText: 'Prompt de sistema *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _promptUsuario,
                minLines: 2,
                maxLines: 6,
                decoration: const InputDecoration(labelText: 'Prompt usuario template (opcional)'),
              ),
              TextFormField(
                controller: _idioma,
                decoration: const InputDecoration(labelText: 'Idioma (ej. es) *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _temperatura,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Temperatura (0-2)'),
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty && double.tryParse(v.trim()) == null) {
                    return 'Debe ser número';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxTokens,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Max tokens (opcional)'),
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty && int.tryParse(v.trim()) == null) {
                    return 'Debe ser entero';
                  }
                  return null;
                },
              ),
              if (esEdicion)
                SwitchListTile(
                  title: const Text('Activa'),
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
