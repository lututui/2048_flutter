import 'dart:convert';
import 'dart:io';

import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:path_provider/path_provider.dart';

class SaveManager {
  SaveManager._();

  static const int VERSION = 2;

  static Future<Directory> get dir async => getApplicationDocumentsDirectory();

  static Future<File> getSaveFile(int gridSize, {bool mustExist = true}) async {
    final String path = (await dir)?.path;

    if (path == null) return null;

    final File f = File("$path/save_$gridSize.json");

    if (!mustExist) return f;

    if (await f.exists()) return f;

    return null;
  }

  static Future<File> save(int gridSize, GridProvider provider) async {
    if (gridSize == null || provider == null) return null;

    return (await getSaveFile(gridSize, mustExist: false))?.writeAsString(
      json.encode(provider.toJSON()..["version"] = SaveManager.VERSION),
    );
  }

  static Future<Tuple<int, List<List<int>>>> load(int gridSize) async {
    final File f = await getSaveFile(gridSize);

    if (f == null) return null;

    final String jsonString = await f.readAsString();

    if (jsonString == null || jsonString.isEmpty) return null;

    final Map<String, dynamic> parsedJson = jsonDecode(jsonString);

    if (parsedJson["version"] as int != VERSION) {
      SaveManager.wipe(gridSize);

      return null;
    }

    return Tuple(
      parsedJson["score"] as int,
      (parsedJson["grid"] as List<dynamic>)
          .map((line) => List<int>.from(line))
          .toList(),
    );
  }

  static Future<FileSystemEntity> wipe(int gridSize) async {
    final File f = await getSaveFile(gridSize);

    if (f == null) return null;

    return f.delete();
  }
}
