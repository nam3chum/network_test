class Story {
  final String id;
  final String name;
  final String slug;
  final String thumbnail;
  final List<String> categories;
  final String? latestChapterName;
  final String? latestChapterLink;

  Story({
    required this.id,
    required this.name,
    required this.slug,
    required this.thumbnail,
    required this.categories,
    this.latestChapterName,
    this.latestChapterLink,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['_id'],
      name: json['name'],
      slug: json['slug'],
      thumbnail: "https://otruyenapi.com/uploads/comics/${json['thumb_url']}",
      categories: (json['category'] as List<dynamic>)
          .map((e) => e['name'].toString())
          .toList(),
      latestChapterName: json['chaptersLatest'] != null && json['chaptersLatest'].isNotEmpty
          ? json['chaptersLatest'][0]['chapter_name']
          : '0',
      latestChapterLink: json['chaptersLatest'] != null && json['chaptersLatest'].isNotEmpty
          ? json['chaptersLatest'][0]['chapter_api_data']
          : null,
    );
  }

}
