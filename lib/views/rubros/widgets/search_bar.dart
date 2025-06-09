import 'package:flutter/material.dart';

class RubrosSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String? hintText;

  const RubrosSearchBar({super.key, required this.onSearch, this.hintText});

  @override
  State<RubrosSearchBar> createState() => _RubrosSearchBarState();
}

class _RubrosSearchBarState extends State<RubrosSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: widget.onSearch,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Buscar rubros...',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () {
                      _controller.clear();
                      widget.onSearch('');
                      _focusNode.unfocus();
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
