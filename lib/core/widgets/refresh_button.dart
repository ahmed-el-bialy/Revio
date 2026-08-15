import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../logic/get_all_cards_cubit.dart';
import '../theming/app_colors.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await context.read<GetAllCardsCubit>().fetchAllCards();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "Library updated successfully! ✅",
                style: TextStyle(
                  color: AppColors.indigoAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColors.indigoAccent.withValues(alpha: 0.4),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      },
      icon: Icon(
        Icons.refresh_rounded,
        color: AppColors.lavenderGray,
        size: 26.sp,
      ),
    );
  }
}
