import 'package:equatable/equatable.dart';
import '../../models/producto.dart';

abstract class ProductosEvent extends Equatable {
  const ProductosEvent();

  @override
  List<Object> get props => [];
}

class LoadProductos extends ProductosEvent {
  final List<String> productosIds;

  const LoadProductos(this.productosIds);

  @override
  List<Object> get props => [productosIds];
}

class SelectProducto extends ProductosEvent {
  final Producto producto;

  const SelectProducto(this.producto);

  @override
  List<Object> get props => [producto];
}
