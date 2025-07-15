import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:laferia/core/services/categoria_service.dart';
import 'ubicacion.dart';
import 'contacto.dart';
import 'comentario.dart';

enum StoreStatus {
  active('active'),
  inactive('inactive'),
  pending('pending'),
  suspend('suspend');

  const StoreStatus(this.value);
  final String value;

  static StoreStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return StoreStatus.active;
      case 'inactive':
        return StoreStatus.inactive;
      case 'pending':
        return StoreStatus.pending;
      case 'suspend':
        return StoreStatus.suspend;
      default:
        return StoreStatus.active;
    }
  }
}

class Tienda extends Equatable {
  final int id;
  final String name;
  final String ownerName;
  final Ubicacion ubicacion;
  final int categoryId;
  final String? categoryName;
  final List<String> productos;
  final Contacto? contacto;
  final String? address;
  final List<String> schedules;
  final String operatingHours;
  final StoreStatus status;
  final double? averageRating;
  final int totalComments;
  final List<Comentario> comentarios;
  final String? logoUrl;
  final String? bannerUrl;
  final String? icon;
  final String? color;

  const Tienda({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.ubicacion,
    required this.categoryId,
    this.categoryName,
    this.productos = const [],
    this.contacto,
    this.address,
    this.schedules = const ['Jueves', 'Domingo'],
    this.operatingHours = '08:00 - 18:00',
    this.status = StoreStatus.active,
    this.averageRating,
    this.totalComments = 0,
    this.comentarios = const [],
    this.logoUrl,
    this.bannerUrl,
    this.icon,
    this.color,
  });

  // Getters para compatibilidad con código existente
  String get tiendaId => id.toString();
  String get nombre => name;
  String get nombrePropietario => ownerName;
  String get categoriaId => categoryId.toString();
  String? get direccion => address;
  List<String> get diasAtencion => schedules;
  String get horarioAtencion => operatingHours;
  String? get horario => operatingHours; // Compatibilidad
  double? get calificacion => averageRating;

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      id:
          json['store_id'] is int
              ? json['store_id']
              : int.parse(json['store_id'].toString()),
      name: json['name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ubicacion: Ubicacion.fromJson(json['ubicacion'] ?? json),
      categoryId:
          json['category_id'] is int
              ? json['category_id']
              : int.parse(json['category_id'].toString()),
      categoryName: json['Category']?['name'],
      productos: List<String>.from(json['products'] ?? json['productos'] ?? []),
      contacto:
          json['contact'] != null
              ? Contacto.fromJson(json['contact'])
              : (json['contacto'] != null
                  ? Contacto.fromJson(json['contacto'])
                  : null),
      address: json['address'] ?? json['direccion'],
      schedules: List<String>.from(
        json['schedules'] ?? json['dias_atencion'] ?? ['Jueves', 'Domingo'],
      ),
      operatingHours:
          json['operating_hours'] ??
          json['horario_atencion'] ??
          '08:00 - 18:00',
      status: StoreStatus.fromString(json['status'] ?? 'active'),
      averageRating:
          (json['average_rating'] ?? json['calificacion_promedio'])?.toDouble(),
      totalComments: json['total_comments'] ?? json['total_comentarios'] ?? 0,
      comentarios: [],
      logoUrl: json['logo_url'] ?? json['logo'],
      bannerUrl: json['banner_url'] ?? json['banner'],
      icon: json['Category']?['icon'],
      color: json['Category']?['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner_name': ownerName,
      'ubicacion': ubicacion.toJson(),
      'category_id': categoryId,
      'products': productos,
      'contact': contacto?.toJson(),
      'address': address,
      'schedules': schedules,
      'operating_hours': operatingHours,
      'status': status.value,
      'average_rating': averageRating,
      'total_comments': totalComments,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
      'icon': icon,
      'color': color,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    ownerName,
    ubicacion,
    categoryId,
    categoryName,
    productos,
    contacto,
    address,
    schedules,
    operatingHours,
    status,
    averageRating,
    totalComments,
    comentarios,
    logoUrl,
    bannerUrl,
    icon,
    color,
  ];

  Tienda copyWith({
    int? id,
    String? name,
    String? ownerName,
    Ubicacion? ubicacion,
    int? categoryId,
    String? categoryName,
    List<String>? productos,
    Contacto? contacto,
    String? address,
    List<String>? schedules,
    String? operatingHours,
    StoreStatus? status,
    double? averageRating,
    int? totalComments,
    List<Comentario>? comentarios,
    String? logoUrl,
    String? bannerUrl,
    String? icon,
    String? color,
  }) {
    return Tienda(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerName: ownerName ?? this.ownerName,
      ubicacion: ubicacion ?? this.ubicacion,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      productos: productos ?? this.productos,
      contacto: contacto ?? this.contacto,
      address: address ?? this.address,
      schedules: schedules ?? this.schedules,
      operatingHours: operatingHours ?? this.operatingHours,
      status: status ?? this.status,
      averageRating: averageRating ?? this.averageRating,
      totalComments: totalComments ?? this.totalComments,
      comentarios: comentarios ?? this.comentarios,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  String toString() =>
      'Tienda(id: $id, name: $name, ownerName: $ownerName, categoryId: $categoryId, status: $status)';

  // Método auxiliar para obtener el icono
  static IconData getIconData(String? iconName) {
    if (iconName != null) {
      final iconMap = CategoriaService.availableIcons.firstWhere(
        (icon) => icon['name'] == iconName,
        orElse: () => CategoriaService.availableIcons.first,
      );
      return iconMap['icon'] as IconData;
    } else {
      return Icons.store;
    }
  }

  // Método auxiliar para obtener el color desde hex
  static Color getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.blue;
    }

    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
