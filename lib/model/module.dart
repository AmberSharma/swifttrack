class Module {
  final String uuid;
  final String name;
  final int pointsEarned;
  final int pointsRequired;
  final String color;
  final String progress1;
  final int progress1Count;
  final String progress2;
  final int progress2Count;
  final String progress3;
  final int progress3Count;

  Module(
      {required this.uuid,
      required this.name,
      required this.pointsEarned,
      required this.pointsRequired,
      required this.color,
      required this.progress1,
      required this.progress1Count,
      required this.progress2,
      required this.progress2Count,
      required this.progress3,
      required this.progress3Count});

  factory Module.fromJson(Map<String, dynamic> data) {
    return Module(
      uuid: data["uuid"],
      name: data["name"],
      pointsEarned: data["points_earned"],
      pointsRequired: data["points_target"],
      // ignore: prefer_interpolation_to_compose_strings
      color: data["color"].replaceAll(RegExp('#'), '0xff'),
      progress1: data["prog_1_title"],
      progress1Count: data["prog_1_count"],
      progress2: data["prog_2_title"],
      progress2Count: data["prog_2_count"],
      progress3: data["prog_3_title"],
      progress3Count: data["prog_3_count"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'pointsEarned': pointsEarned,
      'pointsRequired': pointsRequired,
      'color': color,
      'progress1': progress1,
      'progress1Count': progress1Count,
      'progress2': progress2,
      'progress2Count': progress2Count,
      'progress3': progress3,
      'progress3Count': progress3Count
    };
  }
}
