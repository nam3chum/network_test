import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/genre_model.dart';

class GenreService {
  static const String genreBaseUrl = 'https://684fbe32e7c42cfd1795bed4.mockapi.io/genre';

  static Future<List<Genre>> getGenres() async {
    final response = await http.get(Uri.parse(genreBaseUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }


  static Future<Genre> createGenre(Genre genre) async {
    final response = await http.post(
      Uri.parse(genreBaseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(genre.toJson()),
    );
    if (response.statusCode == 201) {
      return Genre.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create genre');
    }
  }

  static Future<Genre> updateGenre(String id, Genre genre) async {
    final response = await http.put(
      Uri.parse('$genreBaseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(genre.toJson()),
    );
    if (response.statusCode == 200) {
      return Genre.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update genre');
    }
  }

  static Future<void> deleteGenre(String id) async {
    final response = await http.delete(Uri.parse('$genreBaseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete genre');
    }
  }

  static Future<Genre?> getGenreById(String id) async {
    final response = await http.get(Uri.parse('$genreBaseUrl/$id'));
    if (response.statusCode == 200) {
      return Genre.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
