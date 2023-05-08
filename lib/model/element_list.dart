import 'package:swifttrack/model/module_element.dart';

class ElementList {
  final List<ModuleElement> moduleElement;

  ElementList({
    required this.moduleElement,
  });

  factory ElementList.fromJson(List<dynamic> parsedJson) {
    List<ModuleElement> moduleElement = <ModuleElement>[];
    moduleElement = parsedJson.map((i) => ModuleElement.fromJson(i)).toList();

    return ElementList(moduleElement: moduleElement);
  }
}
