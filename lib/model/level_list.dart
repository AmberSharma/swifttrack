import 'package:swifttrack/model/level.dart';
//import 'package:swifttrack/model/module_element.dart';

class LevelList {
  final List<ModuleLevel> level;

  LevelList({
    required this.level,
  });

  factory LevelList.fromJson(List<dynamic> parsedJson) {
    List<ModuleLevel> level = <ModuleLevel>[];
    level = parsedJson.map((i) => ModuleLevel.fromJson(i)).toList();

    return LevelList(level: level);
  }
}
