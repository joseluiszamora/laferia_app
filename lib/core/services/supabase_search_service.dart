import 'dart:async';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_models.dart';
import '../models/trending_search.dart';
import '../models/search_suggestion.dart';
import '../models/producto.dart';
import '../models/tienda.dart';
import '../models/categoria.dart';
import '../utils/logger.dart';

class SupabaseSearchService {
  static final _supabase = Supabase.instance.client;
  static final _logger = Logger('SupabaseSearchService');

  /// Búsqueda global que incluye productos, tiendas y categorías
  static Future<SearchResults> searchGlobal(
    String query,
    SearchFilters filters,
  ) async {
    try {
      _logger.info('Ejecutando búsqueda global: "$query"');

      // Ejecutar búsquedas en paralelo
      final futures = await Future.wait([
        searchProducts(query, filters: filters),
        searchStores(query, filters: filters),
        searchCategories(query),
      ]);

      final products = futures[0] as List<Producto>;
      final stores = futures[1] as List<Tienda>;
      final categories = futures[2] as List<Categoria>;

      final totalResults = products.length + stores.length + categories.length;

      // Ordenar resultados según el criterio seleccionado
      final sortedProducts = _sortProducts(products, filters.sortBy);
      final sortedStores = _sortStores(stores, filters.sortBy);

      _logger.info('Búsqueda completada: $totalResults resultados');

      return SearchResults(
        products: sortedProducts,
        stores: sortedStores,
        categories: categories,
        totalResults: totalResults,
        query: query,
        appliedFilters: filters,
      );
    } catch (e, stackTrace) {
      _logger.error('Error en búsqueda global', e, stackTrace);
      throw Exception('Error al realizar la búsqueda: $e');
    }
  }

  /// Búsqueda específica de productos
  static Future<List<Producto>> searchProducts(
    String query, {
    SearchFilters? filters,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Crear query base
      dynamic queryBuilder = _supabase.from('Product').select('*');

      // Aplicar filtro de texto
      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.or(
          'name.ilike.%$query%,'
          'description.ilike.%$query%',
        );
      }

      // Aplicar filtros adicionales
      if (filters?.category != null) {
        queryBuilder = queryBuilder.eq('category_id', filters!.category!);
      }

      if (filters?.hasOffers == true) {
        queryBuilder = queryBuilder.gt('discount_percentage', 0);
      }

      if (filters?.inStock == true) {
        queryBuilder = queryBuilder.eq('is_available', true);
      }

      if (filters?.minRating != null) {
        queryBuilder = queryBuilder.gte('rating', filters!.minRating!);
      }

      if (filters?.priceRange != null) {
        queryBuilder = queryBuilder
            .gte('price', filters!.priceRange!.min)
            .lte('price', filters.priceRange!.max);
      }

      // Ordenamiento
      if (filters?.sortBy != null) {
        switch (filters!.sortBy) {
          case SortOption.priceAsc:
            queryBuilder = queryBuilder.order('price', ascending: true);
            break;
          case SortOption.priceDesc:
            queryBuilder = queryBuilder.order('price', ascending: false);
            break;
          case SortOption.newest:
            queryBuilder = queryBuilder.order('created_at', ascending: false);
            break;
          case SortOption.alphabetical:
            queryBuilder = queryBuilder.order('name', ascending: true);
            break;
          default:
            // Relevancia - por defecto
            break;
        }
      }

      // Límite y offset
      queryBuilder = queryBuilder.range(offset, offset + limit - 1);

      final response = await queryBuilder;
      final List<dynamic> data = response as List<dynamic>;

      return data.map<Producto>((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      _logger.error('Error searching products', e);
      return [];
    }
  }

  /// Búsqueda específica de tiendas
  static Future<List<Tienda>> searchStores(
    String query, {
    SearchFilters? filters,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      dynamic queryBuilder = _supabase.from('Store').select('*');

      // Aplicar filtro de texto
      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.or(
          'name.ilike.%$query%,'
          'owner_name.ilike.%$query%,'
          'address.ilike.%$query%',
        );
      }

      // Aplicar filtros adicionales
      if (filters?.category != null) {
        queryBuilder = queryBuilder.eq('category_id', filters!.category!);
      }

      if (filters?.minRating != null) {
        queryBuilder = queryBuilder.gte('average_rating', filters!.minRating!);
      }

      // Filtrar solo tiendas activas
      queryBuilder = queryBuilder.eq('status', 'active');

      // Límite y offset
      queryBuilder = queryBuilder.range(offset, offset + limit - 1);

      final response = await queryBuilder;
      final List<dynamic> data = response as List<dynamic>;

      return data.map<Tienda>((json) => Tienda.fromJson(json)).toList();
    } catch (e) {
      _logger.error('Error searching stores', e);
      return [];
    }
  }

