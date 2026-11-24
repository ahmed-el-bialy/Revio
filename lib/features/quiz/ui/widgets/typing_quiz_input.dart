import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_buttons.dart';

class TypingQuizInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isAnswered;
  final VoidCallback onSubmit;
  final VoidCallback onSkip;

  const TypingQuizInput({
    super.key,
    required this.controller,
    required this.isAnswered,
    required this.onSubmit,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          readOnly: isAnswered,
          textInputAction: TextInputAction.done,
          style: AppStyles.font16WhiteSemiBold,
          decoration: InputDecoration(
            hintText: isAnswered ? 'Answer submitted' : 'Type your answer...',
            hintStyle: AppStyles.font14White70,
            filled: true,
            fillColor: AppColors.oceanBlue.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: AppColors.primaryCyan,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
          onSubmitted: (_) {
            if (!isAnswered) onSubmit();
          },
        ),
        verticalSpacing(12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppButton.primary(
                label: 'Check answer',
                onPressed: isAnswered ? null : onSubmit,
              ),
            ),
            horizontalSpacing(10),
            Expanded(
              child: AppButton.secondary(
                label: 'Skip',
                onPressed: isAnswered ? null : onSkip,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
