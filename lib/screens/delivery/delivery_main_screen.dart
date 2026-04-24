import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../landing_page.dart';

class DeliveryMainScreen extends StatelessWidget {
  const DeliveryMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Repartidor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LandingPage()),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: const Center(child: Text('Dashboard Repartidor')),
    );
  }
}
