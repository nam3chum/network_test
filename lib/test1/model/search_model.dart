// To parse this JSON data, do
//
//     final storyDetail = storyDetailFromJson(jsonString);

import 'dart:convert';

StorySearch searchFromJson(String str) => StorySearch.fromJson(jsonDecode(str));


class StorySearch {
  String status;
  String message;
  Data data;

  StorySearch({required this.status, required this.message, required this.data});

  factory StorySearch.fromJson(Map<String, dynamic> json) =>
      StorySearch(status: json["status"], message: json["message"], data: Data.fromJson(json["data"]));

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

}

class BreadCrumb {
  String name;
  bool isCurrent;
  int position;

  BreadCrumb({required this.name, required this.isCurrent, required this.position});

  factory BreadCrumb.fromJson(Map<String, dynamic> json) =>
      BreadCrumb(name: json["name"], isCurrent: json["isCurrent"], position: json["position"]);

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

}

class Category {
  String id;
  String name;
  String slug;

  Category({required this.id, required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["id"], name: json["name"], slug: json["slug"]);

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

}

