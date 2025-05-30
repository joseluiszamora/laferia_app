import 'package:equatable/equatable.dart';

class Categoria extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;
  final String icono;
  final List<Subcategoria> subcategorias;

  const Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    this.subcategorias = const [],
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      icono: json['icono'],
      subcategorias:
          (json['subcategorias'] as List<dynamic>?)
              ?.map((sub) => Subcategoria.fromJson(sub))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'subcategorias': subcategorias.map((sub) => sub.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, nombre, descripcion, icono, subcategorias];
}

class Subcategoria extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;
  final String categoriaId;

  const Subcategoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoriaId,
  });

  factory Subcategoria.fromJson(Map<String, dynamic> json) {
    return Subcategoria(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      categoriaId: json['categoria_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria_id': categoriaId,
    };
  }

  @override
  List<Object?> get props => [id, nombre, descripcion, categoriaId];
}
