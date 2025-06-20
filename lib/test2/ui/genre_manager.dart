import 'package:flutter/material.dart';
import 'package:networking_test/test2/service/story_service.dart';
import '../model/genre_model.dart';
import '../service/genre_service.dart';

class GenreManagementScreen extends StatefulWidget {
  const GenreManagementScreen({super.key});

  @override
  GenreManagementScreenState createState() => GenreManagementScreenState();
}

class GenreManagementScreenState extends State<GenreManagementScreen> {
  List<Genre> genres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    setState(() => isLoading = true);
    try {
      final genresData = await GenreService.getGenres();
      setState(() {
        genres = genresData;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading genres: $e');
    }
  }

  Future<void> _deleteGenre(String id) async {
    try {
      await GenreService.deleteGenre(id);
      _loadGenres();
      print('Genre deleted successfully');
    } catch (e) {
      print('deleting genre: $e');
    }
  }

  Future<void> removeGenreFromStories(String id) async {
    final listStory = await StoryService.getStories();
    for (final story in listStory) {
      if (story.genreId.contains(id)) {
        final updatedGenreId = story.genreId.where((e) => e != id).toList();
        await StoryService.patchStoryGenre(story.id, updatedGenreId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadGenres)],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: Icon(Icons.category),
                      title: Text(genre.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GenreFormScreen(genre: genre)),
                              );
                              if (result == true) _loadGenres();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Delete Genre'),
                                      content: Text('Are you sure you want to delete this genre?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteGenre(genre.id);
                                            removeGenreFromStories(genre.id);
                                          },
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GenreFormScreen()),
          );
          if (result == true) _loadGenres();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// Genre Form Screen
class GenreFormScreen extends StatefulWidget {
  final Genre? genre;

  const GenreFormScreen({super.key, this.genre});

  @override
  GenreFormScreenState createState() => GenreFormScreenState();
}

class GenreFormScreenState extends State<GenreFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) {
      _nameController.text = widget.genre!.name;
    }
  }

  Future<void> _saveGenre() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final genre = Genre(id: widget.genre?.id ?? '', name: _nameController.text);

      if (widget.genre == null) {
        await GenreService.createGenre(genre);
      } else {
        await GenreService.updateGenre(widget.genre!.id, genre);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Genre saved successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving genre: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genre == null ? 'Add Genre' : 'Edit Genre'),
        actions: [
          TextButton(
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlue)),
            onPressed: () {
              _isLoading ? null : _saveGenre();

              Navigator.pop(context);
            },
            child: Text('SAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Genre Name *', border: OutlineInputBorder()),
                        validator: (value) => value?.isEmpty == true ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
