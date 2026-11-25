import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class QuizFavoritesToggleCard extends StatelessWidget {
  final bool onlyFavorites;
  final ValueChanged<bool> onChanged;

  const QuizFavoritesToggleCard({
    super.key,
    required this.onlyFavorites,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!onlyFavorites),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: onlyFavorites
                ? AppColors.primaryCyan
                : AppColors.white.withValues(alpha: 0.08),
            width: onlyFavorites ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: onlyFavorites
                    ? AppColors.primaryCyan.withValues(alpha: 0.15)
                    : AppColors.cardSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                onlyFavorites ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: onlyFavorites
                    ? AppColors.primaryCyan
                    : AppColors.lavenderGray,
                size: 18.sp,
              ),
            ),
            horizontalSpacing(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Favorites Only",
                    style: AppStyles.font16WhiteSemiBold.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  verticalSpacing(2),
                  Text(
                    "Test only your starred flashcards",
                    style: AppStyles.font13GrayMedium.copyWith(
                      color: AppColors.lavenderGray,
                    ),
                  ),
                ],
              ),
            ),
            CupertinoSwitch(
              value: onlyFavorites,
              activeTrackColor: AppColors.primaryCyan,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
