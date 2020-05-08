import 'dart:ui';

import 'package:flutter/material.dart';

class TileColor {
  final Color backgroundColor;
  final Color borderColor;

  const TileColor(this.backgroundColor, this.borderColor);
}

class GamePalette {
  final List<TileColor> tileColors;
  final String name;

  const GamePalette(this.name, this.tileColors);

  TileColor getTileColor(int v) {
    return this.tileColors[v % this.tileColors.length];
  }

  static const GamePalette DEFAULT = const GamePalette(
    "Classic",
    const <TileColor>[
      const TileColor(const Color(0xff928779), const Color(0xff766c60)),
      const TileColor(const Color(0xffc1b098), const Color(0xffa78f6d)),
      const TileColor(const Color(0xffeff7cf), const Color(0xffd5ea81)),
      const TileColor(const Color(0xffe8eef2), const Color(0xffabc1d0)),
      const TileColor(const Color(0xfff4faff), const Color(0xff90cdff)),
      const TileColor(const Color(0xffd1bcd1), const Color(0xffb18db1)),
      const TileColor(const Color(0xffd4adcf), const Color(0xffba7ab1)),
      const TileColor(const Color(0xff51344d), const Color(0xff412a3e)),
      const TileColor(const Color(0xfff4bbd3), const Color(0xffe871a3)),
      const TileColor(const Color(0xffa6808c), const Color(0xff8a616e)),
    ],
  );

  static const GamePalette DRACULA = const GamePalette(
    "Dracula",
    const <TileColor>[
      const TileColor(const Color(0xffff5555), const Color(0xffff1111)),
      const TileColor(const Color(0xffffb86c), const Color(0xffff9523)),
      const TileColor(const Color(0xfff8f8f2), const Color(0xffd6d6b2)),
      const TileColor(const Color(0xfff1fa8c), const Color(0xffe8f741)),
      const TileColor(const Color(0xff50fa7b), const Color(0xff10f84b)),
      const TileColor(const Color(0xff8be9fd), const Color(0xff3edafc)),
      const TileColor(const Color(0xff6272a4), const Color(0xff4d5a85)),
      const TileColor(const Color(0xff282a36), const Color(0xff20222b)),
      const TileColor(const Color(0xff44475a), const Color(0xff363948)),
      const TileColor(const Color(0xffbd93f9), const Color(0xff8f48f5)),
      const TileColor(const Color(0xffff79c6), const Color(0xffff2ea6)),
    ],
  );
}

class Palette {
  static const List<GamePalette> GAME_PALETTES = const [
    GamePalette.DEFAULT,
    GamePalette.DRACULA,
  ];

  static GamePalette getGamePaletteByName(String name) {
    final Map<String, GamePalette> namePaletteMap = Map.fromIterable(
      Palette.GAME_PALETTES,
      key: (element) => (element as GamePalette).name.toLowerCase(),
    );

    if (namePaletteMap.containsKey(name)) {
      return namePaletteMap[name];
    }

    return GamePalette.DEFAULT;
  }

  static const Gradient SILVER_GRADIENT = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: const <Color>[
      const Color(0xff70706f),
      const Color(0xff7d7d7a),
      const Color(0xff8e8d8d),
      const Color(0xffa1a2a3),
      const Color(0xffb3b6b5),
      const Color(0xffbec0c2),
    ],
    stops: const <double>[0, 0.20, 0.40, 0.60, 0.80, 1],
  );

  static const Gradient GOLDEN_GRADIENT = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: const <Color>[
      const Color(0xffe7a220),
      const Color(0xfffdcc33),
      const Color(0xffffdf00),
      const Color(0xfffdbf1c),
      const Color(0xffc27d00),
      const Color(0xff996515),
    ],
    stops: const <double>[0, 0.20, 0.40, 0.60, 0.80, 1],
  );

  static const ColorScheme LIGHT_THEME = const ColorScheme(
    primary: const Color(0xfff6f5d8),
    primaryVariant: const Color(0xffc3c2a7),
    secondary: const Color(0xffcfc8cf),
    secondaryVariant: const Color(0xff9e979e),
    surface: const Color(0xffe2d0be),
    background: const Color(0xffe2d0be),
    error: const Color(0xffd33f49),
    onPrimary: const Color(0xff000000),
    onSecondary: const Color(0xff000000),
    onSurface: const Color(0xff000000),
    onBackground: const Color(0xff000000),
    onError: const Color(0xffffffff),
    brightness: Brightness.light,
  );

  static const ColorScheme DARK_THEME = const ColorScheme(
    primary: const Color(0xff395756),
    primaryVariant: const Color(0xff002715),
    secondary: const Color(0xff6d5959),
    secondaryVariant: const Color(0xff80413e),
    surface: const Color(0xff404040),
    background: const Color(0xff404040),
    error: const Color(0xff550c18),
    onPrimary: const Color(0xffe8e8e8),
    onSecondary: const Color(0xffececec),
    onSurface: const Color(0xffdadfe1),
    onBackground: const Color(0xffdadfe1),
    onError: const Color(0xffeeeeee),
    brightness: Brightness.dark,
  );

  Palette._();
}
