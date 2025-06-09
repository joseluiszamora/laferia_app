import 'package:equatable/equatable.dart';

abstract class RubrosEvent extends Equatable {
  const RubrosEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar todos los rubros
class LoadRubros extends RubrosEvent {
  const LoadRubros();
}

/// Evento para seleccionar un rubro
class SelectRubro extends RubrosEvent {
  final String rubroId;

  const SelectRubro(this.rubroId);

  @override
  List<Object?> get props => [rubroId];
}

/// Evento para seleccionar una categoría
class SelectCategoria extends RubrosEvent {
  final String rubroId;
  final String categoriaId;

  const SelectCategoria(this.rubroId, this.categoriaId);

  @override
  List<Object?> get props => [rubroId, categoriaId];
}

/// Evento para seleccionar una subcategoría
class SelectSubcategoria extends RubrosEvent {
  final String rubroId;
  final String categoriaId;
  final String subcategoriaId;

  const SelectSubcategoria(this.rubroId, this.categoriaId, this.subcategoriaId);

  @override
  List<Object?> get props => [rubroId, categoriaId, subcategoriaId];
}

/// Evento para filtrar rubros por nombre
class FilterRubros extends RubrosEvent {
  final String query;

  const FilterRubros(this.query);

  @override
  List<Object?> get props => [query];
}

/// Evento para resetear la selección
class ResetSelection extends RubrosEvent {
  const ResetSelection();
}

/// Evento para cargar categorías de un rubro específico
class LoadCategoriasByRubro extends RubrosEvent {
  final String rubroId;

  const LoadCategoriasByRubro(this.rubroId);

  @override
  List<Object?> get props => [rubroId];
}

/// Evento para cargar subcategorías de una categoría específica
class LoadSubcategoriasByCategoria extends RubrosEvent {
  final String categoriaId;

  const LoadSubcategoriasByCategoria(this.categoriaId);

  @override
  List<Object?> get props => [categoriaId];
}
