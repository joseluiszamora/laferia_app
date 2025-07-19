import 'package:equatable/equatable.dart';
import '../../models/search_models.dart';
import '../../models/search_suggestion.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Evento cuando el usuario cambia el texto de búsqueda
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

/// Evento para ejecutar una búsqueda
class SearchExecuted extends SearchEvent {
  final String query;
  final SearchFilters? filters;

  const SearchExecuted(this.query, {this.filters});

  @override
  List<Object?> get props => [query, filters];
}

/// Evento cuando se cambian los filtros de búsqueda
class SearchFiltersChanged extends SearchEvent {
  final SearchFilters filters;

  const SearchFiltersChanged(this.filters);

  @override
  List<Object> get props => [filters];
}

/// Evento cuando se selecciona una sugerencia
class SearchSuggestionSelected extends SearchEvent {
  final SearchSuggestion suggestion;

  const SearchSuggestionSelected(this.suggestion);

  @override
  List<Object> get props => [suggestion];
}

/// Evento para solicitar sugerencias de autocompletado
class SearchSuggestionsRequested extends SearchEvent {
  final String query;

  const SearchSuggestionsRequested(this.query);

  @override
  List<Object> get props => [query];
}

/// Evento para solicitar historial de búsquedas
class SearchHistoryRequested extends SearchEvent {
  final String? userId;
  final String sessionId;

  const SearchHistoryRequested({this.userId, required this.sessionId});

  @override
  List<Object?> get props => [userId, sessionId];
}

/// Evento para solicitar búsquedas populares/tendencias
class TrendingSearchesRequested extends SearchEvent {
  final String? category;

  const TrendingSearchesRequested({this.category});

  @override
  List<Object?> get props => [category];
}

/// Evento para limpiar el campo de búsqueda
class SearchCleared extends SearchEvent {
  const SearchCleared();
}

/// Evento para seleccionar un chip de búsqueda rápida
class SearchChipSelected extends SearchEvent {
  final SearchChip chip;

  const SearchChipSelected(this.chip);

  @override
  List<Object> get props => [chip];
}

/// Evento para inicializar el estado de búsqueda
class SearchInitialized extends SearchEvent {
  final String sessionId;

  const SearchInitialized(this.sessionId);

  @override
  List<Object> get props => [sessionId];
}

/// Evento para marcar click en un resultado
class SearchResultClicked extends SearchEvent {
  final String resultType; // 'product', 'store', 'category'
  final int resultId;

  const SearchResultClicked(this.resultType, this.resultId);

  @override
  List<Object> get props => [resultType, resultId];
}

/// Evento para cargar más resultados (paginación)
class SearchLoadMoreResults extends SearchEvent {
  const SearchLoadMoreResults();
}

/// Evento para reintentar búsqueda en caso de error
class SearchRetryRequested extends SearchEvent {
  const SearchRetryRequested();
}
