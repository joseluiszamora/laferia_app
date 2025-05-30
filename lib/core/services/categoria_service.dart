import '../models/categoria.dart';

class CategoriaService {
  static final List<Categoria> _categorias = [
    const Categoria(
      id: "cat_001",
      nombre: "Comida",
      descripcion: "Restaurantes, comida rápida y bebidas",
      icono: "restaurant",
      subcategorias: [
        Subcategoria(
          id: "sub_001",
          nombre: "Chicharrón",
          descripcion: "Chicharrones y frituras",
          categoriaId: "cat_001",
        ),
        Subcategoria(
          id: "sub_002",
          nombre: "Comida Rápida",
          descripcion: "Hamburguesas, salteñas, etc.",
          categoriaId: "cat_001",
        ),
        Subcategoria(
          id: "sub_003",
          nombre: "Bebidas",
          descripcion: "Refrescos naturales y bebidas",
          categoriaId: "cat_001",
        ),
      ],
    ),
    const Categoria(
      id: "cat_002",
      nombre: "Ropa y Accesorios",
      descripcion: "Vestimenta y accesorios personales",
      icono: "checkroom",
      subcategorias: [
        Subcategoria(
          id: "sub_004",
          nombre: "Ropa Americana",
          descripcion: "Ropa usada importada",
          categoriaId: "cat_002",
        ),
        Subcategoria(
          id: "sub_005",
          nombre: "Calzado",
          descripcion: "Zapatos, botas y sandalias",
          categoriaId: "cat_002",
        ),
      ],
    ),
    const Categoria(
      id: "cat_003",
      nombre: "Tecnología",
      descripcion: "Dispositivos y accesorios tecnológicos",
      icono: "devices",
      subcategorias: [
        Subcategoria(
          id: "sub_006",
          nombre: "Accesorios Móviles",
          descripcion: "Fundas, cargadores, audífonos",
          categoriaId: "cat_003",
        ),
      ],
    ),
    const Categoria(
      id: "cat_004",
      nombre: "Artesanías",
      descripcion: "Productos artesanales y tradicionales",
      icono: "palette",
      subcategorias: [
        Subcategoria(
          id: "sub_007",
          nombre: "Tejidos",
          descripcion: "Tejidos andinos y tradicionales",
          categoriaId: "cat_004",
        ),
        Subcategoria(
          id: "sub_008",
          nombre: "Cerámica",
          descripcion: "Productos de cerámica decorativa",
          categoriaId: "cat_004",
        ),
        Subcategoria(
          id: "sub_009",
          nombre: "Joyería",
          descripcion: "Joyería en plata y otros metales",
          categoriaId: "cat_004",
        ),
      ],
    ),
    const Categoria(
      id: "cat_005",
      nombre: "Hogar",
      descripcion: "Muebles y artículos para el hogar",
      icono: "home",
      subcategorias: [
        Subcategoria(
          id: "sub_010",
          nombre: "Muebles",
          descripcion: "Mesas, sillas, roperos",
          categoriaId: "cat_005",
        ),
      ],
    ),
    const Categoria(
      id: "cat_006",
      nombre: "Autopartes",
      descripcion: "Repuestos y accesorios para vehículos",
      icono: "build",
      subcategorias: [
        Subcategoria(
          id: "sub_011",
          nombre: "Repuestos",
          descripcion: "Repuestos para automóviles",
          categoriaId: "cat_006",
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
    final categoria = getCategoriaById(categoriaId);
    return categoria?.nombre ?? 'Sin categoría';
  }

  static String getSubcategoriaNombre(String subcategoriaId) {
    final subcategoria = getSubcategoriaById(subcategoriaId);
    return subcategoria?.nombre ?? 'Sin subcategoría';
  }

  static List<Categoria> getAllCategorias() {
    return _categorias;
  }
}
