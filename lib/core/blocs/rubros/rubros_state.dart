import 'package:equatable/equatable.dart';
import '../../models/rubro.dart';
import '../../models/categoria.dart';

abstract class RubrosState extends Equatable {
  const RubrosState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class RubrosInitial extends RubrosState {
  const RubrosInitial();
}

/// Estado de carga
class RubrosLoading extends RubrosState {
  const RubrosLoading();
}

/// Estado con rubros cargados
class RubrosLoaded extends RubrosState {
  final List<Rubro> rubros;
  final List<Rubro> filteredRubros;
  final String? selectedRubroId;
  final String? selectedCategoriaId;
  final String? selectedSubcategoriaId;
  final String searchQuery;

  const RubrosLoaded({
    required this.rubros,
    required this.filteredRubros,
    this.selectedRubroId,
    this.selectedCategoriaId,
    this.selectedSubcategoriaId,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    rubros,
    filteredRubros,
    selectedRubroId,
    selectedCategoriaId,
    selectedSubcategoriaId,
    searchQuery,
  ];

  /// Obtiene el rubro seleccionado
  Rubro? get selectedRubro {
    if (selectedRubroId == null) return null;
    try {
      return rubros.firstWhere((rubro) => rubro.id == selectedRubroId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene la categoría seleccionada
  Categoria? get selectedCategoria {
    if (selectedCategoriaId == null || selectedRubro == null) return null;
    return selectedRubro!.getCategoriaById(selectedCategoriaId!);
  }

  /// Obtiene la subcategoría seleccionada
  Subcategoria? get selectedSubcategoria {
    if (selectedSubcategoriaId == null || selectedCategoria == null)
      return null;
    return selectedCategoria!.getSubcategoriaById(selectedSubcategoriaId!);
  }

  /// Obtiene las categorías del rubro seleccionado
  List<Categoria> get categoriasFromSelectedRubro {
    return selectedRubro?.categorias ?? [];
  }

  /// Obtiene las subcategorías de la categoría seleccionada
  List<Subcategoria> get subcategoriasFromSelectedCategoria {
    return selectedCategoria?.subcategorias ?? [];
  }

  /// Copia del estado con modificaciones
  RubrosLoaded copyWith({
    List<Rubro>? rubros,
    List<Rubro>? filteredRubros,
    String? selectedRubroId,
    String? selectedCategoriaId,
    String? selectedSubcategoriaId,
    String? searchQuery,
    bool clearRubroSelection = false,
    bool clearCategoriaSelection = false,
    bool clearSubcategoriaSelection = false,
  }) {
    return RubrosLoaded(
      rubros: rubros ?? this.rubros,
      filteredRubros: filteredRubros ?? this.filteredRubros,
      selectedRubroId:
          clearRubroSelection
              ? null
              : (selectedRubroId ?? this.selectedRubroId),
      selectedCategoriaId:
          clearCategoriaSelection
              ? null
              : (selectedCategoriaId ?? this.selectedCategoriaId),
      selectedSubcategoriaId:
          clearSubcategoriaSelection
              ? null
              : (selectedSubcategoriaId ?? this.selectedSubcategoriaId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Estado de error
class RubrosError extends RubrosState {
  final String message;

  const RubrosError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Estado específico para mostrar categorías
class CategoriasLoaded extends RubrosState {
  final String rubroId;
  final List<Categoria> categorias;
  final String? selectedCategoriaId;

  const CategoriasLoaded({
    required this.rubroId,
    required this.categorias,
    this.selectedCategoriaId,
  });

  @override
  List<Object?> get props => [rubroId, categorias, selectedCategoriaId];
}

/// Estado específico para mostrar subcategorías
class SubcategoriasLoaded extends RubrosState {
  final String rubroId;
  final String categoriaId;
  final List<Subcategoria> subcategorias;
  final String? selectedSubcategoriaId;

  const SubcategoriasLoaded({
    required this.rubroId,
    required this.categoriaId,
    required this.subcategorias,
    this.selectedSubcategoriaId,
  });

  @override
  List<Object?> get props => [
    rubroId,
    categoriaId,
    subcategorias,
    selectedSubcategoriaId,
  ];
}
