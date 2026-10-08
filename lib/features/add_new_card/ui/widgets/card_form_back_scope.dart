import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class CardFormBackScope extends StatelessWidget {
  final TextEditingController questionController;
  final TextEditingController hintController;
  final TextEditingController answerController;
  final Widget child;

  const CardFormBackScope({
    super.key,
    required this.questionController,
    required this.hintController,
    required this.answerController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (questionController.text.isNotEmpty ||
            hintController.text.isNotEmpty ||
            answerController.text.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.darkBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                "Discard changes?",
                style: AppStyles.font24BoldIndigoAccentManrope.copyWith(
                  fontSize: 18.sp,
                ),
              ),
              content: Text(
                "You have unsaved changes. Are you sure?",
                style: AppStyles.font16LavenderGray.copyWith(fontSize: 14.sp),
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    "Keep Editing",
                    style: AppStyles.font16LavenderGray,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pop();
                    context.pop();
                  },
                  child: Text(
                    "Discard",
                    style: AppStyles.font14WhiteSemiBold.copyWith(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          context.pop();
        }
      },
      child: child,
    );
  }
}
