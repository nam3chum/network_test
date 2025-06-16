import 'dart:convert';

CategoryStories categoryStoriesFromJson(String str) => CategoryStories.fromJson(json.decode(str));

String categoryStoriesToJson(CategoryStories data) => json.encode(data.toJson());

class CategoryStories {
  final String status;
  final String message;
  final Data data;

  CategoryStories({required this.status, required this.message, required this.data});

  factory CategoryStories.fromJson(Map<String, dynamic> json) =>
      CategoryStories(status: json["status"], message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"status": status, "message": message, "data": data.toJson()};
}

class Data {
  final SeoOnPage seoOnPage;
  final List<BreadCrumb> breadCrumb;
  final String titlePage;
  final List<Item> items;
  final Params params;
  final String typeList;
  final String appDomainFrontend;
  final String appDomainCdnImage;

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
    breadCrumb: List<BreadCrumb>.from(json["breadCrumb"].map((x) => BreadCrumb.fromJson(x))),
    titlePage: json["titlePage"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    params: Params.fromJson(json["params"]),
    typeList: json["type_list"],
    appDomainFrontend: json["APP_DOMAIN_FRONTEND"],
    appDomainCdnImage: json["APP_DOMAIN_CDN_IMAGE"],
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
  final String name;
  final String slug;
  final bool isCurrent;
  final int position;

  BreadCrumb({required this.name, required this.slug, required this.isCurrent, required this.position});

  factory BreadCrumb.fromJson(Map<String, dynamic> json) => BreadCrumb(
    name: json["name"] ?? '',
    slug: json["slug"] ?? '',
    isCurrent: json["isCurrent"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {"name": name, "slug": slug, "isCurrent": isCurrent, "position": position};
}

class Item {
  final String id;
  final String name;
  final String slug;
  final List<String> originName;
  final String status;
  final String thumbUrl;
  final bool subDocquyen;
  final List<Category> category;
  final DateTime updatedAt;
  final List<ChaptersLatest> chaptersLatest;

  Item({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.status,
    required this.thumbUrl,
    required this.subDocquyen,
    required this.category,
    required this.updatedAt,
    required this.chaptersLatest,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["_id"],
    name: json["name"],
    slug: json["slug"],
    originName: List<String>.from(json["origin_name"].map((x) => x)),
    status: json["status"],
    thumbUrl: 'https://otruyenapi.com/uploads/comics/${json["thumb_url"]}',
    subDocquyen: json["sub_docquyen"],
    category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
    updatedAt: DateTime.parse(json["updatedAt"]),
    chaptersLatest:
        json["chapters_latest"] != null
            ? List<ChaptersLatest>.from(json["chapters_latest"].map((x) => ChaptersLatest.fromJson(x)))
            : [],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "slug": slug,
    "origin_name": List<dynamic>.from(originName.map((x) => x)),
    "status": status,
    "thumb_url": thumbUrl,
    "sub_docquyen": subDocquyen,
    "category": List<dynamic>.from(category.map((x) => x.toJson())),
    "updatedAt": updatedAt.toIso8601String(),
    "chaptersLatest": List<dynamic>.from(chaptersLatest.map((x) => x.toJson())),
  };
}

class Category {
  final String id;
  final String name;
  final String slug;

  Category({required this.id, required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["id"], name: json["name"] ?? '', slug: json["slug"] ?? '');

  Map<String, dynamic> toJson() => {"id": id, "name": name, "slug": slug};
}

class ChaptersLatest {
  final String filename;
  final String chapterName;
  final String chapterTitle;
  final String chapterApiData;

  ChaptersLatest({
    required this.filename,
    required this.chapterName,
    required this.chapterTitle,
    required this.chapterApiData,
  });

  factory ChaptersLatest.fromJson(Map<String, dynamic> json) => ChaptersLatest(
    filename: json["filename"] ?? '',
    chapterName: json["chapter_name"] ?? '',
    chapterTitle: json["chapter_title"] ?? '',
    chapterApiData: json["chapter_api_data"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "filename": filename,
    "chapter_name": chapterName,
    "chapter_title": chapterTitle,
    "chapter_api_data": chapterApiData,
  };
}

class Params {
  final String typeSlug;
  final String slug;
  final List<String> filterCategory;
  final String sortField;
  final String sortType;
  final Pagination pagination;

  Params({
    required this.typeSlug,
    required this.slug,
    required this.filterCategory,
    required this.sortField,
    required this.sortType,
    required this.pagination,
  });

  factory Params.fromJson(Map<String, dynamic> json) => Params(
    typeSlug: json["type_slug"],
    slug: json["slug"],
    filterCategory: List<String>.from(json["filterCategory"].map((x) => x)),
    sortField: json["sortField"],
    sortType: json["sortType"],
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "type_slug": typeSlug,
    "slug": slug,
    "filterCategory": List<dynamic>.from(filterCategory.map((x) => x)),
    "sortField": sortField,
    "sortType": sortType,
    "pagination": pagination.toJson(),
  };
}

class Pagination {
  final int totalItems;
  final int totalItemsPerPage;
  final int currentPage;
  final int pageRanges;

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
  final String ogType;
  final String titleHead;
  final List<String> ogImage;
  final String ogUrl;

  SeoOnPage({required this.ogType, required this.titleHead, required this.ogImage, required this.ogUrl});

  factory SeoOnPage.fromJson(Map<String, dynamic> json) => SeoOnPage(
    ogType: json["og_type"],
    titleHead: json["titleHead"],
    ogImage: List<String>.from(json["og_image"].map((x) => x)),
    ogUrl: json["og_url"],
  );

  Map<String, dynamic> toJson() => {
    "og_type": ogType,
    "titleHead": titleHead,
    "og_image": List<dynamic>.from(ogImage.map((x) => x)),
    "og_url": ogUrl,
  };
}
