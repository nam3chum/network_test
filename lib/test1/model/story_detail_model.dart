import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'story_detail_model.g.dart';

StoryDetail storyDetailFromJson(String str) => StoryDetail.fromJson(json.decode(str));

@JsonSerializable()
class StoryDetail {
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  StoryData data;

  StoryDetail({required this.status, required this.message, required this.data});

  factory StoryDetail.fromJson(Map<String, dynamic> json) => _$StoryDetailFromJson(json);
}

@JsonSerializable()
class StoryData {
  @JsonKey(name: "seoOnPage")
  SeoOnPage seoOnPage;
  @JsonKey(name: "breadCrumb")
  List<BreadCrumb> breadCrumb;
  @JsonKey(name: "params")
  Params params;
  @JsonKey(name: "item")
  StoryItem item;
  @JsonKey(name: "APP_DOMAIN_CDN_IMAGE")
  String appDomainCdnImage;

  StoryData({
    required this.seoOnPage,
    required this.breadCrumb,
    required this.params,
    required this.item,
    required this.appDomainCdnImage,
  });

  factory StoryData.fromJson(Map<String, dynamic> json) => _$StoryDataFromJson(json);
}

@JsonSerializable()
class BreadCrumb {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "slug")
  String? slug;
  @JsonKey(name: "position")
  int position;
  @JsonKey(name: "isCurrent")
  bool? isCurrent;

  BreadCrumb({required this.name, this.slug, required this.position, this.isCurrent});

  factory BreadCrumb.fromJson(Map<String, dynamic> json) => _$BreadCrumbFromJson(json);
}

@JsonSerializable()
class StoryItem {
  @JsonKey(name: "_id")
  String id;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "slug")
  String slug;
  @JsonKey(name: "origin_name")
  List<String> originName;
  @JsonKey(name: "content")
  String content;
  @JsonKey(name: "status")
  String status;
  @JsonKey(name: "thumb_url")
  String thumbUrl;
  @JsonKey(name: "sub_docquyen")
  bool subDocquyen;
  @JsonKey(name: "author")
  List<String> author;
  @JsonKey(name: "category")
  List<Category> category;
  @JsonKey(name: "chapters")
  List<Chapter> chapters;
  @JsonKey(name: "updatedAt")
  DateTime updatedAt;

  StoryItem({
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.content,
    required this.status,
    required this.thumbUrl,
    required this.subDocquyen,
    required this.author,
    required this.category,
    required this.chapters,
    required this.updatedAt,
  });

  factory StoryItem.fromJson(Map<String, dynamic> json) => _$StoryItemFromJson(json);
}

@JsonSerializable()
class Category {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "slug")
  String slug;

  Category({required this.id, required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@JsonSerializable()
class Chapter {
  @JsonKey(name: "server_name")
  String serverName;
  @JsonKey(name: "server_data")
  List<ServerDatum> serverData;

  Chapter({required this.serverName, required this.serverData});

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);
}

@JsonSerializable()
class ServerDatum {
  @JsonKey(name: "filename")
  String filename;
  @JsonKey(name: "chapter_name")
  String chapterName;
  @JsonKey(name: "chapter_title")
  String chapterTitle;
  @JsonKey(name: "chapter_api_data")
  String chapterApiData;

  ServerDatum({
    required this.filename,
    required this.chapterName,
    required this.chapterTitle,
    required this.chapterApiData,
  });

  factory ServerDatum.fromJson(Map<String, dynamic> json) => _$ServerDatumFromJson(json);
}

@JsonSerializable()
class Params {
  @JsonKey(name: "slug")
  String slug;
  @JsonKey(name: "crawl_check_url")
  String crawlCheckUrl;

  Params({required this.slug, required this.crawlCheckUrl});

  factory Params.fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}

@JsonSerializable()
class SeoOnPage {
  @JsonKey(name: "og_type")
  String ogType;
  @JsonKey(name: "titleHead")
  String titleHead;
  @JsonKey(name: "seoSchema")
  SeoSchema seoSchema;
  @JsonKey(name: "descriptionHead")
  String descriptionHead;
  @JsonKey(name: "og_image")
  List<String> ogImage;
  @JsonKey(name: "updated_time")
  int updatedTime;
  @JsonKey(name: "og_url")
  String ogUrl;

  SeoOnPage({
    required this.ogType,
    required this.titleHead,
    required this.seoSchema,
    required this.descriptionHead,
    required this.ogImage,
    required this.updatedTime,
    required this.ogUrl,
  });

  factory SeoOnPage.fromJson(Map<String, dynamic> json) => _$SeoOnPageFromJson(json);
}

@JsonSerializable()
class SeoSchema {
  @JsonKey(name: "@context")
  String context;
  @JsonKey(name: "@type")
  String type;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "url")
  String url;
  @JsonKey(name: "image")
  String image;
  @JsonKey(name: "director")
  String director;

  SeoSchema({
    required this.context,
    required this.type,
    required this.name,
    required this.url,
    required this.image,
    required this.director,
  });

  factory SeoSchema.fromJson(Map<String, dynamic> json) => _$SeoSchemaFromJson(json);
}
