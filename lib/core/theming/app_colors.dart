import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBackground = Color(0xFF0B1326);
  static const Color indigoAccent = Color(0xFF818CF8);
  static const Color iceBlue = Color(0xFFDAE2FD);
  static const Color lavenderGray = Color(0xFFC6C5D5);
  static const Color gray = Color(0xFF9CA3AF);
  static const Color oceanBlue = Color(0xFF1E293B);
  static const Color accentCyan = Color(0xFF00D1FF);
  static const Color white = Colors.white;
  static const Color success = Color(0xFF34D399);
  static const Color error = Color(0xFFF87171);
  static const Color deepViolet = Color(0xFF4F46E5);
  static const Color softAmber = Color(0xFFFBBF24);
  static const Color successGreen = Color(0xFF34D399);
  static const Color errorRed = Color(0xFFF87171);
  static const Color warmGray = Color(0xFF6B7280);
  static const Color surfaceDark = Color(0xFF131B2E);
  static const Color cardSurface = Color(0xFF172033);

  static const Map<String, Color> categoryColors = {
    'Science': Color(0xFF34D399),
    'Math': Color(0xFF60A5FA),
    'Language': Color(0xFFFBBF24),
    'History': Color(0xFFF87171),
    'Geography': Color(0xFF818CF8),
    'Technology': Color(0xFF00D1FF),
    'General': Color(0xFFC6C5D5),
  };

  // Premium Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = LinearGradient(
    colors: [
      const Color(0xFF818CF8).withValues(alpha: 0.15),
      const Color(0xFF818CF8).withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Transparent variants
  static Color indigoAccentTransparent(double alpha) =>
      indigoAccent.withValues(alpha: alpha);
  static Color lavenderGrayTransparent(double alpha) =>
      lavenderGray.withValues(alpha: alpha);
}
