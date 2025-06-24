import 'package:equatable/equatable.dart';
import '../../models/categoria.dart';

abstract class CategoriasEvent extends Equatable {
  const CategoriasEvent();

  @override
  List<Object> get props => [];
}

class LoadCategorias extends CategoriasEvent {}

class LoadMainCategorias extends CategoriasEvent {}

class SelectCategoria extends CategoriasEvent {
  final Categoria categoria;

  const SelectCategoria(this.categoria);

  @override
  List<Object> get props => [categoria];
}

class SelectSubcategoria extends CategoriasEvent {
  final Categoria subcategoria;

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

// Eventos para administración CRUD
class CrearCategoria extends CategoriasEvent {
  final String? parentId;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final String? color;
  final String? imageUrl;

  const CrearCategoria({
    this.parentId,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.color,
    this.imageUrl,
  });

  @override
  List<Object> get props => [
    if (parentId != null) parentId!,
    name,
    slug,
    if (description != null) description!,
    if (icon != null) icon!,
    if (color != null) color!,
    if (imageUrl != null) imageUrl!,
  ];
}

class ActualizarCategoria extends CategoriasEvent {
  final String id;
  final String? parentId;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final String? color;
  final String? imageUrl;

  const ActualizarCategoria({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.color,
    this.imageUrl,
  });

  @override
  List<Object> get props => [
    id,
    if (parentId != null) parentId!,
    name,
    slug,
    if (description != null) description!,
    if (icon != null) icon!,
    if (color != null) color!,
    if (imageUrl != null) imageUrl!,
  ];
}

class EliminarCategoria extends CategoriasEvent {
  final String id;

  const EliminarCategoria(this.id);

  @override
  List<Object> get props => [id];
}

class BuscarCategorias extends CategoriasEvent {
  final String termino;

  const BuscarCategorias(this.termino);

  @override
  List<Object> get props => [termino];
}

class LimpiarSeleccion extends CategoriasEvent {}

class SeleccionarParaEditar extends CategoriasEvent {
  final String categoriaId;

  const SeleccionarParaEditar(this.categoriaId);

  @override
  List<Object> get props => [categoriaId];
}
