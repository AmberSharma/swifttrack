import 'package:swifttrack/model/module.dart';

class Assessment {
  final String uuid;
  final String name;
  final int? pointsEarned;
  final int? pointsRequired;
  final List<Module> module;

  Assessment(
      {required this.uuid,
      required this.name,
      required this.pointsEarned,
      required this.pointsRequired,
      required this.module});

  factory Assessment.fromJson(Map<String, dynamic> data) {
    print(data);
    final moduleData = data['modules'] as List<dynamic>?;
    final module = moduleData != null
        ? moduleData.map((moduleData) => Module.fromJson(moduleData)).toList()
        : <Module>[];
    return Assessment(
        uuid: data["uuid"],
        name: data["name"],
        pointsEarned: data["points_earned"],
        pointsRequired: data["points_target"],
        module: module);
  }
}
