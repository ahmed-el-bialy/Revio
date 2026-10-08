import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cards/data/models/card_model.dart';
import '../../../core/helpers/answer_matcher.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizModeSelection());

  late Stopwatch _stopwatch;
  int _skippedCount = 0;

  void emitShowModeSelection() {
    emit(QuizModeSelection());
  }

  void emitStartQuiz(
    List<CardModel> cards, {
    required QuizMode mode,
    bool shuffle = false,
  }) {
    if (cards.isEmpty) return;

    final quizCards = List<CardModel>.from(cards);
    if (shuffle) quizCards.shuffle();

    _stopwatch = Stopwatch()..start();
    _skippedCount = 0;

    final initialState = QuizInProgress(
      cards: quizCards,
      currentIndex: 0,
      correctCount: 0,
      wrongCount: 0,
      answeredCardIds: {},
      quizMode: mode,
      isShuffled: shuffle,
      currentOptions: mode == QuizMode.multipleChoice
          ? _generateOptions(quizCards, 0)
          : null,
    );

    emit(initialState);
  }

  List<String> _generateOptions(List<CardModel> cards, int currentIndex) {
    final correctAnswer = cards[currentIndex].back;
    final allAnswers = cards.map((c) => c.back).toList();

    final distractors = allAnswers
        .where((a) => a != correctAnswer)
        .toList()
      ..shuffle();

    final options = [correctAnswer, ...distractors.take(3)];
    options.shuffle();
    return options;
  }

  Future<void> emitSubmitAnswer(String userAnswer) async {
    final currentState = state;
    if (currentState is! QuizInProgress) return;
    if (currentState.isCurrentAnswered) return;

    final currentCard = currentState.currentCard;
    final isMcq = currentState.quizMode == QuizMode.multipleChoice;
    final isCorrect = isMcq
        ? userAnswer.trim().toLowerCase() == currentCard.back.trim().toLowerCase()
        : AnswerMatcher.match(userAnswer, currentCard.back).isCorrect;

    final updatedAnsweredIds = Set<String>.from(currentState.answeredCardIds)
      ..add(currentCard.id);

    if (isCorrect) {
      final nextState = QuizInProgress(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex,
        correctCount: currentState.correctCount + 1,
        wrongCount: currentState.wrongCount,
        answeredCardIds: updatedAnsweredIds,
        quizMode: currentState.quizMode,
        isShuffled: currentState.isShuffled,
        selectedOption: currentState.quizMode == QuizMode.multipleChoice
            ? userAnswer
            : null,
        currentOptions: currentState.currentOptions,
      );
      emit(nextState);
      await Future.delayed(const Duration(milliseconds: 800));
      if (state != nextState) return; // Guard against race conditions
      _moveToNextOrComplete(nextState);
    } else {
      final nextState = QuizInProgress(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex,
        correctCount: currentState.correctCount,
        wrongCount: currentState.wrongCount + 1,
        answeredCardIds: updatedAnsweredIds,
        quizMode: currentState.quizMode,
        isShuffled: currentState.isShuffled,
        showCorrectAnswer: true,
        lastCorrectAnswer: currentCard.back,
        selectedOption: currentState.quizMode == QuizMode.multipleChoice
            ? userAnswer
            : null,
        currentOptions: currentState.currentOptions,
      );
      emit(nextState);
      await Future.delayed(const Duration(seconds: 2));
      if (state != nextState) return; // Guard against race conditions
      _moveToNextOrComplete(nextState);
    }
  }

  void emitAdvanceNext() {
    final currentState = state;
    if (currentState is! QuizInProgress) return;
    if (!currentState.isCurrentAnswered) return;
    _moveToNextOrComplete(currentState);
  }

  void emitSkipCard() {
    final currentState = state;
    if (currentState is! QuizInProgress) return;
    if (currentState.isCurrentAnswered) return;

    _skippedCount++;
    final updatedIds = Set<String>.from(currentState.answeredCardIds)
      ..add(currentState.currentCard.id);

    final nextState = QuizInProgress(
      cards: currentState.cards,
      currentIndex: currentState.currentIndex,
      correctCount: currentState.correctCount,
      wrongCount: currentState.wrongCount,
      answeredCardIds: updatedIds,
      quizMode: currentState.quizMode,
      isShuffled: currentState.isShuffled,
    );

    _moveToNextOrComplete(nextState);
  }

  void emitToggleShuffle() {
    final currentState = state;
    if (currentState is! QuizInProgress) return;

    final shuffled = !currentState.isShuffled;
    final newCards = List<CardModel>.from(currentState.cards);
    if (shuffled) newCards.shuffle();

    _skippedCount = 0;
    _stopwatch
      ..reset()
      ..start();

    emit(QuizInProgress(
      cards: newCards,
      currentIndex: 0,
      correctCount: 0,
      wrongCount: 0,
      answeredCardIds: {},
      quizMode: currentState.quizMode,
      isShuffled: shuffled,
      currentOptions: currentState.quizMode == QuizMode.multipleChoice
          ? _generateOptions(newCards, 0)
          : null,
    ));
  }

  void _moveToNextOrComplete(QuizInProgress currentState) {
    final nextIndex = currentState.currentIndex + 1;

    if (nextIndex < currentState.cards.length) {
      emit(QuizInProgress(
        cards: currentState.cards,
        currentIndex: nextIndex,
        correctCount: currentState.correctCount,
        wrongCount: currentState.wrongCount,
        answeredCardIds: currentState.answeredCardIds,
        quizMode: currentState.quizMode,
        isShuffled: currentState.isShuffled,
        currentOptions: currentState.quizMode == QuizMode.multipleChoice
            ? _generateOptions(currentState.cards, nextIndex)
            : null,
      ));
    } else {
      _stopwatch.stop();
      emit(QuizCompleted(
        totalCards: currentState.cards.length,
        correctCount: currentState.correctCount,
        wrongCount: currentState.wrongCount,
        skippedCount: _skippedCount,
        timeTaken: _stopwatch.elapsed,
        quizMode: currentState.quizMode,
      ));
    }
  }

  void emitToggleHint() {}
}
