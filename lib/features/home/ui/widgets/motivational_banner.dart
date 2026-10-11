import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_glass_container.dart';

class MotivationalBanner extends StatelessWidget {
  const MotivationalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AppGlassContainer(
      accentColor: AppColors.primaryCyan,
      borderRadius: 20,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primaryCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.primaryCyan.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              CupertinoIcons.graph_square_fill,
              color: AppColors.primaryCyan,
              size: 20.sp,
            ),
          ),
          horizontalSpacing(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Small steps. Big progress.",
                  style: AppStyles.font14WhiteSemiBold.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
                verticalSpacing(2),
                Text(
                  "Keep going! Your memory is getting stronger.",
                  style: AppStyles.font12LavenderGrayFaded.copyWith(
                    fontSize: 11.sp,
                    color: AppColors.lavenderGray.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
