class Note {
  final String content;
  final String date;
  final String? author;
  final bool editable;

  Note(
      {required this.content,
      required this.date,
      required this.author,
      required this.editable});

  factory Note.fromJson(Map<String, dynamic> data) {
    return Note(
        content: data["content"],
        date: data["date"],
        author: data["author"],
        editable: data["editable"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': date,
      'author': author,
      'editable': editable
    };
  }
}
