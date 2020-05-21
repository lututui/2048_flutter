import 'package:flutter_2048/saved_data_manager.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/screens/leaderboard_screen.dart';

/// Provides data to [LeaderboardScreen]
class Leaderboard {
  const Leaderboard._(this._scores, this._savedDataManager);

  final SavedDataManager _savedDataManager;
  final List<int> _scores;

  /// Loads a leaderboard from persistent storage using [_savedDataManager]
  ///
  /// Returns a future that when completed contains an instance of [Leaderboard]
  /// either filled with the loaded data or with an empty leaderboard.
  static Future<Leaderboard> fromJSON(int gridSize) async {
    final baseLeaderboardSave = SavedDataManager.leaderboard(gridSize);
    final baseScores = List<int>(Misc.kLeaderboardSize);

    final Map<String, dynamic> loadedData = await baseLeaderboardSave.load();

    if (loadedData != null) {
      for (final entry in loadedData.entries) {
        baseScores[int.parse(entry.key)] = entry.value as int;
      }
    }

    return Leaderboard._(baseScores, baseLeaderboardSave);
  }

  /// The n-th entry in the leaderboard
  int operator [](int n) => _scores[n];

  /// The size of the leaderboard
  int get length => _scores.length;

  /// Tries to insert a new entry in the leaderboard
  ///
  /// [score] is the final score obtained in a game and [gridSize] is the size
  /// of that game.
  ///
  /// If [score] is great enough to enter the leaderboard, it's inserted such
  /// that the leaderboard list is always sorted by score. Otherwise the
  /// leaderboard remains unchanged.
  ///
  /// Returns the i-th position that [score] was inserted (starting at 0), or -1
  /// if wasn't inserted
  int insert(int score, int gridSize) {
    for (int i = 0; i < Misc.kLeaderboardSize; i++) {
      if ((_scores[i] ?? -1) >= score) continue;

      final List<int> newList = List.of(_scores);

      newList.insert(i, score);
      newList.removeLast();

      _savedDataManager.save(
        newList.asMap().map((key, value) => MapEntry(key.toString(), value)),
      );

      return i;
    }

    return -1;
  }
}
