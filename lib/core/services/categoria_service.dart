import '../models/categoria.dart';

class CategoriaService {
  // Categorías de tiendas (existentes)
  static final List<Categoria> _categorias = [
    const Categoria(
      id: "cat_001",
      parentId: "",
      name: "Comida",
      slug: "comida",
      description: "Restaurantes, comida rápida y bebidas",
      icon: "restaurant",
      color: "#FF9800",
    ),
    const Categoria(
      id: "cat_002",
      parentId: "",
      name: "Ropa y Accesorios",
      slug: "ropa-accesorios",
      description: "Vestimenta y accesorios personales",
      icon: "checkroom",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "cat_003",
      parentId: "",
      name: "Tecnología",
      slug: "tecnologia",
      description: "Dispositivos y accesorios tecnológicos",
      icon: "devices",
      color: "#2196F3",
    ),
    const Categoria(
      id: "cat_004",
      parentId: "",
      name: "Artesanías",
      slug: "artesanias",
      description: "Productos artesanales y tradicionales",
      icon: "palette",
      color: "#795548",
    ),
    const Categoria(
      id: "cat_005",
      parentId: "",
      name: "Hogar",
      slug: "hogar",
      description: "Muebles y artículos para el hogar",
      icon: "home",
      color: "#4CAF50",
    ),
    const Categoria(
      id: "cat_006",
      parentId: "",
      name: "Autopartes",
      slug: "autopartes",
      description: "Repuestos y accesorios para vehículos",
      icon: "build",
      color: "#607D8B",
    ),
  ];

  // Subcategorías para tiendas
  static final List<Categoria> _subcategorias = [
    // Subcategorías de Comida
    const Categoria(
      id: "sub_001",
      parentId: "cat_001",
      name: "Chicharrón",
      slug: "chicharron",
      description: "Chicharrones y frituras",
      icon: "restaurant_menu",
      color: "#FF9800",
    ),
    const Categoria(
      id: "sub_002",
      parentId: "cat_001",
      name: "Comida Rápida",
      slug: "comida-rapida",
      description: "Hamburguesas, salteñas, etc.",
      icon: "fastfood",
      color: "#FF9800",
    ),
    const Categoria(
      id: "sub_003",
      parentId: "cat_001",
      name: "Bebidas",
      slug: "bebidas",
      description: "Refrescos naturales y bebidas",
      icon: "local_drink",
      color: "#FF9800",
    ),

    // Subcategorías de Ropa
    const Categoria(
      id: "sub_004",
      parentId: "cat_002",
      name: "Ropa Americana",
      slug: "ropa-americana",
      description: "Ropa usada importada",
      icon: "checkroom",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "sub_005",
      parentId: "cat_002",
      name: "Calzado",
      slug: "calzado",
      description: "Zapatos, botas y sandalias",
      icon: "emoji_food_beverage",
      color: "#9C27B0",
    ),

    // Subcategorías de Tecnología
    const Categoria(
      id: "sub_006",
      parentId: "cat_003",
      name: "Accesorios Móviles",
      slug: "accesorios-moviles",
      description: "Fundas, cargadores, audífonos",
      icon: "phone_android",
      color: "#2196F3",
    ),

    // Subcategorías de Artesanías
    const Categoria(
      id: "sub_007",
      parentId: "cat_004",
      name: "Tejidos",
      slug: "tejidos",
      description: "Tejidos andinos y tradicionales",
      icon: "palette",
      color: "#795548",
    ),
    const Categoria(
      id: "sub_008",
      parentId: "cat_004",
      name: "Cerámica",
      slug: "ceramica",
      description: "Productos de cerámica decorativa",
      icon: "pottery",
      color: "#795548",
    ),
    const Categoria(
      id: "sub_009",
      parentId: "cat_004",
      name: "Joyería",
      slug: "joyeria",
      description: "Joyería en plata y otros metales",
      icon: "diamond",
      color: "#795548",
    ),

    // Subcategorías de Hogar
    const Categoria(
      id: "sub_010",
      parentId: "cat_005",
      name: "Muebles",
      slug: "muebles",
      description: "Mesas, sillas, roperos",
      icon: "chair",
      color: "#4CAF50",
    ),

    // Subcategorías de Autopartes
    const Categoria(
      id: "sub_011",
      parentId: "cat_006",
      name: "Repuestos",
      slug: "repuestos",
      description: "Repuestos para automóviles",
      icon: "build",
      color: "#607D8B",
    ),
  ];

  // ===== CATEGORÍAS DE PRODUCTOS =====

