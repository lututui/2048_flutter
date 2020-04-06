import 'dart:ui';

import 'package:flame/palette.dart';

class Palette {
  static const PaletteEntry BOX_BACKGROUND = const PaletteEntry(
    const Color(0xffcfc8cf),
  );
  static const PaletteEntry BACKGROUND = const PaletteEntry(
    const Color(0xffd8d8f6),
  );
  static const PaletteEntry BOX_BORDER = const PaletteEntry(
    const Color(0xffbcb3bc),
  );
  static const PaletteEntry PAUSE_BACKGROUND = const PaletteEntry(
    const Color(0x64cfc8cf),
  );

  static const List<PaletteEntry> TILE_COLORS = const <PaletteEntry>[
    const PaletteEntry(const Color(0xffe8eef2)),
    const PaletteEntry(const Color(0xfff4faff)),
    const PaletteEntry(const Color(0xffeff7cf)),
    const PaletteEntry(const Color(0xffd1bcd1)),
    const PaletteEntry(const Color(0xffd4adcf)),
    const PaletteEntry(const Color(0xfff4bbd3)),
    const PaletteEntry(const Color(0xffc1b098)),
    const PaletteEntry(const Color(0xff928779)),
    const PaletteEntry(const Color(0xffa6808c)),
    const PaletteEntry(const Color(0xff51344d)),
  ];

  Palette._();
}
