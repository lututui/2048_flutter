import 'dart:convert';
import 'dart:io';

import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:path_provider/path_provider.dart';

class SaveManager {
  SaveManager._();

  static const int SAVE_VERSION = 2;
  static const int LEADERBOARD_VERSION = 2;

  static Future<Directory> get dir async => getApplicationDocumentsDirectory();

  static Future<File> _getFile(
    int gridSize,
    String prefix, {
    bool mustExist = true,
  }) async {
    final String path = (await dir)?.path;

    if (path == null) return null;

    final File f = File("$path/${prefix}_$gridSize.json");

    if (!mustExist) return f;

    if (await f.exists()) return f;

    return null;
  }

  static Future<File> getSaveFile(int gridSize, {bool mustExist = true}) async {
    return _getFile(gridSize, "save", mustExist: mustExist);
  }

  static Future<File> getLeaderboardFile(
    int gridSize, {
    bool mustExist = true,
  }) async {
    return _getFile(gridSize, "leaderboard", mustExist: mustExist);
  }

  static Future<File> save(int gridSize, GridProvider provider) async {
    if (gridSize == null || provider == null) return null;

    return (await getSaveFile(gridSize, mustExist: false))?.writeAsString(
      json.encode(provider.toJSON()..["version"] = SAVE_VERSION),
    );
  }

  static Future<Tuple<int, List<List<int>>>> load(int gridSize) async {
    final File f = await getSaveFile(gridSize);

    if (f == null) return null;

    final String jsonString = await f.readAsString();

    if (jsonString == null || jsonString.isEmpty) return null;

    final Map<String, dynamic> parsedJson = json.decode(jsonString);

    if (parsedJson["version"] as int != SAVE_VERSION) {
      await wipeSave(gridSize);

      return null;
    }

    return Tuple(
      parsedJson["score"] as int,
      (parsedJson["grid"] as List<dynamic>)
          .map((line) => List<int>.from(line))
          .toList(),
    );
  }

  static Future<FileSystemEntity> wipeSave(int gridSize) async {
    return _wipe(gridSize, "save");
  }

  static Future<FileSystemEntity> wipeLeaderboard(int gridSize) async {
    return _wipe(gridSize, "leaderboard");
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

    final Map<String, dynamic> parsedJson = json.decode(jsonString);

    if (parsedJson["version"] != LEADERBOARD_VERSION) {
      await wipeLeaderboard(gridSize);
      return null;
    }

    parsedJson.remove("version");

    final List<int> scores = List(Data.LEADERBOARD_SIZE);

    parsedJson.forEach((key, value) => scores[int.parse(key)] = value as int);

    return scores;
  }

  static Future<File> saveLeaderboard(
    int gridSize,
    Map<String, int> leaderboard,
  ) async {
    return (await getLeaderboardFile(gridSize, mustExist: false)).writeAsString(
      json.encode(leaderboard..["version"] = LEADERBOARD_VERSION),
    );
  }
}
