import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/util/misc.dart';

class Leaderboard {
  final List<int> _scores;

  const Leaderboard._(this._scores);

  static Future<Leaderboard> fromJSON(int gridSize) async {
    final List<int> loadedData = await SaveManager.loadLeaderboard(gridSize);

    if (loadedData == null) {
      return Leaderboard._(List(Misc.LEADERBOARD_SIZE));
    }

    return Leaderboard._(loadedData);
  }

  int operator [](int k) => _scores[k];

  int get length => _scores.length;

  int insert(int score, int gridSize) {
    for (int i = 0; i < Misc.LEADERBOARD_SIZE; i++) {
      if ((_scores[i] ?? -1) >= score) continue;

      final List<int> newList = List.of(_scores);

      newList.insert(i, score);
      newList.removeLast();

      SaveManager.saveLeaderboard(
        gridSize,
        newList.asMap().map((key, value) => MapEntry(key.toString(), value)),
      );

      return i;
    }

    return -1;
  }
}
