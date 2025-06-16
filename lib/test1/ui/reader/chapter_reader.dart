import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/chapter_detail_model.dart';

class ChapterReaderPage extends StatelessWidget {
  final String apiData;

  const ChapterReaderPage({super.key, required this.apiData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đọc chương')),
      body: FutureBuilder<List<String>>(
        future: fetchChapterImages(apiData),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final images = snapshot.data!;
          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) => Image.network(images[index]),
          );
        },
      ),
    );
  }

  Future<List<String>> fetchChapterImages(String apiData) async {
    final response = await http.get(Uri.parse(apiData));
    final json = jsonDecode(response.body);
    final chapter = ChapterDetail.fromJson(json);

    return chapter.imageUrls;
  }
}
