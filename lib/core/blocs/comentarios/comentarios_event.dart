import 'package:equatable/equatable.dart';
import '../../models/comentario.dart';

abstract class ComentariosEvent extends Equatable {
  const ComentariosEvent();

  @override
  List<Object?> get props => [];
}

class CargarComentarios extends ComentariosEvent {
  final String tiendaId;

  const CargarComentarios(this.tiendaId);

  @override
  List<Object?> get props => [tiendaId];
}

class AgregarComentario extends ComentariosEvent {
  final Comentario comentario;

  const AgregarComentario(this.comentario);

  @override
  List<Object?> get props => [comentario];
}

class EliminarComentario extends ComentariosEvent {
  final String comentarioId;
  final String tiendaId;

  const EliminarComentario({
    required this.comentarioId,
    required this.tiendaId,
  });

  @override
  List<Object?> get props => [comentarioId, tiendaId];
}

class ActualizarComentario extends ComentariosEvent {
  final Comentario comentario;

  const ActualizarComentario(this.comentario);

  @override
  List<Object?> get props => [comentario];
}
