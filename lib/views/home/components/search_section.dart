import 'package:flutter/material.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: _performSearch,
        decoration: InputDecoration(
          hintText: "Busca comida, repuestos, ropa...",
          hintStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            fontFamily: 'Kodchasan',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
          suffixIcon: GestureDetector(
            onTap: _showSearchFilters,
            child: Icon(Icons.tune, color: theme.colorScheme.primary),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 16,
          fontFamily: 'Kodchasan',
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      // TODO: Implement actual search functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Searching for: "$query"'),
          action: SnackBarAction(
            label: 'View Results',
            onPressed: () {
              // Navigate to search results
            },
          ),
        ),
      );
    }
  }

  void _showSearchFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search Filters",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                    fontFamily: 'Kodchasan',
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Nearby restaurants"),
                  onTap: () {
                    Navigator.pop(context);
                    _filterByLocation();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text("Highly rated"),
                  onTap: () {
                    Navigator.pop(context);
                    _filterByRating();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_offer),
                  title: const Text("Special offers"),
                  onTap: () {
                    Navigator.pop(context);
                    _filterByOffers();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _filterByLocation() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Showing nearby restaurants')));
  }

  void _filterByRating() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Showing highly rated restaurants')),
    );
  }

  void _filterByOffers() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Showing special offers')));
  }
}
