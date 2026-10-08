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

    test('Numeric match (seven vs 7)', () {
      final res = AnswerMatcher.match('seven', '7');
      expect(res.isCorrect, isTrue);
      expect(res.matchType, MatchType.numeric);
    });

    test('Mixed formulas (H2O vs CO2) are NOT numeric match', () {
      final res = AnswerMatcher.match('H2O', 'CO2');
      expect(res.isCorrect, isFalse);
      expect(res.matchType, MatchType.wrong);
    });

    test('Negation mismatch (Not Paris vs Paris) is wrong', () {
      final res = AnswerMatcher.match('Not Paris', 'Paris');
      expect(res.isCorrect, isFalse);
      expect(res.matchType, MatchType.wrong);
    });

    test('Short prefix (the vs The French Revolution) is wrong', () {
      final res = AnswerMatcher.match('the', 'The French Revolution');
      expect(res.isCorrect, isFalse);
      expect(res.matchType, MatchType.wrong);
    });

    test('Partial containment with proper length ratio', () {
      final res = AnswerMatcher.match('French Revolution', 'The French Revolution');
      expect(res.isCorrect, isTrue);
      expect(res.matchType, MatchType.partial);
    });

    test('Fuzzy match with minor typo on long word', () {
      final res = AnswerMatcher.match('Fluttr', 'Flutter');
      expect(res.isCorrect, isTrue);
      expect(res.matchType, MatchType.fuzzy);
    });

    test('Austria vs Australia is wrong (fuzzy threshold)', () {
      final res = AnswerMatcher.match('Austria', 'Australia');
      expect(res.isCorrect, isFalse);
      expect(res.matchType, MatchType.wrong);
    });

    test('Wrong answer', () {
      final res = AnswerMatcher.match('React Native', 'Flutter');
      expect(res.isCorrect, isFalse);
      expect(res.matchType, MatchType.wrong);
    });
  });
}

