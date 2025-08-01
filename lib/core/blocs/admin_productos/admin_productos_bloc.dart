import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/admin_producto_service.dart';
import '../../models/producto.dart';
import 'admin_productos_event.dart';
import 'admin_productos_state.dart';

class AdminProductosBloc
    extends Bloc<AdminProductosEvent, AdminProductosState> {
  AdminProductosBloc() : super(AdminProductosInitial()) {
    on<LoadAdminProductos>(_onLoadAdminProductos);
    on<CreateProducto>(_onCreateProducto);
    on<UpdateProducto>(_onUpdateProducto);
    on<DeleteProducto>(_onDeleteProducto);
    on<LoadProductoForEdit>(_onLoadProductoForEdit);
    on<UpdateProductoStatus>(_onUpdateProductoStatus);
    on<BulkUpdateStatus>(_onBulkUpdateStatus);
    on<BulkDeleteProductos>(_onBulkDeleteProductos);
  }

  Future<void> _onLoadAdminProductos(
    LoadAdminProductos event,
    Emitter<AdminProductosState> emit,
  ) async {
    if (event.offset == 0) {
      emit(AdminProductosLoading());
    }

    try {
      final result = await AdminProductoService.obtenerProductosAdmin(
        limit: event.limit,
        offset: event.offset,
        searchQuery: event.searchQuery,
        categoryId: event.categoryId,
        status: event.status,
        sortBy: event.sortBy,
        ascending: event.ascending,
      );

      final productos = result['productos'] as List<Producto>;
      final totalCount = result['totalCount'] as int;
      final hasMore = result['hasMore'] as bool;

      if (state is AdminProductosLoaded && event.offset > 0) {
        // Cargar más productos (paginación)
        final currentState = state as AdminProductosLoaded;
        final updatedProductos = [...currentState.productos, ...productos];

        emit(
          AdminProductosLoaded(
            productos: updatedProductos,
            hasReachedMax: !hasMore,
            totalCount: totalCount,
            searchQuery: event.searchQuery,
            selectedCategoryId: event.categoryId,
            selectedStatus: event.status,
          ),
        );
      } else {
        // Primera carga o nueva búsqueda
        emit(
          AdminProductosLoaded(
            productos: productos,
            hasReachedMax: !hasMore,
            totalCount: totalCount,
            searchQuery: event.searchQuery,
            selectedCategoryId: event.categoryId,
            selectedStatus: event.status,
          ),
        );
      }
    } catch (e) {
      emit(AdminProductosError(message: e.toString()));
    }
  }

  Future<void> _onCreateProducto(
    CreateProducto event,
    Emitter<AdminProductosState> emit,
  ) async {
    emit(const AdminProductoOperationLoading(operation: 'create'));

    try {
      await AdminProductoService.crearProducto(event.productoData);
      emit(
        const AdminProductoOperationSuccess(
          message: 'Producto creado exitosamente',
          operation: 'create',
        ),
      );

      // Recargar la lista de productos
      add(LoadAdminProductos());
    } catch (e) {
      emit(AdminProductosError(message: 'Error al crear producto: $e'));
    }
  }

  Future<void> _onUpdateProducto(
    UpdateProducto event,
    Emitter<AdminProductosState> emit,
  ) async {
    emit(const AdminProductoOperationLoading(operation: 'update'));

    try {
      await AdminProductoService.actualizarProducto(
        event.productoId,
        event.productoData,
      );
      emit(
        const AdminProductoOperationSuccess(
          message: 'Producto actualizado exitosamente',
          operation: 'update',
        ),
      );

      // Recargar la lista de productos
      add(LoadAdminProductos());
    } catch (e) {
      emit(AdminProductosError(message: 'Error al actualizar producto: $e'));
    }
  }

  Future<void> _onDeleteProducto(
    DeleteProducto event,
    Emitter<AdminProductosState> emit,
  ) async {
    emit(const AdminProductoOperationLoading(operation: 'delete'));

    try {
      await AdminProductoService.eliminarProducto(event.productoId);
      emit(
        const AdminProductoOperationSuccess(
          message: 'Producto eliminado exitosamente',
          operation: 'delete',
        ),
      );

      // Recargar la lista de productos
      add(LoadAdminProductos());
    } catch (e) {
      emit(AdminProductosError(message: 'Error al eliminar producto: $e'));
    }
  }

  Future<void> _onLoadProductoForEdit(
    LoadProductoForEdit event,
    Emitter<AdminProductosState> emit,
  ) async {
    emit(AdminProductosLoading());

    try {
      final producto = await AdminProductoService.obtenerProductoPorId(
        event.productoId,
      );
      emit(AdminProductoForEditLoaded(producto: producto));
    } catch (e) {
      emit(AdminProductosError(message: 'Error al cargar producto: $e'));
    }
  }

  Future<void> _onUpdateProductoStatus(
    UpdateProductoStatus event,
    Emitter<AdminProductosState> emit,
  ) async {
    try {
      await AdminProductoService.actualizarEstadoProducto(
        event.productoId,
        event.status,
      );

      // Actualizar el estado local si tenemos productos cargados
      if (state is AdminProductosLoaded) {
        final currentState = state as AdminProductosLoaded;
        final updatedProductos =
            currentState.productos.map((producto) {
              if (producto.id == event.productoId) {
                return producto.copyWith(status: event.status);
              }
              return producto;
            }).toList();

        emit(currentState.copyWith(productos: updatedProductos));
      }
    } catch (e) {
      emit(AdminProductosError(message: 'Error al actualizar estado: $e'));
    }
  }

  Future<void> _onBulkUpdateStatus(
    BulkUpdateStatus event,
    Emitter<AdminProductosState> emit,
  ) async {
    emit(const AdminProductoOperationLoading(operation: 'bulk_update'));

    try {
      await AdminProductoService.actualizarEstadoMasivo(
        event.productoIds,
        event.status,
      );
      emit(
        const AdminProductoOperationSuccess(
          message: 'Estados actualizados exitosamente',
          operation: 'bulk_update',
        ),
      );

      // Recargar la lista de productos
      add(LoadAdminProductos());
    } catch (e) {
      emit(AdminProductosError(message: 'Error al actualizar estados: $e'));
    }
  }

  Future<void> _onBulkDeleteProductos(
    BulkDeleteProductos event,
    Emitter<AdminProductosState> emit,
  ) async {
    emit(const AdminProductoOperationLoading(operation: 'bulk_delete'));

    try {
      await AdminProductoService.eliminarProductosMasivo(event.productoIds);
      emit(
        const AdminProductoOperationSuccess(
          message: 'Productos eliminados exitosamente',
          operation: 'bulk_delete',
        ),
      );

      // Recargar la lista de productos
      add(LoadAdminProductos());
    } catch (e) {
      emit(AdminProductosError(message: 'Error al eliminar productos: $e'));
    }
  }
}
