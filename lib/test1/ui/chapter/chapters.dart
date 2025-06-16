import 'package:flutter/material.dart';
import '../../model/story_detail_model.dart';
import '../reader/chapter_reader.dart';

class ListChapter extends StatelessWidget {
  final List<Chapter> listChapter;

  const ListChapter({super.key, required this.listChapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("Mục lục", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: listChapter.isEmpty
          ? const Center(
        child: Text(
          "Không có chương nào",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: listChapter.length,
        itemBuilder: (context, index) {
          final chapter = listChapter[index];
          return Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.white54,
              unselectedWidgetColor: Colors.white,
              colorScheme: ColorScheme.dark(),
            ),
            child: ExpansionTile(
              title: Text(
                chapter.serverName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              children: chapter.serverData.map((serverDatum) {
                return ListTile(
                  title: Text(
                    "Chương ${serverDatum.chapterName}: ${serverDatum.chapterTitle}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if (serverDatum.chapterApiData.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChapterReaderPage(apiData: serverDatum.chapterApiData),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
