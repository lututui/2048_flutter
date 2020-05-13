import 'package:flutter/foundation.dart';
import 'package:flutter_2048/types/game_palette.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SettingsProvider.load(SharedPreferences preferences) {
    _palette = Palette.getGamePaletteByName(preferences.getString('palette'));
    _darkMode = preferences.getBool('darkMode') ?? false;
    _autoReset = preferences.getBool('autoReset') ?? true;
  }

  GamePalette _palette = GamePalette.classic;
  bool _darkMode;
  bool _autoReset = true;

  void _savePreference(String name, dynamic value) {
    SharedPreferences.getInstance().then((preferences) {
      if (value is bool) {
        preferences.setBool(name, value);
      } else if (value is String) {
        preferences.setString(name, value);
      } else if (value is int) {
        preferences.setInt(name, value);
      } else if (value is double) {
        preferences.setDouble(name, value);
      } else if (value is List<String>) {
        preferences.setStringList(name, value);
      } else {
        throw Exception('${value.runtimeType} may not be saved directly');
      }
    });
  }

  ChangeNotifierProvider<SettingsProvider> get changeNotifierProvider {
    return ChangeNotifierProvider.value(value: this);
  }

  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    ArgumentError.checkNotNull(value, 'darkMode');

    if (value == _darkMode) return;

    if (_darkMode != null) {
      _darkMode = value;

      _savePreference('darkMode', _darkMode);
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

    _savePreference('palette', _palette.name.toLowerCase());
    notifyListeners();
  }

  bool get autoReset => _autoReset;

  set autoReset(bool value) {
    ArgumentError.checkNotNull(value, 'auto reset');

    if (value == _autoReset) return;

    _autoReset = value;

    _savePreference('autoReset', _autoReset);
    notifyListeners();
  }
}
