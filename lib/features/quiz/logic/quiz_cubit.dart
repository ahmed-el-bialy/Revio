import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/answer_matcher.dart';
import '../../cards/data/models/card_model.dart';
import '../data/models/quiz_result_model.dart';
import '../data/repo/quiz_history_repo.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizTopicSelection());

  late Stopwatch _stopwatch;
  int _skippedCount = 0;
  int _sessionId = 0;
  final List<String> _uniqueAnswers = [];

  void emitShowTopicSelection() {
    _sessionId++;
    emit(QuizTopicSelection());
  }

  void emitShowModeSelection({List<CardModel>? cards}) {
    _sessionId++;
    if (cards != null && cards.isNotEmpty) {
      emit(QuizModeSelection(selectedCards: cards));
    } else if (state is QuizInProgress) {
      emit(QuizModeSelection(selectedCards: (state as QuizInProgress).cards));
    } else {
      emit(QuizTopicSelection());
    }
  }

  void emitProceedToModeSelection(List<CardModel> selectedCards) {
    if (selectedCards.isEmpty) return;
    _sessionId++;
    emit(QuizModeSelection(selectedCards: selectedCards));
  }

  void emitStartQuiz(
    List<CardModel> cards, {
    QuizMode mode = QuizMode.multipleChoice,
  }) {
    if (cards.isEmpty) return;

    _sessionId++;
    _skippedCount = 0;
    _stopwatch = Stopwatch()..start();

    _uniqueAnswers.clear();
    for (var card in cards) {
      final answer = card.back.trim();
      if (answer.isNotEmpty && !_uniqueAnswers.contains(answer)) {
        _uniqueAnswers.add(answer);
      }
    }

    emit(
      QuizInProgress(
        cards: cards,
        currentIndex: 0,
        correctCount: 0,
        wrongCount: 0,
        answeredCardIds: const {},
        quizMode: mode,
        currentOptions: mode == QuizMode.multipleChoice
            ? _generateOptions(cards, 0)
            : null,
      ),
    );
  }

  List<String> _generateOptions(List<CardModel> cards, int currentIndex) {
    if (cards.isEmpty) return [];

    final correctAnswer = cards[currentIndex].back.trim();

    final otherAnswers =
        _uniqueAnswers.where((ans) => ans != correctAnswer).toList()
          ..shuffle();

    final distractors = otherAnswers.take(3).toList();

    final options = [correctAnswer, ...distractors];
    options.shuffle();
    return options;
  }

  void emitSubmitAnswer(String selectedOption) {
    if (state is! QuizInProgress) return;
    final currentState = state as QuizInProgress;
    final currentCard = currentState.currentCard;

    if (currentState.isCurrentAnswered) return;

    final isMcq = currentState.quizMode == QuizMode.multipleChoice;

    final bool isCorrect = isMcq
        ? selectedOption.trim() == currentCard.back.trim()
        : AnswerMatcher.isCorrect(
            userAnswer: selectedOption,
            correctAnswer: currentCard.back,
          );

    final updatedCardIds = Set<String>.from(currentState.answeredCardIds)
      ..add(currentCard.id);

    final newCorrect =
        isCorrect ? currentState.correctCount + 1 : currentState.correctCount;
    final newWrong =
        isCorrect ? currentState.wrongCount : currentState.wrongCount + 1;

    emit(
      QuizInProgress(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex,
        correctCount: newCorrect,
        wrongCount: newWrong,
        answeredCardIds: updatedCardIds,
        selectedOption: selectedOption,
        quizMode: currentState.quizMode,
        isShuffled: currentState.isShuffled,
        currentOptions: currentState.currentOptions,
      ),
    );

    final currentSession = _sessionId;
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (_sessionId != currentSession) return;
      if (state is QuizInProgress) {
        _moveToNextOrComplete(state as QuizInProgress);
      }
    });
  }

  void emitSkipCard() {
    if (state is! QuizInProgress) return;
    final currentState = state as QuizInProgress;

    if (currentState.isCurrentAnswered) return;

    _skippedCount++;
    final updatedCardIds = Set<String>.from(currentState.answeredCardIds)
      ..add(currentState.currentCard.id);

    emit(
      QuizInProgress(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex,
        correctCount: currentState.correctCount,
        wrongCount: currentState.wrongCount + 1,
        answeredCardIds: updatedCardIds,
        quizMode: currentState.quizMode,
        isShuffled: currentState.isShuffled,
        currentOptions: currentState.currentOptions,
      ),
    );

    final currentSession = _sessionId;
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_sessionId != currentSession) return;
      if (state is QuizInProgress) {
        _moveToNextOrComplete(state as QuizInProgress);
      }
    });
  }

  void emitShuffleCurrentQuiz() {
    if (state is! QuizInProgress) return;
    final currentState = state as QuizInProgress;

    final newCards = List<CardModel>.from(currentState.cards)..shuffle();
    emit(currentState.copyWith(cards: newCards, isShuffled: true));
  }

  void emitShuffleRemaining() {
    emitShuffleCurrentQuiz();
  }

  void emitAdvanceNext() {
    if (state is! QuizInProgress) return;
    final currentState = state as QuizInProgress;
    _moveToNextOrComplete(currentState);
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
      final timeTakenSec = _stopwatch.elapsed.inSeconds;
      final modeName = currentState.quizMode == QuizMode.multipleChoice
          ? 'Multiple Choice'
          : 'Smart Typing';

      QuizHistoryRepo().saveResult(
        QuizResultModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          modeName: modeName,
          totalCards: currentState.cards.length,
          correctCount: currentState.correctCount,
          wrongCount: currentState.wrongCount,
          skippedCount: _skippedCount,
          timeTakenSeconds: timeTakenSec,
          timestamp: DateTime.now(),
        ),
      );

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
