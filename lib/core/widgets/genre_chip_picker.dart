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

  void _showManageTopicsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final activeCore = CategoryManager.getActiveCoreCategories();
          final custom = CategoryManager.getCustomCategories();
          final allCurrent = [...activeCore, ...custom];

          return AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(
                color: AppColors.primaryTeal.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(CupertinoIcons.tag_fill,
                      color: AppColors.primaryTeal, size: 18.sp),
                ),
                horizontalSpacing(10),
                Text(
                  "Manage Topics",
                  style: AppStyles.font18BoldIndigoAccent.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 300.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add new topics or delete existing ones below.",
                    style: AppStyles.font14White70.copyWith(fontSize: 13.sp),
                  ),
                  verticalSpacing(14),
                  SizedBox(
                    height: 200.h,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: allCurrent.length,
                      separatorBuilder: (context, index) => verticalSpacing(8),
                      itemBuilder: (context, index) {
                        final cat = allCurrent[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: AppColors.categoryColors[cat] ??
                                      AppColors.primaryTeal,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              horizontalSpacing(10),
                              Expanded(
                                child: Text(
                                  cat,
                                  style: AppStyles.font16WhiteSemiBold.copyWith(
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.all(4.w),
                                icon: Icon(
                                  CupertinoIcons.trash,
                                  color: AppColors.errorRed.withValues(alpha: 0.8),
                                  size: 16.sp,
                                ),
                                onPressed: () async {
                                  await CategoryManager.deleteCategory(cat);
                                  if (!context.mounted) return;
                                  setDialogState(() {});
                                  setState(() {
                                    _categoriesList.remove(cat);
                                  });
                                  if (widget.selectedCategory == cat) {
                                    widget.onCategorySelected('All');
                                  }
                                  SnackBarHelper.showInfo(
                                      context, "Deleted topic '$cat'");
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Done", style: AppStyles.font14Gray),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _showAddCustomCategoryDialog();
                },
                child: Text(
                  "+ Add New",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    color: AppColors.darkBackground,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
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
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(
                color: AppColors.primaryTeal.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(CupertinoIcons.tag_fill,
                      color: AppColors.primaryTeal, size: 18.sp),
                ),
                horizontalSpacing(10),
                Text(
                  "Add Custom Topic",
                  style: AppStyles.font18BoldIndigoAccent.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create a specific topic for your flashcards (e.g., Physics, Medicine, Coding).",
                  style: AppStyles.font14White70.copyWith(fontSize: 13.sp),
                ),
                verticalSpacing(16),
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
                    hintText: "Topic name...",
                    hintStyle: AppStyles.font14White70,
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    errorText: errorMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(
                          color: AppColors.primaryTeal, width: 1.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                ),
                onPressed: () async {
                  final newCat = textController.text.trim();
                  if (newCat.isEmpty) {
                    setDialogState(
                        () => errorMessage = "Please enter a topic name");
                    return;
                  }

                  await CategoryManager.addCustomCategory(newCat);

                  if (!ctx.mounted) return;

                  setState(() {
                    if (!_categoriesList.contains(newCat)) {
                      _categoriesList.add(newCat);
                    }
                  });

                  // Automatically select the newly added category and close dialog
                  widget.onCategorySelected(newCat);
                  Navigator.pop(ctx);
                  SnackBarHelper.showSuccess(
                      ctx, "Added & selected topic '$newCat'");
                },
                child: Text(
                  "Add & Select",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    color: AppColors.darkBackground,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
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

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 44.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: displayCategories.length + 1,
          separatorBuilder: (context, index) => horizontalSpacing(8),
          itemBuilder: (context, index) {
            if (index == displayCategories.length) {
              return GestureDetector(
                onTap: _showManageTopicsDialog,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.primaryTeal.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.gear_alt_fill,
                          color: AppColors.primaryTeal, size: 14.sp),
                      horizontalSpacing(6),
                      Text(
                        "Manage / Add",
                        style: AppStyles.font13GrayMedium.copyWith(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.sp,
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? catColor.withValues(alpha: 0.32)
                      : catColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? catColor
                        : catColor.withValues(alpha: 0.28),
                    width: isSelected ? 1.6 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: catColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: catColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    horizontalSpacing(8),
                    Text(
                      cat,
                      style: AppStyles.font13GrayMedium.copyWith(
                        color: isSelected ? AppColors.white : catColor,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 13.sp,
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
