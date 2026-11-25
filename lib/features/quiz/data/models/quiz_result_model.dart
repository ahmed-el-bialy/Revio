class QuizResultModel {
  final String id;
  final String modeName;
  final int totalCards;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final int timeTakenSeconds;
  final DateTime timestamp;

  QuizResultModel({
    required this.id,
    required this.modeName,
    required this.totalCards,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.timeTakenSeconds,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modeName': modeName,
      'totalCards': totalCards,
      'correctCount': correctCount,
      'wrongCount': wrongCount,
      'skippedCount': skippedCount,
      'timeTakenSeconds': timeTakenSeconds,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QuizResultModel.fromMap(Map<dynamic, dynamic> map) {
    return QuizResultModel(
      id: map['id'] as String? ?? '',
      modeName: map['modeName'] as String? ?? 'Quiz',
      totalCards: map['totalCards'] as int? ?? 0,
      correctCount: map['correctCount'] as int? ?? 0,
      wrongCount: map['wrongCount'] as int? ?? 0,
      skippedCount: map['skippedCount'] as int? ?? 0,
      timeTakenSeconds: map['timeTakenSeconds'] as int? ?? 0,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  double get scorePercentage =>
      totalCards > 0 ? (correctCount / totalCards) * 100 : 0.0;
}
