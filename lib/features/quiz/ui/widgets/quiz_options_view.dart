import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/press_scale_widget.dart';

class QuizOptionsView extends StatelessWidget {
  final List<String> options;
  final String correctAnswer;
  final String? selectedOption;
  final bool isAnswered;
  final void Function(String option) onOptionSelected;
  final VoidCallback onSkip;

  const QuizOptionsView({
    super.key,
    required this.options,
    required this.correctAnswer,
    required this.selectedOption,
    required this.isAnswered,
    required this.onOptionSelected,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(options.length, (index) {
          final option = options[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
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
        if (!isAnswered)
          AppSkipLink(onSkip: onSkip)
        else
          verticalSpacing(8),
      ],
    );
  }

  String _optionLabel(int index) {
    const labels = ['A', 'B', 'C', 'D'];
    return index < labels.length ? labels[index] : '${index + 1}';
  }
}

class AppSkipLink extends StatelessWidget {
  final VoidCallback onSkip;

  const AppSkipLink({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSkip,
      child: Text(
        'Skip this card',
        style: AppStyles.font13GrayMedium.copyWith(
          color: AppColors.lavenderGray,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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
    if (!isAnswered) return AppColors.primaryCyan;
    if (isCorrect) return AppColors.success;
    if (isSelected && !isCorrect) return AppColors.errorRed;
    return AppColors.gray;
  }

  Color _getFillColor() {
    if (!isAnswered) return AppColors.cardSurface;
    if (isCorrect) return AppColors.success.withValues(alpha: 0.12);
    if (isSelected && !isCorrect) {
      return AppColors.errorRed.withValues(alpha: 0.12);
    }
    return AppColors.surfaceDark;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();
    final fillColor = _getFillColor();
    final showResult = isAnswered && (isCorrect || isSelected);

    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      constraints: BoxConstraints(minHeight: 52.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isAnswered && (isCorrect || isSelected)
              ? accentColor.withValues(alpha: 0.65)
              : AppColors.gray.withValues(alpha: 0.18),
          width: showResult ? 1.6 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: showResult && isCorrect
                ? Icon(Icons.check_rounded, color: AppColors.success, size: 16.sp)
                : showResult && isSelected && !isCorrect
                    ? Icon(
                        Icons.close_rounded,
                        color: AppColors.errorRed,
                        size: 16.sp,
                      )
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
                fontWeight: isCorrect ? FontWeight.w700 : FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );

    if (isAnswered) return tile;
    return PressScale(onTap: onTap, child: tile);
  }
}
