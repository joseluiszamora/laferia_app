import 'package:equatable/equatable.dart';

class Producto extends Equatable {
  final String id;
  final String nombre;
  final double precio;
  final String caracteristicas;
  final String? imagenUrl;
  final String categoria; // Mantener por compatibilidad
  final String categoriaId;
  final String subcategoriaId;
  final bool disponible;

  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.caracteristicas,
    this.imagenUrl,
    this.categoria = '', // Mantener por compatibilidad
    required this.categoriaId,
    required this.subcategoriaId,
    this.disponible = true,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: json['precio']?.toDouble() ?? 0.0,
      caracteristicas: json['caracteristicas'] ?? '',
      imagenUrl: json['imagen_url'],
      categoria: json['categoria'] ?? '', // Mantener por compatibilidad
      categoriaId: json['categoria_id'] ?? '',
      subcategoriaId: json['subcategoria_id'] ?? '',
      disponible: json['disponible'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'caracteristicas': caracteristicas,
      'imagen_url': imagenUrl,
      'categoria': categoria, // Mantener por compatibilidad
      'categoria_id': categoriaId,
      'subcategoria_id': subcategoriaId,
      'disponible': disponible,
    };
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    precio,
    caracteristicas,
    imagenUrl,
    categoria,
    categoriaId,
    subcategoriaId,
    disponible,
  ];
}
