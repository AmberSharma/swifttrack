import 'package:swifttrack/model/assessment.dart';

class AssessmentList {
  final List<Assessment> assessments;

  AssessmentList({
    required this.assessments,
  });

  factory AssessmentList.fromJson(List<dynamic> parsedJson) {
    List<Assessment> assessments = <Assessment>[];
    assessments = parsedJson.map((i) => Assessment.fromJson(i)).toList();

    return AssessmentList(assessments: assessments);
  }
}
