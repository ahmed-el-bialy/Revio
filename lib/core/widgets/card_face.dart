import 'package:code_alpha_flash_card_app/core/data/models/card_model.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/review/logic/delete_card/delete_card_cubit.dart';
import '../../features/review/logic/edit_card/edit_card_cubit.dart';
import '../../features/review/ui/widgets/edit_card_bottom_sheet.dart';
import 'confirm_message.dart';

class CardFace extends StatelessWidget {
  const CardFace({
    super.key,
    required this.cardHeight,
    required this.cardModel,
    required this.isInQuiz,
    required this.isFront,
    required this.showHint,
  });

  final double cardHeight;
  final CardModel cardModel;
  final bool isInQuiz;
  final bool isFront;
  final bool showHint;

  @override
  Widget build(BuildContext context) {
    final bool shouldDisplayHint =
        isFront &&
        cardModel.hint != null &&
        cardModel.hint!.trim().isNotEmpty &&
        (!isInQuiz || (isInQuiz && showHint));

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppColors.oceanBlue,
            gradient: LinearGradient(
              colors: [
                AppColors.oceanBlue,
                AppColors.oceanBlue.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: isFront
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  )
                : Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isFront ? cardModel.front : cardModel.back,
                style: AppStyles.font18WhiteMedium,
                textAlign: TextAlign.center,
              ),

              if (shouldDisplayHint) ...[
                SizedBox(height: 12.h),
                Text(
                  cardModel.hint!,
                  style: AppStyles.font14AccentCyan,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        // Only show Edit/Delete icons on the FRONT face and when NOT in quiz
        if (!isInQuiz && isFront) ...[
          Positioned(
            top: 12.h,
            left: 12.w,
            child: _buildActionIcon(
              icon: CupertinoIcons.pencil,
              color: AppColors.indigoAccent,
              onPressed: () {
                final editCubit = context.read<EditCardCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: AppColors.darkBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                  builder: (_) => EditCardBottomSheet(
                    cardModel: cardModel,
                    onCardUpdated: (updatedCard) {
                      editCubit.emitUpdateCard(updatedCard);
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: _buildActionIcon(
              icon: CupertinoIcons.trash,
              color: AppColors.error,
              onPressed: () {
                final deleteCubit = context.read<DeleteCardCubit>();
                showDialog(
                  context: context,
                  builder: (context) => ConfirmMessage(
                    deleteCubit: deleteCubit,
                    cardModel: cardModel,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color.withValues(alpha: 0.8),
          size: 18.sp,
        ),
      ),
    );
  }
}
