import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/search/search_bloc.dart';
import '../../core/blocs/search/search_event.dart';
import '../../core/blocs/search/search_state.dart';
import '../../core/models/search_models.dart';
import '../../core/services/supabase_search_service.dart';
import 'components/search_chips_section.dart';
import 'components/search_suggestions_overlay.dart';
import 'components/search_filters_panel.dart';
import 'components/search_results_view.dart';

class AdvancedSearchSection extends StatefulWidget {
  final Function(SearchResults)? onSearchResults;
  final Function(String)? onQueryChanged;
  final String? initialQuery;
  final bool showInAppBar;

  const AdvancedSearchSection({
    super.key,
    this.onSearchResults,
    this.onQueryChanged,
    this.initialQuery,
    this.showInAppBar = false,
  });

  @override
  State<AdvancedSearchSection> createState() => _AdvancedSearchSectionState();
}

class _AdvancedSearchSectionState extends State<AdvancedSearchSection>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isSearchFocused = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchFocusNode = FocusNode();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _searchFocusNode.addListener(_onFocusChanged);

    // Inicializar el BLoC
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchBloc>().add(
        SearchInitialized(SupabaseSearchService.generateSessionId()),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
      _showSuggestions = _searchFocusNode.hasFocus;
    });

    if (_isSearchFocused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchResultsLoaded) {
          widget.onSearchResults?.call(state.results);
        }
        if (state is SearchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              action: SnackBarAction(
                label: 'Reintentar',
                onPressed: () {
                  context.read<SearchBloc>().add(const SearchRetryRequested());
                },
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          _buildSearchField(),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildSearchContent(state),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search input field
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Buscar productos, tiendas...',
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (query) {
                widget.onQueryChanged?.call(query);
                context.read<SearchBloc>().add(SearchQueryChanged(query));
                setState(() {}); // Para actualizar el suffixIcon
              },
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  _executeSearch(query);
                }
              },
            ),
          ),

          // Filters button
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              final currentFilters = context.read<SearchBloc>().currentFilters;
              return FiltersActiveBadge(
                filters: currentFilters,
                onTap: () => _showFiltersPanel(currentFilters),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSearchContent(SearchState state) {
    if (state is SearchInitial) {
      return _buildInitialContent(state);
    } else if (state is SearchSuggestionsLoaded && _showSuggestions) {
      return _buildSuggestionsContent(state);
    } else if (state is SearchLoading) {
      return _buildLoadingContent();
    } else if (state is SearchResultsLoaded) {
      return _buildResultsContent(state);
    } else if (state is SearchNoResults) {
      return _buildNoResultsContent(state);
    } else if (state is SearchError) {
      return _buildErrorContent(state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildInitialContent(SearchInitial state) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          if (state.quickSearchChips.isNotEmpty)
            CategorizedSearchChips(
              chips: state.quickSearchChips,
              onChipTap: (chip) {
                context.read<SearchBloc>().add(SearchChipSelected(chip));
              },
            ),
          if (state.recentSearches.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildRecentSearchesSection(state.recentSearches),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestionsContent(SearchSuggestionsLoaded state) {
    return SearchSuggestionsOverlay(
      suggestions: state.suggestions,
      recentSearches: state.recentSearches,
      currentQuery: state.query,
      onSuggestionTap: (suggestion) {
        _searchController.text = suggestion;
        _executeSearch(suggestion);
        _searchFocusNode.unfocus();
      },
      onClear: () {
        // Limpiar búsquedas recientes
        // Esto podría implementarse en el servicio
      },
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Buscando...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsContent(SearchResultsLoaded state) {
    return SearchResultsView(
      results: state.results,
      onProductTap: (product) {
        // Navegar a detalle del producto
        context.read<SearchBloc>().add(
          SearchResultClicked('product', product.id),
        );
      },
      onStoreTap: (store) {
        // Navegar a detalle de la tienda
        context.read<SearchBloc>().add(SearchResultClicked('store', store.id));
      },
      onCategoryTap: (category) {
        // Navegar a detalle de la categoría
        context.read<SearchBloc>().add(
          SearchResultClicked('category', category.id),
        );
      },
    );
  }

  Widget _buildNoResultsContent(SearchNoResults state) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron resultados',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otras palabras clave o ajusta los filtros',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (state.suggestions.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text(
              'Sugerencias:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  state.suggestions.take(3).map((suggestion) {
                    return ActionChip(
                      label: Text(suggestion.suggestion),
                      onPressed: () {
                        _searchController.text = suggestion.suggestion;
                        _executeSearch(suggestion.suggestion);
                      },
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorContent(SearchError state) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error en la búsqueda',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<SearchBloc>().add(const SearchRetryRequested());
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchesSection(List<String> recentSearches) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'Búsquedas recientes',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                recentSearches.take(5).map((search) {
                  return ActionChip(
                    label: Text(search),
                    onPressed: () {
                      _searchController.text = search;
                      _executeSearch(search);
                    },
                    avatar: const Icon(Icons.history, size: 16),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  void _executeSearch(String query) {
    if (query.trim().isEmpty) return;

    context.read<SearchBloc>().add(SearchExecuted(query.trim()));
    setState(() {
      _showSuggestions = false;
    });
    _searchFocusNode.unfocus();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(const SearchCleared());
    setState(() {
      _showSuggestions = false;
    });
  }

  void _showFiltersPanel(SearchFilters currentFilters) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder:
                (context, scrollController) => SearchFiltersPanel(
                  initialFilters: currentFilters,
                  onFiltersChanged: (filters) {
                    context.read<SearchBloc>().add(
                      SearchFiltersChanged(filters),
                    );
                  },
                ),
          ),
    );
  }
}
