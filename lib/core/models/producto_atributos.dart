import 'package:equatable/equatable.dart';

class ProductoAtributos extends Equatable {
  final int id;
  final int productId;
  final String name;
  final String value;
  final String type; // text, number, boolean, color, size, etc.
  final String? unity; // kg, cm, litros, etc.
  final int order;
  final bool isVisible;
  final DateTime createdAt;

  const ProductoAtributos({
    required this.id,
    required this.productId,
    required this.name,
    required this.value,
    this.type = 'text',
    this.unity,
    this.order = 0,
    this.isVisible = true,
    required this.createdAt,
  });

  factory ProductoAtributos.fromJson(Map<String, dynamic> json) {
    return ProductoAtributos(
      id: json['product_attributes_id'] ?? json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? json['nombre'] ?? '',
      value: json['value'] ?? json['valor'] ?? '',
      type: json['type'] ?? json['tipo'] ?? 'text',
      unity: json['unity'] ?? json['unidad'],
      order: json['order'] ?? json['orden'] ?? 0,
      isVisible: json['is_visible'] ?? json['isVisible'] ?? true,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_attributes_id': id,
      'product_id': productId,
      'name': name,
      'value': value,
      'type': type,
      'unity': unity,
      'order': order,
      'is_visible': isVisible,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProductoAtributos copyWith({
    int? id,
    int? productId,
    String? name,
    String? value,
    String? type,
    String? unity,
    int? order,
    bool? isVisible,
    DateTime? createdAt,
  }) {
    return ProductoAtributos(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      value: value ?? this.value,
      type: type ?? this.type,
      unity: unity ?? this.unity,
      order: order ?? this.order,
      isVisible: isVisible ?? this.isVisible,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ProductoAtributos{id: $id, productId: $productId, name: $name, value: $value, type: $type, unity: $unity, order: $order, isVisible: $isVisible, createdAt: $createdAt}';
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    name,
    value,
    type,
    unity,
    order,
    isVisible,
    createdAt,
  ];
}
