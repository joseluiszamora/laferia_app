import 'package:laferia/core/models/producto.dart';

class ProductoService {
  static final List<Producto> obtenerProductos = [
    // Productos de Ropa (Rubro 3)
    const Producto(
      id: "prod_001",
      nombre: "Jeans Levis 501",
      precio: 80,
      precioOferta: 65,
      aceptaOfertas: true,
      caracteristicas: "Talla 32, usado, buen estado, color azul clásico",
      imagenesUrl: [
        "https://marathon.vtexassets.com/arquivos/ids/484898-800-auto?v=638424305425670000&width=800&height=auto&aspect=true",
      ],
      categoria: "Ropa nueva",
      rubroId: "3", // Ropa
      categoriaId: "3_1", // Ropa nueva
      subcategoriaId: "3_1_1", // Jeans
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_002",
      nombre: "Camisa Ralph Lauren",
      precio: 45,
      aceptaOfertas: true,
      caracteristicas: "Talla M, seminueva, color blanco",
      imagenesUrl: [
        "https://cdn.aboutstatic.com/file/images/ca690ab03410e720b3c788cb190d896d.png?bg=F4F4F5&quality=75&trim=1&height=480&width=360",
        "https://saleoutpe.com/cdn/shop/files/Diseno_sin_titulo_-_2025-05-10T113619.786.png?v=1746894994",
      ],
      categoria: "Ropa nueva",
      rubroId: "3", // Ropa
      categoriaId: "3_1", // Ropa nueva
      subcategoriaId: "3_1_2", // Camisas
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_003",
      nombre: "Vestido floral",
      precio: 120,
      precioOferta: 95,
      aceptaOfertas: false,
      caracteristicas: "Talla S, nuevo con etiquetas, estampado floral",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/FF9800/FFFFFF?text=Vestido",
      ],
      categoria: "Ropa nueva",
      rubroId: "3", // Ropa
      categoriaId: "3_1", // Ropa nueva
      subcategoriaId: "3_1_3", // Vestidos
      disponible: true,
      esFavorito: true,
    ),
    const Producto(
      id: "prod_004",
      nombre: "Jeans usados vintage",
      precio: 25,
      aceptaOfertas: true,
      caracteristicas: "Talla 30, estilo vintage, buen estado",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/6F42C1/FFFFFF?text=Vintage",
      ],
      categoria: "Ropa usada",
      rubroId: "3", // Ropa
      categoriaId: "3_2", // Ropa usada
      subcategoriaId: "3_2_1", // Ropa casual
      disponible: true,
      esFavorito: false,
    ),

    // Productos de Electrónica (Rubro 4)
    const Producto(
      id: "prod_005",
      nombre: "iPhone 13",
      precio: 650,
      aceptaOfertas: true,
      caracteristicas: "128GB, color azul, estado excelente, con caja",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/007BFF/FFFFFF?text=iPhone",
      ],
      categoria: "Smartphones",
      rubroId: "4", // Electrónica y tecnología
      categoriaId: "4_1", // Smartphones
      subcategoriaId: "4_1_2", // iPhone
      disponible: true,
      esFavorito: true,
    ),
    const Producto(
      id: "prod_006",
      nombre: "Samsung Galaxy S21",
      precio: 450,
      precioOferta: 380,
      aceptaOfertas: true,
      caracteristicas: "256GB, color negro, seminuevo",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/6F42C1/FFFFFF?text=Samsung",
      ],
      categoria: "Smartphones",
      rubroId: "4", // Electrónica y tecnología
      categoriaId: "4_1", // Smartphones
      subcategoriaId: "4_1_1", // Android
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_007",
      nombre: "MacBook Air M1",
      precio: 850,
      aceptaOfertas: false,
      caracteristicas: "8GB RAM, 256GB SSD, estado excelente",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/17A2B8/FFFFFF?text=MacBook",
      ],
      categoria: "Computadoras",
      rubroId: "4", // Electrónica y tecnología
      categoriaId: "4_2", // Computadoras
      subcategoriaId: "4_2_1", // Laptops
      disponible: true,
      esFavorito: true,
    ),
    const Producto(
      id: "prod_008",
      nombre: "PC Gamer Intel i7",
      precio: 1200,
      aceptaOfertas: true,
      caracteristicas: "16GB RAM, RTX 3060, SSD 512GB",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/28A745/FFFFFF?text=PC",
      ],
      categoria: "Computadoras",
      rubroId: "4", // Electrónica y tecnología
      categoriaId: "4_2", // Computadoras
      subcategoriaId: "4_2_2", // PC Escritorio
      disponible: true,
      esFavorito: false,
    ),

    // Productos de Vehículos (Rubro 2)
    const Producto(
      id: "prod_009",
      nombre: "Toyota Corolla 2018",
      precio: 12000,
      aceptaOfertas: true,
      caracteristicas: "Automático, 80,000 km, excelente estado",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/28A745/FFFFFF?text=Toyota",
        "https://via.placeholder.com/300x300/28A745/FFFFFF?text=Interior",
      ],
      categoria: "Autos",
      rubroId: "2", // Vehículos
      categoriaId: "2_1", // Autos
      subcategoriaId: "2_1_2", // Sedán
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_010",
      nombre: "Honda Civic Hatchback",
      precio: 15000,
      aceptaOfertas: true,
      caracteristicas: "Manual, 60,000 km, color rojo",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/DC3545/FFFFFF?text=Honda",
      ],
      categoria: "Autos",
      rubroId: "2", // Vehículos
      categoriaId: "2_1", // Autos
      subcategoriaId: "2_1_1", // Hatchback
      disponible: true,
      esFavorito: true,
    ),
    const Producto(
      id: "prod_011",
      nombre: "Yamaha FZ 150",
      precio: 3500,
      aceptaOfertas: true,
      caracteristicas: "Deportiva, 25,000 km, excelente motor",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/FFC107/FFFFFF?text=Yamaha",
      ],
      categoria: "Motos",
      rubroId: "2", // Vehículos
      categoriaId: "2_2", // Motos
      subcategoriaId: "2_2_1", // Motos deportivas
      disponible: true,
      esFavorito: false,
    ),

    // Productos de Autopartes (Rubro 1)
    const Producto(
      id: "prod_012",
      nombre: "Batería Bosch 12V",
      precio: 120,
      aceptaOfertas: true,
      caracteristicas: "Para auto, nueva, 2 años de garantía",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/FFC107/FFFFFF?text=Bateria",
      ],
      categoria: "Baterías",
      rubroId: "1", // Autopartes y repuestos
      categoriaId: "1_1", // Baterías
      subcategoriaId: "1_1_1", // Baterías de auto
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_013",
      nombre: "Batería de moto 12V",
      precio: 65,
      aceptaOfertas: true,
      caracteristicas: "Para motocicleta, nueva, marca YTX",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/FF9800/FFFFFF?text=BatMoto",
      ],
      categoria: "Baterías",
      rubroId: "1", // Autopartes y repuestos
      categoriaId: "1_1", // Baterías
      subcategoriaId: "1_1_2", // Baterías de moto
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_014",
      nombre: "Pastillas de freno Brembo",
      precio: 85,
      aceptaOfertas: false,
      caracteristicas: "Para Toyota Corolla, nuevas, calidad premium",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/6C757D/FFFFFF?text=Frenos",
      ],
      categoria: "Frenos",
      rubroId: "1", // Autopartes y repuestos
      categoriaId: "1_2", // Frenos
      subcategoriaId: "1_2_1", // Pastillas de freno
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_015",
      nombre: "Llantas Michelin R15",
      precio: 280,
      precioOferta: 240,
      aceptaOfertas: true,
      caracteristicas: "Set de 4 llantas, 90% de vida útil",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/495057/FFFFFF?text=Llantas",
        "https://via.placeholder.com/300x300/495057/FFFFFF?text=Perfil",
      ],
      categoria: "Llantas",
      rubroId: "1", // Autopartes y repuestos
      categoriaId: "1_3", // Llantas
      subcategoriaId: "1_3_1", // Llantas de auto
      disponible: true,
      esFavorito: true,
    ),

    // Productos de Muebles (Rubro 5)
    const Producto(
      id: "prod_016",
      nombre: "Sofá de 3 plazas",
      precio: 450,
      aceptaOfertas: true,
      caracteristicas: "Tela gris, muy cómodo, como nuevo",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/20C997/FFFFFF?text=Sofa",
      ],
      categoria: "Muebles de sala",
      rubroId: "5", // Muebles y madera
      categoriaId: "5_1", // Muebles de sala
      subcategoriaId: "5_1_1", // Sofás
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_017",
      nombre: "Mesa de centro moderna",
      precio: 180,
      aceptaOfertas: true,
      caracteristicas: "Vidrio templado, patas de acero, excelente estado",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/FD7E14/FFFFFF?text=Mesa",
      ],
      categoria: "Muebles de sala",
      rubroId: "5", // Muebles y madera
      categoriaId: "5_1", // Muebles de sala
      subcategoriaId: "5_1_2", // Mesas de centro
      disponible: true,
      esFavorito: false,
    ),
    const Producto(
      id: "prod_018",
      nombre: "Mesa de comedor familiar",
      precio: 380,
      aceptaOfertas: true,
      caracteristicas: "Madera maciza, 6 personas, barnizada",
      imagenesUrl: [
        "https://via.placeholder.com/300x300/8D6E63/FFFFFF?text=Comedor",
      ],
      categoria: "Muebles de cocina",
      rubroId: "5", // Muebles y madera
      categoriaId: "5_2", // Muebles de cocina
      subcategoriaId: "5_2_2", // Mesas de comedor
      disponible: true,
      esFavorito: false,
    ),
  ];

  /// Obtiene una lista de productos recomendados
  static List<Producto> get productosRecomendados {
    // Filtrar productos con ofertas, favoritos y bien valorados
    final recomendados =
        obtenerProductos
            .where((producto) {
              return producto.tieneOferta ||
                  producto.esFavorito ||
                  producto.precio < 100; // Productos económicos
            })
            .take(5)
            .toList();

    // Si no hay suficientes, completar con productos disponibles
    if (recomendados.length < 5) {
      final faltantes = obtenerProductos
          .where((p) => !recomendados.contains(p) && p.disponible)
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

  /// Obtiene productos favoritos
  static List<Producto> get productosFavoritos {
    return obtenerProductos.where((producto) => producto.esFavorito).toList();
  }

  /// Obtiene productos en oferta
  static List<Producto> get productosEnOferta {
    return obtenerProductos.where((producto) => producto.tieneOferta).toList();
  }
}
