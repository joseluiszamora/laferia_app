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
  final Subcategoria? selectedSubcategoria;

  const CategoriasLoaded({
    required this.categorias,
    this.selectedCategoria,
    this.selectedSubcategoria,
  });

  CategoriasLoaded copyWith({
    List<Categoria>? categorias,
    Categoria? selectedCategoria,
    Subcategoria? selectedSubcategoria,
  }) {
    return CategoriasLoaded(
      categorias: categorias ?? this.categorias,
      selectedCategoria: selectedCategoria ?? this.selectedCategoria,
      selectedSubcategoria: selectedSubcategoria ?? this.selectedSubcategoria,
    );
  }

  @override
  List<Object?> get props => [
    categorias,
    selectedCategoria,
    selectedSubcategoria,
  ];
}

class CategoriasError extends CategoriasState {
  final String message;

  const CategoriasError(this.message);

  @override
  List<Object> get props => [message];
}
