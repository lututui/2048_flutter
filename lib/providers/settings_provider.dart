import 'package:flutter/foundation.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  GamePalette _palette = GamePalette.DEFAULT;
  bool _darkMode;

  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    if (value == _darkMode) return;
    _darkMode = value;
    SharedPreferences.getInstance().then(
      (preferences) => preferences.setBool("darkMode", _darkMode),
    );
    notifyListeners();
  }

  GamePalette get palette => _palette;

  set palette(GamePalette value) {
    if (value == _palette) return;
    _palette = value;
    SharedPreferences.getInstance().then(
      (preferences) => preferences.setString(
        "palette",
        _palette.name.toLowerCase(),
      ),
    );
    notifyListeners();
  }
}
