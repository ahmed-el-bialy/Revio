import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/cards/data/models/card_model.dart';
import 'package:code_alpha_flash_card_app/features/cards/data/repo/cards_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final bool shouldDisplayHint =
        isFront &&
        cardModel.hint != null &&
        cardModel.hint!.trim().isNotEmpty &&
        (!isInQuiz || (isInQuiz && showHint));

    final isFav = cardModel.isFavorite ?? false;
    final cat = cardModel.category;
    final catColor = AppColors.categoryColors[cat] ?? AppColors.indigoAccent;

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
                    color: isFav
                        ? AppColors.softAmber.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.05),
                    width: isFav ? 1.5 : 1,
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
              if (cat != null && cat.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    cat,
                    style: AppStyles.font11GrayRegular.copyWith(
                      color: catColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],

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

        if (!isInQuiz && isFront) ...[
          Positioned(
            top: 12.h,
            left: 12.w,
            child: Row(
              children: [
                _buildActionIcon(
                  icon: isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: isFav ? AppColors.softAmber : AppColors.lavenderGray,
                  onPressed: () {
                    CardsRepo().toggleFavorite(cardModel.id);
                  },
                ),
                SizedBox(width: 6.w),
                _buildActionIcon(
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
              ],
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