  /// Búsqueda específica de categorías
  static Future<List<Categoria>> searchCategories(String query) async {
    try {
      if (query.isEmpty) return [];

      final response = await _supabase
          .from('Category')
          .select('*')
          .or(
            'name.ilike.%$query%,'
            'description.ilike.%$query%',
          )
          .limit(10);

      return response
          .map<Categoria>((json) => Categoria.fromJson(json))
          .toList();
    } catch (e) {
      _logger.error('Error en búsqueda de categorías', e);
      return [];
    }
  }

  /// Obtener sugerencias de autocompletado
  static Future<List<SearchSuggestion>> getAutocompleteSuggestions(
    String query,
  ) async {
    try {
      if (query.length < 2) return [];

      // Buscar sugerencias en la tabla SearchSuggestions
      final response = await _supabase
          .from('SearchSuggestion')
          .select('*')
          .or(
            'query.ilike.%$query%,'
            'suggestion.ilike.%$query%',
          )
          .eq('is_active', true)
          .order('weight', ascending: false)
          .limit(10);

      final suggestions =
          response
              .map<SearchSuggestion>((json) => SearchSuggestion.fromMap(json))
              .toList();

      // Si no hay suficientes sugerencias, generar algunas basadas en productos/tiendas
      if (suggestions.length < 5) {
        final additionalSuggestions = await _generateDynamicSuggestions(query);
        suggestions.addAll(additionalSuggestions);
      }

      return suggestions.take(10).toList();
    } catch (e) {
      _logger.error('Error obteniendo sugerencias', e);
      return [];
    }
  }

