import 'package:equatable/equatable.dart';
import 'ubicacion.dart';
import 'contacto.dart';
import 'comentario.dart';

class Tienda extends Equatable {
  final String id;
  final String nombre;
  final String nombrePropietario;
  final Ubicacion ubicacion;
  final String categoriaId;
  final List<String> productos;
  final Contacto? contacto;
  final String? direccion;
  final List<String> diasAtencion;
  final String horarioAtencion;
  final String? horario; // Mantener por compatibilidad
  final double? calificacion;
  final List<Comentario> comentarios;

  const Tienda({
    required this.id,
    required this.nombre,
    required this.nombrePropietario,
    required this.ubicacion,
    required this.categoriaId,
    this.productos = const [],
    this.contacto,
    this.direccion,
    this.diasAtencion = const ['Jueves', 'Domingo'],
    this.horarioAtencion = '08:00 - 18:00',
    this.horario,
    this.calificacion,
    this.comentarios = const [],
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      id: json['id'],
      nombre: json['nombre'],
      nombrePropietario: json['nombre_propietario'],
      ubicacion: Ubicacion.fromJson(json['ubicacion']),
      categoriaId: json['categoria_id'],
      productos: List<String>.from(json['productos'] ?? []),
      contacto:
          json['contacto'] != null ? Contacto.fromJson(json['contacto']) : null,
      direccion: json['direccion'],
      diasAtencion: List<String>.from(
        json['dias_atencion'] ?? ['Jueves', 'Domingo'],
      ),
      horarioAtencion: json['horario_atencion'] ?? '08:00 - 18:00',
      horario: json['horario'], // Mantener por compatibilidad
      calificacion: json['calificacion']?.toDouble(),
      comentarios:
          (json['comentarios'] as List<dynamic>?)
              ?.map((comentario) => Comentario.fromJson(comentario))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'nombre_propietario': nombrePropietario,
      'ubicacion': ubicacion.toJson(),
      'categoria_id': categoriaId,
      'productos': productos,
      'contacto': contacto?.toJson(),
      'direccion': direccion,
      'dias_atencion': diasAtencion,
      'horario_atencion': horarioAtencion,
      'horario': horario,
      'calificacion': calificacion,
      'comentarios':
          comentarios.map((comentario) => comentario.toJson()).toList(),
    };
  }

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
    horario,
    calificacion,
    comentarios,
  ];

  // Método para calcular la calificación promedio basada en comentarios
  double get calificacionPromedio {
    if (comentarios.isEmpty) return 0.0;
    final suma = comentarios.fold(
      0.0,
      (sum, comentario) => sum + comentario.calificacion,
    );
    return suma / comentarios.length;
  }

  // Método para obtener el total de comentarios
  int get totalComentarios => comentarios.length;
}
