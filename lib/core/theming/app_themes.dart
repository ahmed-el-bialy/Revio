// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppThemes {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Manrope',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryCyan,
      secondary: AppColors.indigoAccent,
      surface: AppColors.surfaceDark,
      error: AppColors.errorRed,
      onPrimary: AppColors.darkBackground,
      onSurface: AppColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.white.withValues(alpha: 0.06)),
      ),
      margin: EdgeInsets.zero,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.white,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w600,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: AppColors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: AppColors.primaryCyan, width: 1.5),
      ),
      hintStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 14.sp,
        color: AppColors.lavenderGray.withValues(alpha: 0.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryCyan,
      unselectedItemColor: AppColors.warmGray,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryCyan,
        foregroundColor: AppColors.darkBackground,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        textStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryCyan,
        textStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.white.withValues(alpha: 0.06),
      thickness: 1,
      space: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.cardSurface,
      selectedColor: AppColors.primaryCyan.withValues(alpha: 0.15),
      side: BorderSide(color: AppColors.white.withValues(alpha: 0.08)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      labelStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
