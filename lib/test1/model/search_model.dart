// To parse this JSON data, do
//
//     final storyDetail = storyDetailFromJson(jsonString);

import 'dart:convert';

StorySearch searchFromJson(String str) => StorySearch.fromJson(jsonDecode(str));

String searchToJson(StorySearch data) => json.encode(data.toJson());

class StorySearch {
  String status;
  String message;
  Data data;

  StorySearch({required this.status, required this.message, required this.data});

  factory StorySearch.fromJson(Map<String, dynamic> json) =>
      StorySearch(status: json["status"], message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"status": status, "message": message, "data": data.toJson()};
}

class Data {
  SeoOnPage seoOnPage;
  List<BreadCrumb> breadCrumb;
  String titlePage;
  List<Item> items;
  Params params;
  String typeList;
  String appDomainFrontend;
  String appDomainCdnImage;

  Data({
    required this.seoOnPage,
    required this.breadCrumb,
    required this.titlePage,
    required this.items,
    required this.params,
    required this.typeList,
    required this.appDomainFrontend,
    required this.appDomainCdnImage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    seoOnPage: SeoOnPage.fromJson(json["seoOnPage"]),
    breadCrumb:
        json["breadCrumb"] != null
            ? List<BreadCrumb>.from(json["breadCrumb"].map((x) => BreadCrumb.fromJson(x)))
            : [],
    titlePage: json["titlePage"] ?? '',
    items: json["items"] != null ? List<Item>.from(json["items"].map((x) => Item.fromJson(x))) : [],
    params: Params.fromJson(json["params"]),
    typeList: json["type_list"] ?? '',
    appDomainFrontend: json["APP_DOMAIN_FRONTEND"] ?? '',
    appDomainCdnImage: json["APP_DOMAIN_CDN_IMAGE"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "seoOnPage": seoOnPage.toJson(),
    "breadCrumb": List<dynamic>.from(breadCrumb.map((x) => x.toJson())),
    "titlePage": titlePage,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "params": params.toJson(),
    "type_list": typeList,
    "APP_DOMAIN_FRONTEND": appDomainFrontend,
    "APP_DOMAIN_CDN_IMAGE": appDomainCdnImage,
  };
}

class BreadCrumb {
  String name;
  bool isCurrent;
  int position;

  BreadCrumb({required this.name, required this.isCurrent, required this.position});

  factory BreadCrumb.fromJson(Map<String, dynamic> json) =>
      BreadCrumb(name: json["name"], isCurrent: json["isCurrent"], position: json["position"]);

  Map<String, dynamic> toJson() => {"name": name, "isCurrent": isCurrent, "position": position};
}

class Item {
  String name;
  String slug;
  List<String> originName;
  String status;
  String thumbUrl;
  bool subDocquyen;
  List<String> author;
  List<Category> category;
  List<Chapter> chapters;
  DateTime updatedAt;
  List<ChaptersLatest> chaptersLatest;

  Item({
    required this.name,
    required this.slug,
    required this.originName,
    required this.status,
    required this.thumbUrl,
    required this.subDocquyen,
    required this.author,
    required this.category,
    required this.chapters,
    required this.updatedAt,
    required this.chaptersLatest,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    name: json["name"] ?? '',
    slug: json["slug"] ?? '',
    originName: json["origin_name"] != null ? List<String>.from(json["origin_name"].map((x) => x)) : [],
    status: json["status"] ?? '',
    thumbUrl: "https://otruyenapi.com/uploads/comics/${json["thumb_url"]}",
    subDocquyen: json["sub_docquyen"] ?? false,
    author: json["author"] != null ? List<String>.from(json["author"].map((x) => x)) : [],
    category:
        json["category"] != null
            ? List<Category>.from(json["category"].map((x) => Category.fromJson(x)))
            : [],
    chapters:
        json["chapters"] != null ? List<Chapter>.from(json["chapters"].map((x) => Chapter.fromJson(x))) : [],
    updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : DateTime.now(),
    chaptersLatest:
        json["chaptersLatest"] != null
            ? List<ChaptersLatest>.from(json["chaptersLatest"].map((x) => ChaptersLatest.fromJson(x)))
            : [],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "slug": slug,
    "origin_name": List<dynamic>.from(originName.map((x) => x)),
    "status": status,
    "thumb_url": thumbUrl,
    "sub_docquyen": subDocquyen,
    "author": List<dynamic>.from(author.map((x) => x)),
    "category": List<dynamic>.from(category.map((x) => x.toJson())),
    "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
    "updatedAt": updatedAt.toIso8601String(),
    "chaptersLatest": List<dynamic>.from(chaptersLatest.map((x) => x.toJson())),
  };
}

class Category {
  String id;
  String name;
  String slug;

  Category({required this.id, required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["id"], name: json["name"], slug: json["slug"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "slug": slug};
}

class Chapter {
  String serverName;
  List<ChaptersLatest> serverData;

  Chapter({required this.serverName, required this.serverData});

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    serverName: json["server_name"] ?? '',
    serverData:
        json["server_data"] != null
            ? List<ChaptersLatest>.from(json["server_data"].map((x) => ChaptersLatest.fromJson(x)))
            : [],
  );

  Map<String, dynamic> toJson() => {
    "server_name": serverName,
    "server_data": List<dynamic>.from(serverData.map((x) => x.toJson())),
  };
}

class ChaptersLatest {
  String filename;
  String chapterName;
  String chapterTitle;
  String chapterApiData;

  ChaptersLatest({
    required this.filename,
    required this.chapterName,
    required this.chapterTitle,
    required this.chapterApiData,
  });

  factory ChaptersLatest.fromJson(Map<String, dynamic> json) => ChaptersLatest(
    filename: json["filename"],
    chapterName: json["chapter_name"],
    chapterTitle: json["chapter_title"],
    chapterApiData: json["chapter_api_data"],
  );

  Map<String, dynamic> toJson() => {
    "filename": filename,
    "chapter_name": chapterName,
    "chapter_title": chapterTitle,
    "chapter_api_data": chapterApiData,
  };
}

class Params {
  String typeSlug;
  String keyword;
  List<String> filterCategory;
  String sortField;
  String sortType;
  Pagination pagination;

  Params({
    required this.typeSlug,
    required this.keyword,
    required this.filterCategory,
    required this.sortField,
    required this.sortType,
    required this.pagination,
  });

  factory Params.fromJson(Map<String, dynamic> json) => Params(
    typeSlug: json["type_slug"],
    keyword: json["keyword"],
    filterCategory: List<String>.from(json["filterCategory"].map((x) => x)),
    sortField: json["sortField"],
    sortType: json["sortType"],
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "type_slug": typeSlug,
    "keyword": keyword,
    "filterCategory": List<dynamic>.from(filterCategory.map((x) => x)),
    "sortField": sortField,
    "sortType": sortType,
    "pagination": pagination.toJson(),
  };
}

class Pagination {
  int totalItems;
  int totalItemsPerPage;
  int currentPage;
  int pageRanges;

  Pagination({
    required this.totalItems,
    required this.totalItemsPerPage,
    required this.currentPage,
    required this.pageRanges,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalItems: json["totalItems"],
    totalItemsPerPage: json["totalItemsPerPage"],
    currentPage: json["currentPage"],
    pageRanges: json["pageRanges"],
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalItemsPerPage": totalItemsPerPage,
    "currentPage": currentPage,
    "pageRanges": pageRanges,
  };
}

class SeoOnPage {
  String ogType;
  String titleHead;
  String descriptionHead;
  List<String> ogImage;
  String ogUrl;

  SeoOnPage({
    required this.ogType,
    required this.titleHead,
    required this.descriptionHead,
    required this.ogImage,
    required this.ogUrl,
  });

  factory SeoOnPage.fromJson(Map<String, dynamic> json) => SeoOnPage(
    ogType: json["og_type"],
    titleHead: json["titleHead"],
    descriptionHead: json["descriptionHead"],
    ogImage: List<String>.from(json["og_image"].map((x) => x)),
    ogUrl: json["og_url"],
  );

  Map<String, dynamic> toJson() => {
    "og_type": ogType,
    "titleHead": titleHead,
    "descriptionHead": descriptionHead,
    "og_image": List<dynamic>.from(ogImage.map((x) => x)),
    "og_url": ogUrl,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
