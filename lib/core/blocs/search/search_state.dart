import 'package:equatable/equatable.dart';
import '../../models/search_models.dart';
import '../../models/search_suggestion.dart';
import '../../models/trending_search.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial de la búsqueda
class SearchInitial extends SearchState {
  final String sessionId;
  final List<SearchChip> quickSearchChips;
  final List<String> recentSearches;
  final List<TrendingSearch> trendingSearches;

  const SearchInitial({
    required this.sessionId,
    this.quickSearchChips = const [],
    this.recentSearches = const [],
    this.trendingSearches = const [],
  });

  @override
  List<Object> get props => [
    sessionId,
    quickSearchChips,
    recentSearches,
    trendingSearches,
  ];
}

/// Estado cuando el usuario está escribiendo y se muestran sugerencias
class SearchSuggestionsLoaded extends SearchState {
  final String query;
  final List<SearchSuggestion> suggestions;
  final List<String> recentSearches;
  final SearchFilters currentFilters;

  const SearchSuggestionsLoaded({
    required this.query,
    required this.suggestions,
    this.recentSearches = const [],
    required this.currentFilters,
  });

  @override
  List<Object> get props => [
    query,
    suggestions,
    recentSearches,
    currentFilters,
  ];
}

/// Estado de carga durante la búsqueda
class SearchLoading extends SearchState {
  final String query;
  final SearchFilters filters;

  const SearchLoading({required this.query, required this.filters});

  @override
  List<Object> get props => [query, filters];
}

/// Estado con resultados de búsqueda cargados
class SearchResultsLoaded extends SearchState {
  final SearchResults results;
  final bool hasMoreResults;
  final List<SearchSuggestion> suggestions;

  const SearchResultsLoaded({
    required this.results,
    this.hasMoreResults = false,
    this.suggestions = const [],
  });

  @override
  List<Object> get props => [results, hasMoreResults, suggestions];
}

/// Estado de carga de más resultados (paginación)
class SearchLoadingMore extends SearchState {
  final SearchResults currentResults;

  const SearchLoadingMore({required this.currentResults});

  @override
  List<Object> get props => [currentResults];
}

/// Estado cuando no hay resultados
class SearchNoResults extends SearchState {
  final String query;
  final SearchFilters appliedFilters;
  final List<SearchSuggestion> suggestions;

  const SearchNoResults({
    required this.query,
    required this.appliedFilters,
    this.suggestions = const [],
  });

  @override
  List<Object> get props => [query, appliedFilters, suggestions];
}

/// Estado de error en la búsqueda
class SearchError extends SearchState {
  final String message;
  final String? query;
  final SearchFilters? filters;

  const SearchError({required this.message, this.query, this.filters});

  @override
  List<Object?> get props => [message, query, filters];
}

/// Estado cuando se están cargando las sugerencias
class SearchSuggestionsLoading extends SearchState {
  final String query;

  const SearchSuggestionsLoading({required this.query});

  @override
  List<Object> get props => [query];
}

/// Estado cuando se han actualizado los filtros
class SearchFiltersUpdated extends SearchState {
  final SearchFilters filters;
  final SearchResults? currentResults;

  const SearchFiltersUpdated({required this.filters, this.currentResults});

  @override
  List<Object?> get props => [filters, currentResults];
}
