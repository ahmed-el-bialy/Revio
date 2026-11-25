import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class StudyNavigationRow extends StatelessWidget {
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final bool isLast;

  const StudyNavigationRow({
    super.key,
    required this.onPrev,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NavButton(
            label: 'Previous',
            icon: CupertinoIcons.chevron_left,
            isEnabled: onPrev != null,
            onTap: onPrev,
            isPrimary: false,
          ),
        ),
        horizontalSpacing(12),
        Expanded(
          child: _NavButton(
            label: isLast ? 'Finish 🎉' : 'Next',
            icon: isLast
                ? CupertinoIcons.checkmark_alt
                : CupertinoIcons.chevron_right,
            isEnabled: onNext != null || isLast,
            onTap: isLast ? () => context.pop() : onNext,
            isPrimary: true,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isEnabled;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPrimary ? AppColors.primaryCyan : AppColors.indigoAccent;
    final effectiveColor =
        isEnabled ? color : AppColors.lavenderGray.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isEnabled
              ? color.withValues(alpha: isPrimary ? 1 : 0.1)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: effectiveColor.withValues(alpha: isPrimary ? 0 : 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isPrimary) ...[
              Icon(
                icon,
                size: 16.sp,
                color: isEnabled
                    ? (isPrimary ? AppColors.darkBackground : color)
                    : AppColors.lavenderGray.withValues(alpha: 0.3),
              ),
              horizontalSpacing(6),
            ],
            Text(
              label,
              style: AppStyles.font16WhiteSemiBold.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: isEnabled
                    ? (isPrimary ? AppColors.darkBackground : color)
                    : AppColors.lavenderGray.withValues(alpha: 0.3),
              ),
            ),
            if (isPrimary) ...[
              horizontalSpacing(6),
              Icon(
                icon,
                size: 16.sp,
                color: isEnabled
                    ? AppColors.darkBackground
                    : AppColors.lavenderGray.withValues(alpha: 0.3),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
