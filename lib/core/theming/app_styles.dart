import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppStyles {
  // ── Primary Brand ───────────────────────────────────────────────────────────
  static TextStyle get font24BoldPrimaryManrope => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.primaryTeal,
        height: 1.2,
      );

  // Backward-compat alias
  static TextStyle get font24BoldIndigoAccentManrope => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.primaryTeal,
        height: 1.2,
      );

  static TextStyle get font19BoldIndigoAccent => TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.primaryTeal,
        height: 1.2,
      );

  static TextStyle get font18BoldIndigoAccent => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.primaryTeal,
        height: 1.2,
      );

  static TextStyle get font15IndigoAccentSemiBold => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        fontFamily: "Manrope",
        color: AppColors.primaryTeal,
        height: 1.2,
      );

  // ── Ice / Light ─────────────────────────────────────────────────────────────
  static TextStyle get font24BoldIceBlueManrope => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.iceBlue,
        height: 1.2,
      );

  static TextStyle get font28BoldIceBlue => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.iceBlue,
        height: 1.2,
      );

  static TextStyle get font22BoldIceBlue => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.iceBlue,
        height: 1.2,
      );

  static TextStyle get font17BoldIceBlue => TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.iceBlue,
        height: 1.2,
      );

  // ── White variants ───────────────────────────────────────────────────────────
  static TextStyle get font40BoldWhite => TextStyle(
        fontSize: 40.sp,
        fontWeight: FontWeight.w800,
        fontFamily: "Manrope",
        color: AppColors.white,
        height: 1.2,
      );

  static TextStyle get font20BoldWhite => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.white,
        height: 1.2,
      );

  static TextStyle get font18WhiteBold => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.white,
        height: 1.2,
      );

  static TextStyle get font17WhiteBold => TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.bold,
        fontFamily: "Manrope",
        color: AppColors.white,
        height: 1.2,
      );

  static TextStyle get font16WhiteSemiBold => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: "Manrope",
        color: AppColors.white,
        height: 1.25,
      );

  static TextStyle get font18WhiteMedium => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        fontFamily: "Manrope",
        color: AppColors.white,
        height: 1.25,
      );

  static TextStyle get font14WhiteSemiBold => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: "Manrope",
        color: AppColors.white,
        height: 1.25,
      );

  static TextStyle get font14White70 => TextStyle(
        fontSize: 14.sp,
        fontFamily: "Manrope",
        color: AppColors.white.withValues(alpha: 0.75),
        height: 1.3,
      );

  static TextStyle get font12White38 => TextStyle(
        fontSize: 12.sp,
        fontFamily: "Manrope",
        color: AppColors.white.withValues(alpha: 0.4),
        height: 1.3,
      );

  // ── Lavender / Gray ──────────────────────────────────────────────────────────
  static TextStyle get font16LavenderGray => TextStyle(
        fontSize: 16.sp,
        fontFamily: "Manrope",
        color: AppColors.lavenderGray,
        height: 1.3,
      );

  static TextStyle get font16LavenderGrayBold => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: "Manrope",
        color: AppColors.lavenderGray,
        height: 1.3,
      );

  static TextStyle get font14LavenderGrayMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        fontFamily: "Manrope",
        color: AppColors.lavenderGray.withValues(alpha: 0.8),
        height: 1.3,
      );

  static TextStyle get font12LavenderGray => TextStyle(
        fontSize: 12.sp,
        fontFamily: "Manrope",
        color: AppColors.lavenderGray.withValues(alpha: 0.7),
        height: 1.3,
      );

  static TextStyle get font12LavenderGrayFaded => TextStyle(
        fontSize: 12.sp,
        fontFamily: "Manrope",
        color: AppColors.lavenderGray.withValues(alpha: 0.5),
        height: 1.3,
      );

  static TextStyle get font14Gray => TextStyle(
        fontSize: 14.sp,
        fontFamily: "Manrope",
        color: AppColors.gray,
        height: 1.3,
      );

  static TextStyle get font13GrayMedium => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        fontFamily: "Manrope",
        color: AppColors.warmGray,
        height: 1.3,
      );

  static TextStyle get font11GrayRegular => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        fontFamily: "Manrope",
        color: AppColors.warmGray,
        height: 1.3,
      );

  // ── Accent ───────────────────────────────────────────────────────────────────
  static TextStyle get font14AccentCyan => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        fontFamily: "Manrope",
        color: AppColors.cyberCyan,
        height: 1.3,
      );
}
