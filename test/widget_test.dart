import 'package:flutter_test/flutter_test.dart';
import 'package:code_alpha_flash_card_app/core/helpers/answer_matcher.dart';

void main() {
  test('App smoke test - AnswerMatcher initialization', () {
    final result = AnswerMatcher.match('hello', 'hello');
    expect(result.isCorrect, isTrue);
  });
}
