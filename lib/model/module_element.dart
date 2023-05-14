// import 'package:swifttrack/model/module.dart';

import 'package:swifttrack/model/evidence.dart';
import 'package:swifttrack/model/note.dart';

class ModuleElement {
  final String uuid;
  final String type;
  final String? label;
  final String content;
  final String duration;
  final String? durationSuffix;
  final int? points;
  int? setLevel;
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
      required this.setLevel,
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

    return ModuleElement(
        uuid: data["uuid"],
        type: data["type"],
        label: data["label"],
        content: data["content"],
        duration: data["duration"] ?? "",
        durationSuffix: data["duration_suffix"],
        points: data["points"],
        setLevel: data["set_level"],
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
      'setLevel': setLevel,
      'evidence': evidence,
      'note': note
    };
  }
}
