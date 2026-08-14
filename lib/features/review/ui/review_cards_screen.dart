import 'package:code_alpha_flash_card_app/core/helpers/snackbar_helper.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/core/widgets/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/logic/get_all_cards_cubit.dart';
import '../../../core/logic/get_all_cards_state.dart';
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
        elevation: 1,
        backgroundColor: Colors.transparent,
        title: Text(
          "Review Cards",
          style: AppStyles.font19BoldIndigoAccent,
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

                if (cardsList.isEmpty) {
                  return Center(
                    child: Text(
                      "No cards found! Add some cards first.",
                      style: AppStyles.font16LavenderGray,
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: cardsList.length,
                  itemBuilder: (context, index) {
                    final cardModel = cardsList[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      child: FlashCard(cardModel: cardModel, isInQuiz: false),
                    );
                  },
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
