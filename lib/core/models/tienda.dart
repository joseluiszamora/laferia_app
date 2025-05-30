import 'package:equatable/equatable.dart';
import 'ubicacion.dart';
import 'contacto.dart';

class Tienda extends Equatable {
  final String id;
  final String nombre;
  final String nombrePropietario;
  final Ubicacion ubicacion;
  final String rubroPrincipal;
  final List<String> productos;
  final Contacto? contacto;
  final String? direccion;
  final List<String> diasAtencion;
  final String horarioAtencion;
  final String? horario; // Mantener por compatibilidad
  final double? calificacion;

  const Tienda({
    required this.id,
    required this.nombre,
    required this.nombrePropietario,
    required this.ubicacion,
    required this.rubroPrincipal,
    this.productos = const [],
    this.contacto,
    this.direccion,
    this.diasAtencion = const ['Jueves', 'Domingo'],
    this.horarioAtencion = '08:00 - 18:00',
    this.horario,
    this.calificacion,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      id: json['id'],
      nombre: json['nombre'],
      nombrePropietario: json['nombre_propietario'],
      ubicacion: Ubicacion.fromJson(json['ubicacion']),
      rubroPrincipal: json['rubro_principal'],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'nombre_propietario': nombrePropietario,
      'ubicacion': ubicacion.toJson(),
      'rubro_principal': rubroPrincipal,
      'productos': productos,
      'contacto': contacto?.toJson(),
      'direccion': direccion,
      'dias_atencion': diasAtencion,
      'horario_atencion': horarioAtencion,
      'horario': horario,
      'calificacion': calificacion,
    };
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    nombrePropietario,
    ubicacion,
    rubroPrincipal,
    productos,
    contacto,
    direccion,
    diasAtencion,
    horarioAtencion,
    horario,
    calificacion,
  ];
}
