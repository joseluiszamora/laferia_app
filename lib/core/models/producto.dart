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

  /// Factory constructor para crear un Producto desde JSON (Supabase)
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      discountedPrice: json['discounted_price']?.toDouble(),
      acceptOffers: json['accept_offers'] ?? false,
      categoriaId: json['categoria_id'] ?? '',
      marcaId: json['marca_id'] ?? '',
      status: json['status'] ?? 'borrador',
      isAvailable: json['is_available'] ?? true,
      isFavorite: json['is_favorite'] ?? false,
      atributos:
          json['atributos'] != null
              ? (json['atributos'] as List)
                  .map((attr) => ProductoAtributos.fromJson(attr))
                  .toList()
              : [],
      imagenesUrl:
          json['medias'] != null
              ? (json['medias'] as List)
                  .map((media) => ProductoMedias.fromJson(media))
                  .toList()
              : [],
      logoUrl: json['logo_url'],
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  /// Convierte el Producto a JSON para Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'discounted_price': discountedPrice,
      'accept_offers': acceptOffers,
      'categoria_id': categoriaId,
      'marca_id': marcaId,
      'status': status,
      'is_available': isAvailable,
      'is_favorite': isFavorite,
      'logo_url': logoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Factory constructor para crear una copia del producto con campos modificados
  Producto copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    double? price,
    double? discountedPrice,
    bool? acceptOffers,
    String? categoriaId,
    String? marcaId,
    String? status,
    bool? isAvailable,
    bool? isFavorite,
    List<ProductoAtributos>? atributos,
    List<ProductoMedias>? imagenesUrl,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Producto(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      acceptOffers: acceptOffers ?? this.acceptOffers,
      categoriaId: categoriaId ?? this.categoriaId,
      marcaId: marcaId ?? this.marcaId,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      atributos: atributos ?? this.atributos,
      imagenesUrl: imagenesUrl ?? this.imagenesUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Producto{id: $id, name: $name, slug: $slug, price: $price, discountedPrice: $discountedPrice, status: $status, categoriaId: $categoriaId, marcaId: $marcaId}';
  }
}
