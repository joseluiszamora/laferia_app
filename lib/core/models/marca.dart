import 'package:equatable/equatable.dart';

class Marca extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? logoUrl;

  const Marca({
    required this.id,
    required this.name,
    required this.slug,
    this.logoUrl,
  });

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      logoUrl: json['logoUrl'] as String?,
    );
  }

  @override
  String toString() =>
      'Marca(id: $id, name: $name, slug: $slug, logoUrl: $logoUrl)';
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug, 'logoUrl': logoUrl};
  }

  @override
  List<Object?> get props => [id, name, slug, logoUrl];
}
