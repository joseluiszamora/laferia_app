import 'package:equatable/equatable.dart';

class Categoria extends Equatable {
  final String id;
  final String parentId;
  final String name;
  final String slug;
  final String description;
  final String icon;
  final String color;
  final String? imageUrl;
  final DateTime? createdAt;

  const Categoria({
    required this.id,
    required this.parentId,
    required this.name,
    required this.slug,
    required this.description,
    required this.icon,
    required this.color,
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
}
