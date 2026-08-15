import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/cards/data/models/card_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../features/review/logic/delete_card/delete_card_cubit.dart';

class ConfirmMessage extends StatelessWidget {
  const ConfirmMessage({
    super.key,
    required this.deleteCubit,
    required this.cardModel,
  });

  final DeleteCardCubit deleteCubit;
  final CardModel cardModel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkBackground,
      elevation: 10,
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              color: AppColors.error,
              size: 40.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              "Delete Card",
              style: AppStyles.font17WhiteBold.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              "Are you sure you want to delete this card? This action cannot be undone.",
              style: AppStyles.font14White70,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: AppColors.gray.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: AppStyles.font14Gray.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      deleteCubit.emitDeleteCard(cardModel.id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.2),
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      "Delete",
                      style: AppStyles.font14WhiteSemiBold.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
