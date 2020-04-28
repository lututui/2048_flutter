import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter_2048/util/data.dart';

class Palette {
  static const Color BOX_BACKGROUND = const Color(0xffcfc8cf);
  static const Color BACKGROUND = const Color(0xffd8d8f6);
  static const Color BOX_BORDER = const Color(0xffbcb3bc);
  static const Color PAUSE_BACKGROUND = const Color(0xcccfc8cf);
  static const Color PROGRESS_INDICATOR_COLOR = const Color(0xfff6f5d8);
  static const Color GAME_OVER_BUTTON_BORDER_COLOR = const Color(0xff9a8c9a);

  static const Color APP_BAR_THEME_COLOR = const Color(0xff8d8de5);
  static const Color TAB_BAR_THEME_COLOR = const Color(0xff222297);
  static const Color MAIN_MENU_BUTTON_BORDER_COLOR = const Color(0xff5151d7);
  static const Color MAIN_MENU_BUTTON_TEXT_COLOR = const Color(0xff2c2cc0);
  static const Color MAIN_MENU_BUTTON_BACKGROUND_COLOR = const Color(0xffb2b2ed);

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

  static const List<Color> TILE_COLORS = const <Color>[
    const Color(0xffe8eef2),
    const Color(0xfff4faff),
    const Color(0xffeff7cf),
    const Color(0xffd1bcd1),
    const Color(0xffd4adcf),
    const Color(0xfff4bbd3),
    const Color(0xffc1b098),
    const Color(0xff928779),
    const Color(0xffa6808c),
    const Color(0xff51344d),
  ];

  static const List<Color> TILE_BORDER_COLORS = const <Color>[
    const Color(0xccabc1d0),
    const Color(0xcc90cdff),
    const Color(0xccd5ea81),
    const Color(0xccb18db1),
    const Color(0xccba7ab1),
    const Color(0xcce871a3),
    const Color(0xcca78f6d),
    const Color(0xcc766c60),
    const Color(0xcc8a616e),
    const Color(0xcc412a3e),
  ];

  static Color getTileColor(int v) {
    return Palette.TILE_COLORS[v % Palette.TILE_COLORS.length];
  }

  static Color getTileBorder(int v) {
    return Palette.TILE_BORDER_COLORS[v % Palette.TILE_BORDER_COLORS.length];
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

  static Color getRandomTileColor() {
    return getTileColor(Data.rand.nextInt(TILE_COLORS.length));
  }

  Palette._();
}
