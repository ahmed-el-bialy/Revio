import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_glass_container.dart';

class HeroQuizCard extends StatelessWidget {
  const HeroQuizCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppGlassContainer(
      onTap: () => context.pushNamed(AppConstants.quizScreen, null),
      accentColor: AppColors.softAmber,
      borderRadius: 24,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.softAmber.withValues(alpha: 0.3),
                  AppColors.softAmber.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: AppColors.softAmber.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(
              CupertinoIcons.bolt_fill,
              color: AppColors.softAmber,
              size: 28.sp,
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
                        color: AppColors.softAmber.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "SMART",
                        style: AppStyles.font11GrayRegular.copyWith(
                          color: AppColors.softAmber,
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
                        color: AppColors.softAmber,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5.sp,
                      ),
                    ),
                    horizontalSpacing(4),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: AppColors.softAmber,
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
