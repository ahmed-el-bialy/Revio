import 'package:flip_card/flip_card.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/card_model.dart';
import 'card_face.dart';

class FlashCard extends StatelessWidget {
  final CardModel cardModel;
  final bool isInQuiz;
  final bool showHint;
  final GlobalKey<FlipCardState>? flipKey;
  final double? cardHeight;

  const FlashCard({
    super.key,
    required this.cardModel,
    required this.isInQuiz,
    this.showHint = false,
    this.flipKey,
    this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final double resolvedHeight = cardHeight ?? 220.h;

    return FlipCard(
      key: flipKey ?? ValueKey('flashcard_${cardModel.id}'),
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      speed: 400,
      flipOnTouch: !isInQuiz,
      front: CardFace(
        cardHeight: resolvedHeight,
        cardModel: cardModel,
        isInQuiz: isInQuiz,
        isFront: true,
        showHint: showHint,
      ),
      back: CardFace(
        cardHeight: resolvedHeight,
        cardModel: cardModel,
        isInQuiz: isInQuiz,
        isFront: false,
        showHint: showHint,
      ),
    );
  }
}
