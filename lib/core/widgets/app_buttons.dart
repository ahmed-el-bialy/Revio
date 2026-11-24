import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';
import 'press_scale_widget.dart';

enum AppButtonVariant { primary, secondary, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expanded;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expanded = true,
    this.loading = false,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.loading = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.loading = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.loading = false,
  }) : variant = AppButtonVariant.danger;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final child = _buildContent();

    final button = PressScale(
      onTap: enabled ? onPressed : null,
      scaleDown: 0.97,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: expanded ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: _fillColor(enabled),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: _borderColor(enabled), width: 1.4),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: button,
    );
  }

  Widget _buildContent() {
    if (loading) {
      return SizedBox(
        height: 18.h,
        width: 18.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.primary
              ? AppColors.darkBackground
              : AppColors.white,
        ),
      );
    }

    final text = Text(
      label,
      style: AppStyles.font14WhiteSemiBold.copyWith(
        color: _textColor(),
        fontWeight: FontWeight.w800,
        fontSize: 14.sp,
      ),
    );

    if (icon == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: _textColor()),
        horizontalSpacing(8),
        text,
      ],
    );
  }

  Color _fillColor(bool enabled) {
    if (!enabled) return AppColors.gray.withValues(alpha: 0.18);
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primaryCyan;
      case AppButtonVariant.secondary:
        return Colors.transparent;
      case AppButtonVariant.danger:
        return AppColors.errorRed.withValues(alpha: 0.18);
    }
  }

  Color _borderColor(bool enabled) {
    if (!enabled) return AppColors.gray.withValues(alpha: 0.2);
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primaryCyan;
      case AppButtonVariant.secondary:
        return AppColors.lavenderGray.withValues(alpha: 0.28);
      case AppButtonVariant.danger:
        return AppColors.errorRed;
    }
  }

  Color _textColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.darkBackground;
      case AppButtonVariant.secondary:
        return AppColors.white;
      case AppButtonVariant.danger:
        return AppColors.errorRed;
    }
  }
}
