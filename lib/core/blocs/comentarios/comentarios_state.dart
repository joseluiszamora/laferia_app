import 'package:equatable/equatable.dart';
import '../../models/comentario.dart';

abstract class ComentariosState extends Equatable {
  const ComentariosState();

  @override
  List<Object?> get props => [];
}

class ComentariosInitial extends ComentariosState {}

class ComentariosLoading extends ComentariosState {}

class ComentariosLoaded extends ComentariosState {
  final List<Comentario> comentarios;
  final double calificacionPromedio;
  final int totalComentarios;

  const ComentariosLoaded({
    required this.comentarios,
    required this.calificacionPromedio,
    required this.totalComentarios,
  });

  @override
  List<Object?> get props => [
    comentarios,
    calificacionPromedio,
    totalComentarios,
  ];
}

class ComentariosError extends ComentariosState {
  final String mensaje;

  const ComentariosError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}

class ComentarioAgregado extends ComentariosState {
  final Comentario comentario;

  const ComentarioAgregado(this.comentario);

  @override
  List<Object?> get props => [comentario];
}

class ComentarioEliminado extends ComentariosState {
  final int comentarioId;

  const ComentarioEliminado(this.comentarioId);

  @override
  List<Object?> get props => [comentarioId];
}
