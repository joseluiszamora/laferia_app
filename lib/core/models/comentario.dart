import 'package:equatable/equatable.dart';

class Comentario extends Equatable {
  final String id;
  final String tiendaId;
  final String nombreUsuario;
  final String? avatarUrl;
  final String comentario;
  final double calificacion;
  final DateTime fechaCreacion;
  final bool verificado;
  final List<String> imagenes;

  const Comentario({
    required this.id,
    required this.tiendaId,
    required this.nombreUsuario,
    this.avatarUrl,
    required this.comentario,
    required this.calificacion,
    required this.fechaCreacion,
    this.verificado = false,
    this.imagenes = const [],
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'],
      tiendaId: json['tienda_id'],
      nombreUsuario: json['nombre_usuario'],
      avatarUrl: json['avatar_url'],
      comentario: json['comentario'],
      calificacion: json['calificacion']?.toDouble() ?? 0.0,
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      verificado: json['verificado'] ?? false,
      imagenes: List<String>.from(json['imagenes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tienda_id': tiendaId,
      'nombre_usuario': nombreUsuario,
      'avatar_url': avatarUrl,
      'comentario': comentario,
      'calificacion': calificacion,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'verificado': verificado,
      'imagenes': imagenes,
    };
  }

  // Método para obtener el tiempo transcurrido de forma legible
  String get tiempoTranscurrido {
    final now = DateTime.now();
    final difference = now.difference(fechaCreacion);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'hace ${months} ${months == 1 ? 'mes' : 'meses'}';
    } else if (difference.inDays > 0) {
      return 'hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'hace un momento';
    }
  }

  @override
  List<Object?> get props => [
    id,
    tiendaId,
    nombreUsuario,
    avatarUrl,
    comentario,
    calificacion,
    fechaCreacion,
    verificado,
    imagenes,
  ];
}
