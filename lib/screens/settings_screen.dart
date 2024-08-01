// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_card/blocs/blocs.dart';
import 'package:flutter_game_card/models/models.dart';
import 'package:flutter_game_card/screens/screens.dart';
import 'package:flutter_game_card/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette().backgroundSettings,
      body: ResponsiveScreen(
        squarishMainArea: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return ListView(
              children: [
                _gap,
                const Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 55,
                    height: 1,
                  ),
                ),
                _gap,
                NameChangeLine(
                  'Name',
                  state.playerName,
                ),
                SettingsLine(
                  'Sound FX',
                  Icon(state.soundsOn ? Icons.graphic_eq : Icons.volume_off),
                  onSelected: () => context.read<SettingsBloc>().add(
                        ToggleSound(),
                      ),
                ),
                SettingsLine(
                  'Music',
                  Icon(state.musicOn ? Icons.music_note : Icons.music_off),
                  onSelected: () => context.read<SettingsBloc>().add(
                        ToggleMusic(),
                      ),
                ),
                SettingsLine(
                  'Reset progress',
                  const Icon(Icons.delete),
                  onSelected: () {
                    context.read<PlayerProgressBloc>().add(
                          Reset(),
                        );

                    final messenger = ScaffoldMessenger.of(context);
                    messenger.showSnackBar(
                      const SnackBar(
                          content: Text('Player progress has been reset.')),
                    );
                  },
                ),
                _gap,
              ],
            );
          },
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: const Text('Back'),
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 60);
}
