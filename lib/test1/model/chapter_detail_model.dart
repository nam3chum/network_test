class ChapterDetail {
  final String domainCdn;
  final String chapterPath;
  final List<String> imageUrls;

  ChapterDetail({
    required this.domainCdn,
    required this.chapterPath,
    required this.imageUrls,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    final item = json['data']['item'];
    final domain = json['data']['domain_cdn'];
    final path = item['chapter_path'];

    final images = (item['chapter_image'] as List)
        .map((img) => '$domain/$path/${img['image_file']}')
        .toList()
        .cast<String>();

    return ChapterDetail(
      domainCdn: domain,
      chapterPath: path,
      imageUrls: images,
    );
  }
}
