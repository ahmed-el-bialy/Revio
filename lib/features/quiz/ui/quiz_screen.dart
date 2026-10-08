import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/routing_extension.dart';
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
  int? _lastIndex;

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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final quizState = context.read<QuizCubit>().state;
          if (quizState is QuizInProgress) {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.cardSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                title: Text(
                  "Exit Quiz?",
                  style: AppStyles.font18BoldIndigoAccent
                      .copyWith(color: AppColors.white),
                ),
                content: Text(
                  "Your current progress will be lost.",
                  style: AppStyles.font14White70,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text("Cancel", style: AppStyles.font14Gray),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text("Exit", style: AppStyles.font14WhiteSemiBold),
                  ),
                ],
              ),
            );
            if (confirm == true && context.mounted) {
              context.read<QuizCubit>().emitShowModeSelection();
            }
          } else {
            Navigator.pop(context);
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
                // Always return to mode selection after completing the quiz.
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
      ),
    );
  }

  Widget _buildQuizInProgress(QuizInProgress state) {
    if (_lastIndex != state.currentIndex) {
      _lastIndex = state.currentIndex;
      _isHintVisible = false;
    }

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
                        setState(() => _isHintVisible = false);
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
          horizontalSpacing(8),
          GestureDetector(
            onTap: () => context.read<QuizCubit>().emitAdvanceNext(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Next",
                    style: AppStyles.font12White38.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  horizontalSpacing(4),
                  Icon(
                    CupertinoIcons.arrow_right,
                    color: AppColors.white,
                    size: 12.sp,
                  ),
                ],
              ),
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
