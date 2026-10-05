import 'package:flutter/material.dart';

class AppColors {
  // ── Professional Midnight Obsidian & Neo-Teal Palette ──────────────────────
  static const Color darkBackground = Color(0xFF070A12);
  static const Color surfaceDark = Color(0xFF101728);
  static const Color cardSurface = Color(0xFF1A2338);
  static const Color elevatedSurface = Color(0xFF24304D);
  static const Color oceanBlue = Color(0xFF3B4F6C);

  // ── Brand & Accent Colors ──────────────────────────────────────────────────
  static const Color primaryTeal = Color(0xFF00E5CC);
  static const Color cyberCyan = Color(0xFF00F0FF);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color emeraldGold = Color(0xFF10B981);
  static const Color softAmber = Color(0xFFFBBF24);
  static const Color warmGray = Color(0xFF94A3B8);
  static const Color lavenderGray = Color(0xFFCBD5E1);
  static const Color gray = Color(0xFF64748B);
  static const Color white = Colors.white;

  // ── Favorite & Status Colors ───────────────────────────────────────────────
  static const Color favoriteColor = Color(0xFFFF3366);
  static const Color favoriteGlow = Color(0xFFFF6699);

  // Backward compatibility alias colors
  static const Color indigoAccent = Color(0xFF00E5CC);
  static const Color iceBlue = Color(0xFFF8FAFC);

  // Status & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color successGreen = Color(0xFF10B981);
  static const Color error = Color(0xFFFF3366);
  static const Color errorRed = Color(0xFFFF3366);

  // Category & Genre Specific Accent Colors
  static const Map<String, Color> categoryColors = {
    'Science': Color(0xFF10B981),
    'Math': Color(0xFF3B82F6),
    'Language': Color(0xFFF59E0B),
    'History': Color(0xFFEC4899),
    'Geography': Color(0xFF8B5CF6),
    'Technology': Color(0xFF00F0FF),
    'General': Color(0xFF94A3B8),
  };

  // ── Modern Gradients ───────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00E5CC), Color(0xFF0099FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyberGradient = LinearGradient(
    colors: [Color(0xFF00F0FF), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = LinearGradient(
    colors: [
      const Color(0xFF00E5CC).withValues(alpha: 0.15),
      const Color(0xFF00E5CC).withValues(alpha: 0.02),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1A2338), Color(0xFF101728)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper Methods for Transparencies
  static Color primaryTealTransparent(double alpha) =>
      primaryTeal.withValues(alpha: alpha);
  static Color indigoAccentTransparent(double alpha) =>
      indigoAccent.withValues(alpha: alpha);
  static Color lavenderGrayTransparent(double alpha) =>
      lavenderGray.withValues(alpha: alpha);
  static Color favoriteTransparent(double alpha) =>
      favoriteColor.withValues(alpha: alpha);
}
