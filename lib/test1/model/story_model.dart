
class Story {
  final String id;
  final String name;
  final String originName;
  final String content;
  final String author;
  final List<String> genreId;
  final String imgUrl;
  final String status;
  final DateTime updatedAt;
  final int numberOfChapter;

  Story({
    required this.id,
    required this.name,
    required this.originName,
    required this.content,
    required this.author,
    required this.genreId,
    required this.imgUrl,
    required this.status,
    required this.updatedAt,
    required this.numberOfChapter,
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
    id: json["id"].toString(),
    name: json["name"],
    originName: json["originName"],
    content: json["content"],
    author: json["author"],
    genreId: List<String>.from(json["genreId"].map((x) => x)),
    imgUrl: json["imgUrl"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    numberOfChapter: json["numberOfChapter"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "originName": originName,
    "content": content,
    "author": author,
    "genreId": List<dynamic>.from(genreId.map((x) => x)),
    "imgUrl": imgUrl,
    "status": status,
    "updatedAt": updatedAt.toIso8601String(),
    "numberOfChapter": numberOfChapter,
  };
}
