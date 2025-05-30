import 'package:equatable/equatable.dart';
import '../../models/tienda.dart';

abstract class TiendasEvent extends Equatable {
  const TiendasEvent();

  @override
  List<Object> get props => [];
}

class LoadTiendas extends TiendasEvent {}

class SelectTienda extends TiendasEvent {
  final Tienda tienda;

  const SelectTienda(this.tienda);

  @override
  List<Object> get props => [tienda];
}
