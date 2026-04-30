import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/features/manager/data/models/order_model.dart';
import 'package:prontoapp/features/manager/data/providers/order_provider.dart';

class ColaPedidosScreen extends StatelessWidget {
  const ColaPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final colaCocina = [...provider.recibidos, ...provider.enPreparacion];
        final user = context.watch<AuthService>().currentUser;
        final nombreCocinero = user?.name ?? 'Cocinero';

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(nombreCocinero),
                Expanded(
                  child: colaCocina.isEmpty
                      ? _buildColaVacia()
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          children: [
                            _buildMetricsRow(provider),
                            const SizedBox(height: 32),
                            
                            _buildSectionTitle(colaCocina.length),
                            const SizedBox(height: 16),
                            
                            // Lista de tarjetas - VERSION ULTRA SEGURA
                            ...colaCocina.map((pedido) => _buildOrderCardUltraSeguro(context, pedido, provider)),
                            
                            const SizedBox(height: 80),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Header y Métricas (Fiel a Figma) ──────────────────────────────────

  Widget _buildHeader(String nombre) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buenos días 👋', style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 13)),
              Text(
                nombre,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, color: AppColors.warningIcon, size: 6),
                const SizedBox(width: 6),
                const FaIcon(FontAwesomeIcons.fire, color: Color(0xFF92400E), size: 11),
                const SizedBox(width: 6),
                Text(
                  'Cocina',
                  style: GoogleFonts.inter(color: const Color(0xFF92400E), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(OrderProvider provider) {
    return Row(
      children: [
        _buildMetricCard('${provider.recibidos.length}', 'Urgentes', AppColors.dangerDark),
        const SizedBox(width: 8),
        _buildMetricCard('${provider.enPreparacion.length}', 'En cola', AppColors.warningText),
        const SizedBox(width: 8),
        _buildMetricCard('${provider.listos.length}', 'Listos', AppColors.primaryDark),
      ],
    );
  }

  Widget _buildMetricCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.inter(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
            Text(label, style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('📋 Cola activa', style: TextStyle(color: Colors.blueGrey[900], fontSize: 16, fontWeight: FontWeight.bold)),
        const Text('Ordenar ↕', style: TextStyle(color: Colors.green, fontSize: 13)),
      ],
    );
  }

  // ─── Tarjeta ULTRA SEGURA ──────────────────────────────────────────────
  // Usamos solo widgets base de Flutter y colores nativos para descartar errores de dependencias.

  Widget _buildOrderCardUltraSeguro(BuildContext context, OrderModel pedido, OrderProvider provider) {
    final bool estaPreparando = pedido.estado == EstadoPedido.enPreparacion;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: estaPreparando ? Colors.orange : Colors.green, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identificación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORDEN: ${pedido.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: estaPreparando ? Colors.orange[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    estaPreparando ? 'PREPARANDO' : 'RECIBIDO',
                    style: TextStyle(
                      color: estaPreparando ? Colors.orange[900] : Colors.green[900],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'CLIENTE: ${pedido.cliente}',
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const Divider(color: Colors.grey),
            
            // Listado de productos (Manual para mayor seguridad)
            for (var item in pedido.items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '• ${item.cantidad}x ${item.nombre}',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${pedido.minutosTranscurridos} minutos',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                TextButton(
                  onPressed: () => provider.avanzarEstado(pedido.id),
                  style: TextButton.styleFrom(
                    backgroundColor: estaPreparando ? Colors.blueGrey[800] : Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(estaPreparando ? 'MARCAR LISTO' : 'EMPEZAR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColaVacia() {
    return const Center(child: Text('Sin pedidos pendientes'));
  }
}
