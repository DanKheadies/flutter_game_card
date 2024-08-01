import 'dart:math';

import 'package:flutter_game_card/game/game.dart';

class PlayingCard {
  final CardSuit suit;
  final int value;

  const PlayingCard(
    this.suit,
    this.value,
  );

  @override
  bool operator ==(Object other) {
    return other is PlayingCard && other.suit == suit && other.value == value;
  }

  @override
  int get hashCode => Object.hash(suit, value);

  @override
  String toString() {
    return '$suit$value';
  }

  factory PlayingCard.random() {
    return PlayingCard(
      CardSuit.values[Random().nextInt(CardSuit.values.length)],
      2 + Random().nextInt(9),
    );
  }

  factory PlayingCard.fromJson(Map<String, dynamic> json) {
    return PlayingCard(
      CardSuit.values.singleWhere(
        (e) => e.internalRepresentation == json['suit'],
      ),
      json['value'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'suit': suit.internalRepresentation,
        'value': value,
      };
}
