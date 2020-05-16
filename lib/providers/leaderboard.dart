import 'package:flutter_2048/save_state.dart';
import 'package:flutter_2048/util/misc.dart';

class Leaderboard {
  const Leaderboard._(this._scores, this.saveState);

  final SaveState saveState;
  final List<int> _scores;

  static Future<Leaderboard> fromJSON(int gridSize) async {
    final baseLeaderboardSave = SaveState.leaderboard(gridSize);
    final baseScores = List<int>(Misc.kLeaderboardSize);

    final Map<String, dynamic> loadedData = await baseLeaderboardSave.load();

    if (loadedData != null) {
      for (final entry in loadedData.entries) {
        baseScores[int.parse(entry.key)] = entry.value as int;
      }
    }

    return Leaderboard._(baseScores, baseLeaderboardSave);
  }

  int operator [](int k) => _scores[k];

  int get length => _scores.length;

  int insert(int score, int gridSize) {
    for (int i = 0; i < Misc.kLeaderboardSize; i++) {
      if ((_scores[i] ?? -1) >= score) continue;

      final List<int> newList = List.of(_scores);

      newList.insert(i, score);
      newList.removeLast();

      saveState.save(
        newList.asMap().map((key, value) => MapEntry(key.toString(), value)),
      );

      return i;
    }

    return -1;
  }
}
