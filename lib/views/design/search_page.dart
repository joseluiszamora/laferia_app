import 'package:flutter/material.dart';
import 'package:laferia/views/design/components/custom_text_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    "Pizza",
    "Hamburger",
    "Italian food",
    "Chinese restaurant",
  ];
  final List<String> _popularSearches = [
    "Fast food",
    "Healthy meals",
    "Desserts",
    "Drinks",
    "Mexican",
    "Thai",
    "Indian",
    "Japanese",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.textTheme.titleMedium?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomTextField(
          label: "Search",
          controller: _searchController,
          hint: "Search for restaurants, food...",
          prefixIcon: Icon(
            Icons.search,
            color: theme.textTheme.bodyMedium?.color,
          ),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                  : null,
          margin: EdgeInsets.zero,
          // onChanged: (value) {
          //   setState(() {});
          // },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters section
            _buildFiltersSection(theme),
            const SizedBox(height: 24),

            // Recent searches
            if (_recentSearches.isNotEmpty) ...[
              _buildSectionTitle(theme, "Recent searches"),
              const SizedBox(height: 16),
              _buildSearchSuggestions(theme, _recentSearches, true),
              const SizedBox(height: 24),
            ],

            // Popular searches
            _buildSectionTitle(theme, "Popular searches"),
            const SizedBox(height: 16),
            _buildSearchSuggestions(theme, _popularSearches, false),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _FilterButton(
            icon: Icons.tune,
            label: "Filters",
            theme: theme,
            onTap: () => _showFiltersBottomSheet(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FilterButton(
            icon: Icons.sort,
            label: "Sort by",
            theme: theme,
            onTap: () => _showSortBottomSheet(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FilterButton(
            icon: Icons.location_on_outlined,
            label: "Near me",
            theme: theme,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.headlineMedium?.color,
        fontFamily: 'Kodchasan',
      ),
    );
  }

  Widget _buildSearchSuggestions(
    ThemeData theme,
    List<String> suggestions,
    bool showDeleteIcon,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          suggestions.map((suggestion) {
            return _SearchSuggestionChip(
              text: suggestion,
              theme: theme,
              showDeleteIcon: showDeleteIcon,
              onTap: () => _performSearch(suggestion),
              onDelete:
                  showDeleteIcon ? () => _deleteRecentSearch(suggestion) : null,
            );
          }).toList(),
    );
  }

  void _performSearch(String query) {
    _searchController.text = query;
    // Implement search logic here
  }

  void _deleteRecentSearch(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FiltersBottomSheet(),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SortBottomSheet(),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeData theme;
  final VoidCallback onTap;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: theme.textTheme.bodyMedium?.color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w500,
                fontFamily: 'Kodchasan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchSuggestionChip extends StatelessWidget {
  final String text;
  final ThemeData theme;
  final bool showDeleteIcon;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _SearchSuggestionChip({
    required this.text,
    required this.theme,
    required this.showDeleteIcon,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontFamily: 'Kodchasan',
              ),
            ),
            if (showDeleteIcon && onDelete != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FiltersBottomSheet extends StatefulWidget {
  @override
  State<_FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<_FiltersBottomSheet> {
  double _priceRange = 50;
  double _rating = 4.0;
  Set<String> _selectedCuisines = {"Italian", "Mexican"};
  Set<String> _selectedFeatures = {"Delivery", "Takeout"};

  final List<String> _cuisines = [
    "Italian",
    "Mexican",
    "Chinese",
    "Indian",
    "Thai",
    "Japanese",
    "American",
  ];
  final List<String> _features = [
    "Delivery",
    "Takeout",
    "Dine-in",
    "Outdoor seating",
    "Vegetarian options",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filters",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 20),

          // Price range
          Text("Price range", style: theme.textTheme.titleMedium),
          Slider(
            value: _priceRange,
            max: 100,
            divisions: 10,
            label: "\$${_priceRange.round()}",
            onChanged: (value) => setState(() => _priceRange = value),
          ),

          // Rating
          Text("Minimum rating", style: theme.textTheme.titleMedium),
          Slider(
            value: _rating,
            max: 5,
            divisions: 8,
            label: "${_rating.toStringAsFixed(1)} stars",
            onChanged: (value) => setState(() => _rating = value),
          ),

          // Cuisines
          Text("Cuisine type", style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                _cuisines.map((cuisine) {
                  final isSelected = _selectedCuisines.contains(cuisine);
                  return FilterChip(
                    label: Text(cuisine),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCuisines.add(cuisine);
                        } else {
                          _selectedCuisines.remove(cuisine);
                        }
                      });
                    },
                  );
                }).toList(),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Apply Filters"),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _priceRange = 50;
                    _rating = 4.0;
                    _selectedCuisines.clear();
                    _selectedFeatures.clear();
                  });
                },
                child: const Text("Clear"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortBottomSheet extends StatefulWidget {
  @override
  State<_SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<_SortBottomSheet> {
  String _selectedSort = "Distance";
  final List<String> _sortOptions = [
    "Distance",
    "Rating",
    "Price: Low to High",
    "Price: High to Low",
    "Delivery time",
    "Popularity",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sort by",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 20),

          ..._sortOptions.map((option) {
            return RadioListTile<String>(
              value: option,
              groupValue: _selectedSort,
              onChanged: (value) {
                setState(() => _selectedSort = value!);
                Navigator.pop(context);
              },
              title: Text(option),
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ],
      ),
    );
  }
}
