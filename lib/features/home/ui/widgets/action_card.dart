import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_glass_container.dart';

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassContainer(
      onTap: onTap,
      accentColor: accentColor,
      borderRadius: 22,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 22.sp),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: accentColor.withValues(alpha: 0.6),
                size: 14.sp,
              ),
            ],
          ),
          verticalSpacing(14),
          Text(
            title,
            style: AppStyles.font16WhiteSemiBold.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          verticalSpacing(3),
          Text(
            subtitle,
            style: AppStyles.font12LavenderGrayFaded.copyWith(
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
