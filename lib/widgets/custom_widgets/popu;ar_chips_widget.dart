import 'package:flutter/material.dart';

class PopularChips extends StatefulWidget {
  const PopularChips({super.key, required this.query});
  final String query;

  @override
  State<PopularChips> createState() => _PopularChipsState();
}

class _PopularChipsState extends State<PopularChips> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchController.text = widget.query;
          _searchQuery = widget.query;
          _isSearching = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.query,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
      ),
    );
    ;
  }
}
