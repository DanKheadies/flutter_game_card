import 'package:flutter/material.dart';
import 'package:flutter_game_card/game/game.dart';
import 'package:flutter_game_card/models/palette.dart';
import 'package:flutter_game_card/screens/screens.dart';
import 'package:flutter_game_card/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;

  const WinGameScreen({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette().backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'You won!',
                style: TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 50,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Score: ${score.score}\n'
                'Time: ${score.formattedTime}',
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () => GoRouter.of(context).go('/'),
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
