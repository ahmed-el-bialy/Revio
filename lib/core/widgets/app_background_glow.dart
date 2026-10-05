import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_colors.dart';

enum GlowVariant { home, quiz, review, addCard }

class AppBackgroundGlow extends StatelessWidget {
  final Widget child;
  final GlowVariant variant;

  const AppBackgroundGlow({
    super.key,
    required this.child,
    this.variant = GlowVariant.home,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          ..._buildGlowsForVariant(variant),
          child,
        ],
      ),
    );
  }

  List<Widget> _buildGlowsForVariant(GlowVariant v) {
    switch (v) {
      case GlowVariant.home:
        return [
          Positioned(
            top: -70.h,
            left: -50.w,
            child: Container(
              width: 220.w,
              height: 220.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryTeal.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            top: 180.h,
            right: -80.w,
            child: Container(
              width: 260.w,
              height: 260.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyberCyan.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 120.h,
            left: -70.w,
            child: Container(
              width: 240.w,
              height: 240.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emeraldGold.withValues(alpha: 0.07),
              ),
            ),
          ),
        ];
      case GlowVariant.quiz:
        return [
          Positioned(
            top: 40.h,
            right: -60.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.softAmber.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            left: -50.w,
            child: Container(
              width: 240.w,
              height: 240.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryTeal.withValues(alpha: 0.09),
              ),
            ),
          ),
        ];
      case GlowVariant.review:
        return [
          Positioned(
            top: -50.h,
            right: -40.w,
            child: Container(
              width: 230.w,
              height: 230.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyberCyan.withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            bottom: 100.h,
            left: -60.w,
            child: Container(
              width: 240.w,
              height: 240.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emeraldGold.withValues(alpha: 0.08),
              ),
            ),
          ),
        ];
      case GlowVariant.addCard:
        return [
          Positioned(
            top: 80.h,
            left: -60.w,
            child: Container(
              width: 240.w,
              height: 240.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryTeal.withValues(alpha: 0.09),
              ),
            ),
          ),
          Positioned(
            bottom: -30.h,
            right: -40.w,
            child: Container(
              width: 230.w,
              height: 230.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.softAmber.withValues(alpha: 0.08),
              ),
            ),
          ),
        ];
    }
  }
}
