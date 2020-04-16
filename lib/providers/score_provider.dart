import 'package:flutter/foundation.dart';

class ScoreProvider with ChangeNotifier {
  int _score;

  ScoreProvider(this._score);

  int get value => _score;

  set value(int value) {
    if (_score == value) return;
    _score = value;
    notifyListeners();
  }
}
