import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'cola_pedidos_screen.dart';
import 'preparacion_screen.dart';
import 'pedidos_listos_screen.dart';
import 'perfil_cocinero_screen.dart';

class KitchenMainScreen extends StatefulWidget {
  const KitchenMainScreen({super.key});

  @override
  State<KitchenMainScreen> createState() => _KitchenMainScreenState();
}

class _KitchenMainScreenState extends State<KitchenMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ColaPedidosScreen(),
    const PreparacionScreen(),
    const PedidosListosScreen(),
    const PerfilCocineroScreen(),
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
          border: Border(top: BorderSide(color: const Color(0xFFE2E8F0), width: 1.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.06 * 255).toInt()),
              offset: const Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1DB954),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: FaIcon(FontAwesomeIcons.fireBurner, size: 20)),
              label: 'Cola',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: FaIcon(FontAwesomeIcons.fire, size: 20)), // using fire instead of list-check for now
              label: 'En curso',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: FaIcon(FontAwesomeIcons.bellConcierge, size: 20)),
              label: 'Listos',
            ),
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: FaIcon(FontAwesomeIcons.user, size: 20)),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'Cocina — Home', group: 'Kitchen', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget kitchenMainScreenPreview() => const KitchenMainScreen();

