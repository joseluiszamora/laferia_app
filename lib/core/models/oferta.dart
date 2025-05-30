import 'package:equatable/equatable.dart';

class Oferta extends Equatable {
  final String id;
  final String productoId;
  final String nombreUsuario;
  final String? avatarUsuario;
  final double montoOferta;
  final String mensaje;
  final DateTime fechaCreacion;
  final EstadoOferta estado;
  final DateTime? fechaRespuesta;
  final String? respuestaVendedor;

  const Oferta({
    required this.id,
    required this.productoId,
    required this.nombreUsuario,
    this.avatarUsuario,
    required this.montoOferta,
    this.mensaje = '',
    required this.fechaCreacion,
    this.estado = EstadoOferta.pendiente,
    this.fechaRespuesta,
    this.respuestaVendedor,
  });

  factory Oferta.fromJson(Map<String, dynamic> json) {
    return Oferta(
      id: json['id'],
      productoId: json['producto_id'],
      nombreUsuario: json['nombre_usuario'],
      avatarUsuario: json['avatar_usuario'],
      montoOferta: json['monto_oferta']?.toDouble() ?? 0.0,
      mensaje: json['mensaje'] ?? '',
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      estado: EstadoOferta.values.firstWhere(
        (e) => e.name == json['estado'],
        orElse: () => EstadoOferta.pendiente,
      ),
      fechaRespuesta:
          json['fecha_respuesta'] != null
              ? DateTime.parse(json['fecha_respuesta'])
              : null,
      respuestaVendedor: json['respuesta_vendedor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto_id': productoId,
      'nombre_usuario': nombreUsuario,
      'avatar_usuario': avatarUsuario,
      'monto_oferta': montoOferta,
      'mensaje': mensaje,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'estado': estado.name,
      'fecha_respuesta': fechaRespuesta?.toIso8601String(),
      'respuesta_vendedor': respuestaVendedor,
    };
  }

  /// Crea una copia de la oferta con algunos campos modificados
  Oferta copyWith({
    String? id,
    String? productoId,
    String? nombreUsuario,
    String? avatarUsuario,
    double? montoOferta,
    String? mensaje,
    DateTime? fechaCreacion,
    EstadoOferta? estado,
    DateTime? fechaRespuesta,
    String? respuestaVendedor,
  }) {
    return Oferta(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      avatarUsuario: avatarUsuario ?? this.avatarUsuario,
      montoOferta: montoOferta ?? this.montoOferta,
      mensaje: mensaje ?? this.mensaje,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      estado: estado ?? this.estado,
      fechaRespuesta: fechaRespuesta ?? this.fechaRespuesta,
      respuestaVendedor: respuestaVendedor ?? this.respuestaVendedor,
    );
  }

  /// Obtiene el tiempo transcurrido desde la creación de la oferta
  String get tiempoTranscurrido {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fechaCreacion);

    if (diferencia.inDays > 0) {
      return 'hace ${diferencia.inDays} día${diferencia.inDays > 1 ? 's' : ''}';
    } else if (diferencia.inHours > 0) {
      return 'hace ${diferencia.inHours} hora${diferencia.inHours > 1 ? 's' : ''}';
    } else if (diferencia.inMinutes > 0) {
      return 'hace ${diferencia.inMinutes} minuto${diferencia.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'hace un momento';
    }
  }

  /// Indica si la oferta puede ser editada
  bool get puedeEditarse => estado == EstadoOferta.pendiente;

  /// Indica si la oferta puede ser cancelada
  bool get puedeCancelarse => estado == EstadoOferta.pendiente;

  @override
  List<Object?> get props => [
    id,
    productoId,
    nombreUsuario,
    avatarUsuario,
    montoOferta,
    mensaje,
    fechaCreacion,
    estado,
    fechaRespuesta,
    respuestaVendedor,
  ];
}

enum EstadoOferta { pendiente, aceptada, rechazada, cancelada, expirada }

extension EstadoOfertaExtension on EstadoOferta {
  String get displayName {
    switch (this) {
      case EstadoOferta.pendiente:
        return 'Pendiente';
      case EstadoOferta.aceptada:
        return 'Aceptada';
      case EstadoOferta.rechazada:
        return 'Rechazada';
      case EstadoOferta.cancelada:
        return 'Cancelada';
      case EstadoOferta.expirada:
        return 'Expirada';
    }
  }

  String get description {
    switch (this) {
      case EstadoOferta.pendiente:
        return 'Esperando respuesta del vendedor';
      case EstadoOferta.aceptada:
        return 'El vendedor aceptó tu oferta';
      case EstadoOferta.rechazada:
        return 'El vendedor rechazó tu oferta';
      case EstadoOferta.cancelada:
        return 'Oferta cancelada por el usuario';
      case EstadoOferta.expirada:
        return 'La oferta ha expirado';
    }
  }
}
