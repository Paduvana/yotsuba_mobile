import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';
import 'package:yotsuba_mobile/services/CategoryService.dart';

class SearchFilters extends StatefulWidget {
  final TextEditingController keywordController;
  final Function(String keyword, String category) onSearch;

  const SearchFilters({
    super.key,
    required this.keywordController,
    required this.onSearch,
  });

  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  String? _selectedCategory;
  List<String> _categories = [];
  bool _isLoading = true;
  final CategoryService _categoryService = CategoryService(
    authService: AuthService(),
  );

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() => _isLoading = true);
      final categories = await _categoryService.fetchCategories(context);
      
      if (mounted) {
        setState(() {
          _categories = categories;
          _selectedCategory = categories.isNotEmpty ? categories[0] : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Timer? _debounce;

  @override
  void dispose() {
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(
        widget.keywordController.text,
        _selectedCategory ?? '',
      );
    });
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue == null) return;
    
    setState(() {
      _selectedCategory = newValue;
    });
    
    // Trigger search with new category
    widget.onSearch(widget.keywordController.text, newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Category dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'カテゴリーから探す',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 185,
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: _onCategoryChanged,
                      items: _categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
            ),
          ],
        ),

        // Keyword search box
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'キーワードで探す',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 185,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: widget.keywordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _onSearchChanged,
                  ),
                  hintText: 'キーワードを入力',
                ),
                onSubmitted: (value) {
                  widget.onSearch(value, _selectedCategory ?? '');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}