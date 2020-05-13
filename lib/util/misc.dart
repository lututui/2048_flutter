import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/types/fonts.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/util/palette.dart';

class Misc {
  Misc._();

  static int _weightSum;
  static final List<Tuple<int, int>> _spawnValues = [
    Tuple(0, 15),
    Tuple(1, 12),
    Tuple(2, 3),
  ];
  static const int leaderboardSize = 10;

  static final Random rand = Random();

  static int pickSpawnValue() {
    _weightSum ??= _spawnValues.fold(0, (v, element) => v += element.b);

    return rand.pickWithWeight(_spawnValues, weightSum: _weightSum);
  }

  static final Map<Brightness, ThemeData> themes = {
    Brightness.dark: _buildThemeData(Palette.darkTheme),
    Brightness.light: _buildThemeData(Palette.lightTheme),
  };

  static ThemeData _buildThemeData(ColorScheme scheme) {
    final ThemeData theme = ThemeData.from(colorScheme: scheme);

    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        brightness: scheme.brightness,
        color: scheme.primary,
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        buttonColor: scheme.primary,
      ),
      textTheme: theme.textTheme.apply(fontFamily: Fonts.righteousFamily),
      primaryTextTheme: theme.primaryTextTheme.apply(
        fontFamily: Fonts.righteousFamily,
      ),
      accentTextTheme: theme.accentTextTheme.apply(
        fontFamily: Fonts.righteousFamily,
      ),
    );
  }

  static CircularProgressIndicator getDefaultProgressIndicator(
    BuildContext context,
  ) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
