import 'dart:convert';
import 'dart:io';

import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:path_provider/path_provider.dart';

class SaveManager {
  SaveManager._();

  static const int _saveVersion = 2;
  static const int _leaderboardVersion = 2;

  static Future<Directory> get dir async => getApplicationDocumentsDirectory();

  static Future<File> _getFile(
    int gridSize,
    String prefix, {
    bool mustExist = true,
  }) async {
    final String path = (await dir)?.path;

    if (path == null) return null;

    final File f = File('$path/${prefix}_$gridSize.json');

    if (!mustExist) return f;

    if (await f.exists()) return f;

    return null;
  }

  static Future<File> getSaveFile(int gridSize, {bool mustExist = true}) async {
    return _getFile(gridSize, 'save', mustExist: mustExist);
  }

  static Future<File> getLeaderboardFile(
    int gridSize, {
    bool mustExist = true,
  }) async {
    return _getFile(gridSize, 'leaderboard', mustExist: mustExist);
  }

  static Future<File> save(int gridSize, GridProvider provider) async {
    if (gridSize == null || provider == null) return null;

    return (await getSaveFile(gridSize, mustExist: false))?.writeAsString(
      json.encode(provider.toJSON()..['version'] = _saveVersion),
    );
  }

  static Future<Tuple<int, List<List<int>>>> load(int gridSize) async {
    final File f = await getSaveFile(gridSize);

    if (f == null) return null;

    final String jsonString = await f.readAsString();

    if (jsonString == null || jsonString.isEmpty) return null;

    final Map<String, dynamic> parsedJson =
        json.decode(jsonString) as Map<String, dynamic>;

    if (parsedJson['version'] as int != _saveVersion) {
      await wipeSave(gridSize);

      return null;
    }

    return Tuple(
      parsedJson['score'] as int,
      (parsedJson['grid'] as List<dynamic>)
          .map((line) => List<int>.from(line as Iterable))
          .toList(),
    );
  }

  static Future<FileSystemEntity> wipeSave(int gridSize) async {
    return _wipe(gridSize, 'save');
  }

  static Future<FileSystemEntity> wipeLeaderboard(int gridSize) async {
    return _wipe(gridSize, 'leaderboard');
  }

  static Future<FileSystemEntity> _wipe(int gridSize, String prefix) async {
    final File f = await _getFile(gridSize, prefix);

    if (f == null) return null;

    return f.delete();
  }

  static Future<List<int>> loadLeaderboard(int gridSize) async {
    final File f = await getLeaderboardFile(gridSize);

    if (f == null) return null;

    final String jsonString = await f.readAsString();

    if (jsonString == null || jsonString.isEmpty) return null;

    final Map<String, dynamic> parsedJson =
        json.decode(jsonString) as Map<String, dynamic>;

    if (parsedJson['version'] != _leaderboardVersion) {
      await wipeLeaderboard(gridSize);
      return null;
    }

    parsedJson.remove('version');

    final List<int> scores = List(Misc.leaderboardSize);

    parsedJson.forEach((key, value) => scores[int.parse(key)] = value as int);

    return scores;
  }

  static Future<File> saveLeaderboard(
    int gridSize,
    Map<String, int> leaderboard,
  ) async {
    return (await getLeaderboardFile(gridSize, mustExist: false)).writeAsString(
      json.encode(leaderboard..['version'] = _leaderboardVersion),
    );
  }
}
