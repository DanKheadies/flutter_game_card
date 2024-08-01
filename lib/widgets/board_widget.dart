import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_card/game/game.dart';
import 'package:flutter_game_card/widgets/widgets.dart';

class BoardWidget extends StatefulWidget {
  const BoardWidget({super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: PlayingAreaWidget(
                  boardState.areaOne,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: PlayingAreaWidget(
                  boardState.areaTwo,
                ),
              ),
            ],
          ),
        ),
        const PlayerHandWidget(),
      ],
    );
  }
}
