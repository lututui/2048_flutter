import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_2048/logger.dart';

/// Color-related utility functions
class ColorsUtil {
  ColorsUtil._();

  static final Map<Color, double> _luminanceMap = {};
  static final Map<Color, Brightness> _brightnessMap = {};

  /// Darkens a color by a factor between 0 and 1
  static Color darkenColor(Color original, {double factor = 0.80}) {
    assert(factor > 0 && factor < 1);

    final HSLColor hslOriginal = HSLColor.fromColor(original);
    final Color result =
        hslOriginal.withLightness(factor * hslOriginal.lightness).toColor();

    Logger.log<Colors>(
      'darken ${((1 - factor) * 100).toStringAsFixed(2)}%: '
      '0x${original.value.toRadixString(16)}, '
      '0x${result.value.toRadixString(16)}',
    );

    return result;
  }

  /// Lighten color by a factor between 0 and 1
  static Color lightenColor(Color original, {double factor = 0.80}) {
    assert(factor > 0 && factor < 1);

    final HSLColor hslOriginal = HSLColor.fromColor(original);
    final Color result = hslOriginal
        .withLightness(factor * (1 - hslOriginal.lightness))
        .toColor();

    Logger.log<Colors>(
      'lighten ${(factor * 100).toStringAsFixed(2)}%: '
      '0x${original.value.toRadixString(16)}, '
      '0x${result.value.toRadixString(16)}',
    );

    return result;
  }

  /// Computes the luminance value for the given color
  ///
  /// The luminance value is cached
  static double getLuminance(Color color) {
    return _luminanceMap.putIfAbsent(color, () => color.computeLuminance());
  }

  /// Sorts a list of colors by their luminance
  static void sortByLuminance(List<Color> original) {
    original.sort((a, b) => getLuminance(a).compareTo(getLuminance(b)));
  }

  /// Gets the contrast ratio between two colors
  static double contrastRatio(Color foreground, Color background) {
    final colors = [foreground, background];

    sortByLuminance(colors);

    return (getLuminance(colors[1]) + 0.05) / (getLuminance(colors[0]) + 0.05);
  }

  /// Gets the [Brightness] value of a color
  ///
  /// The brightness value is cached
  static Brightness getBrightness(Color color) {
    return _brightnessMap.putIfAbsent(color, () {
      final double luminance = getLuminance(color);

      if ((luminance + 0.05) * (luminance + 0.05) > 0.0525) {
        return Brightness.light;
      }

      return Brightness.dark;
    });
  }

  /// If this color is considered [Brightness.dark]
  static bool isDark(Color color) {
    return getBrightness(color) == Brightness.dark;
  }

  /// Which color should be used by text rendered on top of [backgroundColor]
  static Color calculateTextColor(Color backgroundColor) {
    if (isDark(backgroundColor)) {
      return Colors.white;
    }

    return Colors.black;
  }

  /// Adjusts [original] to meet WCAG minimum contrast (AA level)
  static Color adjustColor(Color original, Color background) {
    final bool meetsRequirement = contrastRatio(original, background) >= 4.5;

    if (meetsRequirement) {
      return original;
    }

    final bool isDarkBackground = isDark(background);
    final Color newColor =
        isDarkBackground ? lightenColor(original) : darkenColor(original);

    if (contrastRatio(newColor, background) < 4.5) {
      return isDarkBackground ? Colors.white : Colors.black;
    }

    return newColor;
  }
}
