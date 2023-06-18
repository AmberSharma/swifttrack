// import 'package:swifttrack/model/module.dart';
import 'package:intl/intl.dart';
import 'package:swifttrack/model/evidence.dart';
import 'package:swifttrack/model/note.dart';

class ModuleElement {
  final String uuid;
  final String type;
  final String? label;
  final String content;
  final String duration;
  final String? durationSuffix;
  final String points;
  int? setPoints;
  int? setLevel;
  String? setDuration;
  String updatedAt;
  String? firebaseCollectionId;
  final List<Evidence> evidence;
  final List<Note> note;
  //final List<Module> module;

  ModuleElement(
      {required this.uuid,
      required this.type,
      required this.label,
      required this.content,
      required this.duration,
      required this.durationSuffix,
      required this.points,
      required this.setPoints,
      required this.setLevel,
      required this.setDuration,
      required this.updatedAt,
      required this.evidence,
      required this.note});

  factory ModuleElement.fromJson(Map<String, dynamic> data) {
    print(data);
    // final moduleData = data['elements'] as List<dynamic>?;
    // final module = moduleData != null
    //     ? moduleData.map((moduleData) => Module.fromJson(moduleData)).toList()
    //     : <Module>[];

    final evidenceData = data['evidence'] as List<dynamic>?;
    final evidence = evidenceData != null
        ? evidenceData
            .map((evidenceData) => Evidence.fromJson(evidenceData))
            .toList()
        : <Evidence>[];

    final noteData = data['notes'] as List<dynamic>?;
    final note = noteData != null
        ? noteData.map((noteData) => Note.fromJson(noteData)).toList()
        : <Note>[];

    var points = 0;

    return ModuleElement(
        uuid: data["uuid"],
        type: data["type"],
        label: data["label"] == null ? "" : data["label"] + ".",
        content: data["content"],
        duration: data["duration"] ?? "",
        durationSuffix: data["duration_suffix"],
        points: data["points"] ?? "",
        setPoints: data["set_points"] ?? 0,
        setLevel: data["set_level"],
        setDuration:
            data["set_duration"] == null ? "" : data["set_duration"].toString(),
        updatedAt: data["updated"] ??
            DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
        evidence: evidence,
        note: note);
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
      'setPoints': setPoints,
      'setLevel': setLevel,
      'setDuration': setDuration,
      'updated': updatedAt,
      'evidence': evidence,
      'note': note
    };
  }
}
