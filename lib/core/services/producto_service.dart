import 'package:laferia/core/models/producto.dart';
import 'package:laferia/core/models/producto_atributos.dart';
import 'package:laferia/core/models/producto_medias.dart';

class ProductoService {
  static final List<Producto> obtenerProductos = [
    // Productos de Ropa (Categoría 3_1)
    Producto(
      id: "prod_001",
      name: "Jeans Levis 501",
      slug: "jeans-levis-501",
      description: "Talla 32, usado, buen estado, color azul clásico",
      price: 80,
      discountedPrice: 65,
      acceptOffers: true,
      categoriaId: "3_1",
      marcaId: "marca_levis",
      status: "publicado",
      isAvailable: true,
      atributos: [
        ProductoAtributos(
          id: "attr_001_1",
          productoId: "prod_001",
          nombre: "Talla",
          valor: "32",
        ),
        ProductoAtributos(
          id: "attr_001_2",
          productoId: "prod_001",
          nombre: "Estado",
          valor: "Usado",
        ),
        ProductoAtributos(
          id: "attr_001_3",
          productoId: "prod_001",
          nombre: "Color",
          valor: "Azul clásico",
        ),
      ],
      imagenesUrl: [
        ProductoMedias(
          id: "media_001_1",
          productoId: "prod_001",
          type: "image",
          url:
              "https://marathon.vtexassets.com/arquivos/ids/484898-800-auto?v=638424305425670000&width=800&height=auto&aspect=true",
          fechaCreacion: DateTime.now(),
          esPrincipal: true,
          orden: 1,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    Producto(
      id: "prod_002",
      name: "Camisa Ralph Lauren",
      slug: "camisa-ralph-lauren",
      description: "Talla M, seminueva, color blanco",
      price: 45,
      acceptOffers: true,
      categoriaId: "3_1",
      marcaId: "marca_ralph_lauren",
      status: "publicado",
      isAvailable: true,
      atributos: [
        ProductoAtributos(
          id: "attr_002_1",
          productoId: "prod_002",
          nombre: "Talla",
          valor: "M",
        ),
        ProductoAtributos(
          id: "attr_002_2",
          productoId: "prod_002",
          nombre: "Estado",
          valor: "Seminueva",
        ),
        ProductoAtributos(
          id: "attr_002_3",
          productoId: "prod_002",
          nombre: "Color",
          valor: "Blanco",
        ),
      ],
      imagenesUrl: [
        ProductoMedias(
          id: "media_002_1",
          productoId: "prod_002",
          type: "image",
          url:
              "https://cdn.aboutstatic.com/file/images/ca690ab03410e720b3c788cb190d896d.png?bg=F4F4F5&quality=75&trim=1&height=480&width=360",
          fechaCreacion: DateTime.now(),
          esPrincipal: true,
          orden: 1,
        ),
        ProductoMedias(
          id: "media_002_2",
          productoId: "prod_002",
          type: "image",
          url:
              "https://saleoutpe.com/cdn/shop/files/Diseno_sin_titulo_-_2025-05-10T113619.786.png?v=1746894994",
          fechaCreacion: DateTime.now(),
          esPrincipal: false,
          orden: 2,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),

    Producto(
      id: "prod_003",
      name: "Vestido floral",
      slug: "vestido-floral",
      description: "Talla S, nuevo con etiquetas, estampado floral",
      price: 120,
      discountedPrice: 95,
      acceptOffers: false,
      categoriaId: "3_1",
      marcaId: "marca_zara",
      status: "publicado",
      isAvailable: true,
      atributos: [
        ProductoAtributos(
          id: "attr_003_1",
          productoId: "prod_003",
          nombre: "Talla",
          valor: "S",
        ),
        ProductoAtributos(
          id: "attr_003_2",
          productoId: "prod_003",
          nombre: "Estado",
          valor: "Nuevo con etiquetas",
        ),
        ProductoAtributos(
          id: "attr_003_3",
          productoId: "prod_003",
          nombre: "Estampado",
          valor: "Floral",
        ),
      ],
      imagenesUrl: [
        ProductoMedias(
          id: "media_003_1",
          productoId: "prod_003",
          type: "image",
          url: "https://via.placeholder.com/300x300/FF9800/FFFFFF?text=Vestido",
          fechaCreacion: DateTime.now(),
          esPrincipal: true,
          orden: 1,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // Productos de Electrónica (Categoría 4_1)
    Producto(
      id: "prod_004",
      name: "iPhone 13",
      slug: "iphone-13",
      description: "128GB, color azul, estado excelente, con caja",
      price: 650,
      acceptOffers: true,
      categoriaId: "4_1",
      marcaId: "marca_apple",
      status: "publicado",
      isAvailable: true,
      atributos: [
        ProductoAtributos(
          id: "attr_004_1",
          productoId: "prod_004",
          nombre: "Almacenamiento",
          valor: "128GB",
        ),
        ProductoAtributos(
          id: "attr_004_2",
          productoId: "prod_004",
          nombre: "Color",
          valor: "Azul",
        ),
        ProductoAtributos(
          id: "attr_004_3",
          productoId: "prod_004",
          nombre: "Estado",
          valor: "Excelente",
        ),
      ],
      imagenesUrl: [
        ProductoMedias(
          id: "media_004_1",
          productoId: "prod_004",
          type: "image",
          url: "https://via.placeholder.com/300x300/007BFF/FFFFFF?text=iPhone",
          fechaCreacion: DateTime.now(),
          esPrincipal: true,
          orden: 1,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    Producto(
      id: "prod_005",
      name: "Samsung Galaxy S21",
      slug: "samsung-galaxy-s21",
      description: "256GB, color negro, seminuevo",
      price: 450,
      discountedPrice: 380,
      acceptOffers: true,
      categoriaId: "4_1",
      marcaId: "marca_samsung",
      status: "publicado",
      isAvailable: true,
      atributos: [
        ProductoAtributos(
          id: "attr_005_1",
          productoId: "prod_005",
          nombre: "Almacenamiento",
          valor: "256GB",
        ),
        ProductoAtributos(
          id: "attr_005_2",
          productoId: "prod_005",
          nombre: "Color",
          valor: "Negro",
        ),
        ProductoAtributos(
          id: "attr_005_3",
          productoId: "prod_005",
          nombre: "Estado",
          valor: "Seminuevo",
        ),
      ],
      imagenesUrl: [
        ProductoMedias(
          id: "media_005_1",
          productoId: "prod_005",
          type: "image",
          url: "https://via.placeholder.com/300x300/6F42C1/FFFFFF?text=Samsung",
          fechaCreacion: DateTime.now(),
          esPrincipal: true,
          orden: 1,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),

    // Productos de Computadoras (Categoría 4_2)
    Producto(
      id: "prod_006",
      name: "MacBook Air M1",
      slug: "macbook-air-m1",
      description: "8GB RAM, 256GB SSD, estado excelente",
      price: 850,
      acceptOffers: false,
      categoriaId: "4_2",
      marcaId: "marca_apple",
      status: "publicado",
      isAvailable: true,
      atributos: [
        ProductoAtributos(
          id: "attr_006_1",
          productoId: "prod_006",
          nombre: "RAM",
          valor: "8GB",
        ),
        ProductoAtributos(
          id: "attr_006_2",
          productoId: "prod_006",
          nombre: "Almacenamiento",
          valor: "256GB SSD",
        ),
        ProductoAtributos(
          id: "attr_006_3",
          productoId: "prod_006",
          nombre: "Estado",
          valor: "Excelente",
        ),
      ],
      imagenesUrl: [
        ProductoMedias(
          id: "media_006_1",
          productoId: "prod_006",
          type: "image",
          url: "https://via.placeholder.com/300x300/17A2B8/FFFFFF?text=MacBook",
          fechaCreacion: DateTime.now(),
          esPrincipal: true,
          orden: 1,
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  /// Obtiene una lista de productos recomendados
  static List<Producto> get productosRecomendados {
    // Filtrar productos con ofertas y productos económicos
    final recomendados =
        obtenerProductos
            .where((producto) {
              return producto.tieneOferta ||
                  producto.price < 100; // Productos económicos
            })
            .take(5)
            .toList();

    // Si no hay suficientes, completar con productos disponibles
    if (recomendados.length < 5) {
      final faltantes = obtenerProductos
          .where((p) => !recomendados.contains(p) && p.isAvailable)
          .take(5 - recomendados.length);
      recomendados.addAll(faltantes);
    }

    return recomendados;
  }

  /// Obtiene productos por categoría específica
  static List<Producto> obtenerProductosPorCategoria(String categoriaId) {
    return obtenerProductos
        .where((producto) => producto.categoriaId == categoriaId)
        .toList();
  }

  /// Obtiene productos en oferta
  static List<Producto> get productosEnOferta {
    return obtenerProductos.where((producto) => producto.tieneOferta).toList();
  }

  /// Obtiene productos por marca
  static List<Producto> obtenerProductosPorMarca(String marcaId) {
    return obtenerProductos
        .where((producto) => producto.marcaId == marcaId)
        .toList();
  }

  /// Busca productos por nombre o descripción
  static List<Producto> buscarProductos(String query) {
    final queryLower = query.toLowerCase();
    return obtenerProductos
        .where(
          (producto) =>
              producto.name.toLowerCase().contains(queryLower) ||
              producto.description.toLowerCase().contains(queryLower),
        )
        .toList();
  }

  /// Obtiene productos disponibles
  static List<Producto> get productosDisponibles {
    return obtenerProductos.where((producto) => producto.isAvailable).toList();
  }
}
