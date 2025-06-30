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

/// Evento para cargar productos por subcategoría
class LoadProductosBySubcategoria extends ProductosEvent {
  final String subcategoriaId;

  const LoadProductosBySubcategoria(this.subcategoriaId);

  @override
  List<Object> get props => [subcategoriaId];
}

/// Evento para cargar productos por categoría
class LoadProductosByCategoria extends ProductosEvent {
  final String categoriaId;

  const LoadProductosByCategoria(this.categoriaId);

  @override
  List<Object> get props => [categoriaId];
}

/// Evento para cargar productos por rubro
class LoadProductosByRubro extends ProductosEvent {
  final String rubroId;

  const LoadProductosByRubro(this.rubroId);

  @override
  List<Object> get props => [rubroId];
}

/// Evento para cargar productos en oferta
class LoadProductosEnOferta extends ProductosEvent {
  final int? limit;
  final int? offset;

  const LoadProductosEnOferta({this.limit, this.offset});

  @override
  List<Object> get props => [limit ?? 0, offset ?? 0];
}
