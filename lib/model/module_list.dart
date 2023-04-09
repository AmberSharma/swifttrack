import 'package:swifttrack/model/module.dart';

class ModuleList {
  final List<Module> module;

  ModuleList({
    required this.module,
  });

  factory ModuleList.fromJson(List<dynamic> parsedJson) {
    List<Module> module = <Module>[];
    module = parsedJson.map((i) => Module.fromJson(i)).toList();

    return ModuleList(module: module);
  }
}
