import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/services/supabase_producto_service.dart';
import 'productos_event.dart';
import 'productos_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  ProductosBloc() : super(ProductosInitial()) {
    on<LoadProductos>(_onLoadProductos);
    on<SelectProducto>(_onSelectProducto);
    on<LoadProductosBySubcategoria>(_onLoadProductosBySubcategoria);
    on<LoadProductosByCategoria>(_onLoadProductosByCategoria);
    on<LoadProductosByRubro>(_onLoadProductosByRubro);
    on<LoadProductosEnOferta>(_onLoadProductosEnOferta);
  }

  void _onLoadProductos(
    LoadProductos event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Filtrar productos según los IDs recibidos
      final productos = await SupabaseProductoService.obtenerProductos();

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
      // Filtrar productos por subcategoría
      // final productos =
      //     ProductoService.obtenerProductos
      //         .where(
      //           (producto) => producto.subcategoriaId == event.subcategoriaId,
      //         )
      //         .toList();
      final productos = await SupabaseProductoService.obtenerProductos();

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
      final productos = await SupabaseProductoService.obtenerProductos();

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
      final productos = await SupabaseProductoService.obtenerProductos();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar productos por rubro: $e'));
    }
  }

  void _onLoadProductosEnOferta(
    LoadProductosEnOferta event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Cargar productos en oferta usando el servicio
      final productos = await SupabaseProductoService.obtenerProductosEnOferta(
        limit: event.limit ?? 20,
        offset: event.offset ?? 0,
      );

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar productos en oferta: $e'));
    }
  }
}
