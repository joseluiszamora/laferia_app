import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/services/categoria_service.dart';
import 'categorias_event.dart';
import 'categorias_state.dart';

class CategoriasBloc extends Bloc<CategoriasEvent, CategoriasState> {
  CategoriasBloc() : super(CategoriasInitial()) {
    on<LoadCategorias>(_onLoadCategorias);
    on<LoadMainCategorias>(_onLoadMainCategorias);
    on<SelectCategoria>(_onSelectCategoria);
    on<SelectSubcategoria>(_onSelectSubcategoria);
    on<FilterByCategoria>(_onFilterByCategoria);
  }

  void _onLoadCategorias(
    LoadCategorias event,
    Emitter<CategoriasState> emit,
  ) async {
    emit(CategoriasLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 300));

      // Datos de prueba de categorías
      final categorias = CategoriaService.getAllCategorias();

      emit(CategoriasLoaded(categorias: categorias));
    } catch (e) {
      emit(CategoriasError('Error al cargar las categorías: $e'));
    }
  }

  void _onLoadMainCategorias(
    LoadMainCategorias event,
    Emitter<CategoriasState> emit,
  ) async {
    emit(CategoriasLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 300));

      // Obtener solo las categorías principales (sin subcategorías)
      final categoriasPrivate = CategoriaService.getMainCategorias();

      emit(CategoriasLoaded(categorias: categoriasPrivate));
    } catch (e) {
      emit(CategoriasError('Error al cargar las categorías principales: $e'));
    }
  }

  void _onSelectCategoria(
    SelectCategoria event,
    Emitter<CategoriasState> emit,
  ) {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;
      emit(
        currentState.copyWith(
          selectedCategoria: event.categoria,
          selectedSubcategoria: null, // Reset subcategoria al cambiar categoría
        ),
      );
    }
  }

  void _onSelectSubcategoria(
    SelectSubcategoria event,
    Emitter<CategoriasState> emit,
  ) {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;
      emit(currentState.copyWith(selectedSubcategoria: event.subcategoria));
    }
  }

  void _onFilterByCategoria(
    FilterByCategoria event,
    Emitter<CategoriasState> emit,
  ) {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;
      final categoria = currentState.categorias.firstWhere(
        (cat) => cat.id == event.categoriaId,
      );
      emit(currentState.copyWith(selectedCategoria: categoria));
    }
  }
}
