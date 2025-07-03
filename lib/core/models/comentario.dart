import 'package:equatable/equatable.dart';

class Comentario extends Equatable {
  final int id;
  final int storeId;
  final String userName;
  final String? avatarUrl;
  final String comment;
  final double rating;
  final DateTime createdAt;
  final bool isVerified;
  final List<String> images;

  const Comentario({
    required this.id,
    required this.storeId,
    required this.userName,
    this.avatarUrl,
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.isVerified = false,
    this.images = const [],
  });

  // Getters para compatibilidad con código existente
  String get comentarioId => id.toString();
  String get tiendaId => storeId.toString();
  String get nombreUsuario => userName;
  String get comentario => comment;
  double get calificacion => rating;
  DateTime get fechaCreacion => createdAt;
  bool get verificado => isVerified;
  List<String> get imagenes => images;

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id:
          json['comment_id'] is int
              ? json['comment_id']
              : int.parse(json['comment_id'].toString()),
      storeId:
          json['store_id'] is int
              ? json['store_id']
              : int.parse(json['store_id'].toString()),
      userName: json['user_name'] ?? '',
      avatarUrl: json['avatar_url'],
      comment: json['comment'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      isVerified: json['is_verified'] ?? false,
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_name': userName,
      'avatar_url': avatarUrl,
      'comment': comment,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'is_verified': isVerified,
      'images': images,
    };
  }

  @override
  List<Object?> get props => [
    id,
    storeId,
    userName,
    avatarUrl,
    comment,
    rating,
    createdAt,
    isVerified,
    images,
  ];

  @override
  String toString() =>
      'Comentario(id: $id, storeId: $storeId, userName: $userName, comment: $comment, rating: $rating, createdAt: $createdAt, isVerified: $isVerified)';
}
