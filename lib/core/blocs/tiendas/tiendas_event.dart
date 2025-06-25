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
  final String nombre;
  final String nombrePropietario;
  final Ubicacion ubicacion;
  final String categoriaId;
  final List<String>? productos;
  final Contacto? contacto;
  final String? direccion;
  final List<String>? diasAtencion;
  final String? horarioAtencion;

  const CrearTienda({
    required this.nombre,
    required this.nombrePropietario,
    required this.ubicacion,
    required this.categoriaId,
    this.productos,
    this.contacto,
    this.direccion,
    this.diasAtencion,
    this.horarioAtencion,
  });

  @override
  List<Object?> get props => [
    nombre,
    nombrePropietario,
    ubicacion,
    categoriaId,
    productos,
    contacto,
    direccion,
    diasAtencion,
    horarioAtencion,
  ];
}

class ActualizarTienda extends TiendasEvent {
  final String id;
  final String nombre;
  final String nombrePropietario;
  final Ubicacion ubicacion;
  final String categoriaId;
  final List<String>? productos;
  final Contacto? contacto;
  final String? direccion;
  final List<String>? diasAtencion;
  final String? horarioAtencion;
  final double? calificacion;
  final List<Comentario>? comentarios;

  const ActualizarTienda({
    required this.id,
    required this.nombre,
    required this.nombrePropietario,
    required this.ubicacion,
    required this.categoriaId,
    this.productos,
    this.contacto,
    this.direccion,
    this.diasAtencion,
    this.horarioAtencion,
    this.calificacion,
    this.comentarios,
  });

  @override
  List<Object?> get props => [
    id,
    nombre,
    nombrePropietario,
    ubicacion,
    categoriaId,
    productos,
    contacto,
    direccion,
    diasAtencion,
    horarioAtencion,
    calificacion,
    comentarios,
  ];
}

class EliminarTienda extends TiendasEvent {
  final String id;

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
  final String categoriaId;

  const FiltrarTiendasPorCategoria(this.categoriaId);

  @override
  List<Object> get props => [categoriaId];
}

class LimpiarFiltros extends TiendasEvent {}

class SeleccionarParaEditar extends TiendasEvent {
  final String tiendaId;

  const SeleccionarParaEditar(this.tiendaId);

  @override
  List<Object> get props => [tiendaId];
}
