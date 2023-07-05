class ResourceElement {
  final String title;
  final String? content;
  final String? mediaUrl;
  final String mediaType;

  ResourceElement(
      {required this.title,
      required this.content,
      required this.mediaUrl,
      required this.mediaType});

  factory ResourceElement.fromJson(Map<String, dynamic> data) {
    return ResourceElement(
        title: data["title"],
        content: data["content"],
        mediaUrl: data["media_url"],
        mediaType: data["media_type"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'mediaUrl': mediaUrl,
      'media_type': mediaType
    };
  }
}
