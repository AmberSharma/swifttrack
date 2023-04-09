class Progress {
  final String name;
  final int points;

  Progress({required this.name, required this.points});

  factory Progress.fromJson(Map<String, dynamic> data) {
    return Progress(
      name: data["name"],
      points: data["points"],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'points': points};
  }
}
