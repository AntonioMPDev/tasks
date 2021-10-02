class Source {
  int id;
  String? title;
  bool? isDone;

  Source({this.id = 0, this.title, this.isDone});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'], title: json['title'], isDone: json['isDone']);
  }
}