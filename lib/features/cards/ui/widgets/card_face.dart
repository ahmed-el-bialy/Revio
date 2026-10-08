import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/cards/data/models/card_model.dart';
import 'package:code_alpha_flash_card_app/features/cards/data/repo/cards_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../features/review/logic/delete_card/delete_card_cubit.dart';
import '../../../../features/review/logic/edit_card/edit_card_cubit.dart';
import '../../../../features/review/ui/widgets/edit_card_bottom_sheet.dart';
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
    final bool shouldDisplayHint = isFront &&
        cardModel.hint != null &&
        cardModel.hint!.trim().isNotEmpty &&
        (!isInQuiz || (isInQuiz && showHint));

    final isFav = cardModel.isFavorite ?? false;
    final cat = cardModel.category;
    final catColor =
        AppColors.categoryColors[cat] ?? AppColors.primaryTeal;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(24.r),
            border: isFront
                ? Border.all(
                    color: isFav
                        ? AppColors.softAmber.withValues(alpha: 0.5)
                        : AppColors.white.withValues(alpha: 0.06),
                    width: isFav ? 1.5 : 1,
                  )
                : Border.all(
                    color: AppColors.primaryTeal.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
            boxShadow: [
              BoxShadow(
                color: isFront
                    ? AppColors.darkBackground.withValues(alpha: 0.4)
                    : AppColors.primaryTeal.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (cat != null && cat.isNotEmpty) ...[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: catColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        cat,
                        style: AppStyles.font11GrayRegular.copyWith(
                          color: catColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    verticalSpacing(10),
                  ],
                  Text(
                    isFront ? cardModel.front : cardModel.back,
                    style: AppStyles.font18WhiteMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (shouldDisplayHint) ...[
                    verticalSpacing(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.lightbulb,
                            color: AppColors.softAmber, size: 14.sp),
                        horizontalSpacing(4),
                        Flexible(
                          child: Text(
                            cardModel.hint!,
                            style: AppStyles.font14AccentCyan.copyWith(
                              color: AppColors.softAmber,
                              fontSize: 13.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // Action buttons — review mode only, front face only
        if (!isInQuiz && isFront) ...[
          Positioned(
            top: 10.h,
            left: 10.w,
            child: Row(
              children: [
                _ActionIcon(
                  icon: isFav
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: isFav
                      ? AppColors.softAmber
                      : AppColors.lavenderGray,
                  onPressed: () =>
                      CardsRepo().toggleFavorite(cardModel.id),
                ),
                horizontalSpacing(6),
                _ActionIcon(
                  icon: CupertinoIcons.pencil,
                  color: AppColors.primaryTeal,
                  onPressed: () {
                    final editCubit = context.read<EditCardCubit>();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppColors.darkBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28.r),
                        ),
                      ),
                      builder: (_) => EditCardBottomSheet(
                        cardModel: cardModel,
                        onCardUpdated: (updated) =>
                            editCubit.emitUpdateCard(updated),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 10.h,
            right: 10.w,
            child: _ActionIcon(
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
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(7.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          icon,
          color: color.withValues(alpha: 0.85),
          size: 16.sp,
        ),
      ),
    );
  }
}
