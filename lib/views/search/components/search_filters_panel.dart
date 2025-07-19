import 'package:flutter/material.dart';
import '../../../core/models/search_models.dart';

class SearchFiltersPanel extends StatefulWidget {
  final SearchFilters initialFilters;
  final Function(SearchFilters) onFiltersChanged;

  const SearchFiltersPanel({
    super.key,
    required this.initialFilters,
    required this.onFiltersChanged,
  });

  @override
  State<SearchFiltersPanel> createState() => _SearchFiltersPanelState();
}

class _SearchFiltersPanelState extends State<SearchFiltersPanel> {
  late SearchFilters _currentFilters;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters;
    _priceRange = RangeValues(
      widget.initialFilters.priceRange?.min ?? 0,
      widget.initialFilters.priceRange?.max ?? 1000,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 20),

          // Filters content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryFilter(context),
                  const SizedBox(height: 20),
                  _buildPriceFilter(context),
                  const SizedBox(height: 20),
                  _buildDistanceFilter(context),
                  const SizedBox(height: 20),
                  _buildRatingFilter(context),
                  const SizedBox(height: 20),
                  _buildToggleFilters(context),
                  const SizedBox(height: 20),
                  _buildSortOptions(context),
                ],
              ),
            ),
          ),

          // Action buttons
          const SizedBox(height: 20),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Text(
          'Filtros',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (_currentFilters.hasActiveFilters)
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Limpiar todo'),
          ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = [
      'Comida',
      'Tecnología',
      'Ropa',
      'Hogar',
      'Belleza',
      'Deportes',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoría',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              categories.map((category) {
                final isSelected = _currentFilters.category == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _currentFilters = _currentFilters.copyWith(
                        category: selected ? category : null,
                      );
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceFilter(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rango de precio',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
              _currentFilters = _currentFilters.copyWith(
                priceRange: PriceRange(min: values.start, max: values.end),
              );
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(
              '\$${_priceRange.end.round()}',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceFilter(BuildContext context) {
    final distances = [1.0, 5.0, 10.0, 25.0, 50.0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distancia máxima',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              distances.map((distance) {
                final isSelected = _currentFilters.maxDistance == distance;
                return FilterChip(
                  label: Text('${distance.toInt()} km'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _currentFilters = _currentFilters.copyWith(
                        maxDistance: selected ? distance : null,
                      );
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calificación mínima',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final rating = index + 1.0;
            final isSelected = (_currentFilters.minRating ?? 0) >= rating;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentFilters = _currentFilters.copyWith(
                    minRating:
                        isSelected && _currentFilters.minRating == rating
                            ? null
                            : rating,
                  );
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  isSelected ? Icons.star : Icons.star_border,
                  color: isSelected ? Colors.amber : Colors.grey,
                  size: 32,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildToggleFilters(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opciones adicionales',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text('Solo productos con descuento'),
          subtitle: const Text('Productos en oferta'),
          value: _currentFilters.hasOffers ?? false,
          onChanged: (value) {
            setState(() {
              _currentFilters = _currentFilters.copyWith(hasOffers: value);
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Solo productos disponibles'),
          subtitle: const Text('En stock'),
          value: _currentFilters.inStock ?? false,
          onChanged: (value) {
            setState(() {
              _currentFilters = _currentFilters.copyWith(inStock: value);
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildSortOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ordenar por',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...SortOption.values.map((option) {
          return RadioListTile<SortOption>(
            title: Text(option.displayName),
            value: option,
            groupValue: _currentFilters.sortBy,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _currentFilters = _currentFilters.copyWith(sortBy: value);
                });
              }
            },
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _clearFilters,
            child: const Text('Limpiar filtros'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _applyFilters,
            child: const Text('Aplicar filtros'),
          ),
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = const SearchFilters();
      _priceRange = const RangeValues(0, 1000);
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_currentFilters);
    Navigator.of(context).pop();
  }
}

/// Badge para mostrar el número de filtros activos
class FiltersActiveBadge extends StatelessWidget {
  final SearchFilters filters;
  final VoidCallback onTap;

  const FiltersActiveBadge({
    super.key,
    required this.filters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeFiltersCount = _getActiveFiltersCount();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                activeFiltersCount > 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                size: 16,
                color:
                    activeFiltersCount > 0
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                activeFiltersCount > 0 ? '$activeFiltersCount' : 'Filtros',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      activeFiltersCount > 0
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (filters.category != null) count++;
    if (filters.priceRange != null) count++;
    if (filters.maxDistance != null) count++;
    if (filters.hasOffers == true) count++;
    if (filters.inStock == true) count++;
    if (filters.minRating != null) count++;
    if (filters.sortBy != SortOption.relevance) count++;
    return count;
  }
}
