import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../logic/quiz_cubit.dart';

class CorrectAnswerBanner extends StatelessWidget {
  final String answer;

  const CorrectAnswerBanner({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.xmark_circle_fill,
            color: AppColors.error,
            size: 18.sp,
          ),
          horizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Not quite!",
                  style: AppStyles.font12LavenderGray.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpacing(2),
                Text(
                  "Answer: $answer",
                  style: AppStyles.font14WhiteSemiBold,
                ),
              ],
            ),
          ),
          horizontalSpacing(8),
          GestureDetector(
            onTap: () => context.read<QuizCubit>().emitAdvanceNext(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Next",
                    style: AppStyles.font12White38.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  horizontalSpacing(4),
                  Icon(
                    CupertinoIcons.arrow_right,
                    color: AppColors.white,
                    size: 12.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
