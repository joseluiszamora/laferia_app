import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/supabase_search_service.dart';
import '../../models/search_models.dart';
import '../../models/search_suggestion.dart';
import '../../utils/logger.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  static final _logger = Logger('SearchBloc');

  // Timer para debounce de búsqueda
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  // Cache para resultados recientes
  final Map<String, SearchResults> _searchCache = {};
  static const int _maxCacheSize = 20;

  // Variables de estado
  String _currentQuery = '';
  SearchFilters _currentFilters = const SearchFilters();
  String _sessionId = '';
  String? _userId;

  SearchBloc() : super(const SearchInitial(sessionId: '')) {
    on<SearchInitialized>(_onSearchInitialized);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchExecuted>(_onSearchExecuted);
    on<SearchFiltersChanged>(_onFiltersChanged);
    on<SearchSuggestionSelected>(_onSuggestionSelected);
    on<SearchSuggestionsRequested>(_onSuggestionsRequested);
    on<SearchHistoryRequested>(_onHistoryRequested);
    on<TrendingSearchesRequested>(_onTrendingRequested);
    on<SearchCleared>(_onSearchCleared);
    on<SearchChipSelected>(_onChipSelected);
    on<SearchResultClicked>(_onResultClicked);
    on<SearchLoadMoreResults>(_onLoadMoreResults);
    on<SearchRetryRequested>(_onRetryRequested);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  /// Inicializar el estado de búsqueda
  Future<void> _onSearchInitialized(
    SearchInitialized event,
    Emitter<SearchState> emit,
  ) async {
    try {
      _sessionId = event.sessionId;

      // Cargar datos iniciales en paralelo
      final futures = await Future.wait([
        SupabaseSearchService.getPopularSearchChips(),
        SupabaseSearchService.getRecentSearches(_userId, _sessionId),
        SupabaseSearchService.getTrendingSearches(null, limit: 5),
      ]);

      final quickChips = futures[0] as List<SearchChip>;
      final recentSearches = futures[1] as List<String>;
      final trendingSearches = futures[2] as List;

      emit(
        SearchInitial(
          sessionId: _sessionId,
          quickSearchChips: quickChips,
          recentSearches: recentSearches,
          trendingSearches: trendingSearches.cast(),
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Error inicializando búsqueda', e, stackTrace);
      emit(SearchError(message: 'Error al inicializar la búsqueda'));
    }
  }

  /// Manejar cambios en el texto de búsqueda con debounce
  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    _currentQuery = event.query;

    // Cancelar timer previo
    _debounceTimer?.cancel();

    if (event.query.isEmpty) {
      // Si está vacío, volver al estado inicial
      add(SearchInitialized(_sessionId));
      return;
    }

    if (event.query.length < 2) {
      return; // No buscar con menos de 2 caracteres
    }

    // Configurar nuevo timer de debounce
    _debounceTimer = Timer(_debounceDuration, () {
      add(SearchSuggestionsRequested(event.query));
    });
  }

  /// Solicitar sugerencias de autocompletado
  Future<void> _onSuggestionsRequested(
    SearchSuggestionsRequested event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(SearchSuggestionsLoading(query: event.query));

      final futures = await Future.wait([
        SupabaseSearchService.getAutocompleteSuggestions(event.query),
        SupabaseSearchService.getRecentSearches(_userId, _sessionId),
      ]);

      final suggestions = futures[0] as List<SearchSuggestion>;
      final recentSearches = futures[1] as List<String>;

      emit(
        SearchSuggestionsLoaded(
          query: event.query,
          suggestions: suggestions,
          recentSearches: recentSearches,
          currentFilters: _currentFilters,
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Error obteniendo sugerencias', e, stackTrace);
      emit(SearchError(message: 'Error al obtener sugerencias'));
    }
  }

  /// Ejecutar búsqueda principal
  Future<void> _onSearchExecuted(
    SearchExecuted event,
    Emitter<SearchState> emit,
  ) async {
    try {
      _currentQuery = event.query;
      if (event.filters != null) {
        _currentFilters = event.filters!;
      }

      // Verificar cache primero
      final cacheKey = '${event.query}_${_currentFilters.hashCode}';
      if (_searchCache.containsKey(cacheKey)) {
        final cachedResults = _searchCache[cacheKey]!;
        emit(
          SearchResultsLoaded(results: cachedResults, hasMoreResults: false),
        );
        return;
      }

      emit(SearchLoading(query: event.query, filters: _currentFilters));

      // Ejecutar búsqueda
      final results = await SupabaseSearchService.searchGlobal(
        event.query,
        _currentFilters,
      );

      // Guardar en historial
      await SupabaseSearchService.saveSearchHistory(
        SearchHistoryData(
          userId: _userId,
          sessionId: _sessionId,
          query: event.query,
          resultCount: results.totalResults,
          filters: _currentFilters,
        ),
      );

      // Guardar en cache
      _addToCache(cacheKey, results);

      if (results.isEmpty) {
        emit(
          SearchNoResults(query: event.query, appliedFilters: _currentFilters),
        );
      } else {
        emit(
          SearchResultsLoaded(
            results: results,
            hasMoreResults: results.totalResults > 50, // Asumiendo límite de 50
          ),
        );
      }
    } catch (e, stackTrace) {
      _logger.error('Error ejecutando búsqueda', e, stackTrace);
      emit(
        SearchError(
          message: 'Error al realizar la búsqueda',
          query: event.query,
          filters: _currentFilters,
        ),
      );
    }
  }

  /// Cambiar filtros de búsqueda
  Future<void> _onFiltersChanged(
    SearchFiltersChanged event,
    Emitter<SearchState> emit,
  ) async {
    _currentFilters = event.filters;

    emit(
      SearchFiltersUpdated(
        filters: _currentFilters,
        currentResults:
            state is SearchResultsLoaded
                ? (state as SearchResultsLoaded).results
                : null,
      ),
    );

    // Si hay una búsqueda activa, ejecutarla con los nuevos filtros
    if (_currentQuery.isNotEmpty) {
      add(SearchExecuted(_currentQuery, filters: _currentFilters));
    }
  }

  /// Seleccionar una sugerencia
  Future<void> _onSuggestionSelected(
    SearchSuggestionSelected event,
    Emitter<SearchState> emit,
  ) async {
    // Ejecutar búsqueda con la sugerencia seleccionada
    add(SearchExecuted(event.suggestion.suggestion));
  }

  /// Seleccionar un chip de búsqueda rápida
  Future<void> _onChipSelected(
    SearchChipSelected event,
    Emitter<SearchState> emit,
  ) async {
    switch (event.chip.type) {
      case SearchChipType.recent:
      case SearchChipType.trending:
      case SearchChipType.category:
        // Ejecutar búsqueda con el texto del chip
        add(SearchExecuted(event.chip.text));
        break;

      case SearchChipType.offer:
        // Aplicar filtro de ofertas
        final newFilters = _currentFilters.copyWith(hasOffers: true);
        add(SearchFiltersChanged(newFilters));
        if (_currentQuery.isNotEmpty) {
          add(SearchExecuted(_currentQuery, filters: newFilters));
        }
        break;

      case SearchChipType.nearby:
        // Aquí se podría implementar búsqueda por ubicación
        _logger.info('Búsqueda por ubicación no implementada aún');
        break;

      case SearchChipType.featured:
      case SearchChipType.topRated:
        // Aplicar filtro de calificación mínima
        final newFilters = _currentFilters.copyWith(
          minRating: 4.0,
          sortBy: SortOption.ratingDesc,
        );
        add(SearchFiltersChanged(newFilters));
        if (_currentQuery.isNotEmpty) {
          add(SearchExecuted(_currentQuery, filters: newFilters));
        }
        break;

      case SearchChipType.newArrivals:
        // Aplicar filtro de productos nuevos
        final newFilters = _currentFilters.copyWith(sortBy: SortOption.newest);
        add(SearchFiltersChanged(newFilters));
        if (_currentQuery.isNotEmpty) {
          add(SearchExecuted(_currentQuery, filters: newFilters));
        }
        break;
    }
  }

  /// Limpiar búsqueda
  Future<void> _onSearchCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) async {
    _currentQuery = '';
    _currentFilters = const SearchFilters();
    add(SearchInitialized(_sessionId));
  }

  /// Cargar historial de búsquedas
  Future<void> _onHistoryRequested(
    SearchHistoryRequested event,
    Emitter<SearchState> emit,
  ) async {
    // Este método se puede usar para mostrar un modal de historial
    try {
      final recentSearches = await SupabaseSearchService.getRecentSearches(
        event.userId,
        event.sessionId,
      );

      _logger.info('Historial cargado: ${recentSearches.length} búsquedas');
    } catch (e, stackTrace) {
      _logger.error('Error cargando historial', e, stackTrace);
    }
  }

  /// Cargar búsquedas populares
  Future<void> _onTrendingRequested(
    TrendingSearchesRequested event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final trending = await SupabaseSearchService.getTrendingSearches(
        event.category,
      );

      _logger.info('Tendencias cargadas: ${trending.length} búsquedas');
    } catch (e, stackTrace) {
      _logger.error('Error cargando tendencias', e, stackTrace);
    }
  }

  /// Marcar click en resultado
  Future<void> _onResultClicked(
    SearchResultClicked event,
    Emitter<SearchState> emit,
  ) async {
    try {
      // Marcar el click en el historial si existe
      // Esto requeriría mantener el ID del historial actual
      _logger.info('Click en resultado: ${event.resultType} ${event.resultId}');
    } catch (e, stackTrace) {
      _logger.error('Error marcando click', e, stackTrace);
    }
  }

  /// Cargar más resultados (paginación)
  Future<void> _onLoadMoreResults(
    SearchLoadMoreResults event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchResultsLoaded) return;

    final currentState = state as SearchResultsLoaded;

    try {
      emit(SearchLoadingMore(currentResults: currentState.results));

      // Aquí se implementaría la lógica de paginación
      // Por ahora, simular que no hay más resultados
      await Future.delayed(const Duration(seconds: 1));

      emit(
        SearchResultsLoaded(
          results: currentState.results,
          hasMoreResults: false,
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Error cargando más resultados', e, stackTrace);
      emit(currentState); // Volver al estado anterior
    }
  }

  /// Reintentar búsqueda en caso de error
  Future<void> _onRetryRequested(
    SearchRetryRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchError) {
      final errorState = state as SearchError;
      if (errorState.query != null) {
        add(SearchExecuted(errorState.query!, filters: errorState.filters));
      }
    }
  }

  /// Métodos auxiliares
  void _addToCache(String key, SearchResults results) {
    if (_searchCache.length >= _maxCacheSize) {
      // Eliminar la entrada más antigua
      final oldestKey = _searchCache.keys.first;
      _searchCache.remove(oldestKey);
    }
    _searchCache[key] = results;
  }

  // Getters públicos
  String get currentQuery => _currentQuery;
  SearchFilters get currentFilters => _currentFilters;
  String get sessionId => _sessionId;

  // Setter para userId (cuando el usuario se loguea)
  void setUserId(String? userId) {
    _userId = userId;
  }
}
