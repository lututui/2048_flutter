import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/types/tuple.dart';

class Misc {
  static int _weightSum;
  static List<Tuple<int, int>> _spawnValues = [
    Tuple(0, 10),
    Tuple(1, 20),
    Tuple(2, 5),
  ];
  static const int LEADERBOARD_SIZE = 10;

  static final Random rand = Random();

  static int pickSpawnValue() {
    _weightSum ??= _spawnValues.fold(0, (v, element) => v += element.b);

    return rand.pickWithWeight(_spawnValues, weightSum: _weightSum);
  }

  static Color darkenColor(Color original, {double factor = 0.80}) {
    assert(factor > 0 && factor < 1);

    final HSLColor hslOriginal = HSLColor.fromColor(original);
    final Color result = hslOriginal
        .withLightness(
          factor * hslOriginal.lightness,
        )
        .toColor();

    print([
      "${factor * 100}%: "
          "0x${original.value.toRadixString(16)}, ",
      "0x${result.value.toRadixString(16)}"
    ].join());
    return result;
  }

  static ThemeData buildThemeDataFromColorScheme(
    ColorScheme scheme, {
    String fontFamily,
  }) {
    ThemeData theme = ThemeData.from(colorScheme: scheme);

    theme = theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        brightness: scheme.brightness,
        color: scheme.primary,
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        buttonColor: scheme.primary,
      ),
    );

    if (fontFamily == null || fontFamily.isEmpty) return theme;

    return theme
      ..textTheme.apply(fontFamily: fontFamily)
      ..accentTextTheme.apply(fontFamily: fontFamily)
      ..primaryTextTheme.apply(fontFamily: fontFamily);
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

  Misc._();
}
