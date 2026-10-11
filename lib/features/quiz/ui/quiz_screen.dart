import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../cards/data/models/card_model.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import '../logic/quiz_cubit.dart';
import '../logic/quiz_state.dart';
import 'quiz_results_screen.dart';
import 'widgets/quiz_exit_dialog.dart';
import 'widgets/quiz_in_progress_view.dart';
import 'widgets/quiz_mode_selection_view.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  void _startQuiz(BuildContext context, QuizMode mode, List<CardModel> cards) {
    context.read<QuizCubit>().emitStartQuiz(
          List.from(cards),
          mode: mode,
        );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundGlow(
      variant: GlowVariant.quiz,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final quizState = context.read<QuizCubit>().state;
          if (quizState is QuizInProgress) {
            final confirm = await QuizExitDialog.show(context);
            if (confirm == true && context.mounted) {
              context.read<QuizCubit>().emitShowModeSelection();
            }
          } else {
            context.pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocListener<QuizCubit, QuizState>(
            listener: (context, state) async {
              if (state is QuizCompleted) {
                await context.pushNamed(
                  AppConstants.quizResultsScreen,
                  QuizResultsArguments(
                    totalCards: state.totalCards,
                    correctCount: state.correctCount,
                    wrongCount: state.wrongCount,
                    skippedCount: state.skippedCount,
                    timeTaken: state.timeTaken,
                  ),
                );
                if (!context.mounted) return;
                context.read<QuizCubit>().emitShowModeSelection();
              }
            },
            child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
              builder: (context, cardsState) {
                return BlocBuilder<QuizCubit, QuizState>(
                  builder: (context, quizState) {
                    if (quizState is QuizModeSelection) {
                      final cards = cardsState is CardsLoadedSuccess
                          ? cardsState.cards
                          : <CardModel>[];
                      return QuizModeSelectionView(
                        cards: cards,
                        onSelectMode: (mode) => _startQuiz(context, mode, cards),
                      );
                    }

                    if (quizState is QuizInProgress) {
                      return QuizInProgressView(state: quizState);
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
