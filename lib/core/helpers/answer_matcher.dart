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

    if (user == correct) {
      return const AnswerResult(
        isCorrect: true,
        matchType: MatchType.exact,
        similarity: 1.0,
      );
    }

    final userNum = _extractNumber(user);
    final correctNum = _extractNumber(correct);
    if (userNum != null && correctNum != null && userNum == correctNum) {
      return const AnswerResult(
        isCorrect: true,
        matchType: MatchType.numeric,
        similarity: 1.0,
      );
    }

    if (user.contains(correct) || correct.contains(user)) {
      if (user.length > 2 && correct.length > 2) {
        return const AnswerResult(
          isCorrect: true,
          matchType: MatchType.partial,
          similarity: 0.8,
        );
      }
    }

    final similarity = _calculateSimilarity(user, correct);
    if (similarity >= 0.75) {
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

  static num? _extractNumber(String str) {
    final match = RegExp(r'\d+').firstMatch(str);
    if (match != null) {
      return num.tryParse(match.group(0)!);
    }
    
    final words = {
      'zero': 0, 'one': 1, 'two': 2, 'three': 3, 'four': 4,
      'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10
    };
    
    for (final word in words.keys) {
      if (str.contains(word)) return words[word];
    }
    
    return null;
  }

  static double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    
    final longer = s1.length > s2.length ? s1 : s2;
    final shorter = s1.length > s2.length ? s2 : s1;
    
    final distance = _levenshtein(longer, shorter);
    return (longer.length - distance) / longer.length;
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
