import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:laferia/core/models/producto.dart';
import 'package:laferia/core/models/producto_atributos.dart';
import 'package:laferia/core/models/producto_medias.dart';

class SupabaseProductoService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Tablas
  static const String _tablaProducto = 'Producto';
  static const String _tablaProductoAtributos = 'ProductoAtributos';
  static const String _tablaProductoMedias = 'ProductoMedias';
  static const String _vistaProductoCompleto = 'ProductoCompleto';
  static const String _vistaProductoPublico = 'ProductoPublico';

  /// Obtiene todos los productos con paginación
  static Future<List<Producto>> obtenerProductos({
    int limit = 20,
    int offset = 0,
    String? categoria,
    String? marca,
    String? status,
    bool? disponible,
    double? precioMin,
    double? precioMax,
    String? busqueda,
    String ordenarPor = 'created_at',
    bool ascending = false,
  }) async {
    try {
      var query = _supabase.from(_vistaProductoCompleto).select();

      // Aplicar filtros
      if (categoria != null) {
        query = query.eq('categoria_id', categoria);
      }
      if (marca != null) {
        query = query.eq('marca_id', marca);
      }
      if (status != null) {
        query = query.eq('status', status);
      }
      if (disponible != null) {
        query = query.eq('is_available', disponible);
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
    String? categoria,
    String? marca,
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
        query = query.eq('categoria_id', categoria);
      }
      if (marca != null) {
        query = query.eq('marca_id', marca);
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
  static Future<Producto?> obtenerProductoPorId(String id) async {
    try {
      final response =
          await _supabase
              .from(_vistaProductoCompleto)
              .select()
              .eq('id', id)
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
        'id': producto.id,
        'name': producto.name,
        'slug': producto.slug,
        'description': producto.description,
        'price': producto.price,
        'discounted_price': producto.discountedPrice,
        'accept_offers': producto.acceptOffers,
        'categoria_id': producto.categoriaId,
        'marca_id': producto.marcaId,
        'status': producto.status,
        'is_available': producto.isAvailable,
        'is_favorite': producto.isFavorite,
        'logo_url': producto.logoUrl,
      };

      await _supabase.from(_tablaProducto).insert(productoData);

      // Crear atributos
      if (producto.atributos.isNotEmpty) {
        await _crearAtributos(producto.id, producto.atributos);
      }

      // Crear medias
      if (producto.imagenesUrl.isNotEmpty) {
        await _crearMedias(producto.id, producto.imagenesUrl);
      }

      return await obtenerProductoPorId(producto.id) ?? producto;
    } catch (e) {
      throw Exception('Error al crear producto: $e');
    }
  }

  /// Actualiza un producto existente
  static Future<Producto> actualizarProducto(
    String id,
    Producto producto,
  ) async {
    try {
      final productoData = {
        'name': producto.name,
        'slug': producto.slug,
        'description': producto.description,
        'price': producto.price,
        'discounted_price': producto.discountedPrice,
        'accept_offers': producto.acceptOffers,
        'categoria_id': producto.categoriaId,
        'marca_id': producto.marcaId,
        'status': producto.status,
        'is_available': producto.isAvailable,
        'is_favorite': producto.isFavorite,
        'logo_url': producto.logoUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from(_tablaProducto).update(productoData).eq('id', id);

      return await obtenerProductoPorId(id) ?? producto;
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }

  /// Elimina un producto y todos sus datos relacionados
  static Future<void> eliminarProducto(String id) async {
    try {
      await _supabase.from(_tablaProducto).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }

  /// Cambia el estado de un producto
  static Future<void> cambiarEstadoProducto(
    String id,
    String nuevoEstado,
  ) async {
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
  static Future<void> alternarDisponibilidad(String id) async {
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
        'id': atributo.id,
        'producto_id': atributo.productoId,
        'nombre': atributo.nombre,
        'valor': atributo.valor,
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
    String id,
    ProductoAtributos atributo,
  ) async {
    try {
      final data = {'nombre': atributo.nombre, 'valor': atributo.valor};

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
  static Future<void> eliminarAtributo(String id) async {
    try {
      await _supabase.from(_tablaProductoAtributos).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar atributo: $e');
    }
  }

  // === GESTIÓN DE MEDIAS ===

  /// Obtiene todas las medias de un producto
  static Future<List<ProductoMedias>> obtenerMediasProducto(
    String productoId,
  ) async {
    try {
      final response = await _supabase
          .from(_tablaProductoMedias)
          .select()
          .eq('producto_id', productoId)
          .order('orden', ascending: true);

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
    String id,
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
  static Future<void> eliminarMedia(String id) async {
    try {
      await _supabase.from(_tablaProductoMedias).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar media: $e');
    }
  }

  /// Establece una imagen como principal
  static Future<void> establecerImagenPrincipal(
    String productoId,
    String mediaId,
  ) async {
    try {
      // Primero quitar el estado principal de todas las imágenes del producto
      await _supabase
          .from(_tablaProductoMedias)
          .update({'is_main': false})
          .eq('producto_id', productoId);

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
    String categoriaId, {
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
    String marcaId, {
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
          .from(_vistaProductoPublico)
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
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: (json['price'] ?? 0.0).toDouble(),
      discountedPrice: json['discounted_price']?.toDouble(),
      acceptOffers: json['accept_offers'] ?? false,
      categoriaId: json['categoria_id'],
      marcaId: json['marca_id'],
      status: json['status'] ?? 'borrador',
      isAvailable: json['is_available'] ?? true,
      isFavorite: json['is_favorite'] ?? false,
      atributos: _mapearAtributos(json['atributos']),
      imagenesUrl: _mapearMedias(json['medias']),
      logoUrl: json['logo_url'],
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
    String productoId,
    List<ProductoAtributos> atributos,
  ) async {
    final atributosData =
        atributos
            .map(
              (attr) => {
                'id': attr.id,
                'producto_id': productoId,
                'nombre': attr.nombre,
                'valor': attr.valor,
              },
            )
            .toList();

    await _supabase.from(_tablaProductoAtributos).insert(atributosData);
  }

  /// Crea las medias de un producto
  static Future<void> _crearMedias(
    String productoId,
    List<ProductoMedias> medias,
  ) async {
    final mediasData =
        medias
            .map((media) => {...media.toJson(), 'producto_id': productoId})
            .toList();

    await _supabase.from(_tablaProductoMedias).insert(mediasData);
  }
}
