import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_2048/types/game_palette.dart';

/// The collection of colors used by this app
class Palette {
  Palette._();

  /// All [GamePalette]s available
  static const List<GamePalette> gamePalettes = [
    GamePalette.classic,
    GamePalette.dracula,
  ];

  /// Returns the [GamePalette] with the given name
  ///
  /// If no palette is found, returns null
  static GamePalette getGamePaletteByName(String name) {
    if (name == null) return null;

    final lowerCaseName = name.toLowerCase();

    for (final gamePalette in gamePalettes) {
      if (gamePalette.name.toLowerCase() == lowerCaseName) {
        return gamePalette;
      }
    }

    return null;
  }

  /// A [LinearGradient] of silver shades
  static const Gradient silverGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xff70706f),
      Color(0xff7d7d7a),
      Color(0xff8e8d8d),
      Color(0xffa1a2a3),
      Color(0xffb3b6b5),
      Color(0xffbec0c2),
    ],
    stops: <double>[0, 0.20, 0.40, 0.60, 0.80, 1],
  );

  /// A [LinearGradient] of golden shades
  static const Gradient goldenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xffe7a220),
      Color(0xfffdcc33),
      Color(0xffffdf00),
      Color(0xfffdbf1c),
      Color(0xffc27d00),
      Color(0xff996515),
    ],
    stops: <double>[0, 0.20, 0.40, 0.60, 0.80, 1],
  );

  /// The [ColorScheme] used to build the [ThemeData] with light brightness
  static const ColorScheme lightTheme = ColorScheme(
    primary: Color(0xfff6f5d8),
    primaryVariant: Color(0xffc3c2a7),
    secondary: Color(0xffcfc8cf),
    secondaryVariant: Color(0xff9e979e),
    surface: Color(0xffe2d0be),
    background: Color(0xffe2d0be),
    error: Color(0xffd33f49),
    onPrimary: Color(0xff000000),
    onSecondary: Color(0xff000000),
    onSurface: Color(0xff000000),
    onBackground: Color(0xff000000),
    onError: Color(0xffffffff),
    brightness: Brightness.light,
  );

  /// The [ColorScheme] used to build the [ThemeData] with dark brightness
  static const ColorScheme darkTheme = ColorScheme(
    primary: Color(0xff395756),
    primaryVariant: Color(0xff002715),
    secondary: Color(0xff6d5959),
    secondaryVariant: Color(0xff80413e),
    surface: Color(0xff404040),
    background: Color(0xff666666),
    error: Color(0xff550c18),
    onPrimary: Color(0xffe8e8e8),
    onSecondary: Color(0xffececec),
    onSurface: Color(0xffdadfe1),
    onBackground: Color(0xffdadfe1),
    onError: Color(0xffeeeeee),
    brightness: Brightness.dark,
  );
}
