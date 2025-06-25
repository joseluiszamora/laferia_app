import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
import '../models/tienda.dart';
import '../models/ubicacion.dart';
import '../models/contacto.dart';
import '../models/comentario.dart';

class SupabaseTiendaService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tiendaTableName = 'Tienda';
  static const String _comentarioTableName = 'Comentario';

  /// Obtener todas las tiendas
  static Future<List<Tienda>> getAllTiendas() async {
    try {
      final response = await _supabase
          .from(_tiendaTableName)
          .select('*')
          .order('nombre');

      final List<dynamic> data = response as List<dynamic>;

      // Cargar comentarios para cada tienda
      List<Tienda> tiendas = [];
      for (final json in data) {
        final tienda = await _fromSupabaseJsonWithComentarios(json);
        tiendas.add(tienda);
      }

      return tiendas;
    } catch (e) {
      throw Exception('Error al obtener tiendas: $e');
    }
  }

  /// Obtener tienda por ID
  static Future<Tienda?> getTiendaById(String id) async {
    try {
      final response =
          await _supabase
              .from(_tiendaTableName)
              .select('*')
              .eq('tienda_id', id)
              .single();

      return await _fromSupabaseJsonWithComentarios(response);
    } catch (e) {
      if (e.toString().contains('No rows')) {
        return null;
      }
      throw Exception('Error al obtener tienda: $e');
    }
  }

  /// Obtener tiendas por categoría
  static Future<List<Tienda>> getTiendasByCategoria(String categoriaId) async {
    try {
      final response = await _supabase
          .from(_tiendaTableName)
          .select('*')
          .eq('categoria_id', categoriaId)
          .order('nombre');

      final List<dynamic> data = response as List<dynamic>;

      List<Tienda> tiendas = [];
      for (final json in data) {
        final tienda = await _fromSupabaseJsonWithComentarios(json);
        tiendas.add(tienda);
      }

      return tiendas;
    } catch (e) {
      throw Exception('Error al obtener tiendas por categoría: $e');
    }
  }

  /// Buscar tiendas por término
  static Future<List<Tienda>> buscarTiendas(String termino) async {
    try {
      final response = await _supabase
          .from(_tiendaTableName)
          .select('*')
          .or(
            'nombre.ilike.%$termino%,nombre_propietario.ilike.%$termino%,direccion.ilike.%$termino%',
          )
          .order('nombre');

      final List<dynamic> data = response as List<dynamic>;

      List<Tienda> tiendas = [];
      for (final json in data) {
        final tienda = await _fromSupabaseJsonWithComentarios(json);
        tiendas.add(tienda);
      }

      return tiendas;
    } catch (e) {
      throw Exception('Error al buscar tiendas: $e');
    }
  }

  /// Crear una nueva tienda
  static Future<Tienda> crearTienda(Tienda tienda) async {
    try {
      final response =
          await _supabase
              .from(_tiendaTableName)
              .insert(_toSupabaseJson(tienda))
              .select('*')
              .single();

      return await _fromSupabaseJsonWithComentarios(response);
    } catch (e) {
      throw Exception('Error al crear tienda: $e');
    }
  }

  /// Actualizar una tienda existente
  static Future<Tienda> actualizarTienda(Tienda tienda) async {
    try {
      final response =
          await _supabase
              .from(_tiendaTableName)
              .update(_toSupabaseJsonForUpdate(tienda))
              .eq('tienda_id', tienda.id)
              .select('*')
              .single();

      return await _fromSupabaseJsonWithComentarios(response);
    } catch (e) {
      throw Exception('Error al actualizar tienda: $e');
    }
  }

  /// Eliminar una tienda
  static Future<void> eliminarTienda(String id) async {
    try {
      // Primero eliminar todos los comentarios asociados
      await _supabase.from(_comentarioTableName).delete().eq('tienda_id', id);

      // Luego eliminar la tienda
      await _supabase.from(_tiendaTableName).delete().eq('tienda_id', id);
    } catch (e) {
      throw Exception('Error al eliminar tienda: $e');
    }
  }

  /// Obtener tiendas por ubicación (cercanas)
  static Future<List<Tienda>> getTiendasCercanas({
    required double lat,
    required double lng,
    double radioKm = 5.0,
  }) async {
    try {
      // Nota: Este es un ejemplo básico. Para una implementación más precisa,
      // se podría usar PostGIS en Supabase para cálculos geoespaciales
      final response = await _supabase
          .from(_tiendaTableName)
          .select('*')
          .order('nombre');

      final List<dynamic> data = response as List<dynamic>;

      List<Tienda> todasLasTiendas = [];
      for (final json in data) {
        final tienda = await _fromSupabaseJsonWithComentarios(json);
        todasLasTiendas.add(tienda);
      }

      // Filtrar por distancia (implementación básica)
      return todasLasTiendas.where((tienda) {
        final distancia = _calcularDistancia(
          lat,
          lng,
          tienda.ubicacion.lat,
          tienda.ubicacion.lng,
        );
        return distancia <= radioKm;
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener tiendas cercanas: $e');
    }
  }

  /// GESTIÓN DE COMENTARIOS ///

  /// Obtener comentarios de una tienda
  static Future<List<Comentario>> getComentariosByTienda(
    String tiendaId,
  ) async {
    try {
      final response = await _supabase
          .from(_comentarioTableName)
          .select('*')
          .eq('tienda_id', tiendaId)
          .order('fecha_creacion', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _comentarioFromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener comentarios: $e');
    }
  }

  /// Crear un nuevo comentario
  static Future<Comentario> crearComentario(Comentario comentario) async {
    try {
      final response =
          await _supabase
              .from(_comentarioTableName)
              .insert(_comentarioToSupabaseJson(comentario))
              .select('*')
              .single();

      return _comentarioFromSupabaseJson(response);
    } catch (e) {
      throw Exception('Error al crear comentario: $e');
    }
  }

  /// Eliminar un comentario
  static Future<void> eliminarComentario(String comentarioId) async {
    try {
      await _supabase
          .from(_comentarioTableName)
          .delete()
          .eq('comentario_id', comentarioId);
    } catch (e) {
      throw Exception('Error al eliminar comentario: $e');
    }
  }

  /// MÉTODOS PRIVADOS DE CONVERSIÓN ///

  /// Convertir de JSON de Supabase a modelo Tienda (incluyendo comentarios)
  static Future<Tienda> _fromSupabaseJsonWithComentarios(
    Map<String, dynamic> json,
  ) async {
    // Obtener comentarios de la tienda
    final comentarios = await getComentariosByTienda(json['tienda_id']);

    return Tienda(
      id: json['tienda_id'] as String,
      nombre: json['nombre'] as String,
      nombrePropietario: json['nombre_propietario'] as String,
      ubicacion: Ubicacion(
        lat: (json['latitud'] as num).toDouble(),
        lng: (json['longitud'] as num).toDouble(),
      ),
      categoriaId: json['categoria_id'] as String,
      productos: List<String>.from(json['productos'] ?? []),
      contacto:
          json['contacto'] != null
              ? _contactoFromJson(json['contacto'] as Map<String, dynamic>)
              : null,
      direccion: json['direccion'] as String?,
      diasAtencion: List<String>.from(
        json['dias_atencion'] ?? ['Jueves', 'Domingo'],
      ),
      horarioAtencion: json['horario_atencion'] as String? ?? '08:00 - 18:00',
      horario: json['horario'] as String?, // Mantener por compatibilidad
      calificacion: json['calificacion_promedio']?.toDouble(),
      comentarios: comentarios,
    );
  }

  /// Convertir de modelo Tienda a JSON para Supabase (inserción)
  static Map<String, dynamic> _toSupabaseJson(Tienda tienda) {
    return {
      'nombre': tienda.nombre,
      'nombre_propietario': tienda.nombrePropietario,
      'latitud': tienda.ubicacion.lat,
      'longitud': tienda.ubicacion.lng,
      'categoria_id': tienda.categoriaId,
      'productos': tienda.productos,
      'contacto': tienda.contacto?.toJson(),
      'direccion': tienda.direccion,
      'dias_atencion': tienda.diasAtencion,
      'horario_atencion': tienda.horarioAtencion,
      'horario': tienda.horario,
      'calificacion_promedio': tienda.calificacion,
    };
  }

  /// Convertir de modelo Tienda a JSON para Supabase (actualización)
  static Map<String, dynamic> _toSupabaseJsonForUpdate(Tienda tienda) {
    return {
      'nombre': tienda.nombre,
      'nombre_propietario': tienda.nombrePropietario,
      'latitud': tienda.ubicacion.lat,
      'longitud': tienda.ubicacion.lng,
      'categoria_id': tienda.categoriaId,
      'productos': tienda.productos,
      'contacto': tienda.contacto?.toJson(),
      'direccion': tienda.direccion,
      'dias_atencion': tienda.diasAtencion,
      'horario_atencion': tienda.horarioAtencion,
      'horario': tienda.horario,
      'calificacion_promedio': tienda.calificacion,
    };
  }

  /// Convertir JSON a modelo Contacto
  static Contacto _contactoFromJson(Map<String, dynamic> json) {
    return Contacto(
      telefono: json['telefono'] as String?,
      whatsapp: json['whatsapp'] as String?,
      redesSociales:
          json['redes_sociales'] != null
              ? RedesSociales(
                facebook: json['redes_sociales']['facebook'] as String?,
                instagram: json['redes_sociales']['instagram'] as String?,
              )
              : null,
    );
  }

  /// Convertir de JSON de Supabase a modelo Comentario
  static Comentario _comentarioFromSupabaseJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['comentario_id'] as String,
      tiendaId: json['tienda_id'] as String,
      nombreUsuario: json['nombre_usuario'] as String,
      avatarUrl: json['avatar_url'] as String?,
      comentario: json['comentario'] as String,
      calificacion: (json['calificacion'] as num).toDouble(),
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      verificado: json['verificado'] as bool? ?? false,
      imagenes: List<String>.from(json['imagenes'] ?? []),
    );
  }

  /// Convertir de modelo Comentario a JSON para Supabase
  static Map<String, dynamic> _comentarioToSupabaseJson(Comentario comentario) {
    return {
      'tienda_id': comentario.tiendaId,
      'nombre_usuario': comentario.nombreUsuario,
      'avatar_url': comentario.avatarUrl,
      'comentario': comentario.comentario,
      'calificacion': comentario.calificacion,
      'fecha_creacion': comentario.fechaCreacion.toIso8601String(),
      'verificado': comentario.verificado,
      'imagenes': comentario.imagenes,
    };
  }

  /// Calcular distancia entre dos puntos (fórmula de Haversine simplificada)
  static double _calcularDistancia(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const double radioTierra = 6371; // Radio de la Tierra en km

    final double dLat = _gradosARadianes(lat2 - lat1);
    final double dLng = _gradosARadianes(lng2 - lng1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_gradosARadianes(lat1)) *
            cos(_gradosARadianes(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final double c = 2 * asin(sqrt(a));

    return radioTierra * c;
  }

  /// Convertir grados a radianes
  static double _gradosARadianes(double grados) {
    return grados * (pi / 180);
  }
}
