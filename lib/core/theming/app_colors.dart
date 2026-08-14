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
  static const Color success = Colors.green;
  static const Color error = Colors.redAccent;

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

  // Transparent variants
  static Color indigoAccentTransparent(double alpha) =>
      indigoAccent.withValues(alpha: alpha);
  static Color lavenderGrayTransparent(double alpha) =>
      lavenderGray.withValues(alpha: alpha);
}
