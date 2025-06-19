import 'package:flutter/material.dart';
import 'package:networking_test/test2/model/genre_model.dart';
import 'package:networking_test/test2/model/story_model.dart';
import 'package:networking_test/test2/ui/genre_list_page.dart';
import 'package:networking_test/test2/ui/story_detail_page.dart';

import '../service/genre_service.dart';
import '../service/story_service.dart';
import 'manager_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Story> listStory = [];
  List<Genre> listGenre = [];
  bool isLoading = true;
  bool showGenres = false;

  String selectedSlug = '';

  Future<void> loadStories() async {
    setState(() => isLoading = true);
    try {
      final loaded = await StoryService.getStories();
      print(" ${loaded.length} stories fetched");
      setState(() {
        listStory = loaded;
        isLoading = false;
      });
    } catch (e) {
      print(' Error loading stories: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> loadGenres() async {
    final genres = await GenreService.getGenres();
    setState(() {
      listGenre = genres;
    });
  }

  @override
  void initState() {
    super.initState();
    loadStories();
    loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StoryAndGenreManagerScreen()));
            },
            icon: Icon(Icons.settings_outlined),
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
                Expanded(
                  child: ListView.builder(
                    itemCount: listGenre.length,
                    itemBuilder: (context, index) {
                      final genre = listGenre[index];
                      final isSelected = selectedSlug == genre.id;

                      return ListTile(
                        title: Text(
                          genre.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            selectedSlug = genre.id;
                          });
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      GenreStoryListScreen(genreId: selectedSlug, genreName: genre.name),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadStories,
        child: ListView.builder(
          itemCount: listStory.length,
          itemBuilder: (context, index) {
            final story = listStory[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoryDetailPage(id: story.id)),
                );
              },
              child: _buildStoryItem(story, context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStoryItem(Story story, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            child: Image.network(
              story.imgUrl,
              width: 120,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          // Nội dung truyện
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text('Tác giả: ${story.author}', style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                  SizedBox(height: 10),
                  Text(
                    "Trạng thái: ${story.status}",
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.menu_book, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${story.numberOfChapter} chương', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Wrap(
                      children:
                          story.genreId.map((e) {
                            final genre = listGenre.firstWhere(
                              (g) => g.id == e.toString(),
                              orElse: () => Genre(id: e.toString(), name: 'Không rõ'),
                            );
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Chip(label: Text(genre.name)),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
