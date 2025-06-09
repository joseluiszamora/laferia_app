import 'package:equatable/equatable.dart';
import 'categoria.dart';

class Rubro extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;
  final String icono;
  final String? imagenUrl;
  final List<Categoria> categorias;
  final bool activo;

  const Rubro({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    this.imagenUrl,
    this.categorias = const [],
    this.activo = true,
  });

  factory Rubro.fromJson(Map<String, dynamic> json) {
    return Rubro(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      icono: json['icono'],
      imagenUrl: json['imagen_url'],
      categorias:
          (json['categorias'] as List<dynamic>?)
              ?.map((cat) => Categoria.fromJson(cat))
              .toList() ??
          [],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'imagen_url': imagenUrl,
      'categorias': categorias.map((cat) => cat.toJson()).toList(),
      'activo': activo,
    };
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    descripcion,
    icono,
    imagenUrl,
    categorias,
    activo,
  ];

  /// Método copyWith para crear copias del rubro con algunos campos modificados
  Rubro copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? icono,
    String? imagenUrl,
    List<Categoria>? categorias,
    bool? activo,
  }) {
    return Rubro(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      icono: icono ?? this.icono,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      categorias: categorias ?? this.categorias,
      activo: activo ?? this.activo,
    );
  }

  /// Obtiene una categoría específica por ID
  Categoria? getCategoriaById(String categoriaId) {
    try {
      return categorias.firstWhere((categoria) => categoria.id == categoriaId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene todas las subcategorías de todas las categorías
  List<Subcategoria> getAllSubcategorias() {
    return categorias.expand((categoria) => categoria.subcategorias).toList();
  }

  /// Obtiene una subcategoría específica por ID
  Subcategoria? getSubcategoriaById(String subcategoriaId) {
    for (final categoria in categorias) {
      try {
        return categoria.subcategorias.firstWhere(
          (sub) => sub.id == subcategoriaId,
        );
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  /// Cuenta el total de categorías activas
  int get totalCategorias => categorias.length;

  /// Cuenta el total de subcategorías
  int get totalSubcategorias =>
      categorias.fold(0, (total, cat) => total + cat.subcategorias.length);
}
