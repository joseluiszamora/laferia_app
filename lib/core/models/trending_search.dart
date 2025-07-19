class TrendingSearch {
  final int trendingSearchId;
  final String query;
  final int searchCount;
  final String? category;
  final String? region;
  final bool isPromoted;
  final double trendScore;
  final DateTime lastSearched;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TrendingSearch({
    required this.trendingSearchId,
    required this.query,
    this.searchCount = 1,
    this.category,
    this.region,
    this.isPromoted = false,
    this.trendScore = 0.0,
    required this.lastSearched,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrendingSearch.fromMap(Map<String, dynamic> map) {
    return TrendingSearch(
      trendingSearchId: map['trending_search_id'] as int,
      query: map['query'] as String,
      searchCount: map['search_count'] as int? ?? 1,
      category: map['category'] as String?,
      region: map['region'] as String?,
      isPromoted: map['is_promoted'] as bool? ?? false,
      trendScore: (map['trend_score'] as num?)?.toDouble() ?? 0.0,
      lastSearched: DateTime.parse(map['last_searched'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trending_search_id': trendingSearchId,
      'query': query,
      'search_count': searchCount,
      'category': category,
      'region': region,
      'is_promoted': isPromoted,
      'trend_score': trendScore,
      'last_searched': lastSearched.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TrendingSearch copyWith({
    int? trendingSearchId,
    String? query,
    int? searchCount,
    String? category,
    String? region,
    bool? isPromoted,
    double? trendScore,
    DateTime? lastSearched,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TrendingSearch(
      trendingSearchId: trendingSearchId ?? this.trendingSearchId,
      query: query ?? this.query,
      searchCount: searchCount ?? this.searchCount,
      category: category ?? this.category,
      region: region ?? this.region,
      isPromoted: isPromoted ?? this.isPromoted,
      trendScore: trendScore ?? this.trendScore,
      lastSearched: lastSearched ?? this.lastSearched,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TrendingSearch(query: $query, count: $searchCount, score: $trendScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrendingSearch &&
        other.trendingSearchId == trendingSearchId;
  }

  @override
  int get hashCode => trendingSearchId.hashCode;
}
