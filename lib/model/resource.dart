import 'package:swifttrack/model/resource_element.dart';

class Resource {
  final String name;
  final List<ResourceElement> resourceElement;

  Resource({required this.name, required this.resourceElement});

  factory Resource.fromJson(Map<String, dynamic> data) {
    final resourceElementData = data['elements'] as List<dynamic>?;
    final resourceElement = resourceElementData != null
        ? resourceElementData
            .map((resourceElement) => ResourceElement.fromJson(resourceElement))
            .toList()
        : <ResourceElement>[];

    return Resource(name: data["name"], resourceElement: resourceElement);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
