import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class DeleteGenreDialog extends StatelessWidget {
  final String genre;

  const DeleteGenreDialog({super.key, required this.genre});

  static Future<bool?> show(BuildContext context, {required String genre}) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => DeleteGenreDialog(genre: genre),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: AppColors.errorRed.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      title: Text(
        "Delete Genre?",
        style: AppStyles.font18BoldIndigoAccent.copyWith(
          color: AppColors.white,
        ),
      ),
      content: Text(
        "All flashcards in '$genre' will be moved to 'No Topic'.",
        style: AppStyles.font14White70,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text("Cancel", style: AppStyles.font14Gray),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: () => context.pop(true),
          child: Text("Delete", style: AppStyles.font14WhiteSemiBold),
        ),
      ],
    );
  }
}
