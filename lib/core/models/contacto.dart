import 'package:equatable/equatable.dart';

class RedesSociales extends Equatable {
  final String? facebook;
  final String? instagram;

  const RedesSociales({this.facebook, this.instagram});

  factory RedesSociales.fromJson(Map<String, dynamic> json) {
    return RedesSociales(
      facebook: json['facebook'],
      instagram: json['instagram'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'facebook': facebook, 'instagram': instagram};
  }

  @override
  List<Object?> get props => [facebook, instagram];
}

class Contacto extends Equatable {
  final String? telefono;
  final String? whatsapp;
  final RedesSociales? redesSociales;

  const Contacto({this.telefono, this.whatsapp, this.redesSociales});

  factory Contacto.fromJson(Map<String, dynamic> json) {
    return Contacto(
      telefono: json['telefono'],
      whatsapp: json['whatsapp'],
      redesSociales:
          json['redes_sociales'] != null
              ? RedesSociales.fromJson(json['redes_sociales'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'telefono': telefono,
      'whatsapp': whatsapp,
      'redes_sociales': redesSociales?.toJson(),
    };
  }

  @override
  List<Object?> get props => [telefono, whatsapp, redesSociales];
}
