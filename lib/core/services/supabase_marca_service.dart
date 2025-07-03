import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/marca.dart';

class SupabaseMarcaService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'Brand';

  /// Obtener todas las marcas
  static Future<List<Marca>> getAllMarcas() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('*')
          .order('name');

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener marcas: $e');
    }
  }

  /// Obtener marca por ID
  static Future<Marca?> getMarcaById(int id) async {
    try {
      final response =
          await _supabase.from(_tableName).select('*').eq('id', id).single();

      return _fromSupabaseJson(response);
    } catch (e) {
      if (e.toString().contains('No rows')) {
        return null;
      }
      throw Exception('Error al obtener marca: $e');
    }
  }

  /// Buscar marcas por término
  static Future<List<Marca>> buscarMarcas(String termino) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('*')
          .or('name.ilike.%$termino%,description.ilike.%$termino%')
          .order('name');

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception('Error al buscar marcas: $e');
    }
  }

  /// Crear una nueva marca
  static Future<Marca> crearMarca(Marca marca) async {
    try {
      final response =
          await _supabase
              .from(_tableName)
              .insert(_toSupabaseJson(marca))
              .select('*')
              .single();

      return _fromSupabaseJson(response);
    } catch (e) {
      throw Exception('Error al crear marca: $e');
    }
  }

  /// Actualizar una marca existente
  static Future<Marca> actualizarMarca(Marca marca) async {
    try {
      final response =
          await _supabase
              .from(_tableName)
              .update(_toSupabaseJsonForUpdate(marca))
              .eq('id', marca.id)
              .select('*')
              .single();

      return _fromSupabaseJson(response);
    } catch (e) {
      throw Exception('Error al actualizar marca: $e');
    }
  }

  /// Eliminar una marca
  static Future<void> eliminarMarca(int id) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar marca: $e');
    }
  }

  /// Convertir de JSON de Supabase a modelo Marca
  static Marca _fromSupabaseJson(Map<String, dynamic> json) {
    return Marca(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      websiteUrl: json['website_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : DateTime.now(),
    );
  }

  /// Convertir de modelo Marca a JSON para Supabase (inserción)
  static Map<String, dynamic> _toSupabaseJson(Marca marca) {
    return {
      'name': marca.name,
      'slug': marca.slug,
      'description': marca.description,
      'logo_url': marca.logoUrl,
      'website_url': marca.websiteUrl,
      'is_active': marca.isActive,
    };
  }

  /// Convertir de modelo Marca a JSON para Supabase (actualización)
  static Map<String, dynamic> _toSupabaseJsonForUpdate(Marca marca) {
    return {
      'name': marca.name,
      'slug': marca.slug,
      'description': marca.description,
      'logo_url': marca.logoUrl,
      'website_url': marca.websiteUrl,
      'is_active': marca.isActive,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
