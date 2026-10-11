import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class QuizExitDialog extends StatelessWidget {
  const QuizExitDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => const QuizExitDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      title: Text(
        "Exit Quiz?",
        style: AppStyles.font18BoldIndigoAccent.copyWith(color: AppColors.white),
      ),
      content: Text(
        "Your current progress will be lost.",
        style: AppStyles.font14White70,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text("Cancel", style: AppStyles.font14Gray),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: () => context.pop(true),
          child: Text("Exit", style: AppStyles.font14WhiteSemiBold),
        ),
      ],
    );
  }
}
