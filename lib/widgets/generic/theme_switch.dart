import 'package:flutter/material.dart';
import 'package:flutter_2048/util/colors.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({
    @required this.value,
    @required this.onChanged,
    Key key,
  }) : super(key: key);

  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final bool isDark = themeData.brightness == Brightness.dark;

    final Color activeColor = ColorsUtil.getActiveColor(
      themeData.toggleableActiveColor,
      themeData.scaffoldBackgroundColor,
    );

    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
      activeTrackColor: activeColor.withOpacity(0.5),
      inactiveThumbColor: _getInactiveThumbColor(isDark),
      inactiveTrackColor: _getInactiveTrackColor(isDark),
      focusColor: themeData.focusColor,
      hoverColor: themeData.hoverColor,
    );
  }

  Color _getInactiveThumbColor(bool isDark) {
    if (onChanged != null) {
      return isDark ? Colors.grey.shade400 : Colors.grey.shade50;
    }

    return isDark ? Colors.grey.shade800 : Colors.grey.shade400;
  }

  Color _getInactiveTrackColor(bool isDark) {
    if (onChanged != null) {
      return isDark ? Colors.white30 : Colors.black.withOpacity(0.32);
    }

    return isDark ? Colors.white10 : Colors.black12;
  }
}
