import 'package:equatable/equatable.dart';

class Producto extends Equatable {
  final String id;
  final String nombre;
  final double precio;
  final double? precioOferta;
  final bool aceptaOfertas;
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
    this.precioOferta,
    this.aceptaOfertas = false,
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
      precioOferta: json['precio_oferta']?.toDouble(),
      aceptaOfertas: json['acepta_ofertas'] ?? false,
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
      'precio_oferta': precioOferta,
      'acepta_ofertas': aceptaOfertas,
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
    precioOferta,
    aceptaOfertas,
    caracteristicas,
    imagenUrl,
    categoria,
    categoriaId,
    subcategoriaId,
    disponible,
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

  /// Método copyWith para crear copias del producto con algunos campos modificados
  Producto copyWith({
    String? id,
    String? nombre,
    double? precio,
    double? precioOferta,
    bool? aceptaOfertas,
    String? caracteristicas,
    String? imagenUrl,
    String? categoria,
    String? categoriaId,
    String? subcategoriaId,
    bool? disponible,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      precioOferta: precioOferta ?? this.precioOferta,
      aceptaOfertas: aceptaOfertas ?? this.aceptaOfertas,
      caracteristicas: caracteristicas ?? this.caracteristicas,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      categoria: categoria ?? this.categoria,
      categoriaId: categoriaId ?? this.categoriaId,
      subcategoriaId: subcategoriaId ?? this.subcategoriaId,
      disponible: disponible ?? this.disponible,
    );
  }
}
