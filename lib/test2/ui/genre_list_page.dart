import 'package:flutter/material.dart';
import 'package:networking_test/test2/ui/story_detail_page.dart';

import '../model/genre_model.dart';
import '../model/story_model.dart';
import '../service/genre_service.dart';
import '../service/story_service.dart';

class GenreStoryListScreen extends StatefulWidget {
  final String genreId;
  final String genreName;

  const GenreStoryListScreen({super.key, required this.genreId, required this.genreName});

  @override
  State<StatefulWidget> createState() {
    return GenreStoryListScreenState();
  }
}

class GenreStoryListScreenState extends State<GenreStoryListScreen> {
  List<Genre> listGenre = [];
  List<Story> listStory = [];
  bool isLoading = false;

  Future<void> loadGenres() async {
    final genres = await GenreService.getGenres();
    setState(() {
      listGenre = genres;
    });
  }

  Future<void> loadStories() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Story> loadedStories = await StoryService.getStories();
      setState(() {
        listStory = loadedStories;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadGenres();
    loadStories();
  }

  @override
  Widget build(BuildContext context) {
    final List<Story> filteredStories =
        listStory.where((story) => story.genreId.any((g) => g == widget.genreId)).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Thể loại: ${widget.genreName}")),
      body: ListView.builder(
        itemCount: filteredStories.length,
        itemBuilder: (context, index) {
          final story = filteredStories[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => StoryDetailPage(id: story.id)));
            },
            child: _buildStoryItem(story, context),
          );
        },
      ),
    );
  }
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
                Row(
                  children: [
                    Icon(Icons.menu_book, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${story.numberOfChapter} chương', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 10),
                Text(story.originName, style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
