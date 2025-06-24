import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/models/categoria.dart';
import 'package:laferia/core/services/supabase_categoria_service.dart';
import 'categorias_event.dart';
import 'categorias_state.dart';

class CategoriasBloc extends Bloc<CategoriasEvent, CategoriasState> {
  CategoriasBloc() : super(CategoriasInitial()) {
    on<LoadCategorias>(_onLoadCategorias);
    on<LoadMainCategorias>(_onLoadMainCategorias);
    on<SelectCategoria>(_onSelectCategoria);
    on<SelectSubcategoria>(_onSelectSubcategoria);
    on<FilterByCategoria>(_onFilterByCategoria);

    // Nuevos handlers para administración
    on<CrearCategoria>(_onCrearCategoria);
    on<ActualizarCategoria>(_onActualizarCategoria);
    on<EliminarCategoria>(_onEliminarCategoria);
    on<BuscarCategorias>(_onBuscarCategorias);
    on<LimpiarSeleccion>(_onLimpiarSeleccion);
    on<SeleccionarParaEditar>(_onSeleccionarParaEditar);
  }

  void _onLoadCategorias(
    LoadCategorias event,
    Emitter<CategoriasState> emit,
  ) async {
    emit(CategoriasLoading());

    try {
      final categorias = await SupabaseCategoriaService.getAllCategorias();

      for (var categoria in categorias) {
        print(
          '📂 Categoría: ${categoria.name} (ID: ${categoria.id}, ParentID: ${categoria.parentId})',
        );
      }

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
      final categorias = await SupabaseCategoriaService.getMainCategorias();
      emit(CategoriasLoaded(categorias: categorias));
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

  // Nuevos métodos para administración CRUD

  void _onCrearCategoria(
    CrearCategoria event,
    Emitter<CategoriasState> emit,
  ) async {
    emit(CategoriaCreandose());

    try {
      final nuevaCategoria = Categoria(
        id: '', // Se generará automáticamente en Supabase
        parentId: event.parentId,
        name: event.name,
        slug: event.slug,
        description: event.description,
        icon: event.icon,
        color: event.color,
        imageUrl: event.imageUrl,
      );

      final categoriaCreada = await SupabaseCategoriaService.crearCategoria(
        nuevaCategoria,
      );
      emit(CategoriaCreada(categoriaCreada));

      // Recargar la lista
      add(LoadCategorias());
    } catch (e) {
      emit(CategoriaOperacionError('Error al crear la categoría: $e'));
    }
  }

  void _onActualizarCategoria(
    ActualizarCategoria event,
    Emitter<CategoriasState> emit,
  ) async {
    emit(CategoriaActualizandose());

    try {
      final categoriaActualizada = Categoria(
        id: event.id,
        parentId: event.parentId,
        name: event.name,
        slug: event.slug,
        description: event.description,
        icon: event.icon,
        color: event.color,
        imageUrl: event.imageUrl,
      );

      final categoriaGuardada =
          await SupabaseCategoriaService.actualizarCategoria(
            categoriaActualizada,
          );
      emit(CategoriaActualizada(categoriaGuardada));

      // Recargar la lista
      add(LoadCategorias());
    } catch (e) {
      emit(CategoriaOperacionError('Error al actualizar la categoría: $e'));
    }
  }

  void _onEliminarCategoria(
    EliminarCategoria event,
    Emitter<CategoriasState> emit,
  ) async {
    emit(CategoriaEliminandose());

    try {
      await SupabaseCategoriaService.eliminarCategoria(event.id);
      emit(CategoriaEliminada(event.id));

      // Recargar la lista
      add(LoadCategorias());
    } catch (e) {
      emit(CategoriaOperacionError('Error al eliminar la categoría: $e'));
    }
  }

  void _onBuscarCategorias(
    BuscarCategorias event,
    Emitter<CategoriasState> emit,
  ) async {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;

      if (event.termino.isEmpty) {
        // Si el término está vacío, mostrar todas las categorías
        try {
          final categorias = await SupabaseCategoriaService.getAllCategorias();
          emit(
            currentState.copyWith(categorias: categorias, terminoBusqueda: ''),
          );
        } catch (e) {
          emit(CategoriaOperacionError('Error al cargar categorías: $e'));
        }
      } else {
        // Buscar categorías que coincidan con el término
        try {
          final categoriasFiltradas =
              await SupabaseCategoriaService.buscarCategorias(event.termino);
          emit(
            currentState.copyWith(
              categorias: categoriasFiltradas,
              terminoBusqueda: event.termino,
            ),
          );
        } catch (e) {
          emit(CategoriaOperacionError('Error al buscar categorías: $e'));
        }
      }
    }
  }

  void _onLimpiarSeleccion(
    LimpiarSeleccion event,
    Emitter<CategoriasState> emit,
  ) {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;
      emit(
        currentState.copyWith(
          clearCategoriaParaEditar: true,
          clearTerminoBusqueda: true,
        ),
      );
    }
  }

  void _onSeleccionarParaEditar(
    SeleccionarParaEditar event,
    Emitter<CategoriasState> emit,
  ) {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;
      final categoria = currentState.categorias.firstWhere(
        (cat) => cat.id == event.categoriaId,
      );
      emit(currentState.copyWith(categoriaParaEditar: categoria));
    }
  }
}
