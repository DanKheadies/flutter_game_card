import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_card/blocs/blocs.dart';
import 'package:flutter_game_card/cubits/cubits.dart';
import 'package:flutter_game_card/game/game.dart';
import 'package:flutter_game_card/models/models.dart';
import 'package:flutter_game_card/widgets/widgets.dart';

class PlayingAreaWidget extends StatefulWidget {
  final PlayingArea area;

  const PlayingAreaWidget(
    this.area, {
    super.key,
  });

  @override
  State<PlayingAreaWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {
  bool isHighlighted = false;
  Palette palette = Palette();

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 200,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: DragTarget<PlayingCardDragData>(
          builder: (context, candidateData, rejectedData) => Material(
            color: isHighlighted ? palette.accept : palette.trueWhite,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: palette.redPen,
              onTap: onAreaTap,
              child: StreamBuilder(
                // Rebuild the card stack whenever the area changes
                // (either by a player action or remotely).
                stream: widget.area.allChanges,
                builder: (context, child) => CardStack(
                  widget.area.cards,
                ),
              ),
            ),
          ),
          onWillAcceptWithDetails: onDragWillAccept,
          onLeave: onDragLeave,
          onAcceptWithDetails: onDragAccept,
        ),
      ),
    );
  }

  void onAreaTap() {
    widget.area.removeFirstCard();
    context.read<AudioCubit>().playSfx(
          SfxType.huhsh,
          context.read<SettingsBloc>().state,
        );
  }

  void onDragAccept(DragTargetDetails<PlayingCardDragData> details) {
    widget.area.acceptCard(details.data.card);
    details.data.holder.removeCard(details.data.card);
    setState(() => isHighlighted = false);
  }

  void onDragLeave(PlayingCardDragData? data) {
    setState(() => isHighlighted = false);
  }

  bool onDragWillAccept(DragTargetDetails<PlayingCardDragData> details) {
    setState(() => isHighlighted = true);
    return true;
  }
}
