import 'package:equatable/equatable.dart';

class Marca extends Equatable {
  final String marcaId;
  final String name;
  final String slug;
  final String? description;
  final String? logoUrl;
  final String? websiteUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Marca({
    required this.marcaId,
    required this.name,
    required this.slug,
    this.description,
    this.logoUrl,
    this.websiteUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      marcaId: json['marca_id'] ?? json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      logoUrl: json['logo_url'] ?? json['logoUrl'],
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
      'Marca(marcaId: $marcaId, name: $name, slug: $slug, description: $description, logoUrl: $logoUrl, websiteUrl: $websiteUrl, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';

  Map<String, dynamic> toJson() {
    return {
      'marca_id': marcaId,
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
    String? marcaId,
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
      marcaId: marcaId ?? this.marcaId,
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
    marcaId,
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
