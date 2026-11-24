import 'package:flutter_test/flutter_test.dart';
import '../lib/core/helpers/answer_matcher.dart';

void main() {
  test('App smoke test - AnswerMatcher initialization', () {
    final result = AnswerMatcher.match('hello', 'hello');
    expect(result.isCorrect, isTrue);
  });
}
