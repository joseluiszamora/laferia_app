enum SearchSuggestionType {
  autocomplete,
  recent,
  trending,
  category,
  product,
  store,
  related,
}

class SearchSuggestion {
  final int suggestionId;
  final String query;
  final String suggestion;
  final SearchSuggestionType suggestionType;
  final int weight;
  final bool isActive;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const SearchSuggestion({
    required this.suggestionId,
    required this.query,
    required this.suggestion,
    required this.suggestionType,
    this.weight = 1,
    this.isActive = true,
    required this.createdAt,
    this.metadata,
  });

  factory SearchSuggestion.fromMap(Map<String, dynamic> map) {
    return SearchSuggestion(
      suggestionId: map['suggestion_id'] as int,
      query: map['query'] as String,
      suggestion: map['suggestion'] as String,
      suggestionType: _parseSearchSuggestionType(
        map['suggestion_type'] as String,
      ),
      weight: map['weight'] as int? ?? 1,
      isActive: map['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(map['created_at'] as String),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'suggestion_id': suggestionId,
      'query': query,
      'suggestion': suggestion,
      'suggestion_type': suggestionType.name,
      'weight': weight,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  static SearchSuggestionType _parseSearchSuggestionType(String type) {
    switch (type) {
      case 'autocomplete':
        return SearchSuggestionType.autocomplete;
      case 'recent':
        return SearchSuggestionType.recent;
      case 'trending':
        return SearchSuggestionType.trending;
      case 'category':
        return SearchSuggestionType.category;
      case 'product':
        return SearchSuggestionType.product;
      case 'store':
        return SearchSuggestionType.store;
      case 'related':
        return SearchSuggestionType.related;
      default:
        return SearchSuggestionType.autocomplete;
    }
  }

  SearchSuggestion copyWith({
    int? suggestionId,
    String? query,
    String? suggestion,
    SearchSuggestionType? suggestionType,
    int? weight,
    bool? isActive,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return SearchSuggestion(
      suggestionId: suggestionId ?? this.suggestionId,
      query: query ?? this.query,
      suggestion: suggestion ?? this.suggestion,
      suggestionType: suggestionType ?? this.suggestionType,
      weight: weight ?? this.weight,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'SearchSuggestion(suggestion: $suggestion, type: $suggestionType, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchSuggestion && other.suggestionId == suggestionId;
  }

  @override
  int get hashCode => suggestionId.hashCode;
}
