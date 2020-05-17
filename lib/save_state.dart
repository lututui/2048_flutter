import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

class SaveState {
  SaveState._({
    @required this.prefix,
    @required this.version,
    @required this.gridSize,
  });

  factory SaveState.leaderboard(int gridSize) {
    return SaveState._(prefix: 'leaderboard', version: 2, gridSize: gridSize);
  }

  factory SaveState.grid(int gridSize) {
    return SaveState._(prefix: 'save', version: 2, gridSize: gridSize);
  }

  final String prefix;
  final int gridSize;
  final int version;


  @override
  String toString() {
    return 'SaveState($prefix, version: $version, size: $gridSize)';
  }

  static Future<Directory> get dir async => getApplicationDocumentsDirectory();

  Future<File> save(Map<String, dynamic> data) async {
    final File f = await getFile(mustExist: false);

    if (f == null) return null;

    return f.writeAsString(json.encode(data..['version'] = version));
  }

  Future<File> getFile({bool mustExist = true}) async {
    final String path = (await dir)?.path;

    if (path == null) return null;

    final String filePath = '$path/${prefix}_$gridSize.json';
    final bool exists = !mustExist ||
        await FileSystemEntity.type(filePath) != FileSystemEntityType.notFound;

    if (exists) {
      return File(filePath);
    }

    return null;
  }

  Future<Map<String, dynamic>> load() async {
    final File f = await getFile();

    if (f == null) return null;

    final String jsonString = await f.readAsString();

    if (jsonString == null || jsonString.isEmpty) return null;

    final parsedJson = json.decode(jsonString) as Map<String, dynamic>;

    if (!parsedJson.containsKey('version') ||
        parsedJson.remove('version') as int != version) {
      await wipe();

      return null;
    }

    return parsedJson;
  }

  Future<FileSystemEntity> wipe() async {
    final File f = await getFile();

    if (f == null) return null;

    return f.delete();
  }
}
