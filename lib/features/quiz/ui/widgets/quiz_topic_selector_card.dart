import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class QuizTopicSelectorCard extends StatelessWidget {
  final String topicDisplayText;
  final VoidCallback onTap;

  const QuizTopicSelectorCard({
    super.key,
    required this.topicDisplayText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppColors.primaryCyan.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.square_stack_3d_up_fill,
                color: AppColors.primaryCyan,
                size: 18.sp,
              ),
            ),
            horizontalSpacing(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quiz Topics",
                    style: AppStyles.font13GrayMedium.copyWith(
                      color: AppColors.lavenderGray,
                    ),
                  ),
                  verticalSpacing(2),
                  Text(
                    topicDisplayText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.font16WhiteSemiBold.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_down,
              color: AppColors.primaryCyan,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
