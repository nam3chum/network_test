import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:networking_test/test1/model/category_model.dart';
import 'package:networking_test/test1/model/story_model.dart';
import 'package:networking_test/test1/ui/categories/list_categories.dart';
import 'package:networking_test/test1/ui/search/search.dart';
import 'package:networking_test/test1/ui/detail/story_detail.dart';

import 'dart:convert';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: TruyenMoiPage());
  }
}

class TruyenMoiPage extends StatefulWidget {
  const TruyenMoiPage({super.key});

  @override
  TruyenMoiPageState createState() => TruyenMoiPageState();
}

class TruyenMoiPageState extends State<TruyenMoiPage> {
  List<Story> listStory = [];
  List<Item> categories = [];
  bool isLoading = true;
  bool showGenres = false;
  String selectedSlug = '';

  Future<void> fetchNewStory() async {
    final url = Uri.parse('https://otruyenapi.com/v1/api/home');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List items = jsonResponse['data']['items'];

        setState(() {
          listStory = items.map((e) => Story.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Lỗi: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Lỗi khi fetch truyện: $e');
    }
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://otruyenapi.com/v1/api/the-loai'));

    if (response.statusCode == 200) {
      final jsonData = categoryFromJson(response.body);

      setState(() {
        categories = jsonData.data.items;
      });
    } else {
      throw Exception("Lỗi khi lấy danh sách thể loại: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNewStory();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thể loại', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: categories.any((item) => item.slug == selectedSlug) ? selectedSlug : null,
                  hint: const Text('Chọn thể loại'),
                  isExpanded: true,
                  items:
                      categories.map((item) {
                        return DropdownMenuItem<String>(value: item.slug, child: Text(item.name));
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSlug = value;
                      });
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ListCategories(genreSlug: value)),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: listStory.length,
                itemBuilder: (context, index) {
                  final story = listStory[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StoryDetailPage(slug: story.slug)),
                      );
                    },
                    leading: Image.network(story.thumbnail, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(story.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (story.latestChapterName != null)
                          Text(
                            "Chapter mới nhất: ${story.latestChapterName!}",
                            style: TextStyle(fontSize: 12),
                          ),
                        Wrap(
                          children:
                              story.categories
                                  .map(
                                    (e) => Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 2),
                                      child: Chip(label: Text(e)),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
