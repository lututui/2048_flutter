import 'dart:ui';

import 'package:flutter_2048/types/tile_color.dart';

/// A collection of [TileColor]s
class GamePalette {
  const GamePalette._(this.name, this.tileColors);

  /// The proper list of colors
  ///
  /// The higher the index, the higher the associated value
  final List<TileColor> tileColors;

  /// The name of this palette
  final String name;

  /// Gets a tile color for the tile with value [v]
  TileColor getTileColor(int v) {
    return tileColors[v % tileColors.length];
  }

  /// The default palette
  static const GamePalette classic = GamePalette._(
    'Classic',
    <TileColor>[
      TileColor(Color(0xff928779), Color(0xff766c60)),
      TileColor(Color(0xffc1b098), Color(0xffa78f6d)),
      TileColor(Color(0xffeff7cf), Color(0xffd5ea81)),
      TileColor(Color(0xffe8eef2), Color(0xffabc1d0)),
      TileColor(Color(0xfff4faff), Color(0xff90cdff)),
      TileColor(Color(0xffd1bcd1), Color(0xffb18db1)),
      TileColor(Color(0xffd4adcf), Color(0xffba7ab1)),
      TileColor(Color(0xff51344d), Color(0xff412a3e)),
      TileColor(Color(0xfff4bbd3), Color(0xffe871a3)),
      TileColor(Color(0xffa6808c), Color(0xff8a616e)),
    ],
  );

  /// A palette inspired by the Dracula Theme
  ///
  /// https://draculatheme.com/
  static const GamePalette dracula = GamePalette._(
    'Dracula',
    <TileColor>[
      TileColor(Color(0xffff5555), Color(0xffff1111)),
      TileColor(Color(0xffffb86c), Color(0xffff9523)),
      TileColor(Color(0xfff8f8f2), Color(0xffd6d6b2)),
      TileColor(Color(0xfff1fa8c), Color(0xffe8f741)),
      TileColor(Color(0xff50fa7b), Color(0xff10f84b)),
      TileColor(Color(0xff8be9fd), Color(0xff3edafc)),
      TileColor(Color(0xff6272a4), Color(0xff4d5a85)),
      TileColor(Color(0xff282a36), Color(0xff20222b)),
      TileColor(Color(0xff44475a), Color(0xff363948)),
      TileColor(Color(0xffbd93f9), Color(0xff8f48f5)),
      TileColor(Color(0xffff79c6), Color(0xffff2ea6)),
    ],
  );
}
