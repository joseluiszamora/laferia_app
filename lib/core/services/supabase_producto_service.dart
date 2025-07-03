import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:laferia/core/models/producto.dart';
import 'package:laferia/core/models/producto_atributos.dart';
import 'package:laferia/core/models/producto_medias.dart';

class SupabaseProductoService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Tablas
  static const String _tablaProducto = 'Product';
  static const String _tablaProductoAtributos = 'ProductAttributes';
  static const String _tablaProductoMedias = 'ProductMedias';
  static const String _vistaProductoCompleto = 'ProductoCompleto';
  static const String _vistaProductoPublico = 'ProductoPublico';

  /// Obtiene todos los productos con paginación
  static Future<List<Producto>> obtenerProductos({
    int limit = 20,
    int offset = 0,
    int? categoria,
    int? marca,
    int? tienda,
    ProductStatus? status,
    bool? disponible,
    bool? destacado,
    int? stockMinimo,
    double? precioMin,
    double? precioMax,
    String? busqueda,
    List<String>? tags,
    String ordenarPor = 'created_at',
    bool ascending = false,
  }) async {
    try {
      var query = _supabase.from(_vistaProductoCompleto).select();

      // Aplicar filtros
      if (categoria != null) {
        query = query.eq('category_id', categoria);
      }
      if (marca != null) {
        query = query.eq('brand_id', marca);
      }
      if (tienda != null) {
        query = query.eq('store_id', tienda);
      }
      if (status != null) {
        query = query.eq('status', status.value);
      }
      if (disponible != null) {
        query = query.eq('is_available', disponible);
      }
      if (destacado != null) {
        query = query.eq('is_featured', destacado);
      }
      if (stockMinimo != null) {
        query = query.gte('stock', stockMinimo);
      }
      if (precioMin != null) {
        query = query.gte('price', precioMin);
      }
      if (precioMax != null) {
        query = query.lte('price', precioMax);
      }
      if (busqueda != null && busqueda.isNotEmpty) {
        query = query.or(
          'name.ilike.%$busqueda%,description.ilike.%$busqueda%',
        );
      }

      // Aplicar ordenamiento y paginación
      final response = await query
          .order(ordenarPor, ascending: ascending)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _mapearProductoCompleto(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener productos: $e');
    }
  }

  /// Obtiene productos públicos (solo productos publicados y disponibles)
  static Future<List<Producto>> obtenerProductosPublicos({
    int limit = 20,
    int offset = 0,
    int? categoria,
    int? marca,
    double? precioMin,
    double? precioMax,
    String? busqueda,
    String ordenarPor = 'created_at',
    bool ascending = false,
  }) async {
    try {
      var query = _supabase.from(_vistaProductoPublico).select();

      // Aplicar filtros
      if (categoria != null) {
        query = query.eq('category_id', categoria);
      }
      if (marca != null) {
        query = query.eq('brand_id', marca);
      }
      if (precioMin != null) {
        query = query.gte('price', precioMin);
      }
      if (precioMax != null) {
        query = query.lte('price', precioMax);
      }
      if (busqueda != null && busqueda.isNotEmpty) {
        query = query.or(
          'name.ilike.%$busqueda%,description.ilike.%$busqueda%',
        );
      }

      // Aplicar ordenamiento y paginación
      final response = await query
          .order(ordenarPor, ascending: ascending)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _mapearProductoCompleto(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener productos públicos: $e');
    }
  }

  /// Obtiene un producto por ID con todos sus detalles
  static Future<Producto?> obtenerProductoPorId(dynamic id) async {
    try {
      final response =
          await _supabase
              .from(_vistaProductoCompleto)
              .select()
              .eq('product_id', id)
              .single();

      return _mapearProductoCompleto(response);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene un producto por slug
  static Future<Producto?> obtenerProductoPorSlug(String slug) async {
    try {
      final response =
          await _supabase
              .from(_vistaProductoCompleto)
              .select()
              .eq('slug', slug)
              .single();

      return _mapearProductoCompleto(response);
    } catch (e) {
      return null;
    }
  }

  /// Crea un nuevo producto
  static Future<Producto> crearProducto(Producto producto) async {
    try {
      // Crear el producto principal
      final productoData = {
        'name': producto.name,
        'slug': producto.slug,
        'description': producto.description,
        'short_description': producto.shortDescription,
        'sku': producto.sku,
        'barcode': producto.barcode,
        'price': producto.price,
        'discounted_price': producto.discountedPrice,
        'cost_price': producto.costPrice,
        'accept_offers': producto.acceptOffers,
        'stock': producto.stock,
        'low_stock_alert': producto.lowStockAlert,
        'weight': producto.weight,
        'dimensions': producto.dimensions,
        'category_id': producto.categoryId,
        'brand_id': producto.brandId,
        'store_id': producto.storeId,
        'status': producto.status.value,
        'is_available': producto.isAvailable,
        'is_featured': producto.isFeatured,
        'meta_title': producto.metaTitle,
        'meta_description': producto.metaDescription,
        'tags': producto.tags,
        'view_count': producto.viewCount,
        'sale_count': producto.saleCount,
      };

      final response =
          await _supabase
              .from(_tablaProducto)
              .insert(productoData)
              .select()
              .single();

      final newProductId = response['id'] as int;

      // Crear atributos
      if (producto.atributos.isNotEmpty) {
        await _crearAtributos(newProductId, producto.atributos);
      }

      // Crear medias
      if (producto.medias.isNotEmpty) {
        await _crearMedias(newProductId, producto.medias);
      }

      return await obtenerProductoPorId(newProductId) ?? producto;
    } catch (e) {
      throw Exception('Error al crear producto: $e');
    }
  }

  /// Actualiza un producto existente
  static Future<Producto> actualizarProducto(int id, Producto producto) async {
    try {
      final productoData = {
        'name': producto.name,
        'slug': producto.slug,
        'description': producto.description,
        'short_description': producto.shortDescription,
        'sku': producto.sku,
        'barcode': producto.barcode,
        'price': producto.price,
        'discounted_price': producto.discountedPrice,
        'cost_price': producto.costPrice,
        'accept_offers': producto.acceptOffers,
        'stock': producto.stock,
        'low_stock_alert': producto.lowStockAlert,
        'weight': producto.weight,
        'dimensions': producto.dimensions,
        'category_id': producto.categoryId,
        'brand_id': producto.brandId,
        'store_id': producto.storeId,
        'status': producto.status.value,
        'is_available': producto.isAvailable,
        'is_featured': producto.isFeatured,
        'meta_title': producto.metaTitle,
        'meta_description': producto.metaDescription,
        'tags': producto.tags,
        'view_count': producto.viewCount,
        'sale_count': producto.saleCount,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from(_tablaProducto).update(productoData).eq('id', id);

      return await obtenerProductoPorId(id) ?? producto;
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }

  /// Elimina un producto y todos sus datos relacionados
  static Future<void> eliminarProducto(int id) async {
    try {
      await _supabase.from(_tablaProducto).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }

  /// Cambia el estado de un producto
  static Future<void> cambiarEstadoProducto(int id, String nuevoEstado) async {
    try {
      await _supabase
          .from(_tablaProducto)
          .update({
            'status': nuevoEstado,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Error al cambiar estado del producto: $e');
    }
  }

  /// Alterna la disponibilidad de un producto
  static Future<void> alternarDisponibilidad(int id) async {
    try {
      final producto =
          await _supabase
              .from(_tablaProducto)
              .select('is_available')
              .eq('id', id)
              .single();

      await _supabase
          .from(_tablaProducto)
          .update({
            'is_available': !producto['is_available'],
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Error al alternar disponibilidad: $e');
    }
  }

  /// Establece el precio con descuento
  static Future<void> establecerDescuento(
    String id,
    double? precioConDescuento,
  ) async {
    try {
      await _supabase
          .from(_tablaProducto)
          .update({
            'discounted_price': precioConDescuento,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw Exception('Error al establecer descuento: $e');
    }
  }

  // === GESTIÓN DE ATRIBUTOS ===

  /// Obtiene todos los atributos de un producto
  static Future<List<ProductoAtributos>> obtenerAtributosProducto(
    String productoId,
  ) async {
    try {
      final response = await _supabase
          .from(_tablaProductoAtributos)
          .select()
          .eq('producto_id', productoId);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => ProductoAtributos.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener atributos: $e');
    }
  }

  /// Agrega un atributo a un producto
  static Future<ProductoAtributos> agregarAtributo(
    ProductoAtributos atributo,
  ) async {
    try {
      final data = {
        'product_id': atributo.productId,
        'name': atributo.name,
        'value': atributo.value,
        'type': atributo.type,
        'unity': atributo.unity,
        'order': atributo.order,
      };

      final response =
          await _supabase
              .from(_tablaProductoAtributos)
              .insert(data)
              .select()
              .single();

      return ProductoAtributos.fromJson(response);
    } catch (e) {
      throw Exception('Error al agregar atributo: $e');
    }
  }

  /// Actualiza un atributo existente
  static Future<ProductoAtributos> actualizarAtributo(
    int id,
    ProductoAtributos atributo,
  ) async {
    try {
      final data = {
        'name': atributo.name,
        'value': atributo.value,
        'type': atributo.type,
        'unity': atributo.unity,
        'order': atributo.order,
      };

      final response =
          await _supabase
              .from(_tablaProductoAtributos)
              .update(data)
              .eq('id', id)
              .select()
              .single();

      return ProductoAtributos.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar atributo: $e');
    }
  }

  /// Elimina un atributo
  static Future<void> eliminarAtributo(int id) async {
    try {
      await _supabase.from(_tablaProductoAtributos).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar atributo: $e');
    }
  }

  // === GESTIÓN DE MEDIAS ===

  /// Obtiene todas las medias de un producto
  static Future<List<ProductoMedias>> obtenerMediasProducto(
    int productoId,
  ) async {
    try {
      final response = await _supabase
          .from(_tablaProductoMedias)
          .select()
          .eq('product_id', productoId)
          .order('order', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => ProductoMedias.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener medias: $e');
    }
  }

  /// Agrega una media a un producto
  static Future<ProductoMedias> agregarMedia(ProductoMedias media) async {
    try {
      final response =
          await _supabase
              .from(_tablaProductoMedias)
              .insert(media.toJson())
              .select()
              .single();

      return ProductoMedias.fromJson(response);
    } catch (e) {
      throw Exception('Error al agregar media: $e');
    }
  }

  /// Actualiza una media existente
  static Future<ProductoMedias> actualizarMedia(
    int id,
    ProductoMedias media,
  ) async {
    try {
      final data = media.toJson();
      data['updated_at'] = DateTime.now().toIso8601String();

      final response =
          await _supabase
              .from(_tablaProductoMedias)
              .update(data)
              .eq('id', id)
              .select()
              .single();

      return ProductoMedias.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar media: $e');
    }
  }

  /// Elimina una media
  static Future<void> eliminarMedia(int id) async {
    try {
      await _supabase.from(_tablaProductoMedias).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar media: $e');
    }
  }

  /// Establece una imagen como principal
  static Future<void> establecerImagenPrincipal(
    int productoId,
    int mediaId,
  ) async {
    try {
      // Primero quitar el estado principal de todas las imágenes del producto
      await _supabase
          .from(_tablaProductoMedias)
          .update({'is_main': false})
          .eq('product_id', productoId);

      // Luego establecer la nueva imagen principal
      await _supabase
          .from(_tablaProductoMedias)
          .update({'is_main': true})
          .eq('id', mediaId);
    } catch (e) {
      throw Exception('Error al establecer imagen principal: $e');
    }
  }

  // === BÚSQUEDAS ESPECIALIZADAS ===

  /// Busca productos por categoría
  static Future<List<Producto>> buscarPorCategoria(
    int categoriaId, {
    int limit = 20,
    int offset = 0,
  }) async {
    return obtenerProductosPublicos(
      categoria: categoriaId,
      limit: limit,
      offset: offset,
    );
  }

  /// Busca productos por marca
  static Future<List<Producto>> buscarPorMarca(
    int marcaId, {
    int limit = 20,
    int offset = 0,
  }) async {
    return obtenerProductosPublicos(
      marca: marcaId,
      limit: limit,
      offset: offset,
    );
  }

  /// Busca productos en oferta
  static Future<List<Producto>> obtenerProductosEnOferta({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from(_tablaProducto)
          .select()
          .not('discounted_price', 'is', null)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _mapearProductoCompleto(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener productos en oferta: $e');
    }
  }

  /// Busca los ultimos productos
  static Future<List<Producto>> obtenerUltimosProductos({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from(_tablaProducto)
          .select()
          .eq('status', 'published')
          .eq('is_available', true)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _mapearProductoCompleto(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener productos en oferta: $e');
    }
  }

  /// Obtiene productos relacionados (misma categoría, excluyendo el actual)
  static Future<List<Producto>> obtenerProductosRelacionados(
    String productoId, {
    int limit = 10,
  }) async {
    try {
      // Primero obtenemos la categoría del producto
      final producto =
          await _supabase
              .from(_tablaProducto)
              .select('categoria_id')
              .eq('id', productoId)
              .single();

      // Luego buscamos productos de la misma categoría
      final response = await _supabase
          .from(_vistaProductoPublico)
          .select()
          .eq('categoria_id', producto['categoria_id'])
          .neq('id', productoId)
          .limit(limit)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => _mapearProductoCompleto(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener productos relacionados: $e');
    }
  }

  // === MÉTODOS PRIVADOS ===

  /// Mapea los datos de la vista completa a un objeto Producto
  static Producto _mapearProductoCompleto(Map<String, dynamic> json) {
    return Producto(
      id:
          json['product_id'] is int
              ? json['product_id']
              : int.parse(json['product_id'].toString()),
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
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
      atributos: _mapearAtributos(json['atributos']),
      medias: _mapearMedias(json['medias']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  /// Mapea los atributos del JSON a una lista de ProductoAtributos
  static List<ProductoAtributos> _mapearAtributos(dynamic atributosJson) {
    if (atributosJson == null) return [];
    if (atributosJson is List) {
      return atributosJson
          .map((json) => ProductoAtributos.fromJson(json))
          .toList();
    }
    return [];
  }

  /// Mapea las medias del JSON a una lista de ProductoMedias
  static List<ProductoMedias> _mapearMedias(dynamic mediasJson) {
    if (mediasJson == null) return [];
    if (mediasJson is List) {
      return mediasJson.map((json) => ProductoMedias.fromJson(json)).toList();
    }
    return [];
  }

  /// Crea los atributos de un producto
  static Future<void> _crearAtributos(
    int productoId,
    List<ProductoAtributos> atributos,
  ) async {
    final atributosData =
        atributos
            .map(
              (attr) => {
                'product_id': productoId,
                'name': attr.name,
                'value': attr.value,
                'type': attr.type,
                'unity': attr.unity,
                'order': attr.order,
              },
            )
            .toList();

    await _supabase.from(_tablaProductoAtributos).insert(atributosData);
  }

  /// Crea las medias de un producto
  static Future<void> _crearMedias(
    int productoId,
    List<ProductoMedias> medias,
  ) async {
    final mediasData =
        medias
            .map((media) => {...media.toJson(), 'product_id': productoId})
            .toList();

    await _supabase.from(_tablaProductoMedias).insert(mediasData);
  }
}
