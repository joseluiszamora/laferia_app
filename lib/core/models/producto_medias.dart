import 'package:equatable/equatable.dart';

enum MediaType {
  image('image'),
  video('video'),
  pdf('pdf');

  const MediaType(this.value);
  final String value;

  static MediaType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      case 'pdf':
        return MediaType.pdf;
      default:
        return MediaType.image;
    }
  }
}

class ProductoMedias extends Equatable {
  final int id;
  final int productId;
  final MediaType type;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final int? fileSize; // en bytes
  final int? duration; // para videos, en segundos
  final int order;
  final bool isMain;
  final bool isActive;
  final String? description;
  final String? altText;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProductoMedias({
    required this.id,
    required this.productId,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.fileSize,
    this.duration,
    this.order = 0,
    this.isMain = false,
    this.isActive = true,
    this.description,
    this.altText,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductoMedias.fromJson(Map<String, dynamic> json) {
    return ProductoMedias(
      id: json['product_medias_id'] ?? json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      type: MediaType.fromString(json['type'] ?? 'image'),
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      width: json['width'],
      height: json['height'],
      fileSize: json['file_size']?.toInt(),
      duration: json['duration'],
      order: json['order'] ?? json['orden'] ?? 0,
      isMain: json['is_main'] ?? false,
      isActive: json['is_active'] ?? true,
      description: json['description'] ?? json['descripcion'],
      altText: json['alt_text'],
      metadata:
          json['metadata'] != null
              ? Map<String, dynamic>.from(json['metadata'])
              : null,
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

  Map<String, dynamic> toJson() {
    return {
      'product_medias_id': id,
      'product_id': productId,
      'type': type.value,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'file_size': fileSize,
      'duration': duration,
      'order': order,
      'is_main': isMain,
      'is_active': isActive,
      'description': description,
      'alt_text': altText,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ProductoMedias{id: $id, productId: $productId, type: $type, url: $url, thumbnailUrl: $thumbnailUrl, width: $width, height: $height, fileSize: $fileSize, duration: $duration, order: $order, isMain: $isMain, isActive: $isActive, description: $description, altText: $altText, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  List<Object?> get props {
    return [
      id,
      productId,
      type,
      url,
      thumbnailUrl,
      width,
      height,
      fileSize,
      duration,
      order,
      isMain,
      isActive,
      description,
      altText,
      metadata,
      createdAt,
      updatedAt,
    ];
  }

  ProductoMedias copyWith({
    int? id,
    int? productId,
    MediaType? type,
    String? url,
    String? thumbnailUrl,
    int? width,
    int? height,
    int? fileSize,
    int? duration,
    int? order,
    bool? isMain,
    bool? isActive,
    String? description,
    String? altText,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductoMedias(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      fileSize: fileSize ?? this.fileSize,
      duration: duration ?? this.duration,
      order: order ?? this.order,
      isMain: isMain ?? this.isMain,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      altText: altText ?? this.altText,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
