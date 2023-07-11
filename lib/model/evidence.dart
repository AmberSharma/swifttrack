class Evidence {
  final int type;
  final String url;
  final String? thumbnail;
  final String comment;
  final bool editable;
  final String created;
  final String? createdUuid;
  final String? creatorType;

  Evidence(
      {required this.type,
      required this.url,
      required this.thumbnail,
      required this.comment,
      required this.editable,
      required this.created,
      required this.createdUuid,
      required this.creatorType});

  factory Evidence.fromJson(Map<String, dynamic> data) {
    return Evidence(
        type: data["type"],
        url: data["url"],
        thumbnail: data["thu"],
        comment: data["comment"],
        editable: data["editable"],
        created: data["created"],
        createdUuid: data["creator_uuid"],
        creatorType: data["creator_type"].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'thumbnail': thumbnail,
      'comment': comment,
      'editable': editable,
      'created': created,
      'creatorUuid': createdUuid,
      'creatorType': creatorType
    };
  }
}
