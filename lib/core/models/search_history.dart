class SearchHistory {
  final int searchHistoryId;
  final String? userId;
  final String sessionId;
  final String query;
  final String searchType;
  final int resultCount;
  final bool clicked;
  final String? clickedType;
  final int? clickedId;
  final Map<String, dynamic>? filters;
  final Map<String, dynamic>? location;
  final DateTime createdAt;

  const SearchHistory({
    required this.searchHistoryId,
    this.userId,
    required this.sessionId,
    required this.query,
    this.searchType = 'general',
    this.resultCount = 0,
    this.clicked = false,
    this.clickedType,
    this.clickedId,
    this.filters,
    this.location,
    required this.createdAt,
  });

  factory SearchHistory.fromMap(Map<String, dynamic> map) {
    return SearchHistory(
      searchHistoryId: map['search_history_id'] as int,
      userId: map['user_id'] as String?,
      sessionId: map['session_id'] as String,
      query: map['query'] as String,
      searchType: map['search_type'] as String? ?? 'general',
      resultCount: map['result_count'] as int? ?? 0,
      clicked: map['clicked'] as bool? ?? false,
      clickedType: map['clicked_type'] as String?,
      clickedId: map['clicked_id'] as int?,
      filters: map['filters'] as Map<String, dynamic>?,
      location: map['location'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'search_history_id': searchHistoryId,
      'user_id': userId,
      'session_id': sessionId,
      'query': query,
      'search_type': searchType,
      'result_count': resultCount,
      'clicked': clicked,
      'clicked_type': clickedType,
      'clicked_id': clickedId,
      'filters': filters,
      'location': location,
      'created_at': createdAt.toIso8601String(),
    };
  }

  SearchHistory copyWith({
    int? searchHistoryId,
    String? userId,
    String? sessionId,
    String? query,
    String? searchType,
    int? resultCount,
    bool? clicked,
    String? clickedType,
    int? clickedId,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? location,
    DateTime? createdAt,
  }) {
    return SearchHistory(
      searchHistoryId: searchHistoryId ?? this.searchHistoryId,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      query: query ?? this.query,
      searchType: searchType ?? this.searchType,
      resultCount: resultCount ?? this.resultCount,
      clicked: clicked ?? this.clicked,
      clickedType: clickedType ?? this.clickedType,
      clickedId: clickedId ?? this.clickedId,
      filters: filters ?? this.filters,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SearchHistory(id: $searchHistoryId, query: $query, type: $searchType, results: $resultCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchHistory && other.searchHistoryId == searchHistoryId;
  }

  @override
  int get hashCode => searchHistoryId.hashCode;
}
