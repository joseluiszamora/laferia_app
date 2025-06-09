import '../models/categoria.dart';

class CategoriaService {
  // Categorías de tiendas (existentes)
  static final List<Categoria> _categorias = [
    const Categoria(
      id: "cat_001",
      nombre: "Comida",
      descripcion: "Restaurantes, comida rápida y bebidas",
      icono: "restaurant",
      rubroId: "rubro_alimentos",
      subcategorias: [
        Subcategoria(
          id: "sub_001",
          nombre: "Chicharrón",
          descripcion: "Chicharrones y frituras",
          categoriaId: "cat_001",
          rubroId: "rubro_alimentos",
        ),
        Subcategoria(
          id: "sub_002",
          nombre: "Comida Rápida",
          descripcion: "Hamburguesas, salteñas, etc.",
          categoriaId: "cat_001",
          rubroId: "rubro_alimentos",
        ),
        Subcategoria(
          id: "sub_003",
          nombre: "Bebidas",
          descripcion: "Refrescos naturales y bebidas",
          categoriaId: "cat_001",
          rubroId: "rubro_alimentos",
        ),
      ],
    ),
    const Categoria(
      id: "cat_002",
      nombre: "Ropa y Accesorios",
      descripcion: "Vestimenta y accesorios personales",
      icono: "checkroom",
      rubroId: "rubro_ropa",
      subcategorias: [
        Subcategoria(
          id: "sub_004",
          nombre: "Ropa Americana",
          descripcion: "Ropa usada importada",
          categoriaId: "cat_002",
          rubroId: "rubro_ropa",
        ),
        Subcategoria(
          id: "sub_005",
          nombre: "Calzado",
          descripcion: "Zapatos, botas y sandalias",
          categoriaId: "cat_002",
          rubroId: "rubro_ropa",
        ),
      ],
    ),
    const Categoria(
      id: "cat_003",
      nombre: "Tecnología",
      descripcion: "Dispositivos y accesorios tecnológicos",
      icono: "devices",
      rubroId: "rubro_electronica",
      subcategorias: [
        Subcategoria(
          id: "sub_006",
          nombre: "Accesorios Móviles",
          descripcion: "Fundas, cargadores, audífonos",
          categoriaId: "cat_003",
          rubroId: "rubro_electronica",
        ),
      ],
    ),
    const Categoria(
      id: "cat_004",
      nombre: "Artesanías",
      descripcion: "Productos artesanales y tradicionales",
      icono: "palette",
      rubroId: "rubro_artesanias",
      subcategorias: [
        Subcategoria(
          id: "sub_007",
          nombre: "Tejidos",
          descripcion: "Tejidos andinos y tradicionales",
          categoriaId: "cat_004",
          rubroId: "rubro_artesanias",
        ),
        Subcategoria(
          id: "sub_008",
          nombre: "Cerámica",
          descripcion: "Productos de cerámica decorativa",
          categoriaId: "cat_004",
          rubroId: "rubro_artesanias",
        ),
        Subcategoria(
          id: "sub_009",
          nombre: "Joyería",
          descripcion: "Joyería en plata y otros metales",
          categoriaId: "cat_004",
          rubroId: "rubro_artesanias",
        ),
      ],
    ),
    const Categoria(
      id: "cat_005",
      nombre: "Hogar",
      descripcion: "Muebles y artículos para el hogar",
      icono: "home",
      rubroId: "rubro_hogar",
      subcategorias: [
        Subcategoria(
          id: "sub_010",
          nombre: "Muebles",
          descripcion: "Mesas, sillas, roperos",
          categoriaId: "cat_005",
          rubroId: "rubro_hogar",
        ),
      ],
    ),
    const Categoria(
      id: "cat_006",
      nombre: "Autopartes",
      descripcion: "Repuestos y accesorios para vehículos",
      icono: "build",
      rubroId: "rubro_autopartes",
      subcategorias: [
        Subcategoria(
          id: "sub_011",
          nombre: "Repuestos",
          descripcion: "Repuestos para automóviles",
          categoriaId: "cat_006",
          rubroId: "rubro_autopartes",
        ),
      ],
    ),
  ];

  static Categoria? getCategoriaById(String id) {
    try {
      return _categorias.firstWhere((categoria) => categoria.id == id);
    } catch (e) {
      return null;
    }
  }

