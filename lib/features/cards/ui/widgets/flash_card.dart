import 'package:code_alpha_flash_card_app/features/cards/data/models/card_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_face.dart';

class FlashCard extends StatelessWidget {
  final CardModel cardModel;
  final bool isInQuiz;
  final bool showHint;
  final GlobalKey<FlipCardState>? flipKey;

  const FlashCard({
    super.key,
    required this.cardModel,
    required this.isInQuiz,
    this.showHint = false,
    this.flipKey,
  });

  @override
  Widget build(BuildContext context) {
    final double cardHeight = 220.h;

    return FlipCard(
      key: flipKey ?? ValueKey('flashcard_${cardModel.id}'),
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      speed: 400,
      front: CardFace(
        cardHeight: cardHeight,
        cardModel: cardModel,
        isInQuiz: isInQuiz,
        isFront: true,
        showHint: showHint,
      ),
      back: CardFace(
        cardHeight: cardHeight,
        cardModel: cardModel,
        isInQuiz: isInQuiz,
        isFront: false,
        showHint: showHint,
      ),
    );
  }
}
