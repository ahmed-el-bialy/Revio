import 'package:flutter_test/flutter_test.dart';
import 'package:revio/features/cards/data/models/card_model.dart';
import 'package:revio/features/quiz/logic/quiz_cubit.dart';
import 'package:revio/features/quiz/logic/quiz_state.dart';

CardModel _card(String id, String answer) =>
    CardModel(id: id, front: 'Question $id', back: answer, category: 'General');

void main() {
  group('QuizCubit', () {
    test(
      'multiple choice options always include the correct answer of the current card',
      () {
        final cubit = QuizCubit();
        cubit.emitStartQuiz([
          _card('1', 'One'),
          _card('2', 'Two'),
          _card('3', 'Three'),
        ], mode: QuizMode.multipleChoice);

        final state = cubit.state as QuizInProgress;
        expect(state.currentOptions, contains(state.currentCard.back));
        expect(
          state.currentOptions!.toSet(),
          hasLength(state.currentOptions!.length),
        );
        expect(state.currentOptions!.length, lessThanOrEqualTo(3));
      },
    );

    test(
      'skipping increments the skipped count without recording a wrong answer',
      () {
        final cubit = QuizCubit();
        cubit.emitStartQuiz([
          _card('1', 'One'),
          _card('2', 'Two'),
        ], mode: QuizMode.typing);

        cubit.emitSkipCard();
        final state = cubit.state as QuizInProgress;
        expect(state.correctCount, 0);
        expect(state.wrongCount, 0);
        expect(state.answeredCardIds.length, 1);
      },
    );

    test('starting a quiz automatically shuffles cards', () {
      final cubit = QuizCubit();
      final cards = [
        _card('1', 'One'),
        _card('2', 'Two'),
        _card('3', 'Three'),
      ];
      cubit.emitStartQuiz(cards, mode: QuizMode.multipleChoice);

      final state = cubit.state as QuizInProgress;
      expect(state.isShuffled, isTrue);
      expect(state.cards.length, 3);
    });
  });
}
