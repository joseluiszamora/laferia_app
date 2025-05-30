import 'package:equatable/equatable.dart';
import '../../models/producto.dart';

abstract class ProductosState extends Equatable {
  const ProductosState();

  @override
  List<Object?> get props => [];
}

class ProductosInitial extends ProductosState {}

class ProductosLoading extends ProductosState {}

class ProductosLoaded extends ProductosState {
  final List<Producto> productos;
  final Producto? selectedProducto;

  const ProductosLoaded({required this.productos, this.selectedProducto});

  ProductosLoaded copyWith({
    List<Producto>? productos,
    Producto? selectedProducto,
  }) {
    return ProductosLoaded(
      productos: productos ?? this.productos,
      selectedProducto: selectedProducto ?? this.selectedProducto,
    );
  }

  @override
  List<Object?> get props => [productos, selectedProducto];
}

class ProductosError extends ProductosState {
  final String message;

  const ProductosError(this.message);

  @override
  List<Object> get props => [message];
}
