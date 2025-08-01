import 'package:flutter/material.dart';
import 'dart:async';

class ProductosSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const ProductosSearchBar({super.key, required this.onSearch});

  @override
  State<ProductosSearchBar> createState() => _ProductosSearchBarState();
}

class _ProductosSearchBarState extends State<ProductosSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar productos por nombre, SKU o descripción...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _debounceTimer?.cancel();
              widget.onSearch('');
              setState(() {});
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        onChanged: (value) {
          setState(() {});
          _onSearchChanged(value);
        },
        onSubmitted: (value) {
          _debounceTimer?.cancel();
          widget.onSearch(value.trim());
        },
      ),
    );
  }
}
