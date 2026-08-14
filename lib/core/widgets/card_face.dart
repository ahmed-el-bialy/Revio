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
            borderRadius: BorderRadius.circular(24.r),
            border: isFront
                ? null
                : Border.all(
                    color: AppColors.accentCyan.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
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
        if (!isInQuiz) ...[
          Positioned(
            top: 8.h,
            left: 8.w,
            child: IconButton(
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
              icon: Icon(
                CupertinoIcons.pencil_circle_fill,
                color: AppColors.indigoAccentTransparent(0.8),
                size: 26.sp,
              ),
            ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: IconButton(
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
              icon: Icon(
                CupertinoIcons.trash_circle_fill,
                color: AppColors.error.withValues(alpha: 0.8),
                size: 26.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