  static final List<Categoria> _categoriasProductos = [
    const Categoria(
      id: "prod_cat_001",
      parentId: "",
      name: "Pantalones",
      slug: "pantalones",
      description: "Todo tipo de pantalones",
      icon: "style",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_cat_002",
      parentId: "",
      name: "Camisas y Blusas",
      slug: "camisas-blusas",
      description: "Camisas, blusas y tops",
      icon: "checkroom",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_cat_003",
      parentId: "",
      name: "Comidas Preparadas",
      slug: "comidas-preparadas",
      description: "Platos y comidas listas",
      icon: "restaurant",
      color: "#FF9800",
    ),
    const Categoria(
      id: "prod_cat_004",
      parentId: "",
      name: "Repuestos Automotrices",
      slug: "repuestos-automotrices",
      description: "Partes y repuestos para vehículos",
      icon: "build",
      color: "#607D8B",
    ),
    const Categoria(
      id: "prod_cat_005",
      parentId: "",
      name: "Artesanías Tradicionales",
      slug: "artesanias-tradicionales",
      description: "Artesanías y objetos decorativos",
      icon: "palette",
      color: "#795548",
    ),
    const Categoria(
      id: "prod_cat_006",
      parentId: "",
      name: "Calzado",
      slug: "calzado",
      description: "Zapatos, botas y sandalias",
      icon: "foundation",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_cat_007",
      parentId: "",
      name: "Muebles",
      slug: "muebles",
      description: "Muebles y decoración para el hogar",
      icon: "chair",
      color: "#4CAF50",
    ),
  ];

  // Subcategorías para productos
  static final List<Categoria> _subcategoriasProductos = [
    // Subcategorías de Pantalones
    const Categoria(
      id: "prod_sub_001",
      parentId: "prod_cat_001",
      name: "Jeans Levi's",
      slug: "jeans-levis",
      description: "Jeans marca Levi's",
      icon: "style",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_sub_002",
      parentId: "prod_cat_001",
      name: "Jeans Generales",
      slug: "jeans-generales",
      description: "Jeans de diversas marcas",
      icon: "style",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_sub_003",
      parentId: "prod_cat_001",
      name: "Pantalones de Vestir",
      slug: "pantalones-vestir",
      description: "Pantalones formales",
      icon: "style",
      color: "#9C27B0",
    ),

    // Subcategorías de Camisas
    const Categoria(
      id: "prod_sub_004",
      parentId: "prod_cat_002",
      name: "Camisas de Vestir",
      slug: "camisas-vestir",
      description: "Camisas formales",
      icon: "checkroom",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_sub_005",
      parentId: "prod_cat_002",
      name: "Polos y T-Shirts",
      slug: "polos-tshirts",
      description: "Camisetas casuales",
      icon: "checkroom",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_sub_006",
      parentId: "prod_cat_002",
      name: "Blusas Femeninas",
      slug: "blusas-femeninas",
      description: "Blusas para mujeres",
      icon: "checkroom",
      color: "#9C27B0",
    ),

    // Subcategorías de Comidas
    const Categoria(
      id: "prod_sub_007",
      parentId: "prod_cat_003",
      name: "Chicharrón de Cerdo",
      slug: "chicharron-cerdo",
      description: "Chicharrones tradicionales",
      icon: "restaurant",
      color: "#FF9800",
    ),
    const Categoria(
      id: "prod_sub_008",
      parentId: "prod_cat_003",
      name: "Chicharrón de Pollo",
      slug: "chicharron-pollo",
      description: "Chicharrones de pollo",
      icon: "restaurant",
      color: "#FF9800",
    ),
    const Categoria(
      id: "prod_sub_009",
      parentId: "prod_cat_003",
      name: "Papas Fritas",
      slug: "papas-fritas",
      description: "Papas fritas y acompañamientos",
      icon: "restaurant",
      color: "#FF9800",
    ),

    // Subcategorías de Repuestos
    const Categoria(
      id: "prod_sub_010",
      parentId: "prod_cat_004",
      name: "Filtros",
      slug: "filtros",
      description: "Filtros de aceite, aire y combustible",
      icon: "build",
      color: "#607D8B",
    ),
    const Categoria(
      id: "prod_sub_011",
      parentId: "prod_cat_004",
      name: "Frenos",
      slug: "frenos",
      description: "Pastillas y discos de freno",
      icon: "build",
      color: "#607D8B",
    ),
    const Categoria(
      id: "prod_sub_012",
      parentId: "prod_cat_004",
      name: "Aceites y Lubricantes",
      slug: "aceites-lubricantes",
      description: "Aceites para motor y lubricantes",
      icon: "build",
      color: "#607D8B",
    ),

    // Subcategorías de Artesanías
    const Categoria(
      id: "prod_sub_013",
      parentId: "prod_cat_005",
      name: "Textiles Andinos",
      slug: "textiles-andinos",
      description: "Tejidos tradicionales andinos",
      icon: "palette",
      color: "#795548",
    ),
    const Categoria(
      id: "prod_sub_014",
      parentId: "prod_cat_005",
      name: "Cerámica",
      slug: "ceramica",
      description: "Cerámicas y vasijas",
      icon: "palette",
      color: "#795548",
    ),
    const Categoria(
      id: "prod_sub_015",
      parentId: "prod_cat_005",
      name: "Joyería Artesanal",
      slug: "joyeria-artesanal",
      description: "Joyas hechas a mano",
      icon: "palette",
      color: "#795548",
    ),

    // Subcategorías de Calzado
    const Categoria(
      id: "prod_sub_016",
      parentId: "prod_cat_006",
      name: "Zapatos de Vestir",
      slug: "zapatos-vestir",
      description: "Calzado formal",
      icon: "foundation",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_sub_017",
      parentId: "prod_cat_006",
      name: "Zapatillas Deportivas",
      slug: "zapatillas-deportivas",
      description: "Calzado deportivo",
      icon: "foundation",
      color: "#9C27B0",
    ),
    const Categoria(
      id: "prod_sub_018",
      parentId: "prod_cat_006",
      name: "Botas",
      slug: "botas",
      description: "Botas de trabajo y casual",
      icon: "foundation",
      color: "#9C27B0",
    ),

    // Subcategorías de Muebles
    const Categoria(
      id: "prod_sub_019",
      parentId: "prod_cat_007",
      name: "Sillas",
      slug: "sillas",
      description: "Sillas de diversos tipos",
      icon: "chair",
      color: "#4CAF50",
    ),
    const Categoria(
      id: "prod_sub_020",
      parentId: "prod_cat_007",
      name: "Mesas",
      slug: "mesas",
      description: "Mesas de comedor y centro",
      icon: "chair",
      color: "#4CAF50",
    ),
    const Categoria(
      id: "prod_sub_021",
      parentId: "prod_cat_007",
      name: "Decoración",
      slug: "decoracion",
      description: "Objetos decorativos",
      icon: "chair",
      color: "#4CAF50",
    ),
  ];

  // ===== MÉTODOS PARA CATEGORÍAS DE TIENDAS =====

  static Categoria? getCategoriaById(String id) {
    try {
      return _categorias.firstWhere((categoria) => categoria.id == id);
    } catch (e) {
      return null;
    }
  }

  static Categoria? getSubcategoriaById(String id) {
    try {
      return _subcategorias.firstWhere((sub) => sub.id == id);
    } catch (e) {
      return null;
    }
  }

  static String getCategoriaNombre(String categoriaId) {
    // Buscar primero en categorías de tiendas
    final categoria = getCategoriaById(categoriaId);
    if (categoria != null) return categoria.name;

    // Buscar en categorías de productos
    final categoriaProducto = getProductoCategoriaById(categoriaId);
    return categoriaProducto?.name ?? 'Sin categoría';
  }

  static String getSubcategoriaNombre(String subcategoriaId) {
    // Buscar primero en subcategorías de tiendas
    final subcategoria = getSubcategoriaById(subcategoriaId);
    if (subcategoria != null) return subcategoria.name;

    // Buscar en subcategorías de productos
    final subcategoriaProducto = getProductoSubcategoriaById(subcategoriaId);
    return subcategoriaProducto?.name ?? 'Sin subcategoría';
  }

  static List<Categoria> getAllCategorias() {
    final todasLasCategorias = [..._categorias, ..._subcategorias];

    return _categorias.map((categoria) {
      return Categoria.withSubcategorias(
        categoria: categoria,
        todasLasCategorias: todasLasCategorias,
      );
    }).toList();
  }

  // ===== MÉTODOS PARA CATEGORÍAS DE PRODUCTOS =====

  static Categoria? getProductoCategoriaById(String categoriaId) {
    try {
      return _categoriasProductos.firstWhere(
        (categoria) => categoria.id == categoriaId,
      );
    } catch (e) {
      return null;
    }
  }

  static Categoria? getProductoSubcategoriaById(String subcategoriaId) {
    try {
      return _subcategoriasProductos.firstWhere(
        (sub) => sub.id == subcategoriaId,
      );
    } catch (e) {
      return null;
    }
  }

  static List<Categoria> getAllProductoCategorias() {
    final todasLasCategoriasProductos = [
      ..._categoriasProductos,
      ..._subcategoriasProductos,
    ];

    return _categoriasProductos.map((categoria) {
      return Categoria.withSubcategorias(
        categoria: categoria,
        todasLasCategorias: todasLasCategoriasProductos,
      );
    }).toList();
  }

  static String getProductoCategoriaNombre(String categoriaId) {
    final categoria = getProductoCategoriaById(categoriaId);
    return categoria?.name ?? 'Sin categoría';
  }

  static String getProductoSubcategoriaNombre(String subcategoriaId) {
    final subcategoria = getProductoSubcategoriaById(subcategoriaId);
    return subcategoria?.name ?? 'Sin subcategoría';
  }

  // Obtener solo categorías principales de tiendas (sin subcategorías)
  static List<Categoria> getMainCategorias() {
    return _categorias
        .where((categoria) => categoria.parentId.isEmpty)
        .toList();
  }

  // Obtener solo categorías principales de productos (sin subcategorías)
  static List<Categoria> getMainProductoCategorias() {
    return _categoriasProductos
        .where((categoria) => categoria.parentId.isEmpty)
        .toList();
  }
}
