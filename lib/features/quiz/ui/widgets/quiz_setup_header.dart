import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import 'quiz_back_chip.dart';

class QuizSetupHeader extends StatelessWidget {
  const QuizSetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        QuizBackChip(onTap: () => context.maybePop()),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primaryCyan.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.primaryCyan.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.bolt_fill,
                color: AppColors.primaryCyan,
                size: 14.sp,
              ),
              horizontalSpacing(6),
              Text(
                'Quiz Options',
                style: AppStyles.font13GrayMedium.copyWith(
                  color: AppColors.primaryCyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
