import 'package:equatable/equatable.dart';
import 'package:laferia/core/models/producto_atributos.dart';
import 'package:laferia/core/models/producto_medias.dart';

class Producto extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String description;

  final double price;
  final double? discountedPrice;
  final bool acceptOffers; // acepta ofertas

  final String categoriaId;
  final String marcaId;

  final String status; // borrador,publicado,archivado
  final bool isAvailable;
  final bool isFavorite;

  final List<ProductoAtributos> atributos;
  final List<ProductoMedias> imagenesUrl;
  final String? logoUrl;

  final DateTime createdAt;
  final DateTime? updatedAt;

  // final List<String> imagenesUrl;
  // final String categoria;
  // final String rubroId;
  // final String subcategoriaId;
  // final bool esFavorito;

  const Producto({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.acceptOffers, // acepta ofertas= false,
    required this.categoriaId,
    required this.marcaId,
    this.status = 'borrador',
    this.isAvailable = true,
    this.isFavorite = true,
    required this.atributos,
    required this.imagenesUrl,
    this.logoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    price,
    discountedPrice,
    acceptOffers, // acepta ofertas
    categoriaId,
    marcaId,
    status,
    isAvailable,
    isFavorite,
    atributos,
    imagenesUrl,
    logoUrl,
    createdAt,
    updatedAt,
  ];

  /// Obtiene el price efectivo del producto (price de oferta si existe, sino el price normal)
  double get priceEfectivo => discountedPrice ?? price;

  /// Indica si el producto tiene una oferta activa
  bool get tieneOferta => discountedPrice != null && discountedPrice! < price;

  /// Calcula el porcentaje de descuento si hay oferta
  double get porcentajeDescuento {
    if (!tieneOferta) return 0.0;
    return ((price - discountedPrice!) / price) * 100;
  }

  /// Calcula el ahorro en dinero si hay oferta
  double get ahorroEnDinero {
    if (!tieneOferta) return 0.0;
    return price - discountedPrice!;
  }

  /// Obtiene la primera imagen disponible o null si no hay imágenes
  ProductoMedias? get imagenPrincipal =>
      imagenesUrl.isNotEmpty ? imagenesUrl.first : null;

  /// Indica si el producto tiene imágenes
  bool get tieneImagenes => imagenesUrl.isNotEmpty;

  /// Obtiene el número total de imágenes
  int get cantidadImagenes => imagenesUrl.length;
}
