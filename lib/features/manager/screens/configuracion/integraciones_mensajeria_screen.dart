/// F6.4 — CRUD integraciones de mensajería (WhatsApp Cloud, WA Business,
/// Telegram, Webchat). credencialSecretRef + webhookSecret se aceptan como
/// strings desde la UI, pero deben ser referencias a Secret Manager — la UI
/// nunca debe pedir ni mostrar tokens en claro. Ver `SEGURIDAD_PLAN.md`.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

class IntegracionesMensajeriaScreen extends StatefulWidget {
  const IntegracionesMensajeriaScreen({super.key});

  @override
  State<IntegracionesMensajeriaScreen> createState() =>
      _IntegracionesMensajeriaScreenState();
}

class _IntegracionesMensajeriaScreenState
    extends State<IntegracionesMensajeriaScreen> {
  late Future<List<ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _cargar();
  }

  Future<List<ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria>> _cargar() async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) throw Exception('Perfil no disponible.');
    final connector = context.read<ProntoappConnector>();
    final r = await connector
        .obtenerIntegracionesMensajeriaAdmin(negocioId: perfil.negocioId)
        .execute();
    return r.data.integracionesMensajeria;
  }

  void _refrescar() => setState(() => _futuro = _cargar());

  Future<void> _abrirModal({
    ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria? existente,
  }) async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) return;
    final connector = context.read<ProntoappConnector>();
    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _IntegracionFormSheet(
        connector: connector,
        negocioId: perfil.negocioId,
        existente: existente,
      ),
    );
    if (guardado == true) _refrescar();
  }

  Future<void> _archivar(
    ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria i,
  ) async {
    final perfil = context.read<PerfilUsuarioAdminService>().perfil;
    if (perfil == null) return;
    final connector = context.read<ProntoappConnector>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Desactivar integración'),
        content: Text('¿Desactivar ${i.identificadorExterno}? Dejará de recibir mensajes.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Desactivar')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await connector
          .desactivarIntegracionMensajeria(negocioId: perfil.negocioId, id: i.id)
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
      appBar: AppBar(title: const Text('Integraciones de mensajería')),
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
            return const Center(child: Text('Sin integraciones. Crea la primera.'));
          }
          return ListView.separated(
            itemCount: lista.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, idx) {
              final i = lista[idx];
              return ListTile(
                leading: Icon(_iconoCanal(i.canal.stringValue), color: AppColors.primary),
                title: Text(i.nombreVisible ?? i.identificadorExterno),
                subtitle: Text('${i.canal.stringValue} · ${i.identificadorExterno}'
                    '${i.activo ? '' : ' · INACTIVA'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _abrirModal(existente: i)),
                    if (i.activo)
                      IconButton(icon: const Icon(Icons.power_settings_new), onPressed: () => _archivar(i)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconoCanal(String canal) {
    switch (canal) {
      case 'WHATSAPP_CLOUD':
      case 'WHATSAPP_BUSINESS':
        return Icons.chat;
      case 'TELEGRAM_BOT':
        return Icons.send;
      case 'WEBCHAT':
        return Icons.language;
      default:
        return Icons.message;
    }
  }
}

class _IntegracionFormSheet extends StatefulWidget {
  const _IntegracionFormSheet({
    required this.connector,
    required this.negocioId,
    this.existente,
  });

  final ProntoappConnector connector;
  final String negocioId;
  final ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria? existente;

  @override
  State<_IntegracionFormSheet> createState() => _IntegracionFormSheetState();
}

class _IntegracionFormSheetState extends State<_IntegracionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _identificador;
  late TextEditingController _nombreVisible;
  late TextEditingController _credencialRef;
  late TextEditingController _webhookSecret;
  late TextEditingController _webhookUrl;
  CanalMensajeria? _canal;
  bool _activo = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existente;
    _identificador = TextEditingController(text: e?.identificadorExterno ?? '');
    _nombreVisible = TextEditingController(text: e?.nombreVisible ?? '');
    _credencialRef = TextEditingController();
    _webhookSecret = TextEditingController();
    _webhookUrl = TextEditingController(text: e?.webhookUrl ?? '');
    _activo = e?.activo ?? true;
    if (e != null) {
      _canal = switch (e.canal) {
        Known<CanalMensajeria>(:final value) => value,
        _ => null,
      };
    }
  }

  @override
  void dispose() {
    _identificador.dispose();
    _nombreVisible.dispose();
    _credencialRef.dispose();
    _webhookSecret.dispose();
    _webhookUrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.existente == null && _canal == null) return;
    setState(() => _guardando = true);
    try {
      final nombre = _nombreVisible.text.trim().isEmpty ? null : _nombreVisible.text.trim();
      final webhookSecret = _webhookSecret.text.trim().isEmpty ? null : _webhookSecret.text.trim();
      final webhookUrl = _webhookUrl.text.trim().isEmpty ? null : _webhookUrl.text.trim();
      if (widget.existente == null) {
        await widget.connector
            .crearIntegracionMensajeria(
              negocioId: widget.negocioId,
              canal: _canal!,
              identificadorExterno: _identificador.text.trim(),
              credencialSecretRef: _credencialRef.text.trim(),
            )
            .nombreVisible(nombre)
            .webhookSecret(webhookSecret)
            .webhookUrl(webhookUrl)
            .execute();
      } else {
        await widget.connector
            .actualizarIntegracionMensajeria(
              negocioId: widget.negocioId,
              id: widget.existente!.id,
              identificadorExterno: _identificador.text.trim(),
              credencialSecretRef: _credencialRef.text.trim(),
              activo: _activo,
            )
            .nombreVisible(nombre)
            .webhookSecret(webhookSecret)
            .webhookUrl(webhookUrl)
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
              Text(esEdicion ? 'Editar integración' : 'Nueva integración',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (!esEdicion)
                DropdownButtonFormField<CanalMensajeria>(
                  initialValue: _canal,
                  decoration: const InputDecoration(labelText: 'Canal *'),
                  items: CanalMensajeria.values
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _canal = v),
                  validator: (v) => v == null ? 'Requerido' : null,
                ),
              TextFormField(
                controller: _identificador,
                decoration: const InputDecoration(
                  labelText: 'Identificador externo *',
                  helperText: 'phone_number_id (WA Cloud), bot_username (Telegram), etc.',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _nombreVisible,
                decoration: const InputDecoration(labelText: 'Nombre visible (opcional)'),
              ),
              TextFormField(
                controller: _credencialRef,
                decoration: const InputDecoration(
                  labelText: 'Referencia Secret Manager *',
                  helperText: 'Ej. projects/X/secrets/wa-token-{negocio}. NUNCA pegar el token en claro.',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _webhookSecret,
                decoration: const InputDecoration(
                  labelText: 'Webhook secret ref (opcional)',
                  helperText: 'Ref a Secret Manager para verificación de firma del webhook.',
                ),
              ),
              TextFormField(
                controller: _webhookUrl,
                decoration: const InputDecoration(labelText: 'URL webhook (opcional)'),
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
