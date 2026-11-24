import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/routing_extension.dart';
import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';
import 'app_buttons.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final IconData icon;
  final bool isDestructive;
  final String cancelLabel;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.icon = CupertinoIcons.exclamationmark_triangle_fill,
    this.isDestructive = false,
    this.cancelLabel = 'Cancel',
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    IconData icon = CupertinoIcons.exclamationmark_triangle_fill,
    bool isDestructive = false,
    String cancelLabel = 'Cancel',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AppConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        icon: icon,
        isDestructive: isDestructive,
        cancelLabel: cancelLabel,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final accent = isDestructive ? AppColors.errorRed : AppColors.primaryCyan;

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(color: accent.withValues(alpha: 0.35), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 24.sp),
            ),
            verticalSpacing(16),
            Text(
              title,
              style: AppStyles.font17WhiteBold.copyWith(
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(8),
            Text(
              message,
              style: AppStyles.font14White70.copyWith(height: 1.45),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(22),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: cancelLabel,
                    onPressed: () => context.pop(false),
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  child: isDestructive
                      ? AppButton.danger(
                          label: confirmLabel,
                          onPressed: () => context.pop(true),
                        )
                      : AppButton.primary(
                          label: confirmLabel,
                          onPressed: () => context.pop(true),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
