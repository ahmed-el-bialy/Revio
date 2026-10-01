import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../models/navigation_model.dart';

class HomeOptionTile extends StatelessWidget {
  final NavigationModel model;
  const HomeOptionTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: model.onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryTeal.withValues(alpha: 0.2),
                  ),
                ),
                child: Image.asset(
                  model.imagePath,
                  height: 28.h,
                  width: 28.w,
                  fit: BoxFit.contain,
                ),
              ),
              horizontalSpacing(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.title,
                      style: AppStyles.font16WhiteSemiBold,
                    ),
                    verticalSpacing(3),
                    Text(
                      model.subtitle,
                      style: AppStyles.font12LavenderGrayFaded,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.white.withValues(alpha: 0.18),
                size: 13.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
