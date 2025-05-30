import 'package:equatable/equatable.dart';
import '../../models/tienda.dart';

abstract class TiendasState extends Equatable {
  const TiendasState();

  @override
  List<Object?> get props => [];
}

class TiendasInitial extends TiendasState {}

class TiendasLoading extends TiendasState {}

class TiendasLoaded extends TiendasState {
  final List<Tienda> tiendas;
  final Tienda? selectedTienda;

  const TiendasLoaded({required this.tiendas, this.selectedTienda});

  TiendasLoaded copyWith({List<Tienda>? tiendas, Tienda? selectedTienda}) {
    return TiendasLoaded(
      tiendas: tiendas ?? this.tiendas,
      selectedTienda: selectedTienda ?? this.selectedTienda,
    );
  }

  @override
  List<Object?> get props => [tiendas, selectedTienda];
}

class TiendasError extends TiendasState {
  final String message;

  const TiendasError(this.message);

  @override
  List<Object> get props => [message];
}
