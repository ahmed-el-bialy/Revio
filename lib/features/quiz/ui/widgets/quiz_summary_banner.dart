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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.primaryCyan.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.info,
                color: AppColors.primaryCyan,
                size: 20.sp,
              ),
              horizontalSpacing(12),
              Expanded(
                child: Text(
                  isLoading
                      ? "Loading cards..."
                      : "$activeSubsetLength ${activeSubsetLength == 1 ? 'card' : 'cards'} ready for this quiz.",
                  style: AppStyles.font13GrayMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpacing(28),
        SizedBox(
          width: double.infinity,
          child: AppButton.primary(
            label: "Start Quiz Now",
            icon: CupertinoIcons.play_fill,
            onPressed: activeSubsetLength == 0 ? null : onStartQuiz,
          ),
        ),
      ],
    );
  }
}
