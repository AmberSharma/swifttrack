// import 'package:swifttrack/model/module.dart';

class ModuleElement {
  final String uuid;
  final String type;
  final String? label;
  final String content;
  final String duration;
  final String? durationSuffix;
  final int? points;
  int? setLevel;
  //final List<Module> module;

  ModuleElement(
      {required this.uuid,
      required this.type,
      required this.label,
      required this.content,
      required this.duration,
      required this.durationSuffix,
      required this.points,
      required this.setLevel});

  factory ModuleElement.fromJson(Map<String, dynamic> data) {
    print(data);
    // final moduleData = data['elements'] as List<dynamic>?;
    // final module = moduleData != null
    //     ? moduleData.map((moduleData) => Module.fromJson(moduleData)).toList()
    //     : <Module>[];
    return ModuleElement(
        uuid: data["uuid"],
        type: data["type"],
        label: data["label"],
        content: data["content"],
        duration: data["duration"] ?? "",
        durationSuffix: data["duration_suffix"],
        points: data["points"],
        setLevel: data["set_level"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'type': type,
      'label': label,
      'content': content,
      'duration': duration,
      'durationSuffix': durationSuffix,
      'points': points,
      'setLevel': setLevel
    };
  }
}
