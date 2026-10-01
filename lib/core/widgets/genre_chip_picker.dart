import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_constants.dart';
import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';

class GenreChipPicker extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final bool includeAllOption;

  const GenreChipPicker({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.includeAllOption = false,
  });

  @override
  Widget build(BuildContext context) {
    final categoriesList = includeAllOption
        ? ['All', ...AppConstants.categories]
        : AppConstants.categories;

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categoriesList.length,
        separatorBuilder: (context, index) => horizontalSpacing(8),
        itemBuilder: (context, index) {
          final cat = categoriesList[index];
          final isSelected = cat == selectedCategory;
          final catColor = cat == 'All'
              ? AppColors.primaryTeal
              : (AppColors.categoryColors[cat] ?? AppColors.primaryTeal);

          return ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            selectedColor: catColor.withValues(alpha: 0.2),
            backgroundColor: AppColors.surfaceDark.withValues(alpha: 0.6),
            side: BorderSide(
              color: isSelected ? catColor : AppColors.gray.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
            labelStyle: AppStyles.font14White70.copyWith(
              color: isSelected ? catColor : AppColors.lavenderGray,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13.sp,
            ),
            onSelected: (selected) {
              if (selected) {
                onCategorySelected(cat);
              }
            },
          );
        },
      ),
    );
  }
}
