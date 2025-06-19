import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_html/flutter_html.dart';
import 'package:networking_test/test2/ui/genre_list_page.dart';

import '../model/genre_model.dart';
import '../model/story_model.dart';
import '../service/genre_service.dart';

class StoryDetailPage extends StatefulWidget {
  final String id;

  const StoryDetailPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => StoryDetailPageState();
}

class StoryDetailPageState extends State<StoryDetailPage> {
  Story? story;
  List<Genre> genreList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStory();
    loadGenres();
  }

  Future<void> loadGenres() async {
    final genres = await GenreService.getGenres();
    setState(() {
      genreList = genres;
    });
  }

  Future<void> fetchStory() async {
    try {
      final response = await http.get(
        Uri.parse('https://684fbe32e7c42cfd1795bed4.mockapi.io/story/${widget.id}'),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          story = Story.fromJson(jsonData);
          isLoading = false;
          print(jsonData);
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
    if (story == null) return;
    //Navigator.push(context, MaterialPageRoute(builder: (_) => ChapterReaderPage(apiData: seoSchema!.url)));
  }

  void loadTableOfContents() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ListChapter(listChapter: storyItem!.chapters)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || story == null) {
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
          Positioned.fill(child: Image.network(story!.imgUrl, fit: BoxFit.cover)),
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
                        child: Image.network(story!.imgUrl, width: 100, height: 140, fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                          );
                        },),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'tác giả: ${story!.author.isNotEmpty ? story!.author : ''}',
                              style: const TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              story!.originName.isNotEmpty ? story!.originName : '',
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
                        story!.genreId.map((e) {
                          final genre = genreList.firstWhere(
                            (g) => g.id == e.toString(),
                            orElse: () => Genre(id: e.toString(), name: 'Không rõ'),
                          );
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: ActionChip(label: Text(genre.name), onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GenreStoryListScreen(genreId: genre.id,genreName: genre.name,),));
                            }),
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
                    data: story!.content,
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
