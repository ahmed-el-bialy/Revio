import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/answer_matcher.dart';
import '../../cards/data/models/card_model.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizModeSelection());

  late Stopwatch _stopwatch;
  int _skippedCount = 0;
  int _sessionId = 0;
  final List<String> _uniqueAnswers = [];

  void emitShowModeSelection() {
    _sessionId++;
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

    _beginSession(quizCards, mode: mode, shuffled: shuffle);
  }

  void _beginSession(
    List<CardModel> quizCards, {
    required QuizMode mode,
    required bool shuffled,
  }) {
    _sessionId++;
    _stopwatch = Stopwatch()..start();
    _skippedCount = 0;
    _uniqueAnswers
      ..clear()
      ..addAll(_collectUniqueAnswers(quizCards));

    emit(
      QuizInProgress(
        cards: quizCards,
        currentIndex: 0,
        correctCount: 0,
        wrongCount: 0,
        answeredCardIds: {},
        quizMode: mode,
        isShuffled: shuffled,
        currentOptions: mode == QuizMode.multipleChoice
            ? _generateOptions(quizCards, 0)
            : null,
      ),
    );
  }

  List<String> _collectUniqueAnswers(List<CardModel> cards) {
    final seen = <String>{};
    final unique = <String>[];
    for (final card in cards) {
      final answer = card.back.trim();
      if (answer.isEmpty) continue;
      final key = answer.toLowerCase();
      if (seen.add(key)) unique.add(answer);
    }
    return unique;
  }

  List<String> _generateOptions(List<CardModel> cards, int currentIndex) {
    final correctAnswer = cards[currentIndex].back.trim();
    final correctKey = correctAnswer.toLowerCase();

    final distractors =
        _uniqueAnswers
            .where((answer) => answer.toLowerCase() != correctKey)
            .toList()
          ..shuffle();

    final options = <String>[correctAnswer, ...distractors.take(3)];
    options.shuffle();
    return options;
  }

  Future<void> emitSubmitAnswer(String userAnswer) async {
    final currentState = state;
    if (currentState is! QuizInProgress) return;
    if (currentState.isCurrentAnswered) return;

    final session = _sessionId;
    final currentCard = currentState.currentCard;
    final isCorrect = AnswerMatcher.match(
      userAnswer,
      currentCard.back,
    ).isCorrect;

    final updatedAnsweredIds = Set<String>.from(currentState.answeredCardIds)
      ..add(currentCard.id);

    final nextState = currentState.copyWith(
      correctCount: currentState.correctCount + (isCorrect ? 1 : 0),
      wrongCount: currentState.wrongCount + (isCorrect ? 0 : 1),
      answeredCardIds: updatedAnsweredIds,
      showCorrectAnswer: !isCorrect,
      lastCorrectAnswer: isCorrect
          ? currentState.lastCorrectAnswer
          : currentCard.back,
      selectedOption: currentState.quizMode == QuizMode.multipleChoice
          ? userAnswer
          : currentState.selectedOption,
    );

    emit(nextState);

    final delay = isCorrect
        ? const Duration(milliseconds: 700)
        : const Duration(milliseconds: 1600);
    await Future<void>.delayed(delay);
    if (_sessionId != session) return;
    if (state is! QuizInProgress) return;
    final latest = state as QuizInProgress;
    if (latest.currentIndex != nextState.currentIndex) return;
    _moveToNextOrComplete(latest);
  }

  void emitAdvanceNext() {
    final currentState = state;
    if (currentState is! QuizInProgress) return;
    if (!currentState.isCurrentAnswered) return;
    _sessionId++;
    _moveToNextOrComplete(currentState);
  }

  void emitSkipCard() {
    final currentState = state;
    if (currentState is! QuizInProgress) return;
    if (currentState.isCurrentAnswered) return;

    _sessionId++;
    _skippedCount++;
    final updatedIds = Set<String>.from(currentState.answeredCardIds)
      ..add(currentState.currentCard.id);

    _moveToNextOrComplete(
      currentState.copyWith(
        answeredCardIds: updatedIds,
        showCorrectAnswer: false,
        clearSelection: true,
      ),
    );
  }

  void emitShuffleRemaining() {
    final currentState = state;
    if (currentState is! QuizInProgress) return;
    if (currentState.isCurrentAnswered) return;

    final nextIndex = currentState.currentIndex + 1;
    if (nextIndex >= currentState.cards.length) return;

    final remaining = currentState.cards.sublist(nextIndex)..shuffle();
    final newCards = [
      ...currentState.cards.sublist(0, nextIndex),
      ...remaining,
    ];

    emit(currentState.copyWith(cards: newCards, isShuffled: true));
  }

  void _moveToNextOrComplete(QuizInProgress currentState) {
    final nextIndex = currentState.currentIndex + 1;

    if (nextIndex < currentState.cards.length) {
      emit(
        QuizInProgress(
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
        ),
      );
    } else {
      _stopwatch.stop();
      emit(
        QuizCompleted(
          totalCards: currentState.cards.length,
          correctCount: currentState.correctCount,
          wrongCount: currentState.wrongCount,
          skippedCount: _skippedCount,
          timeTaken: _stopwatch.elapsed,
          quizMode: currentState.quizMode,
        ),
      );
    }
  }
}
