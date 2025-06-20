import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'ubicacion.dart';
import 'contacto.dart';
import 'comentario.dart';

class Tienda extends Equatable {
  final String id;
  final String nombre;
  final String nombrePropietario;
  final Ubicacion ubicacion;
  final String rubroPrincipal;
  final String categoriaId;
  final String subcategoriaId;
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
    required this.rubroPrincipal,
    required this.categoriaId,
    required this.subcategoriaId,
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
      rubroPrincipal: json['rubro_principal'],
      categoriaId: json['categoria_id'],
      subcategoriaId: json['subcategoria_id'],
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
      'rubro_principal': rubroPrincipal,
      'categoria_id': categoriaId,
      'subcategoria_id': subcategoriaId,
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
    rubroPrincipal,
    categoriaId,
    subcategoriaId,
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

  // Método para obtener icono característico según el rubro principal
  IconData get iconoPorRubro {
    final rubro = rubroPrincipal.toLowerCase().trim();

    // Comida y bebidas
    if (rubro.contains('comida') ||
        rubro.contains('restaurant') ||
        rubro.contains('food') ||
        rubro.contains('bebida') ||
        rubro.contains('cocina') ||
        rubro.contains('almuerzo') ||
        rubro.contains('desayuno') ||
        rubro.contains('cena')) {
      return Icons.restaurant;
    }

    // Frutas y verduras
    if (rubro.contains('fruta') ||
        rubro.contains('verdura') ||
        rubro.contains('vegetal') ||
        rubro.contains('produce') ||
        rubro.contains('fresh') ||
        rubro.contains('orgánico')) {
      return Icons.eco;
    }

    // Ropa y textiles
    if (rubro.contains('ropa') ||
        rubro.contains('vestimenta') ||
        rubro.contains('textil') ||
        rubro.contains('clothing') ||
        rubro.contains('fashion') ||
        rubro.contains('prenda') ||
        rubro.contains('vestuario')) {
      return Icons.checkroom;
    }

    // Calzado
    if (rubro.contains('zapato') ||
        rubro.contains('calzado') ||
        rubro.contains('shoe') ||
        rubro.contains('sandalia') ||
        rubro.contains('bota')) {
      return Icons.shopping_bag;
    }

    // Automóviles y transporte
    if (rubro.contains('auto') ||
        rubro.contains('carro') ||
        rubro.contains('vehículo') ||
        rubro.contains('car') ||
        rubro.contains('motor') ||
        rubro.contains('transport') ||
        rubro.contains('mecánica')) {
      return Icons.directions_car;
    }

    // Electrónicos y tecnología
    if (rubro.contains('electrónico') ||
        rubro.contains('tecnología') ||
        rubro.contains('tech') ||
        rubro.contains('computadora') ||
        rubro.contains('celular') ||
        rubro.contains('phone') ||
        rubro.contains('electronic')) {
      return Icons.devices;
    }

    // Libros y papelería
    if (rubro.contains('libro') ||
        rubro.contains('papelería') ||
        rubro.contains('book') ||
        rubro.contains('educación') ||
        rubro.contains('escolar') ||
        rubro.contains('stationery')) {
      return Icons.menu_book;
    }

    // Farmacia y salud
    if (rubro.contains('farmacia') ||
        rubro.contains('medicina') ||
        rubro.contains('salud') ||
        rubro.contains('pharmacy') ||
        rubro.contains('medical') ||
        rubro.contains('health')) {
      return Icons.local_pharmacy;
    }

    // Herramientas y ferretería
    if (rubro.contains('herramienta') ||
        rubro.contains('ferretería') ||
        rubro.contains('tool') ||
        rubro.contains('construcción') ||
        rubro.contains('hardware')) {
      return Icons.build;
    }

    // Joyas y accesorios
    if (rubro.contains('joya') ||
        rubro.contains('accesorio') ||
        rubro.contains('jewelry') ||
        rubro.contains('reloj') ||
        rubro.contains('watch')) {
      return Icons.diamond;
    }

    // Flores y plantas
    if (rubro.contains('flor') ||
        rubro.contains('planta') ||
        rubro.contains('garden') ||
        rubro.contains('jardinería') ||
        rubro.contains('flower')) {
      return Icons.local_florist;
    }

    // Mascotas
    if (rubro.contains('mascota') ||
        rubro.contains('pet') ||
        rubro.contains('animal') ||
        rubro.contains('veterinaria')) {
      return Icons.pets;
    }

    // Servicios de belleza
    if (rubro.contains('belleza') ||
        rubro.contains('peluquería') ||
        rubro.contains('beauty') ||
        rubro.contains('cosmético') ||
        rubro.contains('salon')) {
      return Icons.face_retouching_natural;
    }

    // Deportes y fitness
    if (rubro.contains('deporte') ||
        rubro.contains('sport') ||
        rubro.contains('fitness') ||
        rubro.contains('gym') ||
        rubro.contains('ejercicio')) {
      return Icons.sports_soccer;
    }

    // Hogar y decoración
    if (rubro.contains('hogar') ||
        rubro.contains('decoración') ||
        rubro.contains('home') ||
        rubro.contains('mueble') ||
        rubro.contains('furniture')) {
      return Icons.home;
    }

    // Juguetes
    if (rubro.contains('juguete') ||
        rubro.contains('toy') ||
        rubro.contains('niño') ||
        rubro.contains('infantil')) {
      return Icons.toys;
    }

    // Música e instrumentos
    if (rubro.contains('música') ||
        rubro.contains('instrumento') ||
        rubro.contains('music') ||
        rubro.contains('audio')) {
      return Icons.music_note;
    }

    // Servicios financieros
    if (rubro.contains('banco') ||
        rubro.contains('financiero') ||
        rubro.contains('money') ||
        rubro.contains('dinero') ||
        rubro.contains('cambio')) {
      return Icons.account_balance;
    }

    // Artesanías
    if (rubro.contains('artesanía') ||
        rubro.contains('artesano') ||
        rubro.contains('craft') ||
        rubro.contains('handmade') ||
        rubro.contains('tradicional')) {
      return Icons.palette;
    }

    // Por defecto: tienda general
    return Icons.store;
  }

