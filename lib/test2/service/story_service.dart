import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/story_model.dart';

class StoryService {
  static const String baseUrl = 'https://684fbe32e7c42cfd1795bed4.mockapi.io/api/v1/story';

  static Future<List<Story>> getStories() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stories ');
    }
  }

  static Future<Story> createStory(Story story) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(story.toJson()),
    );
    if (response.statusCode == 201) {
      return Story.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create story');
    }
  }

  static Future<Story> updateStory(String id, Story story) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(story.toJson()),
    );
    if (response.statusCode == 200) {
      return Story.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update story');
    }
  }

  static Future<void> deleteStory(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete story');
    }
  }
}
