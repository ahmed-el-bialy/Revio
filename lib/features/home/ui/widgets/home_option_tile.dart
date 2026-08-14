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
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: model.onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.indigoAccentTransparent(0.07),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.lavenderGrayTransparent(0.05),
              width: 1.w,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  model.imagePath,
                  height: 48.h,
                  width: 48.w,
                  fit: BoxFit.cover,
                ),
              ),
              horizontalSpacing(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(model.title, style: AppStyles.font17WhiteBold),
                    verticalSpacing(4),
                    Text(
                      model.subtitle,
                      style: AppStyles.font12LavenderGray,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.lavenderGrayTransparent(0.5),
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