  // Método para obtener color característico según el rubro principal
  Color get colorPorRubro {
    final rubro = rubroPrincipal.toLowerCase().trim();

    // Comida y bebidas - Naranja/Rojo
    if (rubro.contains('comida') ||
        rubro.contains('restaurant') ||
        rubro.contains('bebida')) {
      return Colors.orange;
    }

    // Frutas y verduras - Verde
    if (rubro.contains('fruta') ||
        rubro.contains('verdura') ||
        rubro.contains('vegetal')) {
      return Colors.green;
    }

    // Ropa y textiles - Púrpura
    if (rubro.contains('ropa') ||
        rubro.contains('vestimenta') ||
        rubro.contains('textil')) {
      return Colors.purple;
    }

    // Calzado - Marrón
    if (rubro.contains('zapato') || rubro.contains('calzado')) {
      return Colors.brown;
    }

    // Automóviles - Azul oscuro
    if (rubro.contains('auto') ||
        rubro.contains('carro') ||
        rubro.contains('vehículo')) {
      return Colors.indigo;
    }

    // Electrónicos - Azul
    if (rubro.contains('electrónico') ||
        rubro.contains('tecnología') ||
        rubro.contains('tech')) {
      return Colors.blue;
    }

    // Farmacia y salud - Verde claro
    if (rubro.contains('farmacia') ||
        rubro.contains('medicina') ||
        rubro.contains('salud')) {
      return Colors.lightGreen;
    }

    // Herramientas - Gris
    if (rubro.contains('herramienta') || rubro.contains('ferretería')) {
      return Colors.blueGrey;
    }

    // Joyas - Dorado/Amarillo
    if (rubro.contains('joya') || rubro.contains('accesorio')) {
      return Colors.amber;
    }

    // Flores - Rosa
    if (rubro.contains('flor') || rubro.contains('planta')) {
      return Colors.pink;
    }

    // Belleza - Rosa fuerte
    if (rubro.contains('belleza') || rubro.contains('cosmético')) {
      return Colors.pinkAccent;
    }

    // Deportes - Verde oscuro
    if (rubro.contains('deporte') ||
        rubro.contains('sport') ||
        rubro.contains('fitness')) {
      return Colors.teal;
    }

    // Por defecto - Azul gris
    return Colors.blueGrey;
  }

  // Método para crear una copia con nuevos comentarios
  Tienda copyWith({
    String? id,
    String? nombre,
    String? nombrePropietario,
    Ubicacion? ubicacion,
    String? rubroPrincipal,
    String? categoriaId,
    String? subcategoriaId,
    List<String>? productos,
    Contacto? contacto,
    String? direccion,
    List<String>? diasAtencion,
    String? horarioAtencion,
    String? horario,
    double? calificacion,
    List<Comentario>? comentarios,
  }) {
    return Tienda(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      nombrePropietario: nombrePropietario ?? this.nombrePropietario,
      ubicacion: ubicacion ?? this.ubicacion,
      rubroPrincipal: rubroPrincipal ?? this.rubroPrincipal,
      categoriaId: categoriaId ?? this.categoriaId,
      subcategoriaId: subcategoriaId ?? this.subcategoriaId,
      productos: productos ?? this.productos,
      contacto: contacto ?? this.contacto,
      direccion: direccion ?? this.direccion,
      diasAtencion: diasAtencion ?? this.diasAtencion,
      horarioAtencion: horarioAtencion ?? this.horarioAtencion,
      horario: horario ?? this.horario,
      calificacion: calificacion ?? this.calificacion,
      comentarios: comentarios ?? this.comentarios,
    );
  }
}
