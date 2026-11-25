import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';

class ActiveFilterBanner extends StatelessWidget {
  final String selectedCategory;
  final bool onlyFavorites;
  final VoidCallback onClearFilters;
  final double horizontalPadding;

  const ActiveFilterBanner({
    super.key,
    required this.selectedCategory,
    required this.onlyFavorites,
    required this.onClearFilters,
    this.horizontalPadding = 16,
  });

  bool get hasActiveFilter => selectedCategory != 'All' || onlyFavorites;

  @override
  Widget build(BuildContext context) {
    if (!hasActiveFilter) {
      return const SizedBox.shrink();
    }

    final filters = <String>[];
    if (selectedCategory != 'All') {
      filters.add(selectedCategory);
    }
    if (onlyFavorites) {
      filters.add('Favorites Only');
    }

    final filterText = filters.join(' • ');

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding.w,
        vertical: 6.h,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primaryCyan.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryCyan.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.slider_horizontal_3,
              color: AppColors.primaryCyan,
              size: 15.sp,
            ),
            horizontalSpacing(8),
            Text(
              'Filtered:',
              style: AppStyles.font12LavenderGrayFaded.copyWith(
                color: AppColors.primaryCyan,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
            horizontalSpacing(6),
            Expanded(
              child: Text(
                filterText,
                style: AppStyles.font13GrayMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: onClearFilters,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: AppColors.primaryCyan,
                      size: 12.sp,
                    ),
                    horizontalSpacing(4),
                    Text(
                      'Clear',
                      style: AppStyles.font12LavenderGrayFaded.copyWith(
                        color: AppColors.primaryCyan,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
