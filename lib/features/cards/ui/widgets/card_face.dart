import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_glass_container.dart';
import '../../../../features/review/logic/delete_card/delete_card_cubit.dart';
import '../../../../features/review/logic/edit_card/edit_card_cubit.dart';
import '../../../../features/review/ui/widgets/edit_card_bottom_sheet.dart';
import '../../data/models/card_model.dart';
import '../../data/repo/cards_repo.dart';
import 'card_action_icon.dart';
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
    final catColor = AppColors.categoryColors[cat] ?? AppColors.primaryTeal;
    final accentColor = isFront
        ? (isFav ? AppColors.softAmber : AppColors.primaryTeal)
        : AppColors.cyberCyan;

    final semanticsLabel = isFront
        ? "Flashcard Front: ${cardModel.front}${cat != null ? ', Category $cat' : ''}"
        : "Flashcard Back: ${cardModel.back}";

    return Semantics(
      label: semanticsLabel,
      hint: shouldDisplayHint ? "Hint: ${cardModel.hint}" : null,
      child: Stack(
        children: [
          AppGlassContainer(
            width: double.infinity,
            height: cardHeight,
            accentColor: accentColor,
            borderRadius: 24,
            borderOpacity: isFront ? (isFav ? 0.6 : 0.3) : 0.45,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: catColor.withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: catColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: catColor.withValues(alpha: 0.6),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            horizontalSpacing(6),
                            Text(
                              cat,
                              style: AppStyles.font11GrayRegular.copyWith(
                                color: catColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpacing(12),
                    ],
                    Text(
                      isFront ? cardModel.front : cardModel.back,
                      style: AppStyles.font18WhiteMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (shouldDisplayHint) ...[
                      verticalSpacing(14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.lightbulb_fill,
                            color: AppColors.softAmber,
                            size: 15.sp,
                          ),
                          horizontalSpacing(5),
                          Flexible(
                            child: Text(
                              cardModel.hint!,
                              style: AppStyles.font14AccentCyan.copyWith(
                                color: AppColors.softAmber,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
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
                  CardActionIcon(
                    icon: isFav
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: isFav
                        ? AppColors.favoriteColor
                        : AppColors.lavenderGray,
                    tooltip: isFav ? "Remove from favorites" : "Add to favorites",
                    onPressed: () => CardsRepo().toggleFavorite(cardModel.id),
                  ),
                  horizontalSpacing(4),
                  CardActionIcon(
                    icon: CupertinoIcons.pencil,
                    color: AppColors.primaryTeal,
                    tooltip: "Edit card",
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
              child: CardActionIcon(
                icon: CupertinoIcons.trash,
                color: AppColors.error,
                tooltip: "Delete card",
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
      ),
    );
  }
}
