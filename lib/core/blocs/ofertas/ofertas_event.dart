import 'package:equatable/equatable.dart';

abstract class OfertasEvent extends Equatable {
  const OfertasEvent();

  @override
  List<Object> get props => [];
}

class LoadOfertas extends OfertasEvent {
  final String? productoId;
  final String? usuarioId;

  const LoadOfertas({this.productoId, this.usuarioId});

  @override
  List<Object> get props => [
    if (productoId != null) productoId!,
    if (usuarioId != null) usuarioId!,
  ];
}

class CreateOferta extends OfertasEvent {
  final String productoId;
  final double montoOferta;
  final String mensaje;
  final String nombreUsuario;
  final String? avatarUsuario;

  const CreateOferta({
    required this.productoId,
    required this.montoOferta,
    this.mensaje = '',
    required this.nombreUsuario,
    this.avatarUsuario,
  });

  @override
  List<Object> get props => [
    productoId,
    montoOferta,
    mensaje,
    nombreUsuario,
    if (avatarUsuario != null) avatarUsuario!,
  ];
}

class UpdateOferta extends OfertasEvent {
  final String ofertaId;
  final double? nuevoMonto;
  final String? nuevoMensaje;

  const UpdateOferta({
    required this.ofertaId,
    this.nuevoMonto,
    this.nuevoMensaje,
  });

  @override
  List<Object> get props => [
    ofertaId,
    if (nuevoMonto != null) nuevoMonto!,
    if (nuevoMensaje != null) nuevoMensaje!,
  ];
}

class CancelOferta extends OfertasEvent {
  final String ofertaId;

  const CancelOferta(this.ofertaId);

  @override
  List<Object> get props => [ofertaId];
}

class AcceptOferta extends OfertasEvent {
  final String ofertaId;
  final String respuestaVendedor;

  const AcceptOferta({required this.ofertaId, this.respuestaVendedor = ''});

  @override
  List<Object> get props => [ofertaId, respuestaVendedor];
}

class RejectOferta extends OfertasEvent {
  final String ofertaId;
  final String respuestaVendedor;

  const RejectOferta({required this.ofertaId, this.respuestaVendedor = ''});

  @override
  List<Object> get props => [ofertaId, respuestaVendedor];
}
