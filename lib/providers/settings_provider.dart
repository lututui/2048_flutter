import 'package:flutter/foundation.dart';
import 'package:flutter_2048/types/game_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  GamePalette _palette = GamePalette.classic;
  bool _darkMode;

  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    ArgumentError.checkNotNull(value, 'darkMode');

    if (value == _darkMode) return;

    if (_darkMode != null) {
      _darkMode = value;

      SharedPreferences.getInstance().then(
        (preferences) => preferences.setBool('darkMode', _darkMode),
      );

      notifyListeners();
    } else {
      _darkMode = value;
    }
  }

  GamePalette get palette => _palette;

  set palette(GamePalette value) {
    ArgumentError.checkNotNull(value, 'palette');

    if (value == _palette) return;

    _palette = value;
    SharedPreferences.getInstance().then(
      (preferences) => preferences.setString(
        'palette',
        _palette.name.toLowerCase(),
      ),
    );
    notifyListeners();
  }
}
