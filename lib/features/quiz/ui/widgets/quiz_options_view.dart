import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class QuizOptionsView extends StatelessWidget {
  final List<String> options;
  final String correctAnswer;
  final String? selectedOption;
  final bool isAnswered;
  final void Function(String option) onOptionSelected;

  const QuizOptionsView({
    super.key,
    required this.options,
    required this.correctAnswer,
    required this.selectedOption,
    required this.isAnswered,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(options.length, (index) {
        final option = options[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _OptionTile(
            option: option,
            label: _optionLabel(index),
            isCorrect: option == correctAnswer,
            isSelected: option == selectedOption,
            isAnswered: isAnswered,
            onTap: () => onOptionSelected(option),
          ),
        );
      }),
    );
  }

  String _optionLabel(int index) {
    const labels = ['A', 'B', 'C', 'D'];
    return index < labels.length ? labels[index] : '${index + 1}';
  }
}

class _OptionTile extends StatelessWidget {
  final String option;
  final String label;
  final bool isCorrect;
  final bool isSelected;
  final bool isAnswered;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.label,
    required this.isCorrect,
    required this.isSelected,
    required this.isAnswered,
    required this.onTap,
  });

  Color _getAccentColor() {
    if (!isAnswered) return AppColors.primaryTeal;
    if (isCorrect) return AppColors.success;
    if (isSelected && !isCorrect) return AppColors.errorRed;
    return AppColors.gray;
  }

  Color _getFillColor() {
    if (!isAnswered) {
      return AppColors.cardSurface;
    }
    if (isCorrect) return AppColors.success.withValues(alpha: 0.12);
    if (isSelected && !isCorrect) return AppColors.errorRed.withValues(alpha: 0.12);
    return AppColors.surfaceDark;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();
    final fillColor = _getFillColor();
    final showResult = isAnswered && (isCorrect || isSelected);

    return GestureDetector(
      onTap: isAnswered ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isAnswered && (isCorrect || isSelected)
                ? accentColor.withValues(alpha: 0.6)
                : AppColors.gray.withValues(alpha: 0.15),
            width: showResult ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: showResult && isCorrect
                  ? Icon(Icons.check_rounded,
                      color: AppColors.success, size: 16.sp)
                  : showResult && isSelected && !isCorrect
                      ? Icon(Icons.close_rounded,
                          color: AppColors.errorRed, size: 16.sp)
                      : Text(
                          label,
                          style: AppStyles.font14WhiteSemiBold.copyWith(
                            color: accentColor,
                            fontSize: 13.sp,
                          ),
                        ),
            ),
            horizontalSpacing(12),
            Expanded(
              child: Text(
                option,
                style: AppStyles.font14WhiteSemiBold.copyWith(
                  color: isAnswered && !isCorrect && !isSelected
                      ? AppColors.gray
                      : AppColors.white,
                  fontWeight: isCorrect ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13.5.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
