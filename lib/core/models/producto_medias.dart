import 'package:equatable/equatable.dart';

class ProductoMedias extends Equatable {
  final String id;
  final String productoId;
  final String type; // image/video
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;
  final bool esPrincipal;
  final bool estaActivo;
  final int? orden;
  final String? descripcion;
  final String? altTexto;
  final String? metadata;

  const ProductoMedias({
    required this.id,
    required this.productoId,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
    required this.fechaCreacion,
    this.fechaActualizacion,
    required this.esPrincipal,
    this.estaActivo = true,
    this.orden,
    this.descripcion,
    this.altTexto,
    this.metadata,
  });
  factory ProductoMedias.fromJson(Map<String, dynamic> json) {
    return ProductoMedias(
      id: json['id'],
      productoId: json['producto_id'],
      type: json['type'],
      url: json['url'],
      thumbnailUrl: json['thumbnail_url'],
      width: json['width'],
      height: json['height'],
      fechaCreacion:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      fechaActualizacion:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
      esPrincipal: json['is_main'] ?? false,
      estaActivo: json['is_active'] ?? true,
      orden: json['orden'],
      descripcion: json['descripcion'],
      altTexto: json['alt_text'],
      metadata: json['metadata'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto_id': productoId,
      'type': type,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'created_at': fechaCreacion.toIso8601String(),
      'updated_at': fechaActualizacion?.toIso8601String(),
      'is_main': esPrincipal,
      'is_active': estaActivo,
      'orden': orden,
      'descripcion': descripcion,
      'alt_text': altTexto,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'ProductoMedias{id: $id, productoId: $productoId, type: $type, url: $url, thumbnailUrl: $thumbnailUrl, width: $width, height: $height, fechaCreacion: $fechaCreacion, fechaActualizacion: $fechaActualizacion, esPrincipal: $esPrincipal, estaActivo: $estaActivo, orden: $orden, descripcion: $descripcion, altTexto: $altTexto, metadata: $metadata}';
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
      fechaCreacion,
      fechaActualizacion,
      esPrincipal,
      estaActivo,
      orden,
      descripcion,
      altTexto,
      metadata,
    ];
  }
}
