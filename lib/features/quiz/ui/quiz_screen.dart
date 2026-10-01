import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flip_card/flip_card.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/snackbar_helper.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import '../../cards/ui/widgets/flash_card.dart';
import '../logic/quiz_cubit.dart';
import '../logic/quiz_state.dart';
import 'quiz_results_screen.dart';

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
  void initState() {
    super.initState();
    final cardsState = context.read<GetAllCardsCubit>().state;
    if (cardsState is CardsLoadedSuccess) {
      context.read<QuizCubit>().emitStartQuiz(cardsState.cards);
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  GlobalKey<FlipCardState> _getFlipKey(String id) {
    return _flipKeys.putIfAbsent(id, () => GlobalKey<FlipCardState>());
  }

  void _submitAnswer() {
    final text = _answerController.text;
    if (text.trim().isEmpty) {
      SnackBarHelper.showInfo(context, "Please enter an answer first!");
      return;
    }
    context.read<QuizCubit>().emitSubmitAnswer(text);
    _answerController.clear();
    setState(() {
      _isHintVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Quiz Mode",
          style: AppStyles.font18BoldIndigoAccent,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              if (state is QuizInProgress) {
                return IconButton(
                  icon: Icon(
                    CupertinoIcons.shuffle,
                    color: state.isShuffled ? AppColors.accentCyan : AppColors.gray,
                  ),
                  tooltip: "Shuffle Cards",
                  onPressed: () {
                    context.read<QuizCubit>().emitStartQuiz(
                          state.cards,
                          shuffle: !state.isShuffled,
                        );
                    SnackBarHelper.showInfo(
                      context,
                      state.isShuffled ? "Normal order restored" : "Cards shuffled!",
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
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
            if (cardsState is CardsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.indigoAccent),
              );
            }

            if (cardsState is CardsLoadedSuccess && cardsState.cards.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.rectangle_stack_badge_minus,
                          size: 64.sp, color: AppColors.lavenderGray),
                      SizedBox(height: 16.h),
                      Text("No Cards Available", style: AppStyles.font20BoldWhite),
                      SizedBox(height: 8.h),
                      Text(
                        "Add some cards first to start a quiz!",
                        style: AppStyles.font14White70,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return BlocBuilder<QuizCubit, QuizState>(
              builder: (context, quizState) {
                if (quizState is! QuizInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.indigoAccent),
                  );
                }

                final currentCard = quizState.cards[quizState.currentIndex];
                final isAnswered = quizState.answeredCardIds.contains(currentCard.id);

                return SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                    color: AppColors.success.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      color: AppColors.success, size: 16.sp),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Score: ${quizState.correctCount}",
                                    style: AppStyles.font14WhiteSemiBold
                                        .copyWith(color: AppColors.success),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Card ${quizState.currentIndex + 1} of ${quizState.cards.length}",
                              style: AppStyles.font14WhiteSemiBold,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: (quizState.currentIndex + 1) / quizState.cards.length,
                            backgroundColor: AppColors.oceanBlue,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.indigoAccent),
                            minHeight: 6.h,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        SizedBox(
                          height: 240.h,
                          child: FlashCard(
                            flipKey: _getFlipKey(currentCard.id),
                            cardModel: currentCard,
                            isInQuiz: true,
                            showHint: _isHintVisible,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        if (quizState.showCorrectAnswer && quizState.lastCorrectAnswer != null) ...[
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.xmark_circle,
                                        color: AppColors.error, size: 18.sp),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "Not quite right!",
                                      style: AppStyles.font14WhiteSemiBold
                                          .copyWith(color: AppColors.error),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Correct answer: ${quizState.lastCorrectAnswer}",
                                  style: AppStyles.font14WhiteSemiBold,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],

                        TextField(
                          controller: _answerController,
                          enabled: !isAnswered,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: isAnswered ? "Answer submitted" : "Type your answer...",
                            hintStyle: AppStyles.font14White70,
                            filled: true,
                            fillColor: AppColors.oceanBlue.withValues(alpha: 0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: AppColors.indigoAccent),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                          onSubmitted: (_) => _submitAnswer(),
                        ),
                        SizedBox(height: 16.h),

                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: isAnswered ? null : _submitAnswer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.indigoAccent,
                                  disabledBackgroundColor: AppColors.gray.withValues(alpha: 0.3),
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  "Submit Answer",
                                  style: AppStyles.font14WhiteSemiBold
                                      .copyWith(fontSize: 15.sp),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
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
                                      color: AppColors.lavenderGray.withValues(alpha: 0.3)),
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  "Skip",
                                  style: AppStyles.font14White70,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              if (currentCard.hint != null &&
                                  currentCard.hint!.trim().isNotEmpty) {
                                setState(() {
                                  _isHintVisible = !_isHintVisible;
                                });
                              } else {
                                SnackBarHelper.showInfo(
                                    context, "No hint available for this card!");
                              }
                            },
                            icon: Icon(
                              CupertinoIcons.lightbulb,
                              color: _isHintVisible ? AppColors.softAmber : AppColors.gray,
                              size: 20.sp,
                            ),
                            label: Text(
                              _isHintVisible ? "Hide Hint" : "Need a Hint?",
                              style: AppStyles.font14White70.copyWith(
                                color: _isHintVisible ? AppColors.softAmber : AppColors.lavenderGray,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
