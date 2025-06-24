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
  final String?
  categoriaPrincipalFiltro; // ID de categoría principal para filtrar subcategorías

  const CategoriasLoaded({
    required this.categorias,
    required this.todasLasCategorias,
    this.selectedCategoria,
    this.selectedSubcategoria,
    this.categoriaParaEditar,
    this.terminoBusqueda,
    this.tipoFiltro = 'todas',
    this.estadoFiltro = 'activas',
    this.categoriaPrincipalFiltro,
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
    String? categoriaPrincipalFiltro,
    bool clearCategoriaParaEditar = false,
    bool clearTerminoBusqueda = false,
    bool clearCategoriaPrincipalFiltro = false,
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
      categoriaPrincipalFiltro:
          clearCategoriaPrincipalFiltro
              ? null
              : (categoriaPrincipalFiltro ?? this.categoriaPrincipalFiltro),
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

    // Aplicar filtro por categoría principal (mostrar solo sus subcategorías)
    if (categoriaPrincipalFiltro != null &&
        categoriaPrincipalFiltro!.isNotEmpty) {
      resultado =
          resultado.where((cat) {
            // Mostrar la categoría principal seleccionada
            if (cat.id == categoriaPrincipalFiltro) {
              return true;
            }
            // Mostrar todas las subcategorías que pertenecen a esta categoría principal
            return _perteneceACategoriaPrincipal(
              cat,
              categoriaPrincipalFiltro!,
              todasLasCategorias,
            );
          }).toList();
    }

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

  // Método auxiliar para verificar si una categoría pertenece a una categoría principal
  bool _perteneceACategoriaPrincipal(
    Categoria categoria,
    String categoriaPrincipalId,
    List<Categoria> todasLasCategorias,
  ) {
    if (categoria.parentId == null || categoria.parentId!.isEmpty) {
      return false; // Es una categoría principal, no una subcategoría
    }

    // Verificar si es hija directa
    if (categoria.parentId == categoriaPrincipalId) {
      return true;
    }

    // Verificar si es hija indirecta (nieta, bisnieta, etc.)
    String? currentParentId = categoria.parentId;
    while (currentParentId != null && currentParentId.isNotEmpty) {
      if (currentParentId == categoriaPrincipalId) {
        return true;
      }

      final parent = todasLasCategorias.firstWhere(
        (cat) => cat.id == currentParentId,
        orElse: () => const Categoria(id: '', name: '', slug: ''),
      );

      if (parent.id.isEmpty) break;
      currentParentId = parent.parentId;
    }

    return false;
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
    categoriaPrincipalFiltro,
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
