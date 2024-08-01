// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_card/blocs/blocs.dart';
import 'package:flutter_game_card/cubits/cubits.dart';
import 'package:flutter_game_card/models/models.dart';
import 'package:flutter_game_card/screens/screens.dart';
import 'package:flutter_game_card/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette().backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Center(
          child: Transform.rotate(
            angle: -0.1,
            child: const Text(
              'Flutter Game Template!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
          ),
        ),
        rectangularMenuArea: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  onPressed: () {
                    context.read<AudioCubit>().playSfx(
                          SfxType.buttonTap,
                          state,
                        );
                    GoRouter.of(context).go('/play');
                  },
                  child: const Text('Play'),
                ),
                _gap,
                MyButton(
                  onPressed: () => GoRouter.of(context).push('/settings'),
                  child: const Text('Settings'),
                ),
                _gap,
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: IconButton(
                    onPressed: () => context.read<SettingsBloc>().add(
                          ToggleAudio(),
                        ),
                    icon: Icon(
                      state.audioOn ? Icons.volume_up : Icons.volume_off,
                    ),
                  ),
                ),
                _gap,
                const Text('Music by Mr Smith'),
                _gap,
              ],
            );
          },
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}
