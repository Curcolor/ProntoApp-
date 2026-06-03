import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pedidos_para_entregar_screen.dart';
import 'perfil_repartidor_screen.dart';

class DeliveryMainScreen extends StatefulWidget {
  const DeliveryMainScreen({super.key});

  @override
  State<DeliveryMainScreen> createState() => _DeliveryMainScreenState();
}

class _DeliveryMainScreenState extends State<DeliveryMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PedidosParaEntregarScreen(),
    const PerfilRepartidorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1DB954), // Mountain Meadow / Jewel accent
          unselectedItemColor: const Color(0xFF94A3B8), // Gull Gray
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 3.0, top: 10.0),
                child: FaIcon(FontAwesomeIcons.motorcycle, size: 20),
              ),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 3.0, top: 10.0),
                child: FaIcon(FontAwesomeIcons.user, size: 20),
              ),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'Delivery — Home', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget deliveryMainScreenPreview() => const DeliveryMainScreen();
