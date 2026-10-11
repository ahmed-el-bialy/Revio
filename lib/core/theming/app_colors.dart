import 'package:flutter/material.dart';

class AppColors {
  // ── Obsidian & Deep Cyber Navy Backgrounds (Matching Revio Logo) ──────────
  static const Color darkBackground = Color(0xFF060B12);
  static const Color surfaceDark = Color(0xFF0C1424);
  static const Color cardSurface = Color(0xFF101B2E);
  static const Color elevatedSurface = Color(0xFF16253D);
  static const Color oceanBlue = Color(0xFF0A2540);

  // ── Brand Primary Neon & Electric Accents (From Logo) ──────────────────────
  static const Color primaryCyan = Color(0xFF00F2FE);
  static const Color neonAqua = Color(0xFF00E5FF);
  static const Color primaryTeal = Color(0xFF00F2FE); // Alias for primary brand
  static const Color cyberCyan = Color(0xFF00F2FE);
  static const Color skyBlue = Color(0xFF00B4D8);
  static const Color emeraldGold = Color(0xFF10B981);
  static const Color softAmber = Color(0xFFFFB800);
  static const Color warmGray = Color(0xFF64748B);
  static const Color lavenderGray = Color(0xFF94A3B8);
  static const Color gray = Color(0xFF475569);
  static const Color white = Colors.white;

  // ── Favorite & Feedback Colors ─────────────────────────────────────────────
  static const Color favoriteColor = Color(0xFFFF2A6D);
  static const Color favoriteGlow = Color(0xFFFF4D8D);

  // Backward compatibility alias colors
  static const Color indigoAccent = Color(0xFF00F2FE);
  static const Color iceBlue = Color(0xFFF1F5F9);

  // Status & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color successGreen = Color(0xFF10B981);
  static const Color error = Color(0xFFFF2A6D);
  static const Color errorRed = Color(0xFFFF2A6D);

  // Category & Genre Specific Accent Colors
  static const Map<String, Color> categoryColors = {
    'Science': Color(0xFF00E5FF),
    'Math': Color(0xFF00B4D8),
    'Language': Color(0xFFFFB800),
    'History': Color(0xFFFF2A6D),
    'Geography': Color(0xFF8B5CF6),
    'Technology': Color(0xFF00F2FE),
    'General': Color(0xFF94A3B8),
  };

  // ── Sleek Cyber Gradients ──────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F2FE), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyberGradient = LinearGradient(
    colors: [Color(0xFF00F2FE), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = LinearGradient(
    colors: [
      const Color(0xFF00F2FE).withValues(alpha: 0.15),
      const Color(0xFF00E5FF).withValues(alpha: 0.03),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0D1B36), Color(0xFF0A2240)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFB800), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper Methods for Transparencies
  static Color primaryTealTransparent(double alpha) =>
      primaryCyan.withValues(alpha: alpha);
  static Color indigoAccentTransparent(double alpha) =>
      primaryCyan.withValues(alpha: alpha);
  static Color lavenderGrayTransparent(double alpha) =>
      lavenderGray.withValues(alpha: alpha);
  static Color favoriteTransparent(double alpha) =>
      favoriteColor.withValues(alpha: alpha);
}
