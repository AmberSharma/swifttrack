class Evidence {
  final int type;
  final String url;
  final String thumbnail;
  final String comment;
  final bool editable;

  Evidence(
      {required this.type,
      required this.url,
      required this.thumbnail,
      required this.comment,
      required this.editable});

  factory Evidence.fromJson(Map<String, dynamic> data) {
    return Evidence(
        type: data["type"],
        url: data["url"],
        thumbnail: data["thu"],
        comment: data["comment"],
        editable: data["editable"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'thumbnail': thumbnail,
      'comment': comment,
      'editable': editable
    };
  }
}
