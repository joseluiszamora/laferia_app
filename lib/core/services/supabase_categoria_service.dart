import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/categoria.dart';

class SupabaseCategoriaService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'Category';

  /// Obtener todas las categorías
  static Future<List<Categoria>> getAllCategorias() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('*')
          .order('name');

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }

  /// Obtener categorías principales (sin padre)
  static Future<List<Categoria>> getMainCategorias() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('*')
          .isFilter('parent_category_id', null)
          .order('name');

      final List<dynamic> data = response as List<dynamic>;
      final categorias = data.map((json) => _fromSupabaseJson(json)).toList();

      return categorias;
    } catch (e) {
      throw Exception('Error al obtener categorías principales: $e');
    }
  }

  /// Crear una nueva categoría
  static Future<Categoria> crearCategoria(Categoria categoria) async {
    try {
      final response =
          await _supabase
              .from(_tableName)
              .insert(_toSupabaseJson(categoria))
              .select('*')
              .single();

      return _fromSupabaseJson(response);
    } catch (e) {
      throw Exception('Error al crear categoría: $e');
    }
  }

  /// Actualizar una categoría existente
  static Future<Categoria> actualizarCategoria(Categoria categoria) async {
    try {
      final response =
          await _supabase
              .from(_tableName)
              .update(_toSupabaseJsonForUpdate(categoria))
              .eq('id', categoria.id)
              .select('*')
              .single();

      return _fromSupabaseJson(response);
    } catch (e) {
      throw Exception('Error al actualizar categoría: $e');
    }
  }

  /// Eliminar una categoría
  static Future<void> eliminarCategoria(int id) async {
    try {
      // Verificar si tiene subcategorías
      final subcategorias = await _supabase
          .from(_tableName)
          .select('id')
          .eq('parent_category_id', id);

      if (subcategorias.isNotEmpty) {
        throw Exception(
          'No se puede eliminar una categoría que tiene subcategorías',
        );
      }

      await _supabase.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar categoría: $e');
    }
  }

  /// Buscar categorías por término
  static Future<List<Categoria>> buscarCategorias(String termino) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('*')
          .or('name.ilike.%$termino%,description.ilike.%$termino%')
          .order('name');

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception('Error al buscar categorías: $e');
    }
  }

  /// Obtener subcategorías de una categoría
  static Future<List<Categoria>> getSubcategorias(int parentId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('*')
          .eq('parent_category_id', parentId)
          .order('name');

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener subcategorías: $e');
    }
  }

  /// Convertir de JSON de Supabase a modelo Categoria
  static Categoria _fromSupabaseJson(Map<String, dynamic> json) {
    return Categoria(
      id:
          json['category_id'] is int
              ? json['category_id']
              : int.parse(json['category_id'].toString()),
      parentId:
          json['parent_category_id'] != null
              ? (json['parent_category_id'] is int
                  ? json['parent_category_id']
                  : int.parse(json['parent_category_id'].toString()))
              : null,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
    );
  }

  /// Convertir de modelo Categoria a JSON para Supabase (inserción)
  static Map<String, dynamic> _toSupabaseJson(Categoria categoria) {
    return {
      'name': categoria.name,
      'slug': categoria.slug,
      'description':
          categoria.description?.isNotEmpty == true
              ? categoria.description
              : null,
      'icon': categoria.icon?.isNotEmpty == true ? categoria.icon : null,
      'color': categoria.color?.isNotEmpty == true ? categoria.color : null,
      'image_url': categoria.imageUrl,
      'parent_category_id': categoria.parentId,
    };
  }

  /// Convertir de modelo Categoria a JSON para Supabase (actualización)
  static Map<String, dynamic> _toSupabaseJsonForUpdate(Categoria categoria) {
    return {
      'name': categoria.name,
      'slug': categoria.slug,
      'description':
          categoria.description?.isNotEmpty == true
              ? categoria.description
              : null,
      'icon': categoria.icon?.isNotEmpty == true ? categoria.icon : null,
      'color': categoria.color?.isNotEmpty == true ? categoria.color : null,
      'image_url': categoria.imageUrl,
      'parent_category_id': categoria.parentId,
    };
  }
}
