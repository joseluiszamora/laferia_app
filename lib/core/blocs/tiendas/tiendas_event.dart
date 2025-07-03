import 'package:equatable/equatable.dart';
import '../../models/tienda.dart';
import '../../models/ubicacion.dart';
import '../../models/contacto.dart';
import '../../models/comentario.dart';

abstract class TiendasEvent extends Equatable {
  const TiendasEvent();

  @override
  List<Object?> get props => [];
}

class LoadTiendas extends TiendasEvent {}

class SelectTienda extends TiendasEvent {
  final Tienda tienda;

  const SelectTienda(this.tienda);

  @override
  List<Object> get props => [tienda];
}

// Eventos para administración CRUD
class CrearTienda extends TiendasEvent {
  final String name;
  final String ownerName;
  final Ubicacion ubicacion;
  final int categoryId;
  final List<String>? productos;
  final Contacto? contacto;
  final String? address;
  final List<String>? schedules;
  final String? operatingHours;

  const CrearTienda({
    required this.name,
    required this.ownerName,
    required this.ubicacion,
    required this.categoryId,
    this.productos,
    this.contacto,
    this.address,
    this.schedules,
    this.operatingHours,
  });

  @override
  List<Object?> get props => [
    name,
    ownerName,
    ubicacion,
    categoryId,
    productos,
    contacto,
    address,
    schedules,
    operatingHours,
  ];
}

class ActualizarTienda extends TiendasEvent {
  final int id;
  final String name;
  final String ownerName;
  final Ubicacion ubicacion;
  final int categoryId;
  final List<String>? productos;
  final Contacto? contacto;
  final String? address;
  final List<String>? schedules;
  final String? operatingHours;
  final double? averageRating;
  final List<Comentario>? comentarios;

  const ActualizarTienda({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.ubicacion,
    required this.categoryId,
    this.productos,
    this.contacto,
    this.address,
    this.schedules,
    this.operatingHours,
    this.averageRating,
    this.comentarios,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    ownerName,
    ubicacion,
    categoryId,
    productos,
    contacto,
    address,
    schedules,
    operatingHours,
    averageRating,
    comentarios,
  ];
}

class EliminarTienda extends TiendasEvent {
  final int id;

  const EliminarTienda(this.id);

  @override
  List<Object> get props => [id];
}

class BuscarTiendas extends TiendasEvent {
  final String termino;

  const BuscarTiendas(this.termino);

  @override
  List<Object> get props => [termino];
}

class FiltrarTiendasPorCategoria extends TiendasEvent {
  final int categoriaId;

  const FiltrarTiendasPorCategoria(this.categoriaId);

  @override
  List<Object> get props => [categoriaId];
}

class LimpiarFiltros extends TiendasEvent {}

class SeleccionarParaEditar extends TiendasEvent {
  final int tiendaId;

  const SeleccionarParaEditar(this.tiendaId);

  @override
  List<Object> get props => [tiendaId];
}
