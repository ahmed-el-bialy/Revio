enum MatchType { exact, numeric, partial, fuzzy, wrong }

class AnswerResult {
  final bool isCorrect;
  final MatchType matchType;
  final double similarity;

  const AnswerResult({
    required this.isCorrect,
    required this.matchType,
    required this.similarity,
  });
}

class AnswerMatcher {
  static AnswerResult match(String userAnswer, String correctAnswer) {
    final user = _normalize(userAnswer);
    final correct = _normalize(correctAnswer);

    if (user.isEmpty || correct.isEmpty) {
      return const AnswerResult(
        isCorrect: false,
        matchType: MatchType.wrong,
        similarity: 0.0,
      );
    }

    if (user == correct) {
      return const AnswerResult(
        isCorrect: true,
        matchType: MatchType.exact,
        similarity: 1.0,
      );
    }

    final userNum = _extractPureNumber(user);
    final correctNum = _extractPureNumber(correct);
    if (userNum != null && correctNum != null && userNum == correctNum) {
      return const AnswerResult(
        isCorrect: true,
        matchType: MatchType.numeric,
        similarity: 1.0,
      );
    }

    final shorterLen = user.length < correct.length ? user.length : correct.length;
    final longerLen = user.length > correct.length ? user.length : correct.length;

    // Check partial containment match (must meet length ratio and not conflict on negation)
    if ((user.contains(correct) || correct.contains(user)) &&
        !_hasNegationConflict(user, correct)) {
      if (shorterLen >= 3 && (shorterLen / longerLen >= 0.45)) {
        return const AnswerResult(
          isCorrect: true,
          matchType: MatchType.partial,
          similarity: 0.8,
        );
      }
    }

    // Check fuzzy match via Levenshtein distance
    final distance = _levenshtein(user, correct);
    final similarity = (longerLen - distance) / longerLen;

    final maxDistanceAllowed = longerLen <= 5 ? 0 : (longerLen <= 10 ? 1 : 2);

    if (distance <= maxDistanceAllowed && similarity >= 0.82) {
      return AnswerResult(
        isCorrect: true,
        matchType: MatchType.fuzzy,
        similarity: similarity,
      );
    }

    return const AnswerResult(
      isCorrect: false,
      matchType: MatchType.wrong,
      similarity: 0.0,
    );
  }

  static String _normalize(String str) {
    return str.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static num? _extractPureNumber(String str) {
    final parsed = num.tryParse(str);
    if (parsed != null) return parsed;

    final words = {
      'zero': 0, 'one': 1, 'two': 2, 'three': 3, 'four': 4,
      'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10
    };

    return words[str];
  }

  static bool _hasNegationConflict(String s1, String s2) {
    final negations = {'not', 'no', 'never', 'non', 'without', "don't", "isnt", "arent", "cannot"};
    final words1 = s1.split(RegExp(r'\W+')).toSet();
    final words2 = s2.split(RegExp(r'\W+')).toSet();

    final hasNeg1 = words1.any((w) => negations.contains(w));
    final hasNeg2 = words2.any((w) => negations.contains(w));

    return hasNeg1 != hasNeg2;
  }

  static int _levenshtein(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    var v0 = List<int>.generate(s2.length + 1, (i) => i);
    var v1 = List<int>.filled(s2.length + 1, 0);

    for (var i = 0; i < s1.length; i++) {
      v1[0] = i + 1;

      for (var j = 0; j < s2.length; j++) {
        final cost = s1[i] == s2[j] ? 0 : 1;
        v1[j + 1] = _min3(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost);
      }

      for (var j = 0; j <= s2.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[s2.length];
  }

  static int _min3(int a, int b, int c) {
    return (a < b) ? (a < c ? a : c) : (b < c ? b : c);
  }
}

