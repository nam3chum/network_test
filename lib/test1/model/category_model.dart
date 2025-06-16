
import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  final String status;
  final String message;
  final Data data;

  Category({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final List<Item> items;

  Data({
    required this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  final String id;
  final String slug;
  final String name;

  Item({
    required this.id,
    required this.slug,
    required this.name,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["_id"],
    slug: json["slug"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "slug": slug,
    "name": name,
  };
}
