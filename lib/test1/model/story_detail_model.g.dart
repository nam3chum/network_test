// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDetail _$StoryDetailFromJson(Map<String, dynamic> json) => StoryDetail(
  status: json['status'] as String,
  message: json['message'] as String,
  data: StoryData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoryDetailToJson(StoryDetail instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

StoryData _$StoryDataFromJson(Map<String, dynamic> json) => StoryData(
  seoOnPage: SeoOnPage.fromJson(json['seoOnPage'] as Map<String, dynamic>),
  breadCrumb:
      (json['breadCrumb'] as List<dynamic>)
          .map((e) => BreadCrumb.fromJson(e as Map<String, dynamic>))
          .toList(),
  params: Params.fromJson(json['params'] as Map<String, dynamic>),
  item: StoryItem.fromJson(json['item'] as Map<String, dynamic>),
  appDomainCdnImage: json['APP_DOMAIN_CDN_IMAGE'] as String,
);

Map<String, dynamic> _$StoryDataToJson(StoryData instance) => <String, dynamic>{
  'seoOnPage': instance.seoOnPage,
  'breadCrumb': instance.breadCrumb,
  'params': instance.params,
  'item': instance.item,
  'APP_DOMAIN_CDN_IMAGE': instance.appDomainCdnImage,
};

BreadCrumb _$BreadCrumbFromJson(Map<String, dynamic> json) => BreadCrumb(
  name: json['name'] as String,
  slug: json['slug'] as String?,
  position: (json['position'] as num).toInt(),
  isCurrent: json['isCurrent'] as bool?,
);

Map<String, dynamic> _$BreadCrumbToJson(BreadCrumb instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'position': instance.position,
      'isCurrent': instance.isCurrent,
    };

StoryItem _$StoryItemFromJson(Map<String, dynamic> json) => StoryItem(
  id: json['_id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  originName:
      (json['origin_name'] as List<dynamic>).map((e) => e as String).toList(),
  content: json['content'] as String,
  status: json['status'] as String,
  thumbUrl: json['thumb_url'] as String,
  subDocquyen: json['sub_docquyen'] as bool,
  author: (json['author'] as List<dynamic>).map((e) => e as String).toList(),
  category:
      (json['category'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
  chapters:
      (json['chapters'] as List<dynamic>)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$StoryItemToJson(StoryItem instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'origin_name': instance.originName,
  'content': instance.content,
  'status': instance.status,
  'thumb_url': instance.thumbUrl,
  'sub_docquyen': instance.subDocquyen,
  'author': instance.author,
  'category': instance.category,
  'chapters': instance.chapters,
  'updatedAt': instance.updatedAt.toIso8601String(),
};

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
};

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
  serverName: json['server_name'] as String,
  serverData:
      (json['server_data'] as List<dynamic>)
          .map((e) => ServerDatum.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'server_name': instance.serverName,
  'server_data': instance.serverData,
};

ServerDatum _$ServerDatumFromJson(Map<String, dynamic> json) => ServerDatum(
  filename: json['filename'] as String,
  chapterName: json['chapter_name'] as String,
  chapterTitle: json['chapter_title'] as String,
  chapterApiData: json['chapter_api_data'] as String,
);

Map<String, dynamic> _$ServerDatumToJson(ServerDatum instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'chapter_name': instance.chapterName,
      'chapter_title': instance.chapterTitle,
      'chapter_api_data': instance.chapterApiData,
    };

Params _$ParamsFromJson(Map<String, dynamic> json) => Params(
  slug: json['slug'] as String,
  crawlCheckUrl: json['crawl_check_url'] as String,
);

Map<String, dynamic> _$ParamsToJson(Params instance) => <String, dynamic>{
  'slug': instance.slug,
  'crawl_check_url': instance.crawlCheckUrl,
};

SeoOnPage _$SeoOnPageFromJson(Map<String, dynamic> json) => SeoOnPage(
  ogType: json['og_type'] as String,
  titleHead: json['titleHead'] as String,
  seoSchema: SeoSchema.fromJson(json['seoSchema'] as Map<String, dynamic>),
  descriptionHead: json['descriptionHead'] as String,
  ogImage: (json['og_image'] as List<dynamic>).map((e) => e as String).toList(),
  updatedTime: (json['updated_time'] as num).toInt(),
  ogUrl: json['og_url'] as String,
);

Map<String, dynamic> _$SeoOnPageToJson(SeoOnPage instance) => <String, dynamic>{
  'og_type': instance.ogType,
  'titleHead': instance.titleHead,
  'seoSchema': instance.seoSchema,
  'descriptionHead': instance.descriptionHead,
  'og_image': instance.ogImage,
  'updated_time': instance.updatedTime,
  'og_url': instance.ogUrl,
};

SeoSchema _$SeoSchemaFromJson(Map<String, dynamic> json) => SeoSchema(
  context: json['@context'] as String,
  type: json['@type'] as String,
  name: json['name'] as String,
  url: json['url'] as String,
  image: json['image'] as String,
  director: json['director'] as String,
);

Map<String, dynamic> _$SeoSchemaToJson(SeoSchema instance) => <String, dynamic>{
  '@context': instance.context,
  '@type': instance.type,
  'name': instance.name,
  'url': instance.url,
  'image': instance.image,
  'director': instance.director,
};
