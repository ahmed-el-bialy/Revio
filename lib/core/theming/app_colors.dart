import 'package:material_ui/material_ui.dart';

class AppColors {
  // ── Dark Theme Backgrounds ────

  static const Color darkBackground = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF161B22);
  static const Color cardSurface = Color(0xFF1F242D);
  static const Color elevatedSurface = Color(0xFF2B3340);
  static const Color oceanBlue = Color(0xFF1E293B);

  // ── Refined Muted Accents ────

  static const Color primaryCyan = Color(0xFF38BDF8);
  static const Color neonAqua = Color(0xFF2DD4BF);
  static const Color primaryTeal = Color(0xFF38BDF8);
  static const Color cyberCyan = Color(0xFF7DD3FC);
  static const Color skyBlue = Color(0xFF0EA5E9);
  static const Color indigoAccent = Color(0xFF818CF8);

  // ── Warm & Functional Accents ─────

  static const Color emeraldGold = Color(0xFF34D399);
  static const Color softAmber = Color(0xFFFBBF24);
  static const Color warmGray = Color(0xFF94A3B8);
  static const Color lavenderGray = Color(0xFFCBD5E1);
  static const Color gray = Color(0xFF475569);
  static const Color white = Colors.white;

  // ── Status & Feedback ────

  static const Color favoriteColor = Color(0xFF38BDF8);
  static const Color favoriteGlow = Color(0xFF7DD3FC);
  static const Color iceBlue = Color(0xFFF1F5F9);

  static const Color success = Color(0xFF34D399);
  static const Color successGreen = Color(0xFF34D399);
  static const Color error = Color(0xFFEF4444);
  static const Color errorRed = Color(0xFFEF4444);

  // Category Accent Map (Soft & Harmonious)

  static const Map<String, Color> categoryColors = {
    'Science': Color(0xFF38BDF8),
    'Math': Color(0xFF818CF8),
    'Language': Color(0xFF0EA5E9),
    'History': Color(0xFFF472B6),
    'Geography': Color(0xFFA78BFA),
    'Technology': Color(0xFF34D399),
    'General': Color(0xFF94A3B8),
  };

  // ── Subtle, Professional Gradients ────────

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyberGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF2DD4BF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1F242D), Color(0xFF161B22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Transparencies helpers
  static Color primaryTealTransparent(double alpha) =>
      primaryCyan.withValues(alpha: alpha);

  static Color indigoAccentTransparent(double alpha) =>
      indigoAccent.withValues(alpha: alpha);

  static Color lavenderGrayTransparent(double alpha) =>
      lavenderGray.withValues(alpha: alpha);

  static Color favoriteTransparent(double alpha) =>
      favoriteColor.withValues(alpha: alpha);
}
