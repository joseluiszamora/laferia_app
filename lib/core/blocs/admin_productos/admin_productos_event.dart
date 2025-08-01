import '../../models/producto.dart';

abstract class AdminProductosEvent {}

class LoadAdminProductos extends AdminProductosEvent {
  final int limit;
  final int offset;
  final String? searchQuery;
  final int? categoryId;
  final ProductStatus? status;
  final String sortBy;
  final bool ascending;

  LoadAdminProductos({
    this.limit = 20,
    this.offset = 0,
    this.searchQuery,
    this.categoryId,
    this.status,
    this.sortBy = 'created_at',
    this.ascending = false,
  });
}

class CreateProducto extends AdminProductosEvent {
  final Map<String, dynamic> productoData;

  CreateProducto({required this.productoData});
}

class UpdateProducto extends AdminProductosEvent {
  final int productoId;
  final Map<String, dynamic> productoData;

  UpdateProducto({required this.productoId, required this.productoData});
}

class DeleteProducto extends AdminProductosEvent {
  final int productoId;

  DeleteProducto({required this.productoId});
}

class LoadProductoForEdit extends AdminProductosEvent {
  final int productoId;

  LoadProductoForEdit({required this.productoId});
}

class UpdateProductoStatus extends AdminProductosEvent {
  final int productoId;
  final ProductStatus status;

  UpdateProductoStatus({required this.productoId, required this.status});
}

class BulkUpdateStatus extends AdminProductosEvent {
  final List<int> productoIds;
  final ProductStatus status;

  BulkUpdateStatus({required this.productoIds, required this.status});
}

class BulkDeleteProductos extends AdminProductosEvent {
  final List<int> productoIds;

  BulkDeleteProductos({required this.productoIds});
}
