import 'package:flutter/material.dart';

class AppColors {
  // Brand & Primary Colors
  static const Color primary = Color(0xFF25D366); // WhatsApp Green (Main CTAs)
  static const Color primaryDark = Color(0xFF128C7E); // WhatsApp Dark Green
  
  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Main app background (Slate 50)
  static const Color surface = Colors.white;
  
  // Text Colors (Slate palette)
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textTertiary = Color(0xFF64748B); // Slate 500
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  
  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderLight = Color(0xFFF1F5F9); // Slate 100
  
  // Status Colors (Background / Text / Icon)
  
  // Success (Green)
  static const Color successBg = Color(0xFFDCFCE7); // Green 100
  static const Color successText = Color(0xFF15803D); // Green 700
  static const Color successIcon = Color(0xFF22C55E); // Green 500
  
  // Warning / Low Stock (Amber)
  static const Color warningBg = Color(0xFFFEF3C7); // Amber 100
  static const Color warningText = Color(0xFFB45309); // Amber 700
  static const Color warningIcon = Color(0xFFF59E0B); // Amber 500
  static const Color warningDark = Color(0xFFD97706); // Amber 600
  static const Color warningDarker = Color(0xFF92400E); // Amber 800

  // Danger / Error / Out of Stock (Red)
  static const Color dangerBg = Color(0xFFFEE2E2); // Red 100
  static const Color dangerText = Color(0xFFB91C1C); // Red 700
  static const Color dangerIcon = Color(0xFFEF4444); // Red 500
  static const Color dangerDark = Color(0xFFDC2626); // Red 600
  
  // Info / Delivery (Blue)
  static const Color infoBg = Color(0xFFDBEAFE); // Blue 100
  static const Color infoText = Color(0xFF1D4ED8); // Blue 700
  static const Color infoBorder = Color(0xFFBFDBFE); // Blue 200

  // AI & Premium (Purple)
  static const Color aiBg = Color(0xFFEDE9FE); // Violet 100
  static const Color aiText = Color(0xFF6D28D9); // Violet 700
  static const Color aiGradientStart = Color(0xFF6D28D9); 
  static const Color aiGradientEnd = Color(0xFF8B5CF6);
  static const Color aiHighlight = Color(0xFFFAF7FF);

  // Components
  static const Color toggleInactiveBg = Color(0xFFCBD5E1); // Slate 300
  static const Color toggleInactiveThumb = Colors.white;
}
