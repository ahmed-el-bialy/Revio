import 'package:flip_card/flip_card.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
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

  @override
  void didUpdateWidget(covariant QuizInProgressView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.currentIndex != widget.state.currentIndex) {
      _answerController.clear();
      _isHintVisible = false;
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

  void _submitTypingAnswer() {
    final text = _answerController.text.trim();
    if (text.isEmpty) return;
    context.read<QuizCubit>().emitSubmitAnswer(text);
  }

  void _skip() {
    context.read<QuizCubit>().emitSkipCard();
    _answerController.clear();
    setState(() => _isHintVisible = false);
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = widget.state.currentCard;
    final isAnswered = widget.state.isCurrentAnswered;
    final hasHint =
        currentCard.hint != null && currentCard.hint!.trim().isNotEmpty;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Column(
      children: [
        QuizAppBar(state: widget.state),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardHeight = (constraints.maxHeight * 0.28)
                  .clamp(150.0, 230.0);

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      18.w,
                      4.h,
                      18.w,
                      24.h + keyboardInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        QuizProgressBar(state: widget.state),
                        verticalSpacing(14),
                        FlashCard(
                          flipKey: _getFlipKey(currentCard.id),
                          cardModel: currentCard,
                          isInQuiz: true,
                          showHint: _isHintVisible,
                          cardHeight: cardHeight,
                        ),
                        verticalSpacing(14),
                        if (widget.state.showCorrectAnswer &&
                            widget.state.lastCorrectAnswer != null) ...[
                          CorrectAnswerBanner(
                            answer: widget.state.lastCorrectAnswer!,
                          ),
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
                                context.read<QuizCubit>().emitSubmitAnswer(
                                  option,
                                );
                              }
                            },
                            onSkip: _skip,
                          )
                        else
                          TypingQuizInput(
                            controller: _answerController,
                            isAnswered: isAnswered,
                            onSubmit: _submitTypingAnswer,
                            onSkip: _skip,
                          ),
                        if (hasHint) ...[
                          verticalSpacing(4),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                setState(
                                  () => _isHintVisible = !_isHintVisible,
                                );
                              },
                              icon: Icon(
                                CupertinoIcons.lightbulb,
                                color: _isHintVisible
                                    ? AppColors.primaryCyan
                                    : AppColors.lavenderGray,
                                size: 18.sp,
                              ),
                              label: Text(
                                _isHintVisible ? 'Hide hint' : 'Show hint',
                                style: AppStyles.font13GrayMedium.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
