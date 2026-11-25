import '../../cards/data/models/card_model.dart';

enum QuizMode { multipleChoice, typing }

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizTopicSelection extends QuizState {}

class QuizModeSelection extends QuizState {
  final List<CardModel> selectedCards;

  QuizModeSelection({required this.selectedCards});
}

class QuizInProgress extends QuizState {
  final List<CardModel> cards;
  final int currentIndex;
  final int correctCount;
  final int wrongCount;
  final Set<String> answeredCardIds;
  final bool isShuffled;
  final bool showCorrectAnswer;
  final String? lastCorrectAnswer;
  final QuizMode quizMode;
  final List<String>? currentOptions;
  final String? selectedOption;

  QuizInProgress({
    required this.cards,
    required this.currentIndex,
    required this.correctCount,
    required this.wrongCount,
    required this.answeredCardIds,
    required this.quizMode,
    this.isShuffled = false,
    this.showCorrectAnswer = false,
    this.lastCorrectAnswer,
    this.currentOptions,
    this.selectedOption,
  });

  CardModel get currentCard => cards[currentIndex];
  bool get isCurrentAnswered => answeredCardIds.contains(currentCard.id);
  double get progress =>
      cards.isEmpty ? 0 : (currentIndex + 1) / cards.length;

  QuizInProgress copyWith({
    List<CardModel>? cards,
    int? currentIndex,
    int? correctCount,
    int? wrongCount,
    Set<String>? answeredCardIds,
    bool? isShuffled,
    bool? showCorrectAnswer,
    String? lastCorrectAnswer,
    QuizMode? quizMode,
    List<String>? currentOptions,
    String? selectedOption,
    bool clearSelection = false,
  }) {
    return QuizInProgress(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      answeredCardIds: answeredCardIds ?? this.answeredCardIds,
      quizMode: quizMode ?? this.quizMode,
      isShuffled: isShuffled ?? this.isShuffled,
      showCorrectAnswer: showCorrectAnswer ?? this.showCorrectAnswer,
      lastCorrectAnswer: lastCorrectAnswer ?? this.lastCorrectAnswer,
      currentOptions: currentOptions ?? this.currentOptions,
      selectedOption: clearSelection
          ? null
          : (selectedOption ?? this.selectedOption),
    );
  }
}

class QuizCompleted extends QuizState {
  final int totalCards;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final Duration timeTaken;
  final QuizMode quizMode;

  QuizCompleted({
    required this.totalCards,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.timeTaken,
    required this.quizMode,
  });

  double get scorePercentage =>
      totalCards > 0 ? (correctCount / totalCards) * 100 : 0;
}
