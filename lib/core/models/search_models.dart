import 'package:flutter/material.dart';
import 'producto.dart';
import 'tienda.dart';
import 'categoria.dart';

/// Filtros para búsquedas de productos
class ProductFilters {
  final String? category;
  final PriceRange? priceRange;
  final bool? hasOffers;
  final bool? inStock;
  final double? minRating;
  final List<String>? tags;

  const ProductFilters({
    this.category,
    this.priceRange,
    this.hasOffers,
    this.inStock,
    this.minRating,
    this.tags,
  });

  ProductFilters copyWith({
    String? category,
    PriceRange? priceRange,
    bool? hasOffers,
    bool? inStock,
    double? minRating,
    List<String>? tags,
  }) {
    return ProductFilters(
      category: category ?? this.category,
      priceRange: priceRange ?? this.priceRange,
      hasOffers: hasOffers ?? this.hasOffers,
      inStock: inStock ?? this.inStock,
      minRating: minRating ?? this.minRating,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'price_range': priceRange?.toMap(),
      'has_offers': hasOffers,
      'in_stock': inStock,
      'min_rating': minRating,
      'tags': tags,
    };
  }
}

/// Filtros para búsquedas de tiendas
class StoreFilters {
  final String? category;
  final double? maxDistance;
  final double? minRating;
  final bool? isOpen;
  final bool? hasDelivery;

  const StoreFilters({
    this.category,
    this.maxDistance,
    this.minRating,
    this.isOpen,
    this.hasDelivery,
  });

  StoreFilters copyWith({
    String? category,
    double? maxDistance,
    double? minRating,
    bool? isOpen,
    bool? hasDelivery,
  }) {
    return StoreFilters(
      category: category ?? this.category,
      maxDistance: maxDistance ?? this.maxDistance,
      minRating: minRating ?? this.minRating,
      isOpen: isOpen ?? this.isOpen,
      hasDelivery: hasDelivery ?? this.hasDelivery,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'max_distance': maxDistance,
      'min_rating': minRating,
      'is_open': isOpen,
      'has_delivery': hasDelivery,
    };
  }
}

/// Rango de precios
class PriceRange {
  final double min;
  final double max;

  const PriceRange({required this.min, required this.max});

  Map<String, dynamic> toMap() {
    return {'min': min, 'max': max};
  }

  factory PriceRange.fromMap(Map<String, dynamic> map) {
    return PriceRange(
      min: (map['min'] as num).toDouble(),
      max: (map['max'] as num).toDouble(),
    );
  }

  @override
  String toString() =>
      '\$${min.toStringAsFixed(0)} - \$${max.toStringAsFixed(0)}';
}

/// Opciones de ordenamiento
enum SortOption {
  relevance,
  priceAsc,
  priceDesc,
  ratingDesc,
  distanceAsc,
  newest,
  alphabetical,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.relevance:
        return 'Relevancia';
      case SortOption.priceAsc:
        return 'Precio: Menor a Mayor';
      case SortOption.priceDesc:
        return 'Precio: Mayor a Menor';
      case SortOption.ratingDesc:
        return 'Mejor Calificados';
      case SortOption.distanceAsc:
        return 'Más Cercanos';
      case SortOption.newest:
        return 'Más Recientes';
      case SortOption.alphabetical:
        return 'Alfabético';
    }
  }

  IconData get icon {
    switch (this) {
      case SortOption.relevance:
        return Icons.star;
      case SortOption.priceAsc:
        return Icons.arrow_upward;
      case SortOption.priceDesc:
        return Icons.arrow_downward;
      case SortOption.ratingDesc:
        return Icons.thumb_up;
      case SortOption.distanceAsc:
        return Icons.location_on;
      case SortOption.newest:
        return Icons.access_time;
      case SortOption.alphabetical:
        return Icons.sort_by_alpha;
    }
  }
}

/// Filtros generales para búsqueda
class SearchFilters {
  final String? category;
  final PriceRange? priceRange;
  final double? maxDistance;
  final bool? hasOffers;
  final bool? inStock;
  final double? minRating;
  final List<String>? tags;
  final SortOption sortBy;

  const SearchFilters({
    this.category,
    this.priceRange,
    this.maxDistance,
    this.hasOffers,
    this.inStock,
    this.minRating,
    this.tags,
    this.sortBy = SortOption.relevance,
  });

