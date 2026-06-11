import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Encabezado de un grupo de pedidos por día (Hoy / Ayer / fecha) + conteo.
/// Reutilizado por todas las listas de tarjetas de pedido para un seguimiento
/// consistente.
class DiaGrupoHeader extends StatelessWidget {
  final String label;
  final int count;

  const DiaGrupoHeader({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(FontAwesomeIcons.calendarDay,
                  size: 11, color: Color(0xFF475569)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFF334155),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count pedido${count == 1 ? '' : 's'}',
          style: GoogleFonts.inter(
            color: const Color(0xFF94A3B8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
