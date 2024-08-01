import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_card/blocs/blocs.dart';
import 'package:flutter_game_card/cubits/cubits.dart';
import 'package:flutter_game_card/game/game.dart';
import 'package:flutter_game_card/models/models.dart';

class PlayingCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static const double height = 88.9;
  static const double width = 57.1;

  // final Palette
  final Player? player;
  final PlayingCard card;

  const PlayingCardWidget(
    this.card, {
    this.player,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette();
    // palette.
    final textColor =
        card.suit.color == CardSuitColor.red ? palette.redPen : palette.ink;
    final cardWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.apply(
            color: textColor,
          ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: palette.trueWhite,
          border: Border.all(
            color: palette.ink,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            '${card.suit.asCharacter}\n${card.value}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    /// Cards that aren't in a player's hand are not draggable.
    if (player == null) return cardWidget;

    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: cardWidget,
      ),
      data: PlayingCardDragData(
        card,
        player!,
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: cardWidget,
      ),
      onDragStarted: () {
        context.read<AudioCubit>().playSfx(
              SfxType.huhsh,
              context.read<SettingsBloc>().state,
            );
      },
      child: cardWidget,
    );
  }
}

class PlayingCardDragData {
  final Player holder;
  final PlayingCard card;

  const PlayingCardDragData(
    this.card,
    this.holder,
  );
}
