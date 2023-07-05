import 'package:swifttrack/model/categories.dart';

class ResourceList {
  final List<Categories> categories;

  ResourceList({
    required this.categories,
  });

  factory ResourceList.fromJson(List<dynamic> parsedJson) {
    List<Categories> categories = <Categories>[];
    categories = parsedJson.map((i) => Categories.fromJson(i)).toList();

    return ResourceList(categories: categories);
  }
}
