import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class QuizModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizModeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryCyan.withValues(alpha: 0.15)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryCyan
                : AppColors.white.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color:
                  isSelected ? AppColors.primaryCyan : AppColors.lavenderGray,
              size: 22.sp,
            ),
            verticalSpacing(10),
            Text(
              title,
              style: AppStyles.font16WhiteSemiBold.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.white : AppColors.lavenderGray,
              ),
            ),
            verticalSpacing(2),
            Text(
              subtitle,
              style: AppStyles.font12LavenderGrayFaded.copyWith(
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
