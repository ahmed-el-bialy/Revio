import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_buttons.dart';

class QuizSummaryBanner extends StatelessWidget {
  final int activeSubsetLength;
  final bool isLoading;
  final VoidCallback? onStartQuiz;

  const QuizSummaryBanner({
    super.key,
    required this.activeSubsetLength,
    required this.isLoading,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasEnoughCards = activeSubsetLength >= 3;

    String getSummaryText() {
      if (isLoading) return "Loading cards...";
      if (!hasEnoughCards) {
        return "Minimum 3 cards required to start a quiz (currently $activeSubsetLength available).";
      }
      return "$activeSubsetLength ${activeSubsetLength == 1 ? 'card' : 'cards'} ready for this quiz.";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: hasEnoughCards
                ? AppColors.cardSurface
                : AppColors.softAmber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: hasEnoughCards
                  ? AppColors.primaryCyan.withValues(alpha: 0.2)
                  : AppColors.softAmber.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Icon(
                hasEnoughCards
                    ? CupertinoIcons.info
                    : CupertinoIcons.exclamationmark_triangle_fill,
                color: hasEnoughCards
                    ? AppColors.primaryCyan
                    : AppColors.softAmber,
                size: 20.sp,
              ),
              horizontalSpacing(12),
              Expanded(
                child: Text(
                  getSummaryText(),
                  style: AppStyles.font13GrayMedium.copyWith(
                    color: hasEnoughCards
                        ? AppColors.white
                        : AppColors.softAmber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpacing(24),
        SizedBox(
          width: double.infinity,
          child: AppButton.primary(
            label: "Start Quiz Now",
            icon: CupertinoIcons.play_fill,
            onPressed: hasEnoughCards ? onStartQuiz : null,
          ),
        ),
      ],
    );
  }
}
