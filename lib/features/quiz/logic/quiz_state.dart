import '../../cards/data/models/card_model.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizInProgress extends QuizState {
  final List<CardModel> cards;
  final int currentIndex;
  final int correctCount;
  final int wrongCount;
  final Set<String> answeredCardIds;
  final bool isShuffled;
  final bool showCorrectAnswer;
  final String? lastCorrectAnswer;

  QuizInProgress({
    required this.cards,
    required this.currentIndex,
    required this.correctCount,
    required this.wrongCount,
    required this.answeredCardIds,
    this.isShuffled = false,
    this.showCorrectAnswer = false,
    this.lastCorrectAnswer,
  });
}

class QuizCompleted extends QuizState {
  final int totalCards;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final Duration timeTaken;

  QuizCompleted({
    required this.totalCards,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.timeTaken,
  });

  double get scorePercentage => totalCards > 0 ? (correctCount / totalCards) * 100 : 0;
}
