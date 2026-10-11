import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_glass_container.dart';

class GenresWideCard extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const GenresWideCard({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = AppColors.softAmber;

    return AppGlassContainer(
      onTap: onTap,
      accentColor: accentColor,
      borderRadius: 22,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.35),
              ),
            ),
            child: const Icon(
              CupertinoIcons.tag_fill,
              color: accentColor,
            ),
          ),
          horizontalSpacing(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Genres",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                verticalSpacing(3),
                Text(
                  "$count categories · Manage & organize",
                  style: AppStyles.font12LavenderGrayFaded.copyWith(
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            color: accentColor.withValues(alpha: 0.6),
            size: 15.sp,
          ),
        ],
      ),
    );
  }
}
