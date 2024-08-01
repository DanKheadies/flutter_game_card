// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_game_card/game/game.dart';

class BoardState {
  final Player player = Player();
  final PlayingArea areaOne = PlayingArea();
  final PlayingArea areaTwo = PlayingArea();
  final VoidCallback onWin;

  BoardState({
    required this.onWin,
  }) {
    player.addListener(handlePlayerChange);
  }

  void dispose() {
    player.removeListener(handlePlayerChange);
    areaOne.dispose();
    areaTwo.dispose();
  }

  void handlePlayerChange() {
    if (player.hand.isEmpty) {
      onWin();
    }
  }
}
