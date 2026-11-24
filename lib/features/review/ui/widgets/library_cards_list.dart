import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../cards/data/models/card_model.dart';
import '../../../cards/ui/widgets/confirm_message.dart';
import '../../logic/delete_card/delete_card_cubit.dart';
import '../../logic/edit_card/edit_card_cubit.dart';
import 'edit_card_bottom_sheet.dart';
import 'library_card_tile.dart';
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
          child: LibraryCardTile(
            cardModel: cardModel,
            onTap: () {
              AppSheet.show(
                context,
                builder: (_) => EditCardBottomSheet(
                  cardModel: cardModel,
                  onCardUpdated: (updated) =>
                      editCardCubitMethod(editCubit, updated),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void editCardCubitMethod(EditCardCubit editCubit, CardModel updated) {
    editCubit.emitUpdateCard(updated);
  }
}
