import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class StudyProgressRow extends StatelessWidget {
  final int current;
  final int total;
  final double progress;
  final VoidCallback onShuffle;

  const StudyProgressRow({
    super.key,
    required this.current,
    required this.total,
    required this.progress,
    required this.onShuffle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Card $current of $total',
                style: AppStyles.font13GrayMedium.copyWith(
                  color: AppColors.primaryCyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Tap card to flip 🔄',
              style: AppStyles.font12LavenderGrayFaded,
            ),
            horizontalSpacing(12),
            GestureDetector(
              onTap: onShuffle,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.indigoAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.indigoAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.shuffle,
                      color: AppColors.indigoAccent,
                      size: 13.sp,
                    ),
                    horizontalSpacing(4),
                    Text(
                      'Shuffle',
                      style: AppStyles.font12LavenderGrayFaded.copyWith(
                        color: AppColors.indigoAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4.h,
            backgroundColor: AppColors.white.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryCyan,
            ),
          ),
        ),
      ],
    );
  }
}
