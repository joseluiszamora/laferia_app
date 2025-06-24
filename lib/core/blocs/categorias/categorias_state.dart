import 'package:equatable/equatable.dart';
import '../../models/categoria.dart';

abstract class CategoriasState extends Equatable {
  const CategoriasState();

  @override
  List<Object?> get props => [];
}

class CategoriasInitial extends CategoriasState {}

class CategoriasLoading extends CategoriasState {}

class CategoriasLoaded extends CategoriasState {
  final List<Categoria> categorias;
  final Categoria? selectedCategoria;
  final Categoria? selectedSubcategoria;
  final Categoria? categoriaParaEditar;
  final String? terminoBusqueda;

  const CategoriasLoaded({
    required this.categorias,
    this.selectedCategoria,
    this.selectedSubcategoria,
    this.categoriaParaEditar,
    this.terminoBusqueda,
  });

  CategoriasLoaded copyWith({
    List<Categoria>? categorias,
    Categoria? selectedCategoria,
    Categoria? selectedSubcategoria,
    Categoria? categoriaParaEditar,
    String? terminoBusqueda,
    bool clearCategoriaParaEditar = false,
    bool clearTerminoBusqueda = false,
  }) {
    return CategoriasLoaded(
      categorias: categorias ?? this.categorias,
      selectedCategoria: selectedCategoria ?? this.selectedCategoria,
      selectedSubcategoria: selectedSubcategoria ?? this.selectedSubcategoria,
      categoriaParaEditar:
          clearCategoriaParaEditar
              ? null
              : (categoriaParaEditar ?? this.categoriaParaEditar),
      terminoBusqueda:
          clearTerminoBusqueda
              ? null
              : (terminoBusqueda ?? this.terminoBusqueda),
    );
  }

  // Getter para obtener categorías filtradas
  List<Categoria> get categoriasFiltradas {
    if (terminoBusqueda == null || terminoBusqueda!.isEmpty) {
      return categorias;
    }

    return categorias.where((categoria) {
      return categoria.name.toLowerCase().contains(
            terminoBusqueda!.toLowerCase(),
          ) ||
          categoria.description!.toLowerCase().contains(
            terminoBusqueda!.toLowerCase(),
          );
    }).toList();
  }

  @override
  List<Object?> get props => [
    categorias,
    selectedCategoria,
    selectedSubcategoria,
    categoriaParaEditar,
    terminoBusqueda,
  ];
}

class CategoriasError extends CategoriasState {
  final String message;

  const CategoriasError(this.message);

  @override
  List<Object> get props => [message];
}

// Estados específicos para operaciones CRUD
class CategoriaCreandose extends CategoriasState {}

class CategoriaCreada extends CategoriasState {
  final Categoria categoria;

  const CategoriaCreada(this.categoria);

  @override
  List<Object> get props => [categoria];
}

class CategoriaActualizandose extends CategoriasState {}

class CategoriaActualizada extends CategoriasState {
  final Categoria categoria;

  const CategoriaActualizada(this.categoria);

  @override
  List<Object> get props => [categoria];
}

class CategoriaEliminandose extends CategoriasState {}

class CategoriaEliminada extends CategoriasState {
  final String categoriaId;

  const CategoriaEliminada(this.categoriaId);

  @override
  List<Object> get props => [categoriaId];
}

class CategoriaOperacionError extends CategoriasState {
  final String message;

  const CategoriaOperacionError(this.message);

  @override
  List<Object> get props => [message];
}
