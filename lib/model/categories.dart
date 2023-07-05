// import 'package:swifttrack/model/module.dart';
import 'package:intl/intl.dart';
import 'package:swifttrack/model/evidence.dart';
import 'package:swifttrack/model/note.dart';
import 'package:swifttrack/model/resource.dart';

class Categories {
  final String name;
  final List<Resource> resource;

  Categories({required this.name, required this.resource});

  factory Categories.fromJson(Map<String, dynamic> data) {
    print(data);

    final resourceData = data['resources'] as List<dynamic>?;
    final resource = resourceData != null
        ? resourceData
            .map((resourceData) => Resource.fromJson(resourceData))
            .toList()
        : <Resource>[];

    return Categories(name: data["name"], resource: resource);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'resource': resource};
  }
}
