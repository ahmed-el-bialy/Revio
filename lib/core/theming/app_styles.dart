import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppStyles {
  // ── Primary Brand ───────────────────────────────────────────────────────────
  static TextStyle font24BoldPrimaryManrope = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.primaryTeal,
  );

  // Backward-compat alias
  static TextStyle font24BoldIndigoAccentManrope = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.primaryTeal,
  );

  static TextStyle font19BoldIndigoAccent = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.primaryTeal,
  );

  static TextStyle font18BoldIndigoAccent = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.primaryTeal,
  );

  static TextStyle font15IndigoAccentSemiBold = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    fontFamily: "Manrope",
    color: AppColors.primaryTeal,
  );

  // ── Ice / Light ─────────────────────────────────────────────────────────────
  static TextStyle font24BoldIceBlueManrope = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.iceBlue,
  );

  static TextStyle font28BoldIceBlue = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.iceBlue,
  );

  static TextStyle font22BoldIceBlue = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.iceBlue,
  );

  static TextStyle font17BoldIceBlue = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.iceBlue,
  );

  // ── White variants ───────────────────────────────────────────────────────────
  static TextStyle font40BoldWhite = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w800,
    fontFamily: "Manrope",
    color: AppColors.white,
  );

  static TextStyle font20BoldWhite = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.white,
  );

  static TextStyle font18WhiteBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.white,
  );

  static TextStyle font17WhiteBold = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.bold,
    fontFamily: "Manrope",
    color: AppColors.white,
  );

  static TextStyle font16WhiteSemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: "Manrope",
    color: AppColors.white,
  );

  static TextStyle font18WhiteMedium = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    fontFamily: "Manrope",
    color: AppColors.white,
  );

  static TextStyle font14WhiteSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    fontFamily: "Manrope",
    color: AppColors.white,
  );

  static TextStyle font14White70 = TextStyle(
    fontSize: 14.sp,
    fontFamily: "Manrope",
    color: AppColors.white.withValues(alpha: 0.7),
  );

  static TextStyle font12White38 = TextStyle(
    fontSize: 12.sp,
    fontFamily: "Manrope",
    color: AppColors.white.withValues(alpha: 0.38),
  );

  // ── Lavender / Gray ──────────────────────────────────────────────────────────
  static TextStyle font16LavenderGray = TextStyle(
    fontSize: 16.sp,
    fontFamily: "Manrope",
    color: AppColors.lavenderGray,
  );

  static TextStyle font16LavenderGrayBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    fontFamily: "Manrope",
    color: AppColors.lavenderGray,
  );

  static TextStyle font14LavenderGrayMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: "Manrope",
    color: AppColors.lavenderGray.withValues(alpha: 0.7),
  );

  static TextStyle font12LavenderGray = TextStyle(
    fontSize: 12.sp,
    fontFamily: "Manrope",
    color: AppColors.lavenderGray.withValues(alpha: 0.6),
  );

  static TextStyle font12LavenderGrayFaded = TextStyle(
    fontSize: 12.sp,
    fontFamily: "Manrope",
    color: AppColors.lavenderGray.withValues(alpha: 0.5),
  );

  static TextStyle font14Gray = TextStyle(
    fontSize: 14.sp,
    fontFamily: "Manrope",
    color: AppColors.gray,
  );

  static TextStyle font13GrayMedium = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    fontFamily: "Manrope",
    color: AppColors.warmGray,
  );

  static TextStyle font11GrayRegular = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "Manrope",
    color: AppColors.warmGray,
  );

  // ── Accent ───────────────────────────────────────────────────────────────────
  static TextStyle font14AccentCyan = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: "Manrope",
    color: AppColors.cyberCyan,
  );
}
