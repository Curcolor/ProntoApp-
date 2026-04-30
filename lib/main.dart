import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/app/routes.dart';

void main() {
  runApp(const ProntoApp());
}

class ProntoApp extends StatelessWidget {
  const ProntoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProntoApp!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      routes: AppRoutes.getRoutes(),
      home: AppRoutes.getInitialScreen(),
    );
  }
}
