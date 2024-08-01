import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_game_card/game/game.dart';

class PlayingArea {
  /// The maximum number of cards in this playing area.
  static const int maxCards = 6;

  /// The current cards in this area.
  final List<PlayingCard> cards = [];

  final StreamController playerChangesCont = StreamController.broadcast();
  final StreamController remoteChangesCont = StreamController.broadcast();

  PlayingArea();

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream get playerChanges => playerChangesCont.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream get remoteChanges => remoteChangesCont.stream;

  /// A [Stream] that fires an event every time any change to this area is made.
  Stream get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  /// Accepts the [card] into the area.
  void acceptCard(PlayingCard card) {
    cards.add(card);
    maybeTrim();
    playerChangesCont.add(null);
  }

  void dispose() {
    remoteChangesCont.close();
    playerChangesCont.close();
  }

  /// Removes the first card in the area, if any.
  void removeFirstCard() {
    if (cards.isEmpty) return;
    cards.removeAt(0);
    playerChangesCont.add(null);
  }

  /// Replaces the cards in the area with [cards].
  ///
  /// This method is meant to be called when the cards are updated from
  /// a server.
  void replaceWith(List<PlayingCard> cards) {
    this.cards.clear();
    this.cards.addAll(cards);
    maybeTrim();
    remoteChangesCont.add(null);
  }

  void maybeTrim() {
    if (cards.length > maxCards) {
      cards.removeRange(
        0,
        cards.length - maxCards,
      );
    }
  }
}
