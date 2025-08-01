import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/producto.dart';
import '../models/producto_atributos.dart';
import '../models/producto_medias.dart';

class AdminProductoService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Tablas
  static const String _tablaProducto = 'Product';
  static const String _tablaProductoAtributos = 'ProductAttributes';
  static const String _tablaProductoMedias = 'ProductMedias';

  /// Obtiene productos para administración con filtros y paginación
  static Future<Map<String, dynamic>> obtenerProductosAdmin({
    int limit = 20,
    int offset = 0,
    String? searchQuery,
    int? categoryId,
    ProductStatus? status,
    String sortBy = 'created_at',
    bool ascending = false,
  }) async {
    try {
      print('DEBUG: Obteniendo productos con filtros:');
      print('  - searchQuery: $searchQuery');
      print('  - categoryId: $categoryId');
      print('  - status: ${status?.value}');
      print('  - limit: $limit, offset: $offset');

      var query = _supabase.from(_tablaProducto).select('''
            *,
            Category:category_id(name),
            Store:store_id(name),
            ProductAttributes(*),
            ProductMedias(*)
          ''');

      // Aplicar filtros
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
          'name.ilike.%$searchQuery%,description.ilike.%$searchQuery%,sku.ilike.%$searchQuery%',
        );
      }

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      if (status != null) {
        query = query.eq('status', status.value);
      }

      // Aplicar ordenamiento y paginación
      final response = await query
          .order(sortBy, ascending: ascending)
          .range(offset, offset + limit - 1);

      print(
        'DEBUG: Respuesta de productos: ${(response as List).length} productos encontrados',
      );

      // Para obtener el conteo total, necesitamos hacer una consulta separada
      var countQueryBuilder = _supabase
          .from(_tablaProducto)
          .select('product_id');

      if (searchQuery != null && searchQuery.isNotEmpty) {
        countQueryBuilder = countQueryBuilder.or(
          'name.ilike.%$searchQuery%,description.ilike.%$searchQuery%,sku.ilike.%$searchQuery%',
        );
      }
      if (categoryId != null) {
        countQueryBuilder = countQueryBuilder.eq('category_id', categoryId);
      }
      if (status != null) {
        countQueryBuilder = countQueryBuilder.eq('status', status.value);
      }

      final countResponse = await countQueryBuilder;
      final totalCount = (countResponse as List).length;

      print('DEBUG: Total count: $totalCount');

      final productos =
          (response as List).map((json) => _mapJsonToProducto(json)).toList();

      return {
        'productos': productos,
        'totalCount': totalCount,
        'hasMore': offset + limit < totalCount,
      };
    } catch (e) {
      print('DEBUG: Error al obtener productos: $e');
      throw Exception('Error al obtener productos: $e');
    }
  }

  /// Crear un nuevo producto
  static Future<Producto> crearProducto(
    Map<String, dynamic> productoData,
  ) async {
    try {
      // Separar datos principales de atributos y medias
      final mainData = Map<String, dynamic>.from(productoData);
      final atributos =
          mainData.remove('atributos') as List<Map<String, dynamic>>? ?? [];
      final medias =
          mainData.remove('medias') as List<Map<String, dynamic>>? ?? [];

      // Remover campos que no pertenecen a la tabla Product
      mainData.remove('medias_to_delete');

      // Crear producto principal
      final response =
          await _supabase
              .from(_tablaProducto)
              .insert(mainData)
              .select()
              .single();

      final productoId = response['product_id'] as int;

      // Agregar atributos si existen
      if (atributos.isNotEmpty) {
        final atributosData =
            atributos
                .map((attr) => {...attr, 'product_id': productoId})
                .toList();

        await _supabase.from(_tablaProductoAtributos).insert(atributosData);
      }

      // Agregar medias si existen
      if (medias.isNotEmpty) {
        final mediasData =
            medias
                .map((media) => {...media, 'product_id': productoId})
                .toList();

        await _supabase.from(_tablaProductoMedias).insert(mediasData);
      }

      // Obtener el producto completo
      return await obtenerProductoPorId(productoId);
    } catch (e) {
      throw Exception('Error al crear productoxx: $e');
    }
  }

  /// Actualizar un producto existente
  static Future<Producto> actualizarProducto(
    int productoId,
    Map<String, dynamic> productoData,
  ) async {
    try {
      print(
        'DEBUG: Actualizando producto $productoId con datos: ${productoData.keys}',
      );

      // Separar datos principales de atributos y medias
      final mainData = Map<String, dynamic>.from(productoData);
      final atributos =
          mainData.remove('atributos') as List<Map<String, dynamic>>?;
      final medias = mainData.remove('medias') as List<Map<String, dynamic>>?;
      final mediasToDelete =
          mainData.remove('medias_to_delete') as List<int>? ?? [];

      print('DEBUG: Medias a eliminar: $mediasToDelete');
      print('DEBUG: Nuevas medias: ${medias?.length ?? 0}');

      // Primero eliminar medias marcadas para eliminación
      if (mediasToDelete.isNotEmpty) {
        print('DEBUG: Eliminando medias: $mediasToDelete');
        await _supabase
            .from(_tablaProductoMedias)
            .delete()
            .inFilter('id', mediasToDelete);
      }

      // Actualizar datos principales
      print('DEBUG: Actualizando datos principales: ${mainData.keys}');
      await _supabase
          .from(_tablaProducto)
          .update(mainData)
          .eq('product_id', productoId);

      // Actualizar atributos si se proporcionan
      if (atributos != null) {
        // Eliminar atributos existentes
        await _supabase
            .from(_tablaProductoAtributos)
            .delete()
            .eq('product_id', productoId);

        // Insertar nuevos atributos
        if (atributos.isNotEmpty) {
          final atributosData =
              atributos
                  .map((attr) => {...attr, 'product_id': productoId})
                  .toList();

          await _supabase.from(_tablaProductoAtributos).insert(atributosData);
        }
      }

      // Actualizar medias si se proporcionan
      if (medias != null && medias.isNotEmpty) {
        print('DEBUG: Insertando ${medias.length} nuevas medias');
        // Solo insertar nuevas medias (no eliminar todas las existentes)
        final mediasData =
            medias
                .map((media) => {...media, 'product_id': productoId})
                .toList();

        await _supabase.from(_tablaProductoMedias).insert(mediasData);
      }

      // Obtener el producto actualizado
      return await obtenerProductoPorId(productoId);
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }

  /// Eliminar un producto
  static Future<void> eliminarProducto(int productoId) async {
    try {
      // Eliminar atributos relacionados
      await _supabase
          .from(_tablaProductoAtributos)
          .delete()
          .eq('product_id', productoId);

      // Eliminar medias relacionadas
      await _supabase
          .from(_tablaProductoMedias)
          .delete()
          .eq('product_id', productoId);

      // Eliminar producto principal
      await _supabase.from(_tablaProducto).delete().eq('id', productoId);
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }

  /// Obtener un producto por ID para edición
  static Future<Producto> obtenerProductoPorId(int productoId) async {
    try {
      final response =
          await _supabase
              .from(_tablaProducto)
              .select('''
            *,
            Category:category_id(name),
            Store:store_id(name),
            ProductAttributes(*),
            ProductMedias(*)
          ''')
              .eq('product_id', productoId)
              .single();

      return _mapJsonToProducto(response);
    } catch (e) {
      throw Exception('Error al obtener producto por ID: $e');
    }
  }

  /// Actualizar estado de un producto
  static Future<void> actualizarEstadoProducto(
    int productoId,
    ProductStatus status,
  ) async {
    try {
      await _supabase
          .from(_tablaProducto)
          .update({'status': status.value})
          .eq('id', productoId);
    } catch (e) {
      throw Exception('Error al actualizar estado del producto: $e');
    }
  }

  /// Actualización masiva de estado
  static Future<void> actualizarEstadoMasivo(
    List<int> productoIds,
    ProductStatus status,
  ) async {
    try {
      await _supabase
          .from(_tablaProducto)
          .update({'status': status.value})
          .inFilter('id', productoIds);
    } catch (e) {
      throw Exception('Error al actualizar estado masivo: $e');
    }
  }

  /// Eliminación masiva de productos
  static Future<void> eliminarProductosMasivo(List<int> productoIds) async {
    try {
      // Eliminar atributos relacionados
      await _supabase
          .from(_tablaProductoAtributos)
          .delete()
          .inFilter('product_id', productoIds);

      // Eliminar medias relacionadas
      await _supabase
          .from(_tablaProductoMedias)
          .delete()
          .inFilter('product_id', productoIds);

      // Eliminar productos principales
      await _supabase.from(_tablaProducto).delete().inFilter('id', productoIds);
    } catch (e) {
      throw Exception('Error al eliminar productos masivo: $e');
    }
  }

  /// Mapear JSON a modelo Producto (helper method)
  static Producto _mapJsonToProducto(Map<String, dynamic> json) {
    return Producto(
      id: json['product_id'] ?? json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['short_description'],
      sku: json['sku'],
      barcode: json['barcode'],
      price: (json['price'] ?? 0.0).toDouble(),
      discountedPrice: json['discounted_price']?.toDouble(),
      costPrice: json['cost_price']?.toDouble(),
      acceptOffers: json['accept_offers'] ?? false,
      stock: json['stock'] ?? 0,
      lowStockAlert: json['low_stock_alert'] ?? 5,
      weight: json['weight']?.toDouble(),
      dimensions:
          json['dimensions'] != null
              ? Map<String, dynamic>.from(json['dimensions'])
              : null,
      categoryId:
          json['category_id'] is int
              ? json['category_id']
              : int.parse(json['category_id'].toString()),
      categoryName: json['Category']?['name'],
      brandId:
          json['brand_id'] != null
              ? (json['brand_id'] is int
                  ? json['brand_id']
                  : int.parse(json['brand_id'].toString()))
              : null,
      storeId:
          json['store_id'] != null
              ? (json['store_id'] is int
                  ? json['store_id']
                  : int.parse(json['store_id'].toString()))
              : null,
      status: ProductStatus.fromString(json['status'] ?? 'draft'),
      isAvailable: json['is_available'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      viewCount: json['view_count'] ?? 0,
      saleCount: json['sale_count'] ?? 0,
      atributos:
          json['ProductAttributes'] != null
              ? (json['ProductAttributes'] as List)
                  .map((attr) => ProductoAtributos.fromJson(attr))
                  .toList()
              : [],
      medias:
          json['ProductMedias'] != null
              ? (json['ProductMedias'] as List)
                  .map((media) => ProductoMedias.fromJson(media))
                  .toList()
              : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }
}
