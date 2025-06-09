import 'package:equatable/equatable.dart';

class Categoria extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;
  final String icono;
  final String? imagenUrl;
  final String rubroId;
  final List<Subcategoria> subcategorias;
  final bool activa;

  const Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    this.imagenUrl,
    required this.rubroId,
    this.subcategorias = const [],
    this.activa = true,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      icono: json['icono'],
      imagenUrl: json['imagen_url'],
      rubroId: json['rubro_id'],
      subcategorias:
          (json['subcategorias'] as List<dynamic>?)
              ?.map((sub) => Subcategoria.fromJson(sub))
              .toList() ??
          [],
      activa: json['activa'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'imagen_url': imagenUrl,
      'rubro_id': rubroId,
      'subcategorias': subcategorias.map((sub) => sub.toJson()).toList(),
      'activa': activa,
    };
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    descripcion,
    icono,
    imagenUrl,
    rubroId,
    subcategorias,
    activa,
  ];

  /// Método copyWith para crear copias de la categoría con algunos campos modificados
  Categoria copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? icono,
    String? imagenUrl,
    String? rubroId,
    List<Subcategoria>? subcategorias,
    bool? activa,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      icono: icono ?? this.icono,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      rubroId: rubroId ?? this.rubroId,
      subcategorias: subcategorias ?? this.subcategorias,
      activa: activa ?? this.activa,
    );
  }

  /// Obtiene una subcategoría específica por ID
  Subcategoria? getSubcategoriaById(String subcategoriaId) {
    try {
      return subcategorias.firstWhere((sub) => sub.id == subcategoriaId);
    } catch (e) {
      return null;
    }
  }

  /// Cuenta el total de subcategorías
  int get totalSubcategorias => subcategorias.length;

  /// Obtiene subcategorías activas
  List<Subcategoria> get subcategoriasActivas =>
      subcategorias.where((sub) => sub.activa).toList();
}

class Subcategoria extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;
  final String? imagenUrl;
  final String categoriaId;
  final String rubroId;
  final bool activa;

  const Subcategoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.imagenUrl,
    required this.categoriaId,
    required this.rubroId,
    this.activa = true,
  });

  factory Subcategoria.fromJson(Map<String, dynamic> json) {
    return Subcategoria(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenUrl: json['imagen_url'],
      categoriaId: json['categoria_id'],
      rubroId: json['rubro_id'],
      activa: json['activa'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen_url': imagenUrl,
      'categoria_id': categoriaId,
      'rubro_id': rubroId,
      'activa': activa,
    };
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    descripcion,
    imagenUrl,
    categoriaId,
    rubroId,
    activa,
  ];

  /// Método copyWith para crear copias de la subcategoría con algunos campos modificados
  Subcategoria copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    String? imagenUrl,
    String? categoriaId,
    String? rubroId,
    bool? activa,
  }) {
    return Subcategoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      categoriaId: categoriaId ?? this.categoriaId,
      rubroId: rubroId ?? this.rubroId,
      activa: activa ?? this.activa,
    );
  }
}
