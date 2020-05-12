import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/types/tuple.dart';

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

  static ThemeData buildThemeData({
    @required ColorScheme scheme,
    @required String fontFamily,
  }) {
    final ThemeData theme = ThemeData.from(colorScheme: scheme);

    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        brightness: scheme.brightness,
        color: scheme.primary,
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        buttonColor: scheme.primary,
      ),
      textTheme: theme.textTheme.apply(fontFamily: fontFamily),
      primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: fontFamily),
      accentTextTheme: theme.accentTextTheme.apply(fontFamily: fontFamily),
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
