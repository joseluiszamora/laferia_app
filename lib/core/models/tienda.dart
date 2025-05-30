import 'package:equatable/equatable.dart';
import 'ubicacion.dart';
import 'contacto.dart';

class Tienda extends Equatable {
  final String id;
  final String nombrePropietario;
  final Ubicacion ubicacion;
  final String rubroPrincipal;
  final List<String> productos;
  final Contacto? contacto;
  final String? horario;
  final double? calificacion;

  const Tienda({
    required this.id,
    required this.nombrePropietario,
    required this.ubicacion,
    required this.rubroPrincipal,
    this.productos = const [],
    this.contacto,
    this.horario,
    this.calificacion,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      id: json['id'],
      nombrePropietario: json['nombre_propietario'],
      ubicacion: Ubicacion.fromJson(json['ubicacion']),
      rubroPrincipal: json['rubro_principal'],
      productos: List<String>.from(json['productos'] ?? []),
      contacto:
          json['contacto'] != null ? Contacto.fromJson(json['contacto']) : null,
      horario: json['horario'],
      calificacion: json['calificacion']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_propietario': nombrePropietario,
      'ubicacion': ubicacion.toJson(),
      'rubro_principal': rubroPrincipal,
      'productos': productos,
      'contacto': contacto?.toJson(),
      'horario': horario,
      'calificacion': calificacion,
    };
  }

  @override
  List<Object?> get props => [
    id,
    nombrePropietario,
    ubicacion,
    rubroPrincipal,
    productos,
    contacto,
    horario,
    calificacion,
  ];
}
