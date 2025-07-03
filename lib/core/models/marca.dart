import 'package:equatable/equatable.dart';

class Marca extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? logoUrl;
  final String? websiteUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Marca({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.logoUrl,
    this.websiteUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // Getters para compatibilidad con código existente
  String get marcaId => id.toString();

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      id: json['brand_id'] ?? json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      logoUrl: json['logo_url'],
      websiteUrl: json['website_url'],
      isActive: json['is_active'] ?? true,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
    );
  }

  @override
  String toString() =>
      'Marca(id: $id, name: $name, slug: $slug, description: $description, logoUrl: $logoUrl, websiteUrl: $websiteUrl, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';

  Map<String, dynamic> toJson() {
    return {
      'brand_id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'logo_url': logoUrl,
      'website_url': websiteUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Marca copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? logoUrl,
    String? websiteUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Marca(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    logoUrl,
    websiteUrl,
    isActive,
    createdAt,
    updatedAt,
  ];
}
