import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_game_card/blocs/blocs.dart';
import 'package:flutter_game_card/config/config.dart';
import 'package:flutter_game_card/cubits/cubits.dart';
import 'package:flutter_game_card/helpers/helpers.dart';
import 'package:flutter_game_card/models/palette.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  runApp(const CardGame());
}

class CardGame extends StatelessWidget {
  const CardGame({super.key});

  @override
  Widget build(BuildContext context) {
    Palette palette = Palette();

    return AppLifecycleObserver(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AudioCubit()..initializeAudio(),
          ),
          BlocProvider(
            create: (context) => PlayerProgressBloc(),
          ),
          BlocProvider(
            create: (context) => SettingsBloc(
              appLifecycleNotifier: context.read<AppLifecycleStateNotifier>(),
              audioCubit: context.read<AudioCubit>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'My Flutter Game',
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Palette().darkPen,
              surface: palette.backgroundMain,
            ),
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: palette.ink),
            ),
            useMaterial3: true,
          ).copyWith(
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          routerConfig: router,
        ),
        // child: BlocBuilder<PaletteCubit, PaletteState>(
        //   builder: (context, state) {
        //     return MaterialApp.router(
        //       title: 'My Flutter Game',
        //       theme: ThemeData.from(
        //         colorScheme: ColorScheme.fromSeed(
        //           seedColor: state.palette.darkPen,
        //           surface: state.palette.backgroundMain,
        //         ),
        //         textTheme: TextTheme(
        //           bodyMedium: TextStyle(color: state.palette.ink),
        //         ),
        //         useMaterial3: true,
        //       ).copyWith(
        //         filledButtonTheme: FilledButtonThemeData(
        //           style: FilledButton.styleFrom(
        //             textStyle: const TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 20,
        //             ),
        //           ),
        //         ),
        //       ),
        //       routerConfig: router,
        //     );
        //   },
        // ),
      ),
    );
  }
}