  SearchFilters copyWith({
    String? category,
    PriceRange? priceRange,
    double? maxDistance,
    bool? hasOffers,
    bool? inStock,
    double? minRating,
    List<String>? tags,
    SortOption? sortBy,
  }) {
    return SearchFilters(
      category: category ?? this.category,
      priceRange: priceRange ?? this.priceRange,
      maxDistance: maxDistance ?? this.maxDistance,
      hasOffers: hasOffers ?? this.hasOffers,
      inStock: inStock ?? this.inStock,
      minRating: minRating ?? this.minRating,
      tags: tags ?? this.tags,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters {
    return category != null ||
        priceRange != null ||
        maxDistance != null ||
        hasOffers == true ||
        inStock == true ||
        minRating != null ||
        (tags != null && tags!.isNotEmpty);
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'price_range': priceRange?.toMap(),
      'max_distance': maxDistance,
      'has_offers': hasOffers,
      'in_stock': inStock,
      'min_rating': minRating,
      'tags': tags,
      'sort_by': sortBy.name,
    };
  }
}

/// Resultados de búsqueda
class SearchResults {
  final List<Producto> products;
  final List<Tienda> stores;
  final List<Categoria> categories;
  final int totalResults;
  final String query;
  final SearchFilters appliedFilters;

  const SearchResults({
    this.products = const [],
    this.stores = const [],
    this.categories = const [],
    required this.totalResults,
    required this.query,
    required this.appliedFilters,
  });

  bool get isEmpty => totalResults == 0;
  bool get isNotEmpty => totalResults > 0;

  SearchResults copyWith({
    List<Producto>? products,
    List<Tienda>? stores,
    List<Categoria>? categories,
    int? totalResults,
    String? query,
    SearchFilters? appliedFilters,
  }) {
    return SearchResults(
      products: products ?? this.products,
      stores: stores ?? this.stores,
      categories: categories ?? this.categories,
      totalResults: totalResults ?? this.totalResults,
      query: query ?? this.query,
      appliedFilters: appliedFilters ?? this.appliedFilters,
    );
  }
}

/// Tipos de chips de búsqueda rápida
enum SearchChipType {
  recent,
  trending,
  category,
  offer,
  nearby,
  featured,
  newArrivals,
  topRated,
}

extension SearchChipTypeExtension on SearchChipType {
  String get displayName {
    switch (this) {
      case SearchChipType.recent:
        return 'Reciente';
      case SearchChipType.trending:
        return 'Tendencia';
      case SearchChipType.category:
        return 'Categoría';
      case SearchChipType.offer:
        return 'Con descuento';
      case SearchChipType.nearby:
        return 'Cerca de ti';
      case SearchChipType.featured:
        return 'Destacados';
      case SearchChipType.newArrivals:
        return 'Nuevos';
      case SearchChipType.topRated:
        return 'Mejor valorados';
    }
  }

  IconData get icon {
    switch (this) {
      case SearchChipType.recent:
        return Icons.history;
      case SearchChipType.trending:
        return Icons.trending_up;
      case SearchChipType.category:
        return Icons.category;
      case SearchChipType.offer:
        return Icons.local_offer;
      case SearchChipType.nearby:
        return Icons.location_on;
      case SearchChipType.featured:
        return Icons.star;
      case SearchChipType.newArrivals:
        return Icons.fiber_new;
      case SearchChipType.topRated:
        return Icons.thumb_up;
    }
  }

  Color get color {
    switch (this) {
      case SearchChipType.recent:
        return Colors.grey;
      case SearchChipType.trending:
        return Colors.orange;
      case SearchChipType.category:
        return Colors.blue;
      case SearchChipType.offer:
        return Colors.red;
      case SearchChipType.nearby:
        return Colors.green;
      case SearchChipType.featured:
        return Colors.amber;
      case SearchChipType.newArrivals:
        return Colors.purple;
      case SearchChipType.topRated:
        return Colors.indigo;
    }
  }
}

/// Chip de búsqueda rápida
class SearchChip {
  final String text;
  final SearchChipType type;
  final IconData? icon;
  final Color? color;
  final Map<String, dynamic>? data;

  const SearchChip({
    required this.text,
    required this.type,
    this.icon,
    this.color,
    this.data,
  });

  SearchChip copyWith({
    String? text,
    SearchChipType? type,
    IconData? icon,
    Color? color,
    Map<String, dynamic>? data,
  }) {
    return SearchChip(
      text: text ?? this.text,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      data: data ?? this.data,
    );
  }
}

/// Datos para guardar en historial de búsqueda
class SearchHistoryData {
  final String? userId;
  final String sessionId;
  final String query;
  final String searchType;
  final int resultCount;
  final SearchFilters? filters;
  final Map<String, dynamic>? location;

  const SearchHistoryData({
    this.userId,
    required this.sessionId,
    required this.query,
    this.searchType = 'general',
    this.resultCount = 0,
    this.filters,
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'session_id': sessionId,
      'query': query,
      'search_type': searchType,
      'result_count': resultCount,
      'filters': filters?.toMap(),
      'location': location,
    };
  }
}
