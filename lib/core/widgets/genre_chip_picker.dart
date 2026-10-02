import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helpers/category_manager.dart';
import '../helpers/snackbar_helper.dart';
import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';

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
    final set = <String>{
      ...CategoryManager.coreCategories,
      ...CategoryManager.getCustomCategories(),
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

  void _showAddCustomCategoryDialog() {
    final textController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(
                color: AppColors.primaryTeal.withValues(alpha: 0.3),
              ),
            ),
            title: Row(
              children: [
                Icon(CupertinoIcons.tag_fill,
                    color: AppColors.primaryTeal, size: 20.sp),
                horizontalSpacing(8),
                Text(
                  "Add Custom Topic",
                  style: AppStyles.font18BoldIndigoAccent.copyWith(
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create a specific category for your flashcards (e.g., Biology, Medicine, Code).",
                  style: AppStyles.font14White70.copyWith(fontSize: 13.sp),
                ),
                verticalSpacing(14),
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: AppStyles.font16WhiteSemiBold,
                  onChanged: (_) {
                    if (errorMessage != null) {
                      setDialogState(() => errorMessage = null);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Category name...",
                    hintStyle: AppStyles.font14White70,
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    errorText: errorMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                          color: AppColors.primaryTeal, width: 1.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Cancel", style: AppStyles.font14Gray),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () async {
                  final newCat = textController.text.trim();
                  if (newCat.isEmpty) {
                    setDialogState(
                        () => errorMessage = "Please enter a topic name");
                    return;
                  }

                  if (CategoryManager.categoryExists(newCat, _categoriesList)) {
                    // Category already exists -> Select existing category & close
                    final existingCat = _categoriesList.firstWhere(
                      (c) => c.trim().toLowerCase() == newCat.toLowerCase(),
                    );
                    widget.onCategorySelected(existingCat);
                    Navigator.pop(ctx);
                    SnackBarHelper.showInfo(
                        context, "Topic '$existingCat' already exists!");
                    return;
                  }

                  // Add permanently to Hive
                  await CategoryManager.addCustomCategory(newCat);

                  if (!ctx.mounted) return;

                  setState(() {
                    if (!_categoriesList.contains(newCat)) {
                      _categoriesList.add(newCat);
                    }
                  });

                  widget.onCategorySelected(newCat);
                  Navigator.pop(ctx);
                  SnackBarHelper.showSuccess(
                      ctx, "Added new topic '$newCat'");
                },
                child: Text(
                  "Add",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    color: AppColors.darkBackground,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayCategories = widget.includeAllOption
        ? ['All', ..._categoriesList]
        : _categoriesList;

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: displayCategories.length + 1,
        separatorBuilder: (context, index) => horizontalSpacing(8),
        itemBuilder: (context, index) {
          if (index == displayCategories.length) {
            return GestureDetector(
              onTap: _showAddCustomCategoryDialog,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.primaryTeal.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.add,
                        color: AppColors.primaryTeal, size: 14.sp),
                    horizontalSpacing(5),
                    Text(
                      "Custom",
                      style: AppStyles.font13GrayMedium.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5.sp,
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
              : (AppColors.categoryColors[cat] ?? AppColors.skyBlue);

          return GestureDetector(
            onTap: () => widget.onCategorySelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? catColor.withValues(alpha: 0.28)
                    : catColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isSelected
                      ? catColor
                      : catColor.withValues(alpha: 0.25),
                  width: isSelected ? 1.6 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: catColor.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    width: 7.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: catColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpacing(7),
                  Text(
                    cat,
                    style: AppStyles.font13GrayMedium.copyWith(
                      color: isSelected ? AppColors.white : catColor,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 12.5.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
