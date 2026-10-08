import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnackBarHelper {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.check_circle_rounded,
      backgroundColor: const Color(0xFF064E3B),
      accentColor: AppColors.emeraldGold,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.error_rounded,
      backgroundColor: const Color(0xFF881337),
      accentColor: const Color(0xFFFB7185),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.info_rounded,
      backgroundColor: const Color(0xFF1E293B),
      accentColor: AppColors.primaryTeal,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color backgroundColor,
    required Color accentColor,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: accentColor, size: 20.sp),
            horizontalSpacing(12),
            Expanded(
              child: Text(
                message,
                style: AppStyles.font14WhiteSemiBold,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: accentColor.withValues(alpha: 0.4),
            width: 1.0,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
