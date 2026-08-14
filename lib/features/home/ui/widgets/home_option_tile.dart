import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../models/navigation_model.dart';

class HomeOptionTile extends StatelessWidget {
  final NavigationModel model;
  const HomeOptionTile({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: InkWell(
        onTap: model.onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: AppColors.oceanBlue.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1.w,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Image.asset(
                  model.imagePath,
                  height: 32.h,
                  width: 32.w,
                  fit: BoxFit.cover,
                ),
              ),
              horizontalSpacing(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.title,
                      style: AppStyles.font17WhiteBold.copyWith(
                        fontSize: 16.sp,
                        letterSpacing: 0.3,
                      ),
                    ),
                    verticalSpacing(4),
                    Text(
                      model.subtitle,
                      style: AppStyles.font12LavenderGray.copyWith(
                        color: AppColors.lavenderGray.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.2),
                size: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
