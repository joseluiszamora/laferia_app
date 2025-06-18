import 'package:equatable/equatable.dart';

class Producto extends Equatable {
  final String id;
  final String nombre;
  final double precio;
  final double? precioOferta;
  final bool aceptaOfertas;
  final String caracteristicas;
  final List<String> imagenesUrl;
  final String categoria; // Mantener por compatibilidad
  final String rubroId;
  final String categoriaId;
  final String subcategoriaId;
  final bool disponible;
  final bool esFavorito;

  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.precioOferta,
    this.aceptaOfertas = false,
    required this.caracteristicas,
    this.imagenesUrl = const [],
    this.categoria = '', // Mantener por compatibilidad
    required this.rubroId,
    required this.categoriaId,
    required this.subcategoriaId,
    this.disponible = true,
    this.esFavorito = false,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio: json['precio']?.toDouble() ?? 0.0,
      precioOferta: json['precio_oferta']?.toDouble(),
      aceptaOfertas: json['acepta_ofertas'] ?? false,
      caracteristicas: json['caracteristicas'] ?? '',
      imagenesUrl:
          json['imagenes_url'] != null
              ? List<String>.from(json['imagenes_url'])
              : (json['imagen_url'] != null
                  ? [json['imagen_url']]
                  : []), // Compatibilidad con imagen_url antigua
      categoria: json['categoria'] ?? '', // Mantener por compatibilidad
      rubroId: json['rubro_id'] ?? '',
      categoriaId: json['categoria_id'] ?? '',
      subcategoriaId: json['subcategoria_id'] ?? '',
      disponible: json['disponible'] ?? true,
      esFavorito: json['es_favorito'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'precio_oferta': precioOferta,
      'acepta_ofertas': aceptaOfertas,
      'caracteristicas': caracteristicas,
      'imagenes_url': imagenesUrl,
      'imagen_url':
          imagenesUrl.isNotEmpty
              ? imagenesUrl.first
              : null, // Mantener compatibilidad
      'categoria': categoria, // Mantener por compatibilidad
      'rubro_id': rubroId,
      'categoria_id': categoriaId,
      'subcategoria_id': subcategoriaId,
      'disponible': disponible,
      'es_favorito': esFavorito,
    };
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    precio,
    precioOferta,
    aceptaOfertas,
    caracteristicas,
    imagenesUrl,
    categoria,
    rubroId,
    categoriaId,
    subcategoriaId,
    disponible,
    esFavorito,
  ];

  /// Obtiene el precio efectivo del producto (precio de oferta si existe, sino el precio normal)
  double get precioEfectivo => precioOferta ?? precio;

  /// Indica si el producto tiene una oferta activa
  bool get tieneOferta => precioOferta != null && precioOferta! < precio;

  /// Calcula el porcentaje de descuento si hay oferta
  double get porcentajeDescuento {
    if (!tieneOferta) return 0.0;
    return ((precio - precioOferta!) / precio) * 100;
  }

  /// Calcula el ahorro en dinero si hay oferta
  double get ahorroEnDinero {
    if (!tieneOferta) return 0.0;
    return precio - precioOferta!;
  }

  /// Obtiene la primera imagen disponible o null si no hay imágenes
  String? get imagenPrincipal =>
      imagenesUrl.isNotEmpty ? imagenesUrl.first : null;

  /// Indica si el producto tiene imágenes
  bool get tieneImagenes => imagenesUrl.isNotEmpty;

  /// Obtiene el número total de imágenes
  int get cantidadImagenes => imagenesUrl.length;

  /// Método copyWith para crear copias del producto con algunos campos modificados
  Producto copyWith({
    String? id,
    String? nombre,
    double? precio,
    double? precioOferta,
    bool? aceptaOfertas,
    String? caracteristicas,
    List<String>? imagenesUrl,
    String? categoria,
    String? rubroId,
    String? categoriaId,
    String? subcategoriaId,
    bool? disponible,
    bool? esFavorito,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      precioOferta: precioOferta ?? this.precioOferta,
      aceptaOfertas: aceptaOfertas ?? this.aceptaOfertas,
      caracteristicas: caracteristicas ?? this.caracteristicas,
      imagenesUrl: imagenesUrl ?? this.imagenesUrl,
      categoria: categoria ?? this.categoria,
      rubroId: rubroId ?? this.rubroId,
      categoriaId: categoriaId ?? this.categoriaId,
      subcategoriaId: subcategoriaId ?? this.subcategoriaId,
      disponible: disponible ?? this.disponible,
      esFavorito: esFavorito ?? this.esFavorito,
    );
  }
}
