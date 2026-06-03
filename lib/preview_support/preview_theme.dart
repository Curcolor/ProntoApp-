import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema aplicado a todas las widget previews. Replica el tema de la app
/// definido en `lib/main.dart`.
PreviewThemeData previewTheme() => PreviewThemeData(
      materialLight: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
    );
