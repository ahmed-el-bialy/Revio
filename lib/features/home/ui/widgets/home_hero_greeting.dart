import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class HomeHeroGreeting extends StatelessWidget {
  const HomeHeroGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good to see you again,",
                style: AppStyles.font14White70.copyWith(
                  color: AppColors.lavenderGray,
                  fontSize: 13.5.sp,
                ),
              ),
              verticalSpacing(4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Welcome ",
                      style: AppStyles.font24BoldIceBlueManrope.copyWith(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: "back! 👋",
                      style: AppStyles.font24BoldIceBlueManrope.copyWith(
                        fontSize: 26.sp,
                        color: AppColors.primaryCyan,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacing(6),
              Text(
                "Master your decks & test your memory effortlessly.",
                style: AppStyles.font14White70.copyWith(
                  fontSize: 13.sp,
                  color: AppColors.lavenderGray.withValues(alpha: 0.8),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        horizontalSpacing(12),

        // Glass Deck Stack Graphic matching Revio Logo & UI Mockups
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryCyan.withValues(alpha: 0.22),
                AppColors.skyBlue.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.primaryCyan.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryCyan.withValues(alpha: 0.15),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                CupertinoIcons.square_stack_3d_up_fill,
                color: AppColors.primaryCyan,
                size: 38.sp,
              ),
              Positioned(
                top: 14.h,
                right: 14.w,
                child: Icon(
                  CupertinoIcons.bolt_fill,
                  color: AppColors.softAmber,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
