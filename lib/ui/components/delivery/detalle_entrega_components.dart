import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/data/models/order_model.dart';

class DeliveryDetailHeader extends StatelessWidget {
  final OrderModel pedido;
  final VoidCallback? onBack;

  const DeliveryDetailHeader({super.key, required this.pedido, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 16.0,
        bottom: 14.0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 16,
                color: Color(0xFF334155),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pedido #${pedido.id}',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Recoge en: Central de Cocina',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryDetailContent extends StatelessWidget {
  final OrderModel pedido;

  const DeliveryDetailContent({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
        bottom: 100.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DeliveryClientCard(pedido: pedido),
          const SizedBox(height: 12),
          _DeliveryAddressCard(pedido: pedido),
          const SizedBox(height: 12),
          _DeliveryItemsCard(pedido: pedido),
          if (pedido.direccion != null && pedido.direccion!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DeliveryNoteCard(pedido: pedido),
          ],
        ],
      ),
    );
  }
}

class DeliveryActionBar extends StatelessWidget {
  final OrderModel pedido;
  final VoidCallback? onStartDelivery;

  const DeliveryActionBar({
    super.key,
    required this.pedido,
    this.onStartDelivery,
  });

  @override
  Widget build(BuildContext context) {
    final bool yaEnCamino = pedido.estado == EstadoPedido.enCamino;

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x593B82F6),
              offset: Offset(0, 4),
              blurRadius: 14,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onStartDelivery,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.motorcycle,
                size: 15,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                yaEnCamino ? 'Ver mapa de entrega' : 'Salir a entregar',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryClientCard extends StatelessWidget {
  final OrderModel pedido;

  const _DeliveryClientCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return _DeliveryCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  pedido.inicialCliente,
                  style: GoogleFonts.inter(
                    fontSize: 20,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      pedido.telefono,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  pedido.estado.etiqueta,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(
                child: _ContactButton(
                  label: 'Llamar',
                  icon: FontAwesomeIcons.phone,
                  color: Color(0xFF3B82F6),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _ContactButton(
                  label: 'WhatsApp',
                  icon: FontAwesomeIcons.whatsapp,
                  color: Color(0xFF25D366),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryAddressCard extends StatelessWidget {
  final OrderModel pedido;

  const _DeliveryAddressCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return _DeliveryCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DeliverySectionTitle(
            icon: FontAwesomeIcons.locationDot,
            iconColor: Color(0xFFEF4444),
            text: 'Dirección de entrega',
          ),
          const SizedBox(height: 12),
          Text(
            pedido.direccion ?? 'Recoger en tienda',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          Text(
            pedido.tipo == TipoPedido.domicilio
                ? 'Entrega a domicilio'
                : 'El cliente recoge',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: FontAwesomeIcons.clock,
                iconColor: const Color(0xFF15803D),
                bgColor: const Color(0xFFDCFCE7),
                value: pedido.tiempoTranscurridoFormat,
                label: 'Espera',
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: FontAwesomeIcons.handHoldingDollar,
                iconColor: const Color(0xFFB45309),
                bgColor: const Color(0xFFFEF3C7),
                value: '\$${pedido.total.toStringAsFixed(0)}',
                label: 'Cobro',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryItemsCard extends StatelessWidget {
  final OrderModel pedido;

  const _DeliveryItemsCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return _DeliveryCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(17.0),
            child: _DeliverySectionTitle(
              icon: FontAwesomeIcons.bagShopping,
              iconColor: Color(0xFF1DB954),
              text: 'Contenido del pedido',
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 17.0,
              vertical: 11.0,
            ),
            child: Column(
              children: [
                ...pedido.items.map(
                  (item) => _ItemRow(
                    qty: item.cantidad.toString(),
                    name: item.nombre,
                    price:
                        '\$${(item.precio * item.cantidad).toStringAsFixed(0)}',
                  ),
                ),
                const SizedBox(height: 4),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 9),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '💳 Pago',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    Text(
                      '\$${pedido.total.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryNoteCard extends StatelessWidget {
  final OrderModel pedido;

  const _DeliveryNoteCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FaIcon(
            FontAwesomeIcons.noteSticky,
            size: 14,
            color: Color(0xFFF59E0B),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instrucciones de entrega',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB45309),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pedido.direccion ?? 'Sin instrucciones adicionales.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _DeliveryCard({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ContactButton extends StatelessWidget {
  final String label;
  final FaIconData icon;
  final Color color;

  const _ContactButton({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliverySectionTitle extends StatelessWidget {
  final FaIconData icon;
  final Color iconColor;
  final String text;

  const _DeliverySectionTitle({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 13, color: iconColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final FaIconData icon;
  final Color iconColor;
  final Color bgColor;
  final String value;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: iconColor,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.inter(fontSize: 9, color: iconColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String qty;
  final String name;
  final String price;

  const _ItemRow({required this.qty, required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'x$qty',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF334155),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF334155),
                ),
              ),
            ],
          ),
          Text(
            price,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
