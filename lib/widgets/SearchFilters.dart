import 'package:flutter/material.dart';

class SearchFilters extends StatefulWidget {
  final TextEditingController keywordController;

  const SearchFilters({
    super.key,
    required this.keywordController,
  });

  @override
  _SearchFiltersState createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
  String? _selectedCategory = '機械測定機器'; // Default category
  final List<String> _categories = [
    '機械測定機器',
    '機械測定機器ー2',
    '機械測定機器ー3'
  ]; // Dropdown options

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
                  color: Colors.black54),
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
              child: DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items:
                    _categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down),
                isExpanded: true,
                underline: const SizedBox(), // Remove underline
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
                  color: Colors.black54),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  suffixIcon: Icon(Icons.search),
                  hintText: '', // Hint text
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
