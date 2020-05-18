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

  static Future<T> showDialog<T>({
    @required BuildContext context,
    @required WidgetBuilder builder,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    Duration duration = const Duration(milliseconds: 300),
    RouteSettings routeSettings,
  }) {
    assert(debugCheckHasMaterialLocalizations(context));

    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Builder(
            builder: (context) {
              final themeData = Theme.of(context, shadowThemeOnly: true);

              if (themeData == null) {
                return Builder(builder: builder);
              }

              return Theme(data: themeData, child: Builder(builder: builder));
            },
          ),
        );
      },
      barrierDismissible: barrierDismissible ?? true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      transitionBuilder: (context, inAnimation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: inAnimation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      useRootNavigator: useRootNavigator ?? true,
      routeSettings: routeSettings,
    );
  }
}
