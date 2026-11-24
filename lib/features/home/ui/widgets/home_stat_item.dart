import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class HomeStatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const HomeStatItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final targetNumber = int.tryParse(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: iconColor, size: 15.sp),
            ),
            horizontalSpacing(6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.font12LavenderGray.copyWith(
                  color: AppColors.lavenderGray,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(6),
        if (targetNumber != null)
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: targetNumber),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, _) {
              return Text(
                "$animatedValue",
                style: AppStyles.font28BoldIceBlue.copyWith(
                  color: AppColors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                ),
              );
            },
          )
        else
          Text(
            value,
            style: AppStyles.font28BoldIceBlue.copyWith(
              color: AppColors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}
