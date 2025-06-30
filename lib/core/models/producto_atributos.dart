import 'package:equatable/equatable.dart';

class ProductoAtributos extends Equatable {
  final String id;
  final String productoId;
  final String nombre;
  final String valor;
  final String tipo; // text, number, boolean, color, size, etc.
  final String? unidad; // kg, cm, litros, etc.
  final int orden;
  final bool isVisible;
  final DateTime createdAt;

  const ProductoAtributos({
    required this.id,
    required this.productoId,
    required this.nombre,
    required this.valor,
    this.tipo = 'text',
    this.unidad,
    this.orden = 0,
    this.isVisible = true,
    required this.createdAt,
  });
  factory ProductoAtributos.fromJson(Map<String, dynamic> json) {
    return ProductoAtributos(
      id: json['id'],
      productoId: json['producto_id'] ?? json['productoId'],
      nombre: json['nombre'],
      valor: json['valor'],
      tipo: json['tipo'] ?? 'text',
      unidad: json['unidad'],
      orden: json['orden'] ?? 0,
      isVisible: json['is_visible'] ?? json['isVisible'] ?? true,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto_id': productoId,
      'nombre': nombre,
      'valor': valor,
      'tipo': tipo,
      'unidad': unidad,
      'orden': orden,
      'is_visible': isVisible,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProductoAtributos copyWith({
    String? id,
    String? productoId,
    String? nombre,
    String? valor,
    String? tipo,
    String? unidad,
    int? orden,
    bool? isVisible,
    DateTime? createdAt,
  }) {
    return ProductoAtributos(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      nombre: nombre ?? this.nombre,
      valor: valor ?? this.valor,
      tipo: tipo ?? this.tipo,
      unidad: unidad ?? this.unidad,
      orden: orden ?? this.orden,
      isVisible: isVisible ?? this.isVisible,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ProductoAtributos{id: $id, productoId: $productoId, nombre: $nombre, valor: $valor, tipo: $tipo, unidad: $unidad, orden: $orden, isVisible: $isVisible, createdAt: $createdAt}';
  }

  @override
  List<Object?> get props => [
    id,
    productoId,
    nombre,
    valor,
    tipo,
    unidad,
    orden,
    isVisible,
    createdAt,
  ];
}
