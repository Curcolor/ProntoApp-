import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_fixtures.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/features/delivery/widgets/entrega_confirmada_modal.dart';

class EnRutaScreen extends StatelessWidget {
  final OrderModel pedido;

  const EnRutaScreen({
    super.key,
    required this.pedido,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Simulated Map Background
          _buildMapBackground(),
          
          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 12),
                  ],
                ),
                alignment: Alignment.center,
                child: const FaIcon(FontAwesomeIcons.arrowLeft, size: 16, color: Color(0xFF334155)),
              ),
            ),
          ),
          
          // Map Pins (Simulated)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.25,
            child: _buildMapPin(
              icon: FontAwesomeIcons.store,
              iconColor: Colors.white,
              pinColor: const Color(0xFF25D366),
              label: 'Restaurante',
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: MediaQuery.of(context).size.width * 0.5,
            child: _buildRiderPin(),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: MediaQuery.of(context).size.width * 0.15,
            child: _buildMapPin(
              icon: FontAwesomeIcons.house,
              iconColor: Colors.white,
              pinColor: const Color(0xFFEF4444),
              label: pedido.cliente,
            ),
          ),
          
          // ETA Card
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 12),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${(pedido.minutosTranscurridos / 2).floor() + 3}', // Simulación de ETA
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1D4ED8),
                        ),
                      ),
                      Text(
                        ' min',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1D4ED8),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Llegada estimada',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Color(0x1F000000), offset: Offset(0, -8), blurRadius: 32),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Info rápida
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          pedido.inicialCliente,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pedido.cliente,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              pedido.direccion ?? 'Sin dirección definida',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${pedido.total.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Por cobrar',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Acciones rápidas
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.phone, size: 13, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                'Llamar',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF25D366),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.whatsapp, size: 13, color: Colors.white),
                              const SizedBox(width: 6),
                              Text(
                                'WhatsApp',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const FaIcon(FontAwesomeIcons.ellipsis, size: 16, color: Color(0xFF475569)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirm Button
                  Consumer<OrderProvider>(
                    builder: (context, provider, _) {
                      return Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x5925D366),
                              offset: Offset(0, 4),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            await provider.avanzarEstado(pedido.id); // De enCamino a entregado
                            if (context.mounted) {
                              EntregaConfirmadaModal.show(context);
                              // Después de un tiempo o al cerrar el modal, volver a la pantalla principal
                              Future.delayed(const Duration(seconds: 2), () {
                                if (context.mounted) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.circleCheck, size: 16, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Confirmar entrega',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE8F4FD), Color(0xFFEEF5E8), Color(0xFFF0F4E8), Color(0xFFE8F0FD)],
          stops: [0.0, 0.35, 0.55, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildMapPin({required FaIconData icon, required Color iconColor, required Color pinColor, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: pinColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: pinColor.withAlpha(128),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: FaIcon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 3),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiderPin() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x4D3B82F6), width: 2),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x993B82F6),
                    offset: Offset(0, 4),
                    blurRadius: 16,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const FaIcon(FontAwesomeIcons.motorcycle, size: 20, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 3),
                ],
              ),
              child: Text(
                'Tú',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF334155),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

@Preview(name: 'En ruta', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget enRutaScreenPreview() => EnRutaScreen(pedido: sampleOrder());

