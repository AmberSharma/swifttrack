// import 'package:swifttrack/model/module.dart';

class ModuleLevel {
  final String level;
  final String name;
  final String color;
  final int selectable;

  //final List<Module> module;

  ModuleLevel({
    required this.level,
    required this.name,
    required this.color,
    required this.selectable,
  });

  factory ModuleLevel.fromJson(Map<String, dynamic> data) {
    print(data);
    // final moduleData = data['elements'] as List<dynamic>?;
    // final module = moduleData != null
    //     ? moduleData.map((moduleData) => Module.fromJson(moduleData)).toList()
    //     : <Module>[];
    return ModuleLevel(
      level: data["level"],
      name: data["name"],
      color: data["color"].replaceAll(RegExp('#'), '0xff'),
      selectable: data["selectable"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'name': name,
      'color': color,
      'selectable': selectable,
    };
  }
}
