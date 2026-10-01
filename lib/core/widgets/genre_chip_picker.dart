import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  static const List<String> _defaultCoreCategories = [
    'General',
    'Science',
    'Math',
    'Language',
  ];

  late List<String> _userCategories;

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
    final set = <String>{..._defaultCoreCategories};
    if (widget.customCategories != null) {
      set.addAll(widget.customCategories!);
    }
    if (widget.selectedCategory.isNotEmpty &&
        widget.selectedCategory != 'All' &&
        !set.contains(widget.selectedCategory)) {
      set.add(widget.selectedCategory);
    }
    _userCategories = set.toList();
  }

  void _showAddCustomCategoryDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: AppColors.primaryTeal.withValues(alpha: 0.3)),
        ),
        title: Row(
          children: [
            Icon(
              CupertinoIcons.tag_fill,
              color: AppColors.primaryTeal,
              size: 20.sp,
            ),
            horizontalSpacing(8),
            Text(
              "Add Custom Topic",
              style: AppStyles.font18BoldIndigoAccent.copyWith(fontSize: 18.sp),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create a specific category for your flashcards (e.g., Biology, Medicine, History, Code).",
              style: AppStyles.font14White70.copyWith(fontSize: 13.sp),
            ),
            verticalSpacing(14),
            TextField(
              controller: textController,
              autofocus: true,
              style: AppStyles.font16WhiteSemiBold,
              decoration: InputDecoration(
                hintText: "Category name...",
                hintStyle: AppStyles.font14White70,
                filled: true,
                fillColor: AppColors.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: AppColors.primaryTeal,
                    width: 1.5,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
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
            onPressed: () {
              final newCat = textController.text.trim();
              if (newCat.isNotEmpty) {
                setState(() {
                  if (!_userCategories.contains(newCat)) {
                    _userCategories.add(newCat);
                  }
                });
                widget.onCategorySelected(newCat);
                Navigator.pop(ctx);
              }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesList = widget.includeAllOption
        ? ['All', ..._userCategories]
        : _userCategories;

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categoriesList.length + 1,
        separatorBuilder: (context, index) => horizontalSpacing(8),
        itemBuilder: (context, index) {
          if (index == categoriesList.length) {
            return GestureDetector(
              onTap: _showAddCustomCategoryDialog,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.primaryTeal.withValues(alpha: 0.35),
                    style: BorderStyle.solid,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.add,
                      color: AppColors.primaryTeal,
                      size: 14.sp,
                    ),
                    horizontalSpacing(4),
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

          final cat = categoriesList[index];
          final isSelected = cat == widget.selectedCategory;
          final catColor = cat == 'All'
              ? AppColors.primaryTeal
              : (AppColors.categoryColors[cat] ?? AppColors.primaryTeal);

          return ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            selectedColor: catColor.withValues(alpha: 0.2),
            backgroundColor: AppColors.surfaceDark.withValues(alpha: 0.6),
            side: BorderSide(
              color: isSelected
                  ? catColor
                  : AppColors.gray.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
            labelStyle: AppStyles.font14White70.copyWith(
              color: isSelected ? catColor : AppColors.lavenderGray,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 12.5.sp,
            ),
            onSelected: (selected) {
              if (selected) {
                widget.onCategorySelected(cat);
              }
            },
          );
        },
      ),
    );
  }
}
