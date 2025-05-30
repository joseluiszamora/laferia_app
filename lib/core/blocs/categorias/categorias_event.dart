import 'package:equatable/equatable.dart';
import '../../models/categoria.dart';

abstract class CategoriasEvent extends Equatable {
  const CategoriasEvent();

  @override
  List<Object> get props => [];
}

class LoadCategorias extends CategoriasEvent {}

class SelectCategoria extends CategoriasEvent {
  final Categoria categoria;

  const SelectCategoria(this.categoria);

  @override
  List<Object> get props => [categoria];
}

class SelectSubcategoria extends CategoriasEvent {
  final Subcategoria subcategoria;

  const SelectSubcategoria(this.subcategoria);

  @override
  List<Object> get props => [subcategoria];
}

class FilterByCategoria extends CategoriasEvent {
  final String categoriaId;

  const FilterByCategoria(this.categoriaId);

  @override
  List<Object> get props => [categoriaId];
}
