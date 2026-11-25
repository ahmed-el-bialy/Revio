import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../models/quiz_result_model.dart';

class QuizHistoryRepo {
  static const String _boxName = 'quiz_history_box';
  static final QuizHistoryRepo _instance = QuizHistoryRepo._internal();
  factory QuizHistoryRepo() => _instance;
  QuizHistoryRepo._internal();

  Box? _getBox() {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return null;
  }

  Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  Future<void> saveResult(QuizResultModel result) async {
    final box = _getBox() ?? await _openBox();
    await box.put(result.id, result.toMap());
  }

  List<QuizResultModel> getAllResults() {
    final box = _getBox();
    if (box == null) return [];
    final results = box.values
        .map((e) => QuizResultModel.fromMap(e as Map))
        .toList();
    results.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return results;
  }

  Future<void> deleteResult(String id) async {
    final box = _getBox() ?? await _openBox();
    await box.delete(id);
  }

  Future<void> clearAll() async {
    final box = _getBox() ?? await _openBox();
    await box.clear();
  }
}
