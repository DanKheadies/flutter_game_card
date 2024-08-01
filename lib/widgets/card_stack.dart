import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_game_card/game/game.dart';
import 'package:flutter_game_card/widgets/widgets.dart';

class CardStack extends StatelessWidget {
  static const double leftOffset = 10.0;
  static const double topOffset = 5.0;
  static const int maxCards = 6;

  static const double maxHeight =
      maxCards * topOffset + PlayingCardWidget.height;
  static const double maxWidth =
      maxCards * leftOffset + PlayingCardWidget.width;

  final List<PlayingCard> cards;

  const CardStack(
    this.cards, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: maxHeight,
        width: maxWidth,
        child: Stack(
          children: [
            for (var i = max(0, cards.length - maxCards); i < cards.length; i++)
              Positioned(
                top: i * topOffset,
                left: i * leftOffset,
                child: PlayingCardWidget(
                  cards[i],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
