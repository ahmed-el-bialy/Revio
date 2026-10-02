import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../logic/quiz_state.dart';

class QuizProgressBar extends StatelessWidget {
  final QuizInProgress state;

  const QuizProgressBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildScoreBadge(
              Icons.check_circle_outline,
              AppColors.success,
              "${state.correctCount} correct",
            ),
            Text(
              "${state.currentIndex + 1} / ${state.cards.length}",
              style: AppStyles.font14WhiteSemiBold,
            ),
            _buildScoreBadge(
              Icons.cancel_outlined,
              AppColors.errorRed,
              "${state.wrongCount} wrong",
            ),
          ],
        ),
        verticalSpacing(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: (state.currentIndex + 1) / state.cards.length,
            backgroundColor: AppColors.oceanBlue,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
            minHeight: 6.h,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBadge(IconData icon, Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          horizontalSpacing(5),
          Text(
            label,
            style: AppStyles.font12LavenderGray.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
