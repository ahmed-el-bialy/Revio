import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/genre_chip_picker.dart';
import '../../../cards/data/models/card_model.dart';
import '../../../cards/data/repo/cards_repo.dart';
import '../../../add_new_card/ui/widgets/app_text_form.dart';

class AddCardModalBottomSheet extends StatefulWidget {
  final String? initialCategory;

  const AddCardModalBottomSheet({super.key, this.initialCategory});

  @override
  State<AddCardModalBottomSheet> createState() =>
      _AddCardModalBottomSheetState();
}

class _AddCardModalBottomSheetState extends State<AddCardModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory != null &&
            widget.initialCategory != 'All'
        ? widget.initialCategory!
        : AppConstants.categories.first;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _hintController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      final newCard = CardModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory,
        front: _questionController.text.trim(),
        hint: _hintController.text.trim().isEmpty
            ? null
            : _hintController.text.trim(),
        back: _answerController.text.trim(),
        isFavorite: false,
        createdAt: DateTime.now(),
      );

      await CardsRepo().saveCard(newCard);
      if (!mounted) return;

      Navigator.of(context).pop();
      SnackBarHelper.showSuccess(context, "Flashcard added successfully! 🎉");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        border: Border.all(
          color: AppColors.primaryTeal.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBackground.withValues(alpha: 0.6),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        left: 20.w,
        right: 20.w,
        top: 12.h,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.lavenderGray.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                verticalSpacing(18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryTeal.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            CupertinoIcons.add,
                            color: AppColors.darkBackground,
                            size: 18.sp,
                          ),
                        ),
                        horizontalSpacing(12),
                        Text(
                          "Add New Flashcard",
                          style: AppStyles.font18BoldIndigoAccent.copyWith(
                            fontSize: 20.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.cardSurface,
                        padding: EdgeInsets.all(8.w),
                      ),
                      icon: Icon(
                        CupertinoIcons.xmark,
                        color: AppColors.lavenderGray,
                        size: 18.sp,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                verticalSpacing(20),
                Text(
                  "Topic / Category",
                  style: AppStyles.font16LavenderGray.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.lavenderGray,
                  ),
                ),
                verticalSpacing(10),
                GenreChipPicker(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
                verticalSpacing(20),
                Text(
                  "Question (Front)",
                  style: AppStyles.font16LavenderGray.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.lavenderGray,
                  ),
                ),
                verticalSpacing(8),
                AppTextForm(
                  controller: _questionController,
                  hint: "What do you want to remember?",
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                verticalSpacing(16),
                Text(
                  "Hint (Optional)",
                  style: AppStyles.font16LavenderGray.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.lavenderGray,
                  ),
                ),
                verticalSpacing(8),
                AppTextForm(
                  controller: _hintController,
                  hint: "Enter a helpful hint...",
                  maxLines: 2,
                ),
                verticalSpacing(16),
                Text(
                  "Answer (Back)",
                  style: AppStyles.font16LavenderGray.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.lavenderGray,
                  ),
                ),
                verticalSpacing(8),
                AppTextForm(
                  controller: _answerController,
                  hint: "Enter the answer...",
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an answer';
                    }
                    return null;
                  },
                ),
                verticalSpacing(28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: _saveCard,
                    child: Text(
                      "Save Card",
                      style: AppStyles.font17WhiteBold.copyWith(
                        color: AppColors.darkBackground,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
