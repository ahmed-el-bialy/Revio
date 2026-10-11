import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/category_manager.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class AddGenreDialog extends StatefulWidget {
  final VoidCallback onGenreAdded;

  const AddGenreDialog({super.key, required this.onGenreAdded});

  static Future<void> show(BuildContext context, {required VoidCallback onGenreAdded}) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AddGenreDialog(onGenreAdded: onGenreAdded),
    );
  }

  @override
  State<AddGenreDialog> createState() => _AddGenreDialogState();
}

class _AddGenreDialogState extends State<AddGenreDialog> {
  late final TextEditingController _textController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final newGenre = _textController.text.trim();
    if (newGenre.isEmpty) {
      setState(() => _errorMessage = "Please enter a genre name");
      return;
    }

    final added = await CategoryManager.addCustomCategory(newGenre);
    if (!mounted) return;

    if (!added) {
      setState(() => _errorMessage = "Genre already exists");
      return;
    }

    context.pop();
    widget.onGenreAdded();
    SnackBarHelper.showSuccess(context, "Added genre '$newGenre'");
  }

  @override
  Widget build(BuildContext context) {
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
            child: Icon(
              CupertinoIcons.tag_fill,
              color: AppColors.primaryTeal,
              size: 18.sp,
            ),
          ),
          horizontalSpacing(10),
          Text(
            "Add New Genre",
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
            "Create a new genre category for your flashcards.",
            style: AppStyles.font14White70.copyWith(fontSize: 13.sp),
          ),
          verticalSpacing(16),
          TextField(
            controller: _textController,
            autofocus: true,
            style: AppStyles.font16WhiteSemiBold,
            onChanged: (_) {
              if (_errorMessage != null) {
                setState(() => _errorMessage = null);
              }
            },
            decoration: InputDecoration(
              hintText: "Genre name...",
              hintStyle: AppStyles.font14White70,
              filled: true,
              fillColor: AppColors.cardSurface,
              errorText: _errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(
                  color: AppColors.primaryTeal,
                  width: 1.5,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
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
          onPressed: _submit,
          child: Text(
            "Add Genre",
            style: AppStyles.font16WhiteSemiBold.copyWith(
              color: AppColors.darkBackground,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
