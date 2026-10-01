import 'package:flutter_test/flutter_test.dart';
import 'package:code_alpha_flash_card_app/core/helpers/answer_matcher.dart';

void main() {
  group('AnswerMatcher Tests', () {
    test('Exact match after normalization', () {
      final res = AnswerMatcher.match('  Flutter  ', 'flutter');
      expect(res.isCorrect, isTrue);
      expect(res.matchType, MatchType.exact);
      expect(res.similarity, 1.0);
    });

    test('Numeric match (7 numbers vs 7)', () {
      final res = AnswerMatcher.match('7 numbers', '7');
      expect(res.isCorrect, isTrue);
      expect(res.matchType, MatchType.numeric);
    });

    test('Partial containment match', () {
      final res = AnswerMatcher.match('Widget', 'StatelessWidget');
      expect(res.isCorrect, isTrue);
      expect(res.matchType, MatchType.partial);
    });

    test('Fuzzy match with minor typo', () {
      final res = AnswerMatcher.match('Fluttr', 'Flutter');
      expect(res.isCorrect, isTrue);
      expect(res.matchType, MatchType.fuzzy);
    });

    test('Wrong answer', () {
      final res = AnswerMatcher.match('React Native', 'Flutter');
      expect(res.isCorrect, isFalse);
      expect(res.matchType, MatchType.wrong);
    });
  });
}
