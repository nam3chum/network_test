import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/search_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  StorySearch? _searchResult;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _performSearch() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });
    final url = ("https://otruyenapi.com/v1/api/tim-kiem?keyword=$keyword");

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = response.body;
        setState(() {
          _searchResult = searchFromJson(data);
          debugPrint("URL search: $url");
        });
      } else {
        setState(() {
          _error = 'Lỗi: ${response.statusCode}';
          debugPrint("URL search: $url");
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Đã xảy ra lỗi khi tìm kiếm.';
        debugPrint("URL search: $url");
        debugPrint('lỗi: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Nhập tên truyện...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: _performSearch, child: const Icon(Icons.search)),
        ],
      ),
    );
  }

  Widget _buildResultList() {
    final items = _searchResult?.data.items ?? [];

    if (items.isEmpty) {
      return const Center(child: Text('Không tìm thấy truyện nào.'));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return StoryItemCard(item: item);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm truyện')),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error, style: const TextStyle(color: Colors.red)),
            )
          else if (_searchResult != null)
            _buildResultList(),
        ],
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
        subtitle: Text('Tác giả: ${item.author.isNotEmpty ? item.author.join(', ') : ''}', maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: () {
          // ví dụ: Navigator.push tới trang chi tiết truyện
        },
      ),
    );
  }
}
