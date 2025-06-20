import 'package:equatable/equatable.dart';

class ProductoAtributos extends Equatable {
  final String id;
  final String productoId;
  final String nombre;
  final String valor;

  const ProductoAtributos({
    required this.id,
    required this.productoId,
    required this.nombre,
    required this.valor,
  });
  factory ProductoAtributos.fromJson(Map<String, dynamic> json) {
    return ProductoAtributos(
      id: json['id'],
      productoId: json['productoId'],
      nombre: json['nombre'],
      valor: json['valor'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productoId': productoId,
      'nombre': nombre,
      'valor': valor,
    };
  }

  @override
  String toString() {
    return 'ProductoAtributos{id: $id, productoId: $productoId, nombre: $nombre, valor: $valor}';
  }

  @override
  List<Object?> get props => [id, productoId, nombre, valor];
}
