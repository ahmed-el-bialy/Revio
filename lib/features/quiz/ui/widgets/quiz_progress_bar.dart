import 'package:material_ui/material_ui.dart';
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
          children: [
            _ScoreChip(
              color: AppColors.success,
              label: '${state.correctCount}',
              icon: Icons.check_rounded,
            ),
            Expanded(
              child: Text(
                '${state.currentIndex + 1} / ${state.cards.length}',
                textAlign: TextAlign.center,
                style: AppStyles.font14WhiteSemiBold.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _ScoreChip(
              color: AppColors.errorRed,
              label: '${state.wrongCount}',
              icon: Icons.close_rounded,
            ),
          ],
        ),
        verticalSpacing(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: state.progress,
            backgroundColor: AppColors.oceanBlue,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryCyan,
            ),
            minHeight: 7.h,
          ),
        ),
      ],
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  const _ScoreChip({
    required this.color,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          horizontalSpacing(4),
          Text(
            label,
            style: AppStyles.font12LavenderGray.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
