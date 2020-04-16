import 'dart:ui';

class Palette {
  static const Color BOX_BACKGROUND = const Color(0xffcfc8cf);
  static const Color BACKGROUND = const Color(0xffd8d8f6);
  static const Color BOX_BORDER = const Color(0xffbcb3bc);
  static const Color PAUSE_BACKGROUND = const Color(0x64cfc8cf);

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

  static Color getTileColor(int value) {
    return Palette.TILE_COLORS[value % Palette.TILE_COLORS.length];
  }

  Palette._();
}
