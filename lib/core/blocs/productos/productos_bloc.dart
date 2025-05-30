import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/producto.dart';
import 'productos_event.dart';
import 'productos_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  ProductosBloc() : super(ProductosInitial()) {
    on<LoadProductos>(_onLoadProductos);
    on<SelectProducto>(_onSelectProducto);
  }

  void _onLoadProductos(
    LoadProductos event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 300));

      // Filtrar productos según los IDs recibidos
      final productos =
          _getMockProductos()
              .where((producto) => event.productosIds.contains(producto.id))
              .toList();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar los productos: $e'));
    }
  }

  void _onSelectProducto(SelectProducto event, Emitter<ProductosState> emit) {
    if (state is ProductosLoaded) {
      final currentState = state as ProductosLoaded;
      emit(currentState.copyWith(selectedProducto: event.producto));
    }
  }

  List<Producto> _getMockProductos() {
    return [
      // Productos para puesto_001 (Juan Pérez - Ropa usada americana)
      const Producto(
        id: "prod_001",
        nombre: "Jeans Levis 501",
        precio: 80,
        precioOferta: 65, // Oferta especial
        aceptaOfertas: true,
        caracteristicas: "Talla 32, usado, buen estado, color azul clásico",
        imagenUrl:
            "https://via.placeholder.com/300x300/4285F4/FFFFFF?text=Jeans",
        categoria: "Ropa usada", // Mantener por compatibilidad
        categoriaId: "prod_cat_001", // Pantalones
        subcategoriaId: "prod_sub_001", // Jeans Levi's
        disponible: true,
      ),
      const Producto(
        id: "prod_002",
        nombre: "Camisa Tommy Hilfiger",
        precio: 45,
        aceptaOfertas: true,
        caracteristicas: "Talla M, algodón 100%, como nueva",
        imagenUrl:
            "https://via.placeholder.com/300x300/34A853/FFFFFF?text=Camisa",
        categoria: "Ropa usada", // Mantener por compatibilidad
        categoriaId: "prod_cat_002", // Camisas y Blusas
        subcategoriaId: "prod_sub_004", // Camisas de Vestir
        disponible: true,
      ),
      const Producto(
        id: "prod_003",
        nombre: "Chaqueta Nike",
        precio: 120,
        precioOferta: 95, // Oferta por liquidación
        aceptaOfertas: false,
        caracteristicas: "Talla L, impermeable, deportiva",
        imagenUrl:
            "https://via.placeholder.com/300x300/EA4335/FFFFFF?text=Chaqueta",
        categoria: "Ropa usada", // Mantener por compatibilidad
        categoriaId: "prod_cat_002", // Camisas y Blusas
        subcategoriaId: "prod_sub_005", // Polos y T-Shirts
        disponible: false,
      ),

      // Productos para puesto_002 (María González - Comida rápida)
      const Producto(
        id: "prod_004",
        nombre: "Chicharrón de Cerdo",
        precio: 25,
        precioOferta: 20, // Oferta de medio día
        aceptaOfertas: false,
        caracteristicas: "Porción de 200g, crujiente, con papa y ensalada",
        imagenUrl:
            "https://via.placeholder.com/300x300/FBBC04/FFFFFF?text=Chicharron",
        categoria: "Comida rápida", // Mantener por compatibilidad
        categoriaId: "prod_cat_003", // Comidas Preparadas
        subcategoriaId: "prod_sub_007", // Chicharrón de Cerdo
        disponible: true,
      ),
      const Producto(
        id: "prod_005",
        nombre: "Chicharrón de Pollo",
        precio: 20,
        aceptaOfertas: false,
        caracteristicas: "Porción de 250g, dorado, con papas fritas",
        imagenUrl:
            "https://via.placeholder.com/300x300/FF6D01/FFFFFF?text=Pollo",
        categoria: "Comida rápida", // Mantener por compatibilidad
        categoriaId: "prod_cat_003", // Comidas Preparadas
        subcategoriaId: "prod_sub_008", // Chicharrón de Pollo
        disponible: true,
      ),
      const Producto(
        id: "prod_006",
        nombre: "Papas Fritas Especiales",
        precio: 12,
        precioOferta: 10, // Combo especial
        aceptaOfertas: false,
        caracteristicas: "Papas cortadas finas, doradas, con salsa",
        imagenUrl:
            "https://via.placeholder.com/300x300/9C27B0/FFFFFF?text=Papas",
        categoria: "Comida rápida", // Mantener por compatibilidad
        categoriaId: "prod_cat_003", // Comidas Preparadas
        subcategoriaId: "prod_sub_009", // Papas Fritas
        disponible: true,
      ),

      // Productos para puesto_003 (Carlos Mamani - Autopartes)
      const Producto(
        id: "prod_007",
        nombre: "Filtro de Aceite",
        precio: 35,
        aceptaOfertas: true,
        caracteristicas: "Compatible con Toyota, Nissan, Honda",
        imagenUrl:
            "https://via.placeholder.com/300x300/607D8B/FFFFFF?text=Filtro",
        categoria: "Autopartes", // Mantener por compatibilidad
        categoriaId: "prod_cat_004", // Repuestos Automotrices
        subcategoriaId: "prod_sub_010", // Filtros
        disponible: true,
      ),
      const Producto(
        id: "prod_008",
        nombre: "Pastillas de Freno",
        precio: 120,
        precioOferta: 100, // Liquidación de stock
        aceptaOfertas: true,
        caracteristicas: "Cerámicas, larga duración, para vehículos medianos",
        imagenUrl:
            "https://via.placeholder.com/300x300/795548/FFFFFF?text=Frenos",
        categoria: "Autopartes", // Mantener por compatibilidad
        categoriaId: "prod_cat_004", // Repuestos Automotrices
        subcategoriaId: "prod_sub_011", // Frenos
        disponible: true,
      ),
      const Producto(
        id: "prod_009",
        nombre: "Aceite de Motor 5W-30",
        precio: 85,
        aceptaOfertas: false,
        caracteristicas: "4 litros, sintético, para motores a gasolina",
        imagenUrl:
            "https://via.placeholder.com/300x300/FF9800/FFFFFF?text=Aceite",
        categoria: "Autopartes", // Mantener por compatibilidad
        categoriaId: "prod_cat_004", // Repuestos Automotrices
        subcategoriaId: "prod_sub_012", // Aceites y Lubricantes
        disponible: true,
      ),

      // Productos para puesto_004 (Ana Torres - Artesanías)
      const Producto(
        id: "prod_010",
        nombre: "Tejido Andino",
        precio: 150,
        caracteristicas: "Lana de alpaca, diseño tradicional",
        imagenUrl:
            "https://via.placeholder.com/300x300/E91E63/FFFFFF?text=Tejido",
        categoria: "Artesanías", // Mantener por compatibilidad
        categoriaId: "prod_cat_005", // Artesanías Tradicionales
        subcategoriaId: "prod_sub_013", // Textiles Andinos
        disponible: true,
      ),
      const Producto(
        id: "prod_011",
        nombre: "Cerámica Decorativa",
        precio: 75,
        caracteristicas: "Hecha a mano, motivos prehispánicos",
        imagenUrl:
            "https://via.placeholder.com/300x300/FF9800/FFFFFF?text=Cerámica",
        categoria: "Artesanías", // Mantener por compatibilidad
        categoriaId: "prod_cat_005", // Artesanías Tradicionales
        subcategoriaId: "prod_sub_014", // Cerámica
        disponible: true,
      ),
      const Producto(
        id: "prod_012",
        nombre: "Joyería en Plata",
        precio: 200,
        caracteristicas: "Plata 925, diseño exclusivo",
        imagenUrl:
            "https://via.placeholder.com/300x300/9E9E9E/FFFFFF?text=Joyería",
        categoria: "Artesanías", // Mantener por compatibilidad
        categoriaId: "prod_cat_005", // Artesanías Tradicionales
        subcategoriaId: "prod_sub_015", // Joyería Artesanal
        disponible: true,
      ),

      // Productos para puesto_005 (Roberto Silva - Zapatos y calzado)
      const Producto(
        id: "prod_013",
        nombre: "Botas de Cuero",
        precio: 180,
        caracteristicas: "Cuero genuino, número 42, color marrón",
        imagenUrl:
            "https://via.placeholder.com/300x300/8BC34A/FFFFFF?text=Botas",
        categoria: "Calzado", // Mantener por compatibilidad
        categoriaId: "prod_cat_006", // Calzado
        subcategoriaId: "prod_sub_016", // Botas
        disponible: true,
      ),
      const Producto(
        id: "prod_014",
        nombre: "Zapatillas Deportivas",
        precio: 95,
        caracteristicas: "Número 40, para running, muy cómodas",
        imagenUrl:
            "https://via.placeholder.com/300x300/00BCD4/FFFFFF?text=Zapatillas",
        categoria: "Calzado", // Mantener por compatibilidad
        categoriaId: "prod_cat_006", // Calzado
        subcategoriaId: "prod_sub_017", // Calzado Deportivo
        disponible: true,
      ),
      const Producto(
        id: "prod_015",
        nombre: "Sandalias de Verano",
        precio: 45,
        caracteristicas: "Número 38, perfectas para el calor",
        imagenUrl:
            "https://via.placeholder.com/300x300/FFEB3B/FFFFFF?text=Sandalias",
        categoria: "Calzado", // Mantener por compatibilidad
        categoriaId: "prod_cat_006", // Calzado
        subcategoriaId: "prod_sub_018", // Sandalias
        disponible: false,
      ),

      // Productos para puesto_006 (Carlos Fernández - Muebles y decoración)
      const Producto(
        id: "prod_016",
        nombre: "Mesa de Comedor",
        precio: 450,
        caracteristicas: "Madera de pino, 6 personas, barnizada",
        imagenUrl:
            "https://via.placeholder.com/300x300/8D6E63/FFFFFF?text=Mesa",
        categoria: "Muebles", // Mantener por compatibilidad
        categoriaId: "prod_cat_007", // Muebles
        subcategoriaId: "prod_sub_019", // Mesas
        disponible: true,
      ),
      const Producto(
        id: "prod_017",
        nombre: "Sillas de Madera",
        precio: 80,
        caracteristicas: "Juego de 4, tapizado en cuero sintético",
        imagenUrl:
            "https://via.placeholder.com/300x300/795548/FFFFFF?text=Sillas",
        categoria: "Muebles", // Mantener por compatibilidad
        categoriaId: "prod_cat_007", // Muebles
        subcategoriaId: "prod_sub_020", // Sillas
        disponible: true,
      ),
      const Producto(
        id: "prod_018",
        nombre: "Ropero 3 Puertas",
        precio: 650,
        caracteristicas: "Melaminico blanco, con espejo central",
        imagenUrl:
            "https://via.placeholder.com/300x300/607D8B/FFFFFF?text=Ropero",
        categoria: "Muebles", // Mantener por compatibilidad
        categoriaId: "prod_cat_007", // Muebles
        subcategoriaId: "prod_sub_021", // Roperos y Armarios
        disponible: true,
      ),
    ];
  }
}
