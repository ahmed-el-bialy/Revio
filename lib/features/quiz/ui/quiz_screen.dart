import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flip_card/flip_card.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../cards/data/models/card_model.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import '../../cards/ui/widgets/flash_card.dart';
import '../logic/quiz_cubit.dart';
import '../logic/quiz_state.dart';
import 'quiz_results_screen.dart';
import 'widgets/quiz_app_bar.dart';
import 'widgets/quiz_mode_selection_view.dart';
import 'widgets/quiz_options_view.dart';
import 'widgets/quiz_progress_bar.dart';
import 'widgets/typing_quiz_input.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController _answerController = TextEditingController();
  final Map<String, GlobalKey<FlipCardState>> _flipKeys = {};
  bool _isHintVisible = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  GlobalKey<FlipCardState> _getFlipKey(String id) {
    return _flipKeys.putIfAbsent(id, () => GlobalKey<FlipCardState>());
  }

  void _startQuiz(QuizMode mode, List<CardModel> cards) {
    context.read<QuizCubit>().emitStartQuiz(
          List.from(cards),
          mode: mode,
        );
  }

  void _submitTypingAnswer(QuizInProgress state) {
    final text = _answerController.text.trim();
    if (text.isEmpty) return;
    context.read<QuizCubit>().emitSubmitAnswer(text);
    _answerController.clear();
    setState(() => _isHintVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundGlow(
      variant: GlowVariant.quiz,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<QuizCubit, QuizState>(
          listener: (context, state) {
            if (state is QuizCompleted) {
              Navigator.pushReplacementNamed(
                context,
                AppConstants.quizResultsScreen,
                arguments: QuizResultsArguments(
                  totalCards: state.totalCards,
                  correctCount: state.correctCount,
                  wrongCount: state.wrongCount,
                  skippedCount: state.skippedCount,
                  timeTaken: state.timeTaken,
                ),
              );
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
                      onSelectMode: (mode) => _startQuiz(mode, cards),
                    );
                  }

                  if (quizState is QuizInProgress) {
                    return _buildQuizInProgress(quizState);
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuizInProgress(QuizInProgress state) {
    final currentCard = state.currentCard;
    final isAnswered = state.isCurrentAnswered;

    return Column(
      children: [
        QuizAppBar(state: state),
        Expanded(
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 18.w,
                right: 18.w,
                top: 8.h,
                bottom: 50.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  QuizProgressBar(state: state),
                  verticalSpacing(12),
                  SizedBox(
                    height: 165.h,
                    child: FlashCard(
                      flipKey: _getFlipKey(currentCard.id),
                      cardModel: currentCard,
                      isInQuiz: true,
                      showHint: _isHintVisible,
                    ),
                  ),
                  verticalSpacing(12),
                  if (state.showCorrectAnswer && state.lastCorrectAnswer != null) ...[
                    _buildCorrectAnswerBanner(state.lastCorrectAnswer!),
                    verticalSpacing(10),
                  ],
                  if (state.quizMode == QuizMode.multipleChoice)
                    QuizOptionsView(
                      options: state.currentOptions ?? [],
                      correctAnswer: currentCard.back,
                      selectedOption: state.selectedOption,
                      isAnswered: isAnswered,
                      onOptionSelected: (option) {
                        if (!isAnswered) {
                          context.read<QuizCubit>().emitSubmitAnswer(option);
                        }
                      },
                    )
                  else
                    TypingQuizInput(
                      controller: _answerController,
                      isAnswered: isAnswered,
                      onSubmit: () => _submitTypingAnswer(state),
                      onSkip: () {
                        context.read<QuizCubit>().emitSkipCard();
                        _answerController.clear();
                      },
                    ),
                  verticalSpacing(10),
                  _buildHintRow(state),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorrectAnswerBanner(String answer) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.xmark_circle_fill,
            color: AppColors.error,
            size: 18.sp,
          ),
          horizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Not quite!",
                  style: AppStyles.font12LavenderGray.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpacing(2),
                Text(
                  "Answer: $answer",
                  style: AppStyles.font14WhiteSemiBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHintRow(QuizInProgress state) {
    final card = state.currentCard;
    final hasHint = card.hint != null && card.hint!.trim().isNotEmpty;
    return Center(
      child: TextButton.icon(
        onPressed: !hasHint
            ? null
            : () {
                setState(() => _isHintVisible = !_isHintVisible);
              },
        icon: Icon(
          CupertinoIcons.lightbulb,
          color: !hasHint
              ? AppColors.gray
              : (_isHintVisible
                  ? AppColors.softAmber
                  : AppColors.lavenderGray),
          size: 18.sp,
        ),
        label: Text(
          !hasHint
              ? "No hint available"
              : (_isHintVisible ? "Hide Hint" : "Show Hint"),
          style: AppStyles.font13GrayMedium.copyWith(
            color: !hasHint
                ? AppColors.gray
                : (_isHintVisible
                    ? AppColors.softAmber
                    : AppColors.lavenderGray),
          ),
        ),
      ),
    );
  }
}
