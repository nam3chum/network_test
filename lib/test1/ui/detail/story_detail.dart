import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_html/flutter_html.dart';
import 'package:networking_test/test1/ui/categories/list_categories.dart';

import '../../model/story_detail_model.dart';
import '../reader/chapter_reader.dart';
import '../chapter/chapters.dart';

class StoryDetailPage extends StatefulWidget {
  final String slug;

  const StoryDetailPage({super.key, required this.slug});

  @override
  State<StatefulWidget> createState() => StoryDetailPageState();
}

class StoryDetailPageState extends State<StoryDetailPage> {
  StoryItem? storyItem;
  SeoSchema? seoSchema;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStory();
  }

  Future<void> fetchStory() async {
    try {
      final response = await http.get(Uri.parse('https://otruyenapi.com/v1/api/truyen-tranh/${widget.slug}'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        setState(() {
          seoSchema = SeoSchema.fromJson(jsonData['seoOnPage']['seoSchema']);
          storyItem = StoryItem.fromJson(jsonData['item']);
          isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không tải được truyện')));
          setState(() {
            isLoading = false;
          });
        }
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')));
        Navigator.pop(context);
      }
    }
  }

  void addToBookshelf() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm vào kệ sách')));
  }

  void readStory() {
    if (storyItem == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterReaderPage(apiData: seoSchema!.url)));
  }

  void loadTableOfContents() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListChapter(listChapter: storyItem!.chapters)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || storyItem == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black.withValues(alpha: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBottomItem(Icons.menu_book, "mục lục", loadTableOfContents),
            _buildBottomItem(Icons.play_circle, "đọc truyện", readStory),
            _buildBottomItem(Icons.add, "Thêm vào kệ", addToBookshelf),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: Image.network(seoSchema!.image, fit: BoxFit.cover)),
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.6))),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.bookmark_border, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(seoSchema!.image, width: 100, height: 140, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              storyItem!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'tác giả: ${storyItem!.author.isNotEmpty ?  storyItem!.author.join(', ') : ''}',
                              style: const TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              storyItem!.originName.isNotEmpty ? storyItem!.originName.join(', ') : '',
                              style: const TextStyle(fontSize: 16, color: Colors.orangeAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8,
                    children:
                        storyItem!.category.map((type) {
                          return ActionChip(
                            label: Text(type.name),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ListCategories(genreSlug: type.slug)),
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Giới thiệu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Html(
                    data: storyItem!.content,
                    style: {"body": Style(color: Colors.white, fontSize: FontSize(15))},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem(IconData iconItem, String labelText, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(icon: Icon(iconItem, color: Colors.white), onPressed: onTap),
        Text(labelText, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
