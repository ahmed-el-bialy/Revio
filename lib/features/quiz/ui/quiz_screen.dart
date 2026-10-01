import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flip_card/flip_card.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import '../../cards/ui/widgets/flash_card.dart';
import '../logic/quiz_cubit.dart';
import '../logic/quiz_state.dart';
import 'quiz_results_screen.dart';
import 'widgets/quiz_mode_selector.dart';
import 'widgets/quiz_options_view.dart';

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

  void _startQuiz(QuizMode mode, List cards) {
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
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
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
                  return _buildModeSelection(cardsState);
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
    );
  }

  Widget _buildModeSelection(GetAllCardsState cardsState) {
    final cards = cardsState is CardsLoadedSuccess ? cardsState.cards : [];

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: Icon(CupertinoIcons.back,
                      color: AppColors.lavenderGray, size: 22.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                horizontalSpacing(8),
                Text("Quiz Mode", style: AppStyles.font18BoldIndigoAccent),
              ],
            ),
            verticalSpacing(20),
            Text(
              "Choose how you\nwant to be tested",
              style: AppStyles.font24BoldIceBlueManrope.copyWith(
                fontSize: 25.sp,
                height: 1.25,
              ),
            ),
            verticalSpacing(6),
            Text(
              "${cards.length} cards ready · Pick your challenge",
              style: AppStyles.font14White70,
            ),
            verticalSpacing(24),
            QuizModeSelector(
              onSelectMode: (mode) => _startQuiz(mode, cards),
              cardCount: cards.length,
            ),
            verticalSpacing(24),
            if (cards.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(CupertinoIcons.rectangle_stack_badge_minus,
                        size: 48.sp, color: AppColors.gray),
                    verticalSpacing(10),
                    Text("No cards yet!", style: AppStyles.font18WhiteBold),
                    verticalSpacing(4),
                    Text("Add cards first to start a quiz.",
                        style: AppStyles.font14White70),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizInProgress(QuizInProgress state) {
    final currentCard = state.currentCard;
    final isAnswered = state.isCurrentAnswered;

    return Column(
      children: [
        _buildQuizAppBar(state),
        Expanded(
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 8.h, bottom: 50.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProgressRow(state),
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
                  if (state.showCorrectAnswer && state.lastCorrectAnswer != null)
                    _buildCorrectAnswerBanner(state.lastCorrectAnswer!),
                  if (state.showCorrectAnswer && state.lastCorrectAnswer != null)
                    verticalSpacing(10),
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
                    _buildTypingInput(state),
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

  Widget _buildQuizAppBar(QuizInProgress state) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            IconButton(
              onPressed: () =>
                  context.read<QuizCubit>().emitShowModeSelection(),
              icon: Icon(CupertinoIcons.back,
                  color: AppColors.lavenderGray, size: 22.sp),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            horizontalSpacing(6),
            Expanded(
              child: Text(
                state.quizMode == QuizMode.multipleChoice
                    ? "Multiple Choice"
                    : "Smart Typing",
                style: AppStyles.font18BoldIndigoAccent,
              ),
            ),
            _buildModeInfoButton(state.quizMode),
            horizontalSpacing(8),
            _buildShuffleBadge(state),
          ],
        ),
      ),
    );
  }

  Widget _buildModeInfoButton(QuizMode mode) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.cardSurface,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
            title: Row(
              children: [
                Icon(
                  mode == QuizMode.multipleChoice
                      ? CupertinoIcons.list_bullet
                      : CupertinoIcons.keyboard,
                  color: AppColors.primaryTeal,
                  size: 22.sp,
                ),
                horizontalSpacing(10),
                Text(
                  mode == QuizMode.multipleChoice
                      ? "Multiple Choice"
                      : "Smart Typing",
                  style: AppStyles.font16WhiteSemiBold,
                ),
              ],
            ),
            content: Text(
              mode == QuizMode.multipleChoice
                  ? "Tap the correct answer from 4 options. One attempt per card — choose wisely!"
                  : "Type your answer. Minor typos and short forms are accepted. You have one attempt per card.",
              style: AppStyles.font14White70,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Got it!", style: AppStyles.font15IndigoAccentSemiBold),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
              color: AppColors.primaryTeal.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.info_circle,
                color: AppColors.primaryTeal, size: 14.sp),
            horizontalSpacing(4),
            Text(
              _modeBadgeLabel(mode),
              style: AppStyles.font11GrayRegular.copyWith(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _modeBadgeLabel(QuizMode mode) {
    return mode == QuizMode.multipleChoice ? "MCQ Mode" : "Typing Mode";
  }

  Widget _buildShuffleBadge(QuizInProgress state) {
    return GestureDetector(
      onTap: () => context.read<QuizCubit>().emitToggleShuffle(),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: state.isShuffled
              ? AppColors.emeraldGold.withValues(alpha: 0.15)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: state.isShuffled
                ? AppColors.emeraldGold.withValues(alpha: 0.4)
                : AppColors.gray.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          CupertinoIcons.shuffle,
          color:
              state.isShuffled ? AppColors.emeraldGold : AppColors.gray,
          size: 16.sp,
        ),
      ),
    );
  }

  Widget _buildProgressRow(QuizInProgress state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildScoreBadge(
                Icons.check_circle_outline, AppColors.success,
                "${state.correctCount} correct"),
            Text(
              "${state.currentIndex + 1} / ${state.cards.length}",
              style: AppStyles.font14WhiteSemiBold,
            ),
            _buildScoreBadge(
                Icons.cancel_outlined, AppColors.errorRed,
                "${state.wrongCount} wrong"),
          ],
        ),
        verticalSpacing(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: (state.currentIndex + 1) / state.cards.length,
            backgroundColor: AppColors.oceanBlue,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
            minHeight: 6.h,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBadge(IconData icon, Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          horizontalSpacing(5),
          Text(
            label,
            style: AppStyles.font12LavenderGray.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
          Icon(CupertinoIcons.xmark_circle_fill,
              color: AppColors.error, size: 18.sp),
          horizontalSpacing(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Not quite!",
                    style: AppStyles.font12LavenderGray.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    )),
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

  Widget _buildTypingInput(QuizInProgress state) {
    final isAnswered = state.isCurrentAnswered;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _answerController,
          enabled: !isAnswered,
          style: AppStyles.font16WhiteSemiBold,
          decoration: InputDecoration(
            hintText: isAnswered ? "Answer submitted" : "Type your answer...",
            hintStyle: AppStyles.font14White70,
            filled: true,
            fillColor: AppColors.oceanBlue.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide:
                  const BorderSide(color: AppColors.primaryTeal, width: 1.5),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
          onSubmitted: (_) => _submitTypingAnswer(state),
        ),
        verticalSpacing(12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed:
                    isAnswered ? null : () => _submitTypingAnswer(state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  disabledBackgroundColor:
                      AppColors.gray.withValues(alpha: 0.2),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    color: AppColors.darkBackground,
                  ),
                ),
              ),
            ),
            horizontalSpacing(10),
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: isAnswered
                    ? null
                    : () {
                        context.read<QuizCubit>().emitSkipCard();
                        _answerController.clear();
                      },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.lavenderGray.withValues(alpha: 0.25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text("Skip", style: AppStyles.font14White70),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHintRow(QuizInProgress state) {
    final card = state.currentCard;
    final hasHint =
        card.hint != null && card.hint!.trim().isNotEmpty;
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
