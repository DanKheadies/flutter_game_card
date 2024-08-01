// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_game_card/blocs/blocs.dart';
import 'package:flutter_game_card/cubits/cubits.dart';
import 'package:flutter_game_card/game/game.dart';
import 'package:flutter_game_card/models/models.dart';
import 'package:flutter_game_card/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  final Duration celebrationDuration = const Duration(milliseconds: 2000);
  final Duration preCelebrationDuration = const Duration(milliseconds: 500);

  bool duringCelebration = false;

  late DateTime startOfPlay;
  late final BoardState boardState;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(
          value: boardState,
        ),
      ],
      child: IgnorePointer(
        // Ignore all input during the celebration animation.
        ignoring: duringCelebration,
        child: Scaffold(
          backgroundColor: Palette().backgroundPlaySession,
          // The stack is how you layer widgets on top of each other.
          // Here, it is used to overlay the winning confetti animation on top
          // of the game.
          body: Stack(
            children: [
              // This is the main layout of the play session screen,
              // with a settings button at top, the actual play area
              // in the middle, and a back button at the bottom.
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkResponse(
                      onTap: () => GoRouter.of(context).push('/settings'),
                      child: Image.asset(
                        'assets/images/settings.png',
                        semanticLabel: 'Settings',
                      ),
                    ),
                  ),
                  const Spacer(),
                  // The actual UI of the game.
                  const BoardWidget(),
                  const Text('Drag cards to the two areas above.'),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () => GoRouter.of(context).go('/'),
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(
                      isStopped: !duringCelebration,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    boardState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startOfPlay = DateTime.now();
    boardState = BoardState(
      onWin: playerWon,
    );
  }

  Future<void> playerWon() async {
    Logger('PlaySessionScreen').info('Player won');

    // TODO: replace with some meaningful score for the card game
    final score = Score(
      DateTime.now().difference(startOfPlay),
      1,
      1,
    );

    // final playerProgress = context.read<PlayerProgress>();
    // playerProgress.setLevelReached(widget.level.number);

    // Let the player see the game just after winning for a bit.
    await Future.delayed(preCelebrationDuration);
    if (!mounted) return;

    setState(() => duringCelebration = true);

    context.read<AudioCubit>().playSfx(
          SfxType.congrats,
          context.read<SettingsBloc>().state,
        );

    /// Give the player some time to see the celebration animation.
    await Future.delayed(preCelebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go(
      '/play/won',
      extra: {
        'score': score,
      },
    );
  }
}
