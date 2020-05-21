import 'dart:ui';

/// The color of a game tile
class TileColor {
  /// Creates a new tile color
  const TileColor(this.backgroundColor, this.borderColor);

  /// The main color
  final Color backgroundColor;

  /// The color used to decorate the tile border
  ///
  /// Usually, this color is darker than the background color
  final Color borderColor;
}
