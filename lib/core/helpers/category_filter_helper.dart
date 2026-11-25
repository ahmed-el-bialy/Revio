import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';

import '../../features/cards/data/models/card_model.dart';
import '../helpers/category_manager.dart';
import '../helpers/routing_extension.dart';
import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';

class CategoryFilterHelper {
  static void showCategoryFilterModal({
    required BuildContext context,
    required String selectedCategory,
    required List<CardModel> cards,
    required ValueChanged<String> onCategorySelected,
    bool onlyFavorites = false,
    ValueChanged<bool>? onFavoritesToggled,
    VoidCallback? onResetFilters,
  }) {
    final core = CategoryManager.getActiveCoreCategories();
    final custom = CategoryManager.getCustomCategories();
    final cardCategories = cards
        .map((c) => c.category ?? 'No Topic')
        .where((cat) => cat != 'All')
        .toSet()
        .toList();

    final allCategories = {
      'All',
      ...core,
      ...custom,
      ...cardCategories.where((c) => !core.contains(c) && !custom.contains(c)),
    }.toList();

    final favCount = cards.where((c) => c.isFavorite ?? false).length;
    final hasActiveFilter = selectedCategory != 'All' || onlyFavorites;

    int getCategoryCount(String cat) {
      if (cat == 'All') return cards.length;
      if (cat == 'No Topic') {
        return cards
            .where((c) =>
                c.category == null ||
                c.category!.isEmpty ||
                c.category == 'No Topic')
            .length;
      }
      return cards.where((c) => c.category == cat).length;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          CupertinoIcons.slider_horizontal_3,
                          color: AppColors.primaryCyan,
                          size: 18.sp,
                        ),
                      ),
                      horizontalSpacing(10),
                      Text(
                        "Filter Cards",
                        style: AppStyles.font18BoldIndigoAccent.copyWith(
                          color: AppColors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                      const Spacer(),
                      if (hasActiveFilter && onResetFilters != null)
                        TextButton.icon(
                          onPressed: () {
                            onResetFilters();
                            context.pop();
                          },
                          icon: Icon(
                            CupertinoIcons.arrow_counterclockwise,
                            size: 14.sp,
                            color: AppColors.softAmber,
                          ),
                          label: Text(
                            "Reset",
                            style: AppStyles.font12LavenderGrayFaded.copyWith(
                              color: AppColors.softAmber,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.xmark,
                          color: AppColors.lavenderGray,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                  verticalSpacing(16),

                  // Favorites Quick Filter Row
                  if (onFavoritesToggled != null) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        onFavoritesToggled(!onlyFavorites);
                        context.pop();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: onlyFavorites
                              ? AppColors.softAmber.withValues(alpha: 0.18)
                              : AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: onlyFavorites
                                ? AppColors.softAmber
                                : AppColors.white.withValues(alpha: 0.08),
                            width: onlyFavorites ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              onlyFavorites
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: AppColors.softAmber,
                              size: 20.sp,
                            ),
                            horizontalSpacing(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Favorites Only",
                                  style: AppStyles.font16WhiteSemiBold.copyWith(
                                    color: onlyFavorites
                                        ? AppColors.white
                                        : AppColors.lavenderGray,
                                    fontWeight: onlyFavorites
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "$favCount starred ${favCount == 1 ? 'card' : 'cards'}",
                                  style: AppStyles.font12LavenderGrayFaded
                                      .copyWith(
                                    color: AppColors.lavenderGray
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (onlyFavorites)
                              Icon(
                                CupertinoIcons.checkmark_alt_circle_fill,
                                color: AppColors.softAmber,
                                size: 20.sp,
                              ),
                          ],
                        ),
                      ),
                    ),
                    verticalSpacing(16),
                    Row(
                      children: [
                        Text(
                          "Topics & Genres",
                          style: AppStyles.font14White70.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.lavenderGray,
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(10),
                  ],

                  // Category List
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: allCategories.length,
                      separatorBuilder: (context, _) => verticalSpacing(8),
                      itemBuilder: (context, index) {
                        final cat = allCategories[index];
                        final isSelected = cat == selectedCategory;
                        final count = getCategoryCount(cat);
                        final catColor = cat == 'All'
                            ? AppColors.primaryTeal
                            : (AppColors.categoryColors[cat] ??
                                AppColors.primaryTeal);

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            onCategorySelected(cat);
                            context.pop();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 13.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? catColor.withValues(alpha: 0.2)
                                  : AppColors.cardSurface,
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: isSelected
                                    ? catColor
                                    : AppColors.white.withValues(alpha: 0.08),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: catColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                horizontalSpacing(12),
                                Text(
                                  cat,
                                  style: AppStyles.font16WhiteSemiBold.copyWith(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.lavenderGray,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? catColor.withValues(alpha: 0.25)
                                        : AppColors.white
                                            .withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    "$count",
                                    style: AppStyles.font11GrayRegular.copyWith(
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.lavenderGray
                                              .withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (isSelected) ...[
                                  horizontalSpacing(8),
                                  Icon(
                                    CupertinoIcons.checkmark_alt_circle_fill,
                                    color: catColor,
                                    size: 20.sp,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
