// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryCyan.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.style_rounded,
            color: AppColors.primaryCyan,
            size: 19.sp,
          ),
        ),
        horizontalSpacing(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "REVIO",
              style: AppStyles.font24BoldPrimaryManrope.copyWith(
                fontSize: 20.sp,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Text(
            "v2.0",
            style: AppStyles.font11GrayRegular.copyWith(
              color: AppColors.lavenderGray,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
