import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cards/data/models/card_model.dart';
import '../../../core/helpers/answer_matcher.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  late Stopwatch _stopwatch;
  int _skippedCount = 0;

  void emitStartQuiz(List<CardModel> cards, {bool shuffle = false}) {
    if (cards.isEmpty) return;
    
    final quizCards = List<CardModel>.from(cards);
    if (shuffle) quizCards.shuffle();

    _stopwatch = Stopwatch()..start();
    _skippedCount = 0;

    emit(QuizInProgress(
      cards: quizCards,
      currentIndex: 0,
      correctCount: 0,
      wrongCount: 0,
      answeredCardIds: {},
      isShuffled: shuffle,
    ));
  }

  Future<void> emitSubmitAnswer(String userAnswer) async {
    final currentState = state;
    if (currentState is! QuizInProgress) return;

    final currentCard = currentState.cards[currentState.currentIndex];
    if (currentState.answeredCardIds.contains(currentCard.id)) return;

    final answerResult = AnswerMatcher.match(userAnswer, currentCard.back);
    
    final updatedAnsweredCardIds = Set<String>.from(currentState.answeredCardIds)
      ..add(currentCard.id);

    if (answerResult.isCorrect) {
      final nextState = QuizInProgress(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex,
        correctCount: currentState.correctCount + 1,
        wrongCount: currentState.wrongCount,
        answeredCardIds: updatedAnsweredCardIds,
        isShuffled: currentState.isShuffled,
      );
      
      emit(nextState);
      await Future.delayed(const Duration(milliseconds: 500));
      _moveToNextOrComplete(nextState);
    } else {
      final nextState = QuizInProgress(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex,
        correctCount: currentState.correctCount,
        wrongCount: currentState.wrongCount + 1,
        answeredCardIds: updatedAnsweredCardIds,
        isShuffled: currentState.isShuffled,
        showCorrectAnswer: true,
        lastCorrectAnswer: currentCard.back,
      );
      
      emit(nextState);
      await Future.delayed(const Duration(seconds: 2));
      _moveToNextOrComplete(nextState);
    }
  }

  void emitSkipCard() {
    final currentState = state;
    if (currentState is! QuizInProgress) return;

    final currentCard = currentState.cards[currentState.currentIndex];
    if (currentState.answeredCardIds.contains(currentCard.id)) return;

    _skippedCount++;
    final updatedAnsweredCardIds = Set<String>.from(currentState.answeredCardIds)
      ..add(currentCard.id);

    final nextState = QuizInProgress(
      cards: currentState.cards,
      currentIndex: currentState.currentIndex,
      correctCount: currentState.correctCount,
      wrongCount: currentState.wrongCount,
      answeredCardIds: updatedAnsweredCardIds,
      isShuffled: currentState.isShuffled,
    );

    _moveToNextOrComplete(nextState);
  }

  void _moveToNextOrComplete(QuizInProgress currentState) {
    if (currentState.currentIndex < currentState.cards.length - 1) {
      emit(QuizInProgress(
        cards: currentState.cards,
        currentIndex: currentState.currentIndex + 1,
        correctCount: currentState.correctCount,
        wrongCount: currentState.wrongCount,
        answeredCardIds: currentState.answeredCardIds,
        isShuffled: currentState.isShuffled,
      ));
    } else {
      _stopwatch.stop();
      emit(QuizCompleted(
        totalCards: currentState.cards.length,
        correctCount: currentState.correctCount,
        wrongCount: currentState.wrongCount,
        skippedCount: _skippedCount,
        timeTaken: _stopwatch.elapsed,
      ));
    }
  }

  void emitNextCard() {
    final currentState = state;
    if (currentState is QuizInProgress) {
      if (currentState.currentIndex < currentState.cards.length - 1) {
        emit(QuizInProgress(
          cards: currentState.cards,
          currentIndex: currentState.currentIndex + 1,
          correctCount: currentState.correctCount,
          wrongCount: currentState.wrongCount,
          answeredCardIds: currentState.answeredCardIds,
          isShuffled: currentState.isShuffled,
        ));
      }
    }
  }

  void emitPreviousCard() {
    final currentState = state;
    if (currentState is QuizInProgress) {
      if (currentState.currentIndex > 0) {
        emit(QuizInProgress(
          cards: currentState.cards,
          currentIndex: currentState.currentIndex - 1,
          correctCount: currentState.correctCount,
          wrongCount: currentState.wrongCount,
          answeredCardIds: currentState.answeredCardIds,
          isShuffled: currentState.isShuffled,
        ));
      }
    }
  }

  void emitToggleHint() {
  }
}
