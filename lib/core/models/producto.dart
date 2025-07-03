import 'package:equatable/equatable.dart';
import 'package:laferia/core/models/producto_atributos.dart';
import 'package:laferia/core/models/producto_medias.dart';

enum ProductStatus {
  draft('draft'),
  published('published'),
  archived('archived'),
  exhausted('exhausted');

  const ProductStatus(this.value);
  final String value;

  static ProductStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return ProductStatus.draft;
      case 'published':
        return ProductStatus.published;
      case 'archived':
        return ProductStatus.archived;
      case 'exhausted':
        return ProductStatus.exhausted;
      default:
        return ProductStatus.draft;
    }
  }
}

class Producto extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String? shortDescription;
  final String? sku;
  final String? barcode;

  final double price;
  final double? discountedPrice;
  final double? costPrice;
  final bool acceptOffers;

  final int stock;
  final int lowStockAlert;
  final double? weight; // en kg
  final Map<String, dynamic>? dimensions; // {width, height, depth} en cm

  final int categoryId;
  final int? brandId;
  final int? storeId;

  final ProductStatus status;
  final bool isAvailable;
  final bool isFeatured;

  final String? metaTitle;
  final String? metaDescription;
  final List<String> tags;

  final int viewCount;
  final int saleCount;

  final List<ProductoAtributos> atributos;
  final List<ProductoMedias> medias;

  final DateTime createdAt;
  final DateTime? updatedAt;

  const Producto({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.shortDescription,
    this.sku,
    this.barcode,
    required this.price,
    this.discountedPrice,
    this.costPrice,
    this.acceptOffers = false,
    this.stock = 0,
    this.lowStockAlert = 5,
    this.weight,
    this.dimensions,
    required this.categoryId,
    this.brandId,
    this.storeId,
    this.status = ProductStatus.draft,
    this.isAvailable = true,
    this.isFeatured = false,
    this.metaTitle,
    this.metaDescription,
    this.tags = const [],
    this.viewCount = 0,
    this.saleCount = 0,
    this.atributos = const [],
    this.medias = const [],
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    description,
    shortDescription,
    sku,
    barcode,
    price,
    discountedPrice,
    costPrice,
    acceptOffers,
    stock,
    lowStockAlert,
    weight,
    dimensions,
    categoryId,
    brandId,
    storeId,
    status,
    isAvailable,
    isFeatured,
    metaTitle,
    metaDescription,
    tags,
    viewCount,
    saleCount,
    atributos,
    medias,
    createdAt,
    updatedAt,
  ];

  /// Obtiene el precio efectivo del producto (precio de oferta si existe, sino el precio normal)
  double get precioEfectivo => discountedPrice ?? price;

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
  ProductoMedias? get imagenPrincipal {
    final imagenesActivas =
        medias.where((m) => m.isActive && m.type == MediaType.image).toList();
    if (imagenesActivas.isEmpty) return null;

    // Buscar imagen principal
    final principal = imagenesActivas.where((m) => m.isMain).firstOrNull;
    return principal ?? imagenesActivas.first;
  }

  /// Indica si el producto tiene imágenes
  bool get tieneImagenes =>
      medias.where((m) => m.type == MediaType.image && m.isActive).isNotEmpty;

  /// Obtiene el número total de imágenes activas
  int get cantidadImagenes =>
      medias.where((m) => m.type == MediaType.image && m.isActive).length;

  /// Indica si el producto está en stock
  bool get enStock => stock > 0;

  /// Indica si el stock está bajo
  bool get stockBajo => stock <= lowStockAlert;

  /// Obtiene las dimensiones formateadas
  String? get dimensionesFormateadas {
    if (dimensions == null) return null;
    final w = dimensions!['width'];
    final h = dimensions!['height'];
    final d = dimensions!['depth'];
    if (w != null && h != null && d != null) {
      return '${w}cm x ${h}cm x ${d}cm';
    }
    return null;
  }

  /// Factory constructor para crear un Producto desde JSON (Supabase)
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['product_id'] ?? json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['short_description'],
      sku: json['sku'],
      barcode: json['barcode'],
      price: (json['price'] ?? 0.0).toDouble(),
      discountedPrice: json['discounted_price']?.toDouble(),
      costPrice: json['cost_price']?.toDouble(),
      acceptOffers: json['accept_offers'] ?? false,
      stock: json['stock'] ?? 0,
      lowStockAlert: json['low_stock_alert'] ?? 5,
      weight: json['weight']?.toDouble(),
      dimensions:
          json['dimensions'] != null
              ? Map<String, dynamic>.from(json['dimensions'])
              : null,
      categoryId: json['category_id'] ?? 0,
      brandId: json['brand_id'],
      storeId: json['store_id'],
      status: ProductStatus.fromString(json['status'] ?? 'draft'),
      isAvailable: json['is_available'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      viewCount: json['view_count'] ?? 0,
      saleCount: json['sale_count'] ?? 0,
      atributos:
          json['atributos'] != null || json['attributes'] != null
              ? (json['atributos'] ?? json['attributes'] as List)
                  .map((attr) => ProductoAtributos.fromJson(attr))
                  .toList()
              : [],
      medias:
          json['medias'] != null
              ? (json['medias'] as List)
                  .map((media) => ProductoMedias.fromJson(media))
                  .toList()
              : [],
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
      'product_id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'short_description': shortDescription,
      'sku': sku,
      'barcode': barcode,
      'price': price,
      'discounted_price': discountedPrice,
      'cost_price': costPrice,
      'accept_offers': acceptOffers,
      'stock': stock,
      'low_stock_alert': lowStockAlert,
      'weight': weight,
      'dimensions': dimensions,
      'category_id': categoryId,
      'brand_id': brandId,
      'store_id': storeId,
      'status': status.value,
      'is_available': isAvailable,
      'is_featured': isFeatured,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'tags': tags,
      'view_count': viewCount,
      'sale_count': saleCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Factory constructor para crear una copia del producto con campos modificados
  Producto copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? shortDescription,
    String? sku,
    String? barcode,
    double? price,
    double? discountedPrice,
    double? costPrice,
    bool? acceptOffers,
    int? stock,
    int? lowStockAlert,
    double? weight,
    Map<String, dynamic>? dimensions,
    int? categoryId,
    int? brandId,
    int? storeId,
    ProductStatus? status,
    bool? isAvailable,
    bool? isFeatured,
    String? metaTitle,
    String? metaDescription,
    List<String>? tags,
    int? viewCount,
    int? saleCount,
    List<ProductoAtributos>? atributos,
    List<ProductoMedias>? medias,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Producto(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      costPrice: costPrice ?? this.costPrice,
      acceptOffers: acceptOffers ?? this.acceptOffers,
      stock: stock ?? this.stock,
      lowStockAlert: lowStockAlert ?? this.lowStockAlert,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      storeId: storeId ?? this.storeId,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      metaTitle: metaTitle ?? this.metaTitle,
      metaDescription: metaDescription ?? this.metaDescription,
      tags: tags ?? this.tags,
      viewCount: viewCount ?? this.viewCount,
      saleCount: saleCount ?? this.saleCount,
      atributos: atributos ?? this.atributos,
      medias: medias ?? this.medias,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Producto{id: $id, name: $name, slug: $slug, price: $price, discountedPrice: $discountedPrice, status: $status, categoryId: $categoryId, brandId: $brandId, stock: $stock, isAvailable: $isAvailable, isFeatured: $isFeatured}';
  }
}
