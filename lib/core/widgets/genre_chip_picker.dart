import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/category_manager.dart';
import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';
import 'add_custom_category_dialog.dart';
import 'press_scale_widget.dart';

class GenreChipPicker extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final bool includeAllOption;
  final List<String>? customCategories;

  const GenreChipPicker({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.includeAllOption = false,
    this.customCategories,
  });

  @override
  State<GenreChipPicker> createState() => _GenreChipPickerState();
}

class _GenreChipPickerState extends State<GenreChipPicker> {
  late List<String> _categoriesList;

  @override
  void initState() {
    super.initState();
    _initCategories();
  }

  @override
  void didUpdateWidget(covariant GenreChipPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initCategories();
  }

  void _initCategories() {
    final activeCore = CategoryManager.getActiveCoreCategories();
    final custom = CategoryManager.getCustomCategories();

    final set = <String>{
      ...activeCore,
      ...custom,
    };
    if (widget.customCategories != null) {
      set.addAll(widget.customCategories!);
    }
    if (widget.selectedCategory.isNotEmpty &&
        widget.selectedCategory != 'All' &&
        !set.contains(widget.selectedCategory)) {
      set.add(widget.selectedCategory);
    }
    _categoriesList = set.toList();
  }

  void _openAddCategoryDialog() {
    AddCustomCategoryDialog.show(
      context,
      onCategoryAdded: () {
        if (mounted) {
          setState(() {
            _initCategories();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayCategories = widget.includeAllOption
        ? ['All', ..._categoriesList]
        : _categoriesList;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 38.h,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: displayCategories.length + 1,
          separatorBuilder: (context, _) => horizontalSpacing(8),
          itemBuilder: (context, index) {
            if (index == displayCategories.length) {
              return PressScale(
                onTap: _openAddCategoryDialog,
                scaleDown: 0.93,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColors.primaryTeal.withValues(alpha: 0.4),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.add,
                          color: AppColors.primaryTeal, size: 13.sp),
                      horizontalSpacing(4),
                      Text(
                        "Add",
                        style: AppStyles.font13GrayMedium.copyWith(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final cat = displayCategories[index];
            final isSelected = cat == widget.selectedCategory;
            final catColor = cat == 'All'
                ? AppColors.primaryTeal
                : (AppColors.categoryColors[cat] ?? AppColors.primaryTeal);

            return PressScale(
              onTap: () => widget.onCategorySelected(cat),
              scaleDown: 0.94,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? catColor.withValues(alpha: 0.28)
                      : catColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isSelected
                        ? catColor
                        : catColor.withValues(alpha: 0.22),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: catColor.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: catColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    horizontalSpacing(6),
                    Text(
                      cat,
                      style: AppStyles.font13GrayMedium.copyWith(
                        color: isSelected ? AppColors.white : catColor,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
