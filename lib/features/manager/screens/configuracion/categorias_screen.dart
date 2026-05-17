/// F6.4 — CRUD categorías del menú. Lista + alta/edición vía modal +
/// archivado (soft delete vía activo=false).
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  late Future<List<ObtenerCategoriasAdminCategorias>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _cargar();
  }

  Future<List<ObtenerCategoriasAdminCategorias>> _cargar() async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) throw Exception('Perfil no disponible.');
    final connector = context.read<ProntoappConnector>();
    final r = await connector
        .obtenerCategoriasAdmin(negocioId: perfil.negocioId)
        .execute();
    return r.data.categorias;
  }

  void _refrescar() => setState(() => _futuro = _cargar());

  Future<void> _abrirModal({ObtenerCategoriasAdminCategorias? existente}) async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) return;
    final connector = context.read<ProntoappConnector>();
    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CategoriaFormSheet(
        connector: connector,
        negocioId: perfil.negocioId,
        existente: existente,
      ),
    );
    if (guardado == true) _refrescar();
  }

  Future<void> _archivar(ObtenerCategoriasAdminCategorias c) async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) return;
    final connector = context.read<ProntoappConnector>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Archivar categoría'),
        content: Text('¿Archivar "${c.nombre}"? Productos asociados no se borran.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Archivar')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await connector
          .desactivarCategoria(negocioId: perfil.negocioId, id: c.id)
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
      appBar: AppBar(title: const Text('Categorías')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirModal(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nueva'),
      ),
      body: FutureBuilder<List<ObtenerCategoriasAdminCategorias>>(
        future: _futuro,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final cats = snap.data ?? [];
          if (cats.isEmpty) {
            return const Center(child: Text('Sin categorías. Crea la primera.'));
          }
          return ListView.separated(
            itemCount: cats.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final c = cats[i];
              return ListTile(
                leading: Text(c.emoji ?? '📦', style: const TextStyle(fontSize: 24)),
                title: Text(c.nombre,
                    style: TextStyle(decoration: c.activo ? null : TextDecoration.lineThrough)),
                subtitle: Text('Orden: ${c.orden}${c.activo ? '' : ' · archivada'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _abrirModal(existente: c)),
                    if (c.activo)
                      IconButton(icon: const Icon(Icons.archive_outlined), onPressed: () => _archivar(c)),
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

class _CategoriaFormSheet extends StatefulWidget {
  const _CategoriaFormSheet({
    required this.connector,
    required this.negocioId,
    this.existente,
  });

  final ProntoappConnector connector;
  final String negocioId;
  final ObtenerCategoriasAdminCategorias? existente;

  @override
  State<_CategoriaFormSheet> createState() => _CategoriaFormSheetState();
}

class _CategoriaFormSheetState extends State<_CategoriaFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombre;
  late TextEditingController _emoji;
  late TextEditingController _orden;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.existente?.nombre ?? '');
    _emoji = TextEditingController(text: widget.existente?.emoji ?? '');
    _orden = TextEditingController(text: (widget.existente?.orden ?? 0).toString());
  }

  @override
  void dispose() {
    _nombre.dispose();
    _emoji.dispose();
    _orden.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      final nombre = _nombre.text.trim();
      final emoji = _emoji.text.trim().isEmpty ? null : _emoji.text.trim();
      final orden = int.parse(_orden.text.trim());
      if (widget.existente == null) {
        await widget.connector
            .crearCategoria(negocioId: widget.negocioId, nombre: nombre, orden: orden)
            .emoji(emoji)
            .execute();
      } else {
        await widget.connector
            .actualizarCategoria(
              negocioId: widget.negocioId,
              id: widget.existente!.id,
              nombre: nombre,
              orden: orden,
            )
            .emoji(emoji)
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(esEdicion ? 'Editar categoría' : 'Nueva categoría',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _emoji,
              decoration: const InputDecoration(labelText: 'Emoji (opcional)'),
            ),
            TextFormField(
              controller: _orden,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Orden de aparición'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Requerido';
                if (int.tryParse(v.trim()) == null) return 'Debe ser entero';
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                child: Text(_guardando ? 'Guardando…' : (esEdicion ? 'Actualizar' : 'Crear')),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
