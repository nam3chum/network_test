import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/catgory_stories_model.dart';
import '../detail/story_detail.dart';

class ListCategories extends StatefulWidget {
  final String genreSlug;

  const ListCategories({super.key, required this.genreSlug});

  @override
  State<ListCategories> createState() => ListCategoriesState();
}

class ListCategoriesState extends State<ListCategories> {
  List<Item> stories = [];
  int currentPage = 1;
  bool isLoading = false;
  String nameOfCategory = '';

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  Future<void> fetchStories() async {
    setState(() => isLoading = true);

    final url = 'https://otruyenapi.com/v1/api/the-loai/${widget.genreSlug}?page=$currentPage';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = response.body;
      final newStories = categoryStoriesFromJson(json);

      setState(() {
        stories = newStories.data.items;
      });
    }

    setState(() => isLoading = false);
  }

  void goToNextPage() {
    if (currentPage < 15) {
      setState(() {
        currentPage++;
      });
      fetchStories();
    }
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchStories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thể loại $nameOfCategory")),
      body: Column(children: [if (isLoading) const LinearProgressIndicator(), _buildResultList()]),
    );
  }

  Widget _buildResultList() {
    return Expanded(
      child: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final item = stories[index];
          return StoryItemCard(item: item);
        },
      ),
    );
  }
}

class StoryItemCard extends StatelessWidget {
  final Item item;

  const StoryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: SizedBox(
          width: 56,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.thumbUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
            ),
          ),
        ),
        title: Text(item.name.toString(), maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(item.originName.isNotEmpty ? item.originName.join(', ') : '', maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoryDetailPage(slug: item.slug)));
        },
      ),
    );
  }
}
