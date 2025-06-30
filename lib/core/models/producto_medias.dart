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
  final String id;
  final String productoId;
  final MediaType type;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final int? fileSize; // en bytes
  final int? duration; // para videos, en segundos
  final int orden;
  final bool isMain;
  final bool isActive;
  final String? descripcion;
  final String? altText;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProductoMedias({
    required this.id,
    required this.productoId,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.fileSize,
    this.duration,
    this.orden = 0,
    this.isMain = false,
    this.isActive = true,
    this.descripcion,
    this.altText,
    this.metadata,
    required this.createdAt,
    this.updatedAt,
  });
  factory ProductoMedias.fromJson(Map<String, dynamic> json) {
    return ProductoMedias(
      id: json['id'],
      productoId: json['producto_id'],
      type: MediaType.fromString(json['type'] ?? 'image'),
      url: json['url'],
      thumbnailUrl: json['thumbnail_url'],
      width: json['width'],
      height: json['height'],
      fileSize: json['file_size'],
      duration: json['duration'],
      orden: json['orden'] ?? 0,
      isMain: json['is_main'] ?? false,
      isActive: json['is_active'] ?? true,
      descripcion: json['descripcion'],
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
      'id': id,
      'producto_id': productoId,
      'type': type.value,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'file_size': fileSize,
      'duration': duration,
      'orden': orden,
      'is_main': isMain,
      'is_active': isActive,
      'descripcion': descripcion,
      'alt_text': altText,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ProductoMedias{id: $id, productoId: $productoId, type: $type, url: $url, thumbnailUrl: $thumbnailUrl, width: $width, height: $height, fileSize: $fileSize, duration: $duration, orden: $orden, isMain: $isMain, isActive: $isActive, descripcion: $descripcion, altText: $altText, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  List<Object?> get props {
    return [
      id,
      productoId,
      type,
      url,
      thumbnailUrl,
      width,
      height,
      fileSize,
      duration,
      orden,
      isMain,
      isActive,
      descripcion,
      altText,
      metadata,
      createdAt,
      updatedAt,
    ];
  }

  ProductoMedias copyWith({
    String? id,
    String? productoId,
    MediaType? type,
    String? url,
    String? thumbnailUrl,
    int? width,
    int? height,
    int? fileSize,
    int? duration,
    int? orden,
    bool? isMain,
    bool? isActive,
    String? descripcion,
    String? altText,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductoMedias(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      fileSize: fileSize ?? this.fileSize,
      duration: duration ?? this.duration,
      orden: orden ?? this.orden,
      isMain: isMain ?? this.isMain,
      isActive: isActive ?? this.isActive,
      descripcion: descripcion ?? this.descripcion,
      altText: altText ?? this.altText,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
