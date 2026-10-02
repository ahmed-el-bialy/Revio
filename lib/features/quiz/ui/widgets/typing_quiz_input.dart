import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

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
          enabled: !isAnswered,
          style: AppStyles.font16WhiteSemiBold,
          decoration: InputDecoration(
            hintText: isAnswered ? "Answer submitted" : "Type your answer...",
            hintStyle: AppStyles.font14White70,
            filled: true,
            fillColor: AppColors.oceanBlue.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide:
                  const BorderSide(color: AppColors.primaryTeal, width: 1.5),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
          onSubmitted: (_) => onSubmit(),
        ),
        verticalSpacing(12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isAnswered ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  disabledBackgroundColor:
                      AppColors.gray.withValues(alpha: 0.2),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    color: AppColors.darkBackground,
                  ),
                ),
              ),
            ),
            horizontalSpacing(10),
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: isAnswered ? null : onSkip,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.lavenderGray.withValues(alpha: 0.25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text("Skip", style: AppStyles.font14White70),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
