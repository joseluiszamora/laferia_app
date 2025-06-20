import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/services/producto_service.dart';
import '../../models/producto.dart';
import 'productos_event.dart';
import 'productos_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  ProductosBloc() : super(ProductosInitial()) {
    on<LoadProductos>(_onLoadProductos);
    on<SelectProducto>(_onSelectProducto);
    on<LoadProductosBySubcategoria>(_onLoadProductosBySubcategoria);
    on<LoadProductosByCategoria>(_onLoadProductosByCategoria);
    on<LoadProductosByRubro>(_onLoadProductosByRubro);
  }

  void _onLoadProductos(
    LoadProductos event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 300));

      // Filtrar productos según los IDs recibidos
      final productos =
          ProductoService.obtenerProductos
              .where((producto) => event.productosIds.contains(producto.id))
              .toList();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar los productos: $e'));
    }
  }

  void _onSelectProducto(SelectProducto event, Emitter<ProductosState> emit) {
    if (state is ProductosLoaded) {
      final currentState = state as ProductosLoaded;
      emit(currentState.copyWith(selectedProducto: event.producto));
    }
  }

  void _onLoadProductosBySubcategoria(
    LoadProductosBySubcategoria event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Filtrar productos por subcategoría
      // final productos =
      //     ProductoService.obtenerProductos
      //         .where(
      //           (producto) => producto.subcategoriaId == event.subcategoriaId,
      //         )
      //         .toList();
      final productos = ProductoService.obtenerProductos.toList();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar productos por subcategoría: $e'));
    }
  }

  void _onLoadProductosByCategoria(
    LoadProductosByCategoria event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Filtrar productos por categoría
      final productos =
          ProductoService.obtenerProductos
              .where((producto) => producto.categoriaId == event.categoriaId)
              .toList();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar productos por categoría: $e'));
    }
  }

  void _onLoadProductosByRubro(
    LoadProductosByRubro event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Filtrar productos por rubro
      // final productos =
      //     ProductoService.obtenerProductos
      //         .where((producto) => producto.rubroId == event.rubroId)
      //         .toList();
      final productos = ProductoService.obtenerProductos.toList();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar productos por rubro: $e'));
    }
  }
}
