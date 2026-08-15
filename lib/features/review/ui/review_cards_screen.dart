import 'package:code_alpha_flash_card_app/core/helpers/snackbar_helper.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_cubit.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_state.dart';
import 'package:code_alpha_flash_card_app/features/cards/ui/widgets/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../logic/delete_card/delete_card_cubit.dart';
import '../logic/delete_card/delete_card_state.dart';
import '../logic/edit_card/edit_card_cubit.dart';
import '../logic/edit_card/edit_card_state.dart';

class ReviewCardsScreen extends StatelessWidget {
  const ReviewCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          "Manage Library",
          style: AppStyles.font18BoldIndigoAccent,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.indigoAccent),
      ),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<DeleteCardCubit, DeleteCardState>(
              listener: (context, state) {
                if (state is DeleteCardSuccess) {
                  SnackBarHelper.showSuccess(
                      context, "Card deleted successfully");
                } else if (state is DeleteCardError) {
                  SnackBarHelper.showError(context, state.error);
                }
              },
            ),
            BlocListener<EditCardCubit, EditCardState>(
              listener: (context, state) {
                if (state is EditCardSuccess) {
                  SnackBarHelper.showSuccess(
                      context, "Card updated successfully");
                } else if (state is EditCardError) {
                  SnackBarHelper.showError(context, state.error);
                }
              },
            ),
          ],
          child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
            builder: (context, state) {
              if (state is CardsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.indigoAccent,
                  ),
                );
              }

              if (state is CardsLoadedSuccess) {
                final cardsList = state.cards;

                return Column(
                  children: [
                    if (cardsList.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                        child: Row(
                          children: [
                            Text(
                              "Total: ${cardsList.length} cards",
                              style: AppStyles.font14White70,
                            ),
                            const Spacer(),
                            Text(
                              "Flip to see answer",
                              style: AppStyles.font12LavenderGrayFaded,
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: cardsList.isEmpty
                          ? Center(
                              child: Text(
                                "No cards found! Add some cards first.",
                                style: AppStyles.font16LavenderGray,
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
                              itemCount: cardsList.length,
                              itemBuilder: (context, index) {
                                final cardModel = cardsList[index];

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  child: FlashCard(cardModel: cardModel, isInQuiz: false),
                                );
                              },
                            ),
                    ),
                  ],
                );
              }

              if (state is CardsError) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: AppStyles.font16LavenderGray.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
