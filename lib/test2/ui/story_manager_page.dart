import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:networking_test/test2/service/story_service.dart';
import '../model/genre_model.dart';
import '../model/story_model.dart';
import '../service/genre_service.dart';

class StoryManagementScreen extends StatefulWidget {
  const StoryManagementScreen({super.key});

  @override
  StoryManagementScreenState createState() => StoryManagementScreenState();
}

class StoryManagementScreenState extends State<StoryManagementScreen> {
  List<Story> stories = [];
  List<Genre> genres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final storiesData = await StoryService.getStories();
      final genresData = await GenreService.getGenres();
      setState(() {
        stories = storiesData;
        genres = genresData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }
  }

  Future<void> _deleteStory(String id) async {
    try {
      await StoryService.deleteStory(id);
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Story deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting story: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadData)],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading:
                          story.imgUrl.isNotEmpty
                              ? Image.network(
                                story.imgUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.book, size: 50),
                              )
                              : Icon(Icons.book, size: 50),
                      title: Text(story.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Author: ${story.author}'),
                          Text('Chapters: ${story.numberOfChapter}'),
                          Text('Status: ${story.status}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryFormScreen(story: story, genres: genres),
                                ),
                              );
                              if (result == true) _loadData();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Delete Story'),
                                      content: Text('Are you sure you want to delete this story?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteStory(story.id);
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
            MaterialPageRoute(builder: (context) => StoryFormScreen(genres: genres)),
          );
          if (result == true) _loadData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class StoryFormScreen extends StatefulWidget {
  final Story? story;
  final List<Genre> genres;

  const StoryFormScreen({super.key, this.story, required this.genres});

  @override
  StoryFormScreenState createState() => StoryFormScreenState();
}

class StoryFormScreenState extends State<StoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _originNameController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController();
  final _imgUrlController = TextEditingController();
  final _numberOfChapterController = TextEditingController();

  String _status = 'Đang tiến hành';
  List<String> _selectedGenres = [];
  File? _selectedImage;
  bool _useImageUrl = true;
  bool _isLoading = false;
  List<String> statuses = ['Đang tiến hành', 'Hoàn thành', 'Tạm ngưng', 'Đã drop'];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.story != null) {
      _nameController.text = widget.story!.name;
      _originNameController.text = widget.story!.originName;
      _contentController.text = widget.story!.content;
      _authorController.text = widget.story!.author;
      _imgUrlController.text = widget.story!.imgUrl;
      _numberOfChapterController.text = widget.story!.numberOfChapter.toString();
      _status = widget.story!.status;
      _selectedGenres = List.from(widget.story!.genreId);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _saveStory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String imageUrl = _imgUrlController.text;

      if (!_useImageUrl && _selectedImage != null) {
        imageUrl = "";
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Image upload not implemented in MockAPI')));
      }

      final story = Story(
        id: widget.story?.id ?? '',
        name: _nameController.text,
        originName: _originNameController.text,
        content: _contentController.text,
        author: _authorController.text,
        genreId: _selectedGenres,
        imgUrl: imageUrl,
        status: _status,
        updatedAt: DateTime.now(),
        numberOfChapter: int.tryParse(_numberOfChapterController.text) ?? 0,
      );

      if (widget.story == null) {
        await StoryService.createStory(story);
      } else {
        await StoryService.updateStory(widget.story!.id, story);
      }

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Story saved successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving story: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story == null ? 'Add Story' : 'Edit Story'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveStory,
            child: Text('SAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Story Name *', border: OutlineInputBorder()),
                      validator: (value) => value?.isEmpty == true ? 'Required' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _originNameController,
                      decoration: InputDecoration(labelText: 'Origin Name', border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _authorController,
                      decoration: InputDecoration(labelText: 'Author *', border: OutlineInputBorder()),
                      validator: (value) => value?.isEmpty == true ? 'Required' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _numberOfChapterController,
                      decoration: InputDecoration(
                        labelText: 'Number of Chapters',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                      items:
                          statuses
                              .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                              .toList(),
                      onChanged: (value) => setState(() => _status = value!),
                    ),
                    SizedBox(height: 16),
                    // Image Section
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: _useImageUrl,
                                  onChanged: (value) => setState(() => _useImageUrl = value!),
                                ),
                                Text('Image URL'),
                                SizedBox(width: 20),
                                Radio<bool>(
                                  value: false,
                                  groupValue: _useImageUrl,
                                  onChanged: (value) => setState(() => _useImageUrl = value!),
                                ),
                                Text('Upload Image'),
                              ],
                            ),
                            if (_useImageUrl)
                              TextFormField(
                                controller: _imgUrlController,
                                decoration: InputDecoration(
                                  labelText: 'Image URL',
                                  border: OutlineInputBorder(),
                                ),
                              )
                            else
                              Column(
                                children: [
                                  if (_selectedImage != null)
                                    SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                                    ),
                                  SizedBox(height: 8),
                                  ElevatedButton(onPressed: _pickImage, child: Text('Select Image')),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Genres Section
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Genres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Wrap(
                              children:
                                  widget.genres.map((genre) {
                                    final isSelected = _selectedGenres.contains(genre.id);
                                    return Padding(
                                      padding: EdgeInsets.only(right: 8, bottom: 8),
                                      child: FilterChip(
                                        label: Text(genre.name),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              _selectedGenres.add(genre.id);
                                            } else {
                                              _selectedGenres.remove(genre.id);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
