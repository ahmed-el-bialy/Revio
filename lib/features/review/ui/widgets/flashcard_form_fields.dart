import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/genre_chip_picker.dart';
import '../../../add_new_card/ui/widgets/app_text_form.dart';

class FlashcardFormFields extends StatelessWidget {
  final TextEditingController questionController;
  final TextEditingController hintController;
  final TextEditingController answerController;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  const FlashcardFormFields({
    super.key,
    required this.questionController,
    required this.hintController,
    required this.answerController,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          selectedCategory: selectedCategory,
          onCategorySelected: onCategorySelected,
          horizontalPadding: 0,
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
          controller: questionController,
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
          controller: hintController,
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
          controller: answerController,
          hint: "Enter the answer...",
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter an answer';
            }
            return null;
          },
        ),
        verticalSpacing(24),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onFavoriteChanged(!isFavorite),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isFavorite
                    ? AppColors.primaryCyan
                    : AppColors.white.withValues(alpha: 0.08),
                width: isFavorite ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? AppColors.primaryCyan.withValues(alpha: 0.15)
                        : AppColors.cardSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: isFavorite
                        ? AppColors.primaryCyan
                        : AppColors.lavenderGray,
                    size: 18.sp,
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mark as Favorite",
                        style: AppStyles.font16WhiteSemiBold.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      verticalSpacing(2),
                      Text(
                        "Add this card to your favorites list instantly",
                        style: AppStyles.font13GrayMedium.copyWith(
                          color: AppColors.lavenderGray,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: isFavorite,
                  activeTrackColor: AppColors.primaryCyan,
                  onChanged: onFavoriteChanged,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