  static Subcategoria? getSubcategoriaById(String id) {
    for (final categoria in _categorias) {
      try {
        return categoria.subcategorias.firstWhere((sub) => sub.id == id);
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  static String getCategoriaNombre(String categoriaId) {
    // Buscar primero en categorías de tiendas
    final categoria = getCategoriaById(categoriaId);
    if (categoria != null) return categoria.nombre;

    // Buscar en categorías de productos
    final categoriaProducto = getProductoCategoriaById(categoriaId);
    return categoriaProducto?.nombre ?? 'Sin categoría';
  }

  static String getSubcategoriaNombre(String subcategoriaId) {
    // Buscar primero en subcategorías de tiendas
    final subcategoria = getSubcategoriaById(subcategoriaId);
    if (subcategoria != null) return subcategoria.nombre;

    // Buscar en subcategorías de productos
    final subcategoriaProducto = getProductoSubcategoriaById(subcategoriaId);
    return subcategoriaProducto?.nombre ?? 'Sin subcategoría';
  }

  static List<Categoria> getAllCategorias() {
    return _categorias;
  }

  // ===== CATEGORÍAS DE PRODUCTOS =====

  static final List<Categoria> _categoriasProductos = [
    const Categoria(
      id: "prod_cat_001",
      nombre: "Pantalones",
      descripcion: "Todo tipo de pantalones",
      icono: "style",
      rubroId: "rubro_ropa",
      subcategorias: [
        Subcategoria(
          id: "prod_sub_001",
          nombre: "Jeans Levi's",
          descripcion: "Jeans marca Levi's",
          categoriaId: "prod_cat_001",
          rubroId: "rubro_ropa",
        ),
        Subcategoria(
          id: "prod_sub_002",
          nombre: "Jeans Generales",
          descripcion: "Jeans de diversas marcas",
          categoriaId: "prod_cat_001",
          rubroId: "rubro_ropa",
        ),
        Subcategoria(
          id: "prod_sub_003",
          nombre: "Pantalones de Vestir",
          descripcion: "Pantalones formales",
          categoriaId: "prod_cat_001",
          rubroId: "rubro_ropa",
        ),
      ],
    ),
    const Categoria(
      id: "prod_cat_002",
      nombre: "Camisas y Blusas",
      descripcion: "Camisas, blusas y tops",
      icono: "checkroom",
      rubroId: "rubro_ropa",
      subcategorias: [
        Subcategoria(
          id: "prod_sub_004",
          nombre: "Camisas de Vestir",
          descripcion: "Camisas formales",
          categoriaId: "prod_cat_002",
          rubroId: "rubro_ropa",
        ),
        Subcategoria(
          id: "prod_sub_005",
          nombre: "Polos y T-Shirts",
          descripcion: "Camisetas casuales",
          categoriaId: "prod_cat_002",
          rubroId: "rubro_ropa",
        ),
        Subcategoria(
          id: "prod_sub_006",
          nombre: "Blusas Femeninas",
          descripcion: "Blusas para mujeres",
          categoriaId: "prod_cat_002",
          rubroId: "rubro_ropa",
        ),
      ],
    ),
    const Categoria(
      id: "prod_cat_003",
      nombre: "Comidas Preparadas",
      descripcion: "Platos y comidas listas",
      icono: "restaurant",
      rubroId: "rubro_alimentos",
      subcategorias: [
        Subcategoria(
          id: "prod_sub_007",
          nombre: "Chicharrón de Cerdo",
          descripcion: "Chicharrones tradicionales",
          categoriaId: "prod_cat_003",
          rubroId: "rubro_alimentos",
        ),
        Subcategoria(
          id: "prod_sub_008",
          nombre: "Chicharrón de Pollo",
          descripcion: "Chicharrones de pollo",
          categoriaId: "prod_cat_003",
          rubroId: "rubro_alimentos",
        ),
        Subcategoria(
          id: "prod_sub_009",
          nombre: "Papas Fritas",
          descripcion: "Papas fritas y acompañamientos",
          categoriaId: "prod_cat_003",
          rubroId: "rubro_alimentos",
        ),
      ],
    ),
    const Categoria(
      id: "prod_cat_004",
      nombre: "Repuestos Automotrices",
      descripcion: "Partes y repuestos para vehículos",
      icono: "build",
      rubroId: "rubro_autopartes",
      subcategorias: [
        Subcategoria(
          id: "prod_sub_010",
          nombre: "Filtros",
          descripcion: "Filtros de aceite, aire y combustible",
          categoriaId: "prod_cat_004",
          rubroId: "rubro_autopartes",
        ),
        Subcategoria(
          id: "prod_sub_011",
          nombre: "Frenos",
          descripcion: "Pastillas y discos de freno",
          categoriaId: "prod_cat_004",
          rubroId: "rubro_autopartes",
        ),
        Subcategoria(
          id: "prod_sub_012",
          nombre: "Aceites y Lubricantes",
          descripcion: "Aceites para motor y lubricantes",
          categoriaId: "prod_cat_004",
          rubroId: "rubro_autopartes",
        ),
      ],
    ),
    const Categoria(
      id: "prod_cat_005",
      nombre: "Artesanías Tradicionales",
      descripcion: "Artesanías y objetos decorativos",
      icono: "palette",
      rubroId: "rubro_artesanias",
      subcategorias: [
        Subcategoria(
          id: "prod_sub_013",
          nombre: "Textiles Andinos",
          descripcion: "Tejidos tradicionales andinos",
          categoriaId: "prod_cat_005",
          rubroId: "rubro_artesanias",
        ),
        Subcategoria(
          id: "prod_sub_014",
          nombre: "Cerámica",
          descripcion: "Cerámicas y vasijas",
          categoriaId: "prod_cat_005",
          rubroId: "rubro_artesanias",
        ),
        Subcategoria(
          id: "prod_sub_015",
          nombre: "Joyería Artesanal",
          descripcion: "Joyas hechas a mano",
          categoriaId: "prod_cat_005",
          rubroId: "rubro_artesanias",
        ),
      ],
    ),
    const Categoria(
      id: "prod_cat_006",
      nombre: "Calzado",
      descripcion: "Zapatos, botas y sandalias",
      icono: "foundation",
      rubroId: "rubro_ropa",
      subcategorias: [
        Subcategoria(
          id: "prod_sub_016",
          nombre: "Zapatos de Vestir",
          descripcion: "Calzado formal",
          categoriaId: "prod_cat_006",
          rubroId: "rubro_ropa",
        ),
        Subcategoria(
          id: "prod_sub_017",
          nombre: "Zapatillas Deportivas",
          descripcion: "Calzado deportivo",
          categoriaId: "prod_cat_006",
          rubroId: "rubro_ropa",
        ),
        Subcategoria(
          id: "prod_sub_018",
          nombre: "Botas",
          descripcion: "Botas de trabajo y casual",
          categoriaId: "prod_cat_006",
          rubroId: "rubro_ropa",
        ),
      ],
    ),
    const Categoria(
      id: "prod_cat_007",
      nombre: "Muebles",
      descripcion: "Muebles y decoración para el hogar",
      icono: "chair",
      rubroId: "rubro_hogar",
      subcategorias: [
        Subcategoria(
          id: "prod_sub_019",
          nombre: "Sillas",
          descripcion: "Sillas de diversos tipos",
          categoriaId: "prod_cat_007",
          rubroId: "rubro_hogar",
        ),
        Subcategoria(
          id: "prod_sub_020",
          nombre: "Mesas",
          descripcion: "Mesas de comedor y centro",
          categoriaId: "prod_cat_007",
          rubroId: "rubro_hogar",
        ),
        Subcategoria(
          id: "prod_sub_021",
          nombre: "Decoración",
          descripcion: "Objetos decorativos",
          categoriaId: "prod_cat_007",
          rubroId: "rubro_hogar",
        ),
      ],
    ),
  ];

  // Métodos para categorías de productos
  static Categoria? getProductoCategoriaById(String categoriaId) {
    try {
      return _categoriasProductos.firstWhere(
        (categoria) => categoria.id == categoriaId,
      );
    } catch (e) {
      return null;
    }
  }

  static Subcategoria? getProductoSubcategoriaById(String subcategoriaId) {
    for (final categoria in _categoriasProductos) {
      try {
        return categoria.subcategorias.firstWhere(
          (sub) => sub.id == subcategoriaId,
        );
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  static List<Categoria> getAllProductoCategorias() {
    return _categoriasProductos;
  }

  static String getProductoCategoriaNombre(String categoriaId) {
    final categoria = getProductoCategoriaById(categoriaId);
    return categoria?.nombre ?? 'Sin categoría';
  }

  static String getProductoSubcategoriaNombre(String subcategoriaId) {
    final subcategoria = getProductoSubcategoriaById(subcategoriaId);
    return subcategoria?.nombre ?? 'Sin subcategoría';
  }
}
