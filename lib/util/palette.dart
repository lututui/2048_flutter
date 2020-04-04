import 'dart:ui';

import 'package:flame/palette.dart';

class Palette {
  static const PaletteEntry lavenderGray = const PaletteEntry(const Color(0xffcfc8cf));
  static const PaletteEntry paleLavender = const PaletteEntry(const Color(0xffd8d8f6));
  static const PaletteEntry x11Gray = const PaletteEntry(const Color(0xffbcb3bc));
  static const PaletteEntry sunsetOrange = const PaletteEntry(const Color(0xfffe5f55));

  static const List<PaletteEntry> colorProgression = const <PaletteEntry>[
    const PaletteEntry(const Color(0xffe8eef2)),
    const PaletteEntry(const Color(0xfff4faff)),
    const PaletteEntry(const Color(0xffeff7cf)),
    const PaletteEntry(const Color(0xffd1bcd1)),
    const PaletteEntry(const Color(0xffd4adcf)),
    const PaletteEntry(const Color(0xff9381ff)),
    const PaletteEntry(const Color(0xffb4e1ff)),
  ];

  static const PaletteEntry lavenderGrayPause = const PaletteEntry(const Color(0x64cfc8cf));

  Palette._();
}