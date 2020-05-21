import 'dart:convert';
import 'dart:io';

import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:path_provider/path_provider.dart';

/// Saves/retrieves persistent data
class SavedDataManager {
  SavedDataManager._(this._prefix, this._version, this._gridSize);

  /// Creates a new manager used by a [Leaderboard] of given [gridSize]
  factory SavedDataManager.leaderboard(int gridSize) {
    return SavedDataManager._('leaderboard', 2, gridSize);
  }

  /// Creates a new manager used by a [GridProvider] of given [gridSize]
  factory SavedDataManager.grid(int gridSize) {
    return SavedDataManager._('save', 2, gridSize);
  }

  final String _prefix;
  final int _gridSize;
  final int _version;

  @override
  String toString() {
    return 'SavedDataManager($_prefix, version: $_version, size: $_gridSize)';
  }

  static Future<Directory> get _dir async => getApplicationDocumentsDirectory();

  /// Saves the given [data] as JSON to persistent storage
  Future<File> save(Map<String, dynamic> data) async {
    final File f = await _getFile(mustExist: false);

    if (f == null) return null;

    return f.writeAsString(json.encode(data..['version'] = _version));
  }

  Future<File> _getFile({bool mustExist = true}) async {
    final String path = (await _dir)?.path;

    if (path == null) return null;

    final String filePath = '$path/${_prefix}_$_gridSize.json';
    final bool exists = !mustExist ||
        await FileSystemEntity.type(filePath) != FileSystemEntityType.notFound;

    if (exists) {
      return File(filePath);
    }

    return null;
  }

  /// Loads JSON data from persistent storage
  Future<Map<String, dynamic>> load() async {
    final File f = await _getFile();

    if (f == null) return null;

    final String jsonString = await f.readAsString();

    if (jsonString == null || jsonString.isEmpty) return null;

    final parsedJson = json.decode(jsonString) as Map<String, dynamic>;

    if (!parsedJson.containsKey('version') ||
        parsedJson.remove('version') as int != _version) {
      await wipe();

      return null;
    }

    return parsedJson;
  }

  /// Deletes this save file
  Future<FileSystemEntity> wipe() async {
    final File f = await _getFile();

    if (f == null) return null;

    return f.delete();
  }
}