  /// Generar sugerencias dinámicas basadas en contenido
  static Future<List<SearchSuggestion>> _generateDynamicSuggestions(
    String query,
  ) async {
    final suggestions = <SearchSuggestion>[];

    try {
      // Buscar productos similares
      final products = await _supabase
          .from('Product')
          .select('name')
          .ilike('name', '%$query%')
          .limit(5);

      for (final product in products) {
        suggestions.add(
          SearchSuggestion(
            suggestionId: 0, // Temporal para sugerencias dinámicas
            query: query,
            suggestion: product['name'],
            suggestionType: SearchSuggestionType.product,
            weight: 1,
            createdAt: DateTime.now(),
          ),
        );
      }

      // Buscar tiendas similares
      final stores = await _supabase
          .from('Store')
          .select('name')
          .ilike('name', '%$query%')
          .limit(3);

      for (final store in stores) {
        suggestions.add(
          SearchSuggestion(
            suggestionId: 0,
            query: query,
            suggestion: store['name'],
            suggestionType: SearchSuggestionType.store,
            weight: 1,
            createdAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      _logger.error('Error generando sugerencias dinámicas', e);
    }

    return suggestions;
  }

  /// Obtener búsquedas recientes del usuario
  static Future<List<String>> getRecentSearches(
    String? userId,
    String sessionId, {
    int limit = 10,
  }) async {
    try {
      dynamic queryBuilder = _supabase.from('SearchHistory').select('query');

      // Aplicar filtros primero
      if (userId != null) {
        queryBuilder = queryBuilder.eq('user_id', userId);
      } else {
        queryBuilder = queryBuilder.eq('session_id', sessionId);
      }

      // Luego orden y límite
      queryBuilder = queryBuilder
          .order('created_at', ascending: false)
          .limit(limit);

      final response = await queryBuilder;

      return response
          .map<String>((json) => json['query'] as String)
          .toSet() // Eliminar duplicados
          .toList();
    } catch (e) {
      _logger.error('Error obteniendo búsquedas recientes', e);
      return [];
    }
  }

  /// Obtener búsquedas populares/tendencias
  static Future<List<TrendingSearch>> getTrendingSearches(
    String? category, {
    int limit = 10,
  }) async {
    try {
      dynamic queryBuilder = _supabase.from('TrendingSearch').select('*');

      // Aplicar filtro de categoría si se especifica
      if (category != null) {
        queryBuilder = queryBuilder.eq('category', category);
      }

      // Aplicar orden y límite
      queryBuilder = queryBuilder
          .order('trend_score', ascending: false)
          .limit(limit);

      final response = await queryBuilder;

      return response
          .map<TrendingSearch>((json) => TrendingSearch.fromMap(json))
          .toList();
    } catch (e) {
      _logger.error('Error obteniendo tendencias', e);
      return [];
    }
  }

  /// Guardar búsqueda en historial
  static Future<void> saveSearchHistory(SearchHistoryData data) async {
    try {
      await _supabase.from('SearchHistory').insert(data.toMap());

      // Actualizar contador de tendencias
      await _updateTrendingSearch(data.query, data.searchType);
    } catch (e) {
      _logger.error('Error guardando historial de búsqueda', e);
    }
  }

  /// Actualizar contador de búsquedas populares
  static Future<void> _updateTrendingSearch(
    String query,
    String category,
  ) async {
    try {
      // Intentar actualizar registro existente
      final existing =
          await _supabase
              .from('TrendingSearch')
              .select('trending_search_id, search_count')
              .eq('query', query)
              .maybeSingle();

      if (existing != null) {
        // Actualizar contador existente
        await _supabase
            .from('TrendingSearch')
            .update({
              'search_count': existing['search_count'] + 1,
              'last_searched': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('trending_search_id', existing['trending_search_id']);
      } else {
        // Crear nuevo registro
        await _supabase.from('TrendingSearch').insert({
          'query': query,
          'search_count': 1,
          'category': category,
          'trend_score': 1.0,
          'last_searched': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      _logger.error('Error actualizando tendencias', e);
    }
  }

  /// Marcar click en resultado de búsqueda
  static Future<void> markSearchClick(
    int searchHistoryId,
    String clickedType,
    int clickedId,
  ) async {
    try {
      await _supabase
          .from('SearchHistory')
          .update({
            'clicked': true,
            'clicked_type': clickedType,
            'clicked_id': clickedId,
          })
          .eq('search_history_id', searchHistoryId);
    } catch (e) {
      _logger.error('Error marcando click en búsqueda', e);
    }
  }

  /// Obtener búsquedas populares por chips
  static Future<List<SearchChip>> getPopularSearchChips() async {
    try {
      final trending = await getTrendingSearches(null, limit: 5);
      final chips = <SearchChip>[];

      // Agregar chips de tendencias
      for (final trend in trending.take(3)) {
        chips.add(
          SearchChip(
            text: trend.query,
            type: SearchChipType.trending,
            icon: SearchChipType.trending.icon,
            color: SearchChipType.trending.color,
            data: {'trending_id': trend.trendingSearchId},
          ),
        );
      }

      // Agregar chips predefinidos
      chips.addAll([
        const SearchChip(text: 'Con descuento', type: SearchChipType.offer),
        const SearchChip(text: 'Cerca de ti', type: SearchChipType.nearby),
        const SearchChip(
          text: 'Mejor valorados',
          type: SearchChipType.topRated,
        ),
        const SearchChip(
          text: 'Nuevos productos',
          type: SearchChipType.newArrivals,
        ),
      ]);

      return chips;
    } catch (e) {
      _logger.error('Error obteniendo chips populares', e);
      return _getDefaultChips();
    }
  }

  /// Chips por defecto si falla la carga
  static List<SearchChip> _getDefaultChips() {
    return const [
      SearchChip(text: 'Comida', type: SearchChipType.category),
      SearchChip(text: 'Tecnología', type: SearchChipType.category),
      SearchChip(text: 'Ropa', type: SearchChipType.category),
      SearchChip(text: 'Con descuento', type: SearchChipType.offer),
      SearchChip(text: 'Cerca de ti', type: SearchChipType.nearby),
    ];
  }

  /// Generar ID de sesión único
  static String generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    return '${timestamp}_$random';
  }

  /// Métodos auxiliares para ordenamiento
  static List<Producto> _sortProducts(
    List<Producto> products,
    SortOption sortBy,
  ) {
    switch (sortBy) {
      case SortOption.relevance:
        return products; // Ya ordenados por search_score
      case SortOption.priceAsc:
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingDesc:
        // Nota: rating no existe en el modelo actual de Producto
        // products.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case SortOption.newest:
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.alphabetical:
        products.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        break;
    }
    return products;
  }

  static List<Tienda> _sortStores(List<Tienda> stores, SortOption sortBy) {
    switch (sortBy) {
      case SortOption.relevance:
        return stores; // Ya ordenadas por search_score
      case SortOption.ratingDesc:
        stores.sort(
          (a, b) => (b.averageRating ?? 0).compareTo(a.averageRating ?? 0),
        );
        break;
      case SortOption.alphabetical:
        stores.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        break;
    }
    return stores;
  }
}
