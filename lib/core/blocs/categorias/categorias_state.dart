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
  final List<Categoria> todasLasCategorias; // Lista completa sin filtros
  final Categoria? selectedCategoria;
  final Categoria? selectedSubcategoria;
  final Categoria? categoriaParaEditar;
  final String? terminoBusqueda;
  final String? tipoFiltro; // 'todas', 'principales', 'subcategorias'
  final String? estadoFiltro; // 'activas', 'inactivas', 'todas'

  const CategoriasLoaded({
    required this.categorias,
    required this.todasLasCategorias,
    this.selectedCategoria,
    this.selectedSubcategoria,
    this.categoriaParaEditar,
    this.terminoBusqueda,
    this.tipoFiltro = 'todas',
    this.estadoFiltro = 'activas',
  });

  CategoriasLoaded copyWith({
    List<Categoria>? categorias,
    List<Categoria>? todasLasCategorias,
    Categoria? selectedCategoria,
    Categoria? selectedSubcategoria,
    Categoria? categoriaParaEditar,
    String? terminoBusqueda,
    String? tipoFiltro,
    String? estadoFiltro,
    bool clearCategoriaParaEditar = false,
    bool clearTerminoBusqueda = false,
  }) {
    return CategoriasLoaded(
      categorias: categorias ?? this.categorias,
      todasLasCategorias: todasLasCategorias ?? this.todasLasCategorias,
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
      tipoFiltro: tipoFiltro ?? this.tipoFiltro,
      estadoFiltro: estadoFiltro ?? this.estadoFiltro,
    );
  }

  // Getter para obtener categorías filtradas
  List<Categoria> get categoriasFiltradas {
    List<Categoria> resultado = List.from(todasLasCategorias);

    // Aplicar filtro de tipo
    if (tipoFiltro == 'principales') {
      resultado =
          resultado
              .where((cat) => cat.parentId == null || cat.parentId!.isEmpty)
              .toList();
    } else if (tipoFiltro == 'subcategorias') {
      resultado =
          resultado
              .where((cat) => cat.parentId != null && cat.parentId!.isNotEmpty)
              .toList();
    }

    // Aplicar filtro de estado (por ahora todas las categorías están activas)
    if (estadoFiltro == 'inactivas') {
      // Como no tenemos categorías inactivas, retornamos lista vacía
      resultado = [];
    } else if (estadoFiltro == 'todas_estado') {
      // Mantener todas las categorías
      // No hacer nada, resultado ya tiene todas
    }
    // Para 'activas' (default), mantener todas ya que todas están activas

    // Aplicar filtro de búsqueda
    if (terminoBusqueda != null && terminoBusqueda!.isNotEmpty) {
      resultado =
          resultado.where((categoria) {
            final searchLower = terminoBusqueda!.toLowerCase();
            return categoria.name.toLowerCase().contains(searchLower) ||
                (categoria.description?.toLowerCase().contains(searchLower) ??
                    false);
          }).toList();
    }

    return resultado;
  }

  @override
  List<Object?> get props => [
    categorias,
    todasLasCategorias,
    selectedCategoria,
    selectedSubcategoria,
    categoriaParaEditar,
    terminoBusqueda,
    tipoFiltro,
    estadoFiltro,
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
