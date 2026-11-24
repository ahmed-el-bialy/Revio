import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  const FlashcardFormFields({
    super.key,
    required this.questionController,
    required this.hintController,
    required this.answerController,
    required this.selectedCategory,
    required this.onCategorySelected,
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
      ],
    );
  }
}
