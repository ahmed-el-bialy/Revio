import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../cards/ui/widgets/flash_card.dart';
import '../../logic/quiz_cubit.dart';
import '../../logic/quiz_state.dart';
import 'correct_answer_banner.dart';
import 'quiz_app_bar.dart';
import 'quiz_options_view.dart';
import 'quiz_progress_bar.dart';
import 'typing_quiz_input.dart';

class QuizInProgressView extends StatefulWidget {
  final QuizInProgress state;

  const QuizInProgressView({super.key, required this.state});

  @override
  State<QuizInProgressView> createState() => _QuizInProgressViewState();
}

class _QuizInProgressViewState extends State<QuizInProgressView> {
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

  void _submitTypingAnswer() {
    final text = _answerController.text.trim();
    if (text.isEmpty) return;
    context.read<QuizCubit>().emitSubmitAnswer(text);
    _answerController.clear();
    setState(() => _isHintVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_lastIndex != widget.state.currentIndex) {
      _lastIndex = widget.state.currentIndex;
      _isHintVisible = false;
    }

    final currentCard = widget.state.currentCard;
    final isAnswered = widget.state.isCurrentAnswered;
    final hasHint = currentCard.hint != null && currentCard.hint!.trim().isNotEmpty;

    return Column(
      children: [
        QuizAppBar(state: widget.state),
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
                  QuizProgressBar(state: widget.state),
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
                  if (widget.state.showCorrectAnswer && widget.state.lastCorrectAnswer != null) ...[
                    CorrectAnswerBanner(answer: widget.state.lastCorrectAnswer!),
                    verticalSpacing(10),
                  ],
                  if (widget.state.quizMode == QuizMode.multipleChoice)
                    QuizOptionsView(
                      options: widget.state.currentOptions ?? [],
                      correctAnswer: currentCard.back,
                      selectedOption: widget.state.selectedOption,
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
                      onSubmit: _submitTypingAnswer,
                      onSkip: () {
                        context.read<QuizCubit>().emitSkipCard();
                        _answerController.clear();
                        setState(() => _isHintVisible = false);
                      },
                    ),
                  verticalSpacing(10),
                  Center(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
