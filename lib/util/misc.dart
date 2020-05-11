import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/types/tuple.dart';

class Misc {
  Misc._();

  static int _weightSum;
  static final List<Tuple<int, int>> _spawnValues = [
    Tuple(0, 10),
    Tuple(1, 20),
    Tuple(2, 5),
  ];
  static const int leaderboardSize = 10;

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

    Logger.log<Misc>(
      '${factor * 100}%: 0x${original.value.toRadixString(16)}, '
      '0x${result.value.toRadixString(16)}',
    );
    return result;
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

  static final Map<Color, double> luminanceMap = {};

  static Color calculateTextColor(Color backgroundColor) {
    final double luminance = luminanceMap.putIfAbsent(
      backgroundColor,
      () => backgroundColor.computeLuminance(),
    );

    if ((luminance + 0.05) * (luminance + 0.05) > 0.0525) {
      return Colors.black;
    }

    return Colors.white;
  }
}

extension ColorBrightness on Color {
  Brightness estimateBrightness() {
    return ThemeData.estimateBrightnessForColor(this);
  }
}
