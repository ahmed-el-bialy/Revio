import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../cards/data/models/card_model.dart';
import '../../../cards/data/repo/cards_repo.dart';
import '../../../cards/ui/widgets/confirm_message.dart';
import '../../logic/delete_card/delete_card_cubit.dart';
import '../../logic/edit_card/edit_card_cubit.dart';
import 'edit_card_bottom_sheet.dart';
import 'library_empty_state.dart';

class LibraryCardsList extends StatelessWidget {
  final List<CardModel> filteredCards;
  final bool hasCardsOverall;

  const LibraryCardsList({
    super.key,
    required this.filteredCards,
    required this.hasCardsOverall,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredCards.isEmpty) {
      return LibraryEmptyState(hasCardsOverall: hasCardsOverall);
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: filteredCards.length,
      itemBuilder: (context, index) {
        final cardModel = filteredCards[index];
        final deleteCubit = context.read<DeleteCardCubit>();
        final editCubit = context.read<EditCardCubit>();

        return Dismissible(
          key: Key(cardModel.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return ConfirmMessage.show(
              context,
              deleteCubit: deleteCubit,
              cardModel: cardModel,
            );
          },
          background: Container(
            margin: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.errorRed.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.errorRed),
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Delete",
                  style: AppStyles.font14WhiteSemiBold.copyWith(
                    color: AppColors.errorRed,
                  ),
                ),
                horizontalSpacing(8),
                Icon(
                  CupertinoIcons.trash,
                  color: AppColors.errorRed,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          onDismissed: (_) {},
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: AppCard(
              borderRadius: 16,
              borderColor: AppColors.white.withValues(alpha: 0.08),
              padding: EdgeInsets.all(14.w),
              onTap: () {
                AppSheet.show(
                  context,
                  builder: (_) => EditCardBottomSheet(
                    cardModel: cardModel,
                    onCardUpdated: (updated) =>
                        editCubit.emitUpdateCard(updated),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Favorite indicator / Icon
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => CardsRepo().toggleFavorite(cardModel.id),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: (cardModel.isFavorite ?? false)
                            ? AppColors.primaryCyan.withValues(alpha: 0.15)
                            : AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        (cardModel.isFavorite ?? false)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: (cardModel.isFavorite ?? false)
                            ? AppColors.primaryCyan
                            : AppColors.lavenderGray,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  horizontalSpacing(14),
                  // Content: Question & Answer preview + Topic badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryCyan.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                cardModel.category ?? "General",
                                style: AppStyles.font11GrayRegular.copyWith(
                                  color: AppColors.primaryCyan,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpacing(6),
                        Text(
                          cardModel.front,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.font16WhiteSemiBold.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        verticalSpacing(2),
                        Text(
                          cardModel.back,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.font13GrayMedium.copyWith(
                            color: AppColors.lavenderGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalSpacing(8),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: AppColors.lavenderGray.withValues(alpha: 0.5),
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
