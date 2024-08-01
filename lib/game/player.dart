import 'package:flutter/material.dart';

import 'package:flutter_game_card/game/game.dart';

class Player extends ChangeNotifier {
  static const maxCards = 7;

  final List<PlayingCard> hand = List.generate(
    maxCards,
    (_) => PlayingCard.random(),
  );

  void removeCard(PlayingCard card) {
    hand.remove(card);
    notifyListeners();
  }
}
