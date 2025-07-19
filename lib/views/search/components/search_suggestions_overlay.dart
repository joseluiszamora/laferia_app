import 'package:flutter/material.dart';
import '../../../core/models/search_suggestion.dart';

class SearchSuggestionsOverlay extends StatelessWidget {
  final List<SearchSuggestion> suggestions;
  final List<String> recentSearches;
  final Function(String) onSuggestionTap;
  final Function() onClear;
  final String currentQuery;

  const SearchSuggestionsOverlay({
    super.key,
    required this.suggestions,
    this.recentSearches = const [],
    required this.onSuggestionTap,
    required this.onClear,
    this.currentQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasRecentSearches = recentSearches.isNotEmpty && currentQuery.isEmpty;
    final hasSuggestions = suggestions.isNotEmpty;

    if (!hasRecentSearches && !hasSuggestions) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header con título y botón limpiar
          if (hasRecentSearches || hasSuggestions) _buildHeader(context),

          // Lista de sugerencias o búsquedas recientes
          _buildSuggestionsList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final title = currentQuery.isEmpty ? 'Búsquedas recientes' : 'Sugerencias';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            currentQuery.isEmpty ? Icons.history : Icons.search,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          if (recentSearches.isNotEmpty && currentQuery.isEmpty)
            TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 32),
              ),
              child: Text(
                'Limpiar',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList(BuildContext context) {
    final itemsToShow = currentQuery.isEmpty ? recentSearches : suggestions;
    final maxItems = currentQuery.isEmpty ? 5 : 8;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          (itemsToShow.length > maxItems) ? maxItems : itemsToShow.length,
      itemBuilder: (context, index) {
        if (currentQuery.isEmpty) {
          return _buildRecentSearchItem(context, recentSearches[index]);
        } else {
          return _buildSuggestionItem(context, suggestions[index]);
        }
      },
    );
  }

  Widget _buildRecentSearchItem(BuildContext context, String query) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSuggestionTap(query),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.history,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  query,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                Icons.call_made,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(
    BuildContext context,
    SearchSuggestion suggestion,
  ) {
    final theme = Theme.of(context);
    final icon = _getIconForSuggestionType(suggestion.suggestionType);
    final color = _getColorForSuggestionType(suggestion.suggestionType, theme);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSuggestionTap(suggestion.suggestion),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHighlightedText(
                      suggestion.suggestion,
                      currentQuery,
                      theme,
                    ),
                    if (suggestion.suggestionType !=
                        SearchSuggestionType.autocomplete)
                      Text(
                        _getSuggestionTypeLabel(suggestion.suggestionType),
                        style: TextStyle(
                          fontSize: 11,
                          color: color.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.call_made,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, ThemeData theme) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(
        text,
        style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          if (index > 0)
            TextSpan(
              text: text.substring(0, index),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (index + query.length < text.length)
            TextSpan(
              text: text.substring(index + query.length),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIconForSuggestionType(SearchSuggestionType type) {
    switch (type) {
      case SearchSuggestionType.autocomplete:
        return Icons.search;
      case SearchSuggestionType.recent:
        return Icons.history;
      case SearchSuggestionType.trending:
        return Icons.trending_up;
      case SearchSuggestionType.category:
        return Icons.category;
      case SearchSuggestionType.product:
        return Icons.shopping_bag;
      case SearchSuggestionType.store:
        return Icons.store;
      case SearchSuggestionType.related:
        return Icons.link;
    }
  }

  Color _getColorForSuggestionType(SearchSuggestionType type, ThemeData theme) {
    switch (type) {
      case SearchSuggestionType.autocomplete:
        return theme.colorScheme.onSurfaceVariant;
      case SearchSuggestionType.recent:
        return Colors.grey;
      case SearchSuggestionType.trending:
        return Colors.orange;
      case SearchSuggestionType.category:
        return Colors.blue;
      case SearchSuggestionType.product:
        return Colors.green;
      case SearchSuggestionType.store:
        return Colors.purple;
      case SearchSuggestionType.related:
        return theme.colorScheme.primary;
    }
  }

  String _getSuggestionTypeLabel(SearchSuggestionType type) {
    switch (type) {
      case SearchSuggestionType.recent:
        return 'Búsqueda reciente';
      case SearchSuggestionType.trending:
        return 'Tendencia';
      case SearchSuggestionType.category:
        return 'Categoría';
      case SearchSuggestionType.product:
        return 'Producto';
      case SearchSuggestionType.store:
        return 'Tienda';
      case SearchSuggestionType.related:
        return 'Relacionado';
      default:
        return '';
    }
  }
}
