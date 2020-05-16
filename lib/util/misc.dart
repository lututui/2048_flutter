import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/types/fonts.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/tile_loading_indicator.dart';

export 'package:flutter_2048/types/extensions.dart';

class Misc {
  Misc._();

  static const int kLeaderboardSize = 10;

  static final Random rand = Random();
  static final Map<Brightness, ThemeData> themes = {
    Brightness.dark: _buildThemeData(Palette.darkTheme),
    Brightness.light: _buildThemeData(Palette.lightTheme),
  };

  static ThemeData _buildThemeData(ColorScheme scheme) {
    final ThemeData theme = ThemeData.from(colorScheme: scheme);

    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        brightness: scheme.brightness,
        color: scheme.primary,
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        buttonColor: scheme.primary,
      ),
      textTheme: theme.textTheme.apply(fontFamily: Fonts.righteousFamily),
      primaryTextTheme: theme.primaryTextTheme.apply(
        fontFamily: Fonts.righteousFamily,
      ),
      accentTextTheme: theme.accentTextTheme.apply(
        fontFamily: Fonts.righteousFamily,
      ),
    );
  }

  static Widget buildLoadingWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => TileLoadingIndicator.fromBoxConstraints(
        constraints,
      ),
    );
  }

  static Widget buildDefaultMaterialApp(
    BuildContext context, {
    WidgetBuilder childBuilder,
  }) {
    return MaterialApp(
      theme: themes[Brightness.light],
      darkTheme: themes[Brightness.dark],
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: childBuilder?.call(context) ?? Container()),
    );
  }
}
