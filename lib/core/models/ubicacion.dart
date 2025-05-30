import 'package:equatable/equatable.dart';

class Ubicacion extends Equatable {
  final double lat;
  final double lng;

  const Ubicacion({required this.lat, required this.lng});

  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      lat: json['lat']?.toDouble() ?? 0.0,
      lng: json['lng']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }

  @override
  List<Object> get props => [lat, lng];
}
