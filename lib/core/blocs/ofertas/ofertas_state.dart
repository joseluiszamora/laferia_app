import 'package:equatable/equatable.dart';
import '../../models/oferta.dart';

abstract class OfertasState extends Equatable {
  const OfertasState();

  @override
  List<Object> get props => [];
}

class OfertasInitial extends OfertasState {}

class OfertasLoading extends OfertasState {}

class OfertasLoaded extends OfertasState {
  final List<Oferta> ofertas;
  final List<Oferta> ofertasEnviadas;
  final List<Oferta> ofertasRecibidas;

  const OfertasLoaded({
    required this.ofertas,
    required this.ofertasEnviadas,
    required this.ofertasRecibidas,
  });

  @override
  List<Object> get props => [ofertas, ofertasEnviadas, ofertasRecibidas];

  OfertasLoaded copyWith({
    List<Oferta>? ofertas,
    List<Oferta>? ofertasEnviadas,
    List<Oferta>? ofertasRecibidas,
  }) {
    return OfertasLoaded(
      ofertas: ofertas ?? this.ofertas,
      ofertasEnviadas: ofertasEnviadas ?? this.ofertasEnviadas,
      ofertasRecibidas: ofertasRecibidas ?? this.ofertasRecibidas,
    );
  }

  /// Obtiene las ofertas pendientes
  List<Oferta> get ofertasPendientes =>
      ofertas.where((o) => o.estado == EstadoOferta.pendiente).toList();

  /// Obtiene las ofertas aceptadas
  List<Oferta> get ofertasAceptadas =>
      ofertas.where((o) => o.estado == EstadoOferta.aceptada).toList();

  /// Obtiene las ofertas rechazadas
  List<Oferta> get ofertasRechazadas =>
      ofertas.where((o) => o.estado == EstadoOferta.rechazada).toList();

  /// Obtiene las ofertas para un producto específico
  List<Oferta> ofertasParaProducto(String productoId) =>
      ofertas.where((o) => o.productoId == productoId).toList();
}

class OfertasError extends OfertasState {
  final String message;

  const OfertasError(this.message);

  @override
  List<Object> get props => [message];
}

class OfertaCreated extends OfertasState {
  final Oferta oferta;

  const OfertaCreated(this.oferta);

  @override
  List<Object> get props => [oferta];
}

class OfertaUpdated extends OfertasState {
  final Oferta oferta;

  const OfertaUpdated(this.oferta);

  @override
  List<Object> get props => [oferta];
}

class OfertaCancelled extends OfertasState {
  final String ofertaId;

  const OfertaCancelled(this.ofertaId);

  @override
  List<Object> get props => [ofertaId];
}
