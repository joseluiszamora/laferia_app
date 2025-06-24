import 'package:equatable/equatable.dart';

class Categoria extends Equatable {
  final String id;
  final String? parentId;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final String? color;
  final String? imageUrl;
  final DateTime? createdAt;

  const Categoria({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.color,
    this.imageUrl,
    this.createdAt,
    this.subcategorias = const [],
  });

  @override
  List<Object?> get props => [
    id,
    parentId,
    name,
    slug,
    description,
    icon,
    color,
    imageUrl,
    createdAt,
    subcategorias,
  ];

  /// Lista de subcategorías de esta categoría
  final List<Categoria> subcategorias;

  /// Factory constructor para crear una categoría con sus subcategorías
  factory Categoria.withSubcategorias({
    required Categoria categoria,
    required List<Categoria> todasLasCategorias,
  }) {
    final subcats =
        todasLasCategorias
            .where((cat) => cat.parentId == categoria.id)
            .toList();
    return Categoria(
      id: categoria.id,
      parentId: categoria.parentId,
      name: categoria.name,
      slug: categoria.slug,
      description: categoria.description,
      icon: categoria.icon,
      color: categoria.color,
      imageUrl: categoria.imageUrl,
      createdAt: categoria.createdAt,
      subcategorias: subcats,
    );
  }

  /// Indica si la categoría está activa
  bool get activa => true;

  /// Copia la categoría con nuevos valores
  Categoria copyWith({
    String? id,
    String? parentId,
    String? name,
    String? slug,
    String? description,
    String? icon,
    String? color,
    String? imageUrl,
    DateTime? createdAt,
    List<Categoria>? subcategorias,
  }) {
    return Categoria(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      subcategorias: subcategorias ?? this.subcategorias,
    );
  }
}
