import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_card.dart';

class HeroQuizCard extends StatelessWidget {
  const HeroQuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = AppColors.softAmber;

    return AppCard(
      onTap: () => context.pushNamed(AppConstants.quizScreen),
      borderRadius: 22,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              CupertinoIcons.bolt_fill,
              color: accentColor,
              size: 26.sp,
            ),
          ),
          horizontalSpacing(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Start Quiz Challenge",
                        style: AppStyles.font18WhiteBold.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    horizontalSpacing(6),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "SMART",
                        style: AppStyles.font11GrayRegular.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpacing(4),
                Text(
                  "MCQ & Smart Typing with fuzzy matching",
                  style: AppStyles.font12LavenderGrayFaded.copyWith(
                    fontSize: 11.5.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpacing(10),
                Row(
                  children: [
                    Text(
                      "Play Quiz Now",
                      style: AppStyles.font13GrayMedium.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5.sp,
                      ),
                    ),
                    horizontalSpacing(4),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: accentColor,
                      size: 13.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
