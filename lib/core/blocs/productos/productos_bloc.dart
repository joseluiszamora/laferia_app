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
        caracteristicas: "Talla 32, usado, buen estado",
        imagenUrl:
            "https://via.placeholder.com/300x300/4285F4/FFFFFF?text=Jeans",
        categoria: "Ropa usada",
        disponible: true,
      ),
      const Producto(
        id: "prod_002",
        nombre: "Camisa Tommy Hilfiger",
        precio: 45,
        caracteristicas: "Talla M, algodón 100%, como nueva",
        imagenUrl:
            "https://via.placeholder.com/300x300/34A853/FFFFFF?text=Camisa",
        categoria: "Ropa usada",
        disponible: true,
      ),
      const Producto(
        id: "prod_003",
        nombre: "Chaqueta Nike",
        precio: 120,
        caracteristicas: "Talla L, impermeable, deportiva",
        imagenUrl:
            "https://via.placeholder.com/300x300/EA4335/FFFFFF?text=Chaqueta",
        categoria: "Ropa usada",
        disponible: false,
      ),

      // Productos para puesto_002 (María González - Comida rápida)
      const Producto(
        id: "prod_004",
        nombre: "Hamburguesa Completa",
        precio: 25,
        caracteristicas: "Carne, lechuga, tomate, queso, papas fritas",
        imagenUrl:
            "https://via.placeholder.com/300x300/FBBC04/FFFFFF?text=Hamburguesa",
        categoria: "Comida rápida",
        disponible: true,
      ),
      const Producto(
        id: "prod_005",
        nombre: "Salteña de Pollo",
        precio: 8,
        caracteristicas: "Recién horneada, jugosa, tradicional",
        imagenUrl:
            "https://via.placeholder.com/300x300/FF6D01/FFFFFF?text=Salteña",
        categoria: "Comida rápida",
        disponible: true,
      ),
      const Producto(
        id: "prod_006",
        nombre: "Refresco Natural",
        precio: 5,
        caracteristicas: "Mocochinchi, tumbo, durazno",
        imagenUrl:
            "https://via.placeholder.com/300x300/9C27B0/FFFFFF?text=Refresco",
        categoria: "Bebidas",
        disponible: true,
      ),

      // Productos para puesto_003 (Carlos Mamani - Accesorios de celular)
      const Producto(
        id: "prod_007",
        nombre: "Funda iPhone 14",
        precio: 35,
        caracteristicas: "Silicona transparente, protección completa",
        imagenUrl:
            "https://via.placeholder.com/300x300/795548/FFFFFF?text=Funda",
        categoria: "Accesorios",
        disponible: true,
      ),
      const Producto(
        id: "prod_008",
        nombre: "Cargador Universal",
        precio: 40,
        caracteristicas: "Tipo C, carga rápida, 2 metros",
        imagenUrl:
            "https://via.placeholder.com/300x300/607D8B/FFFFFF?text=Cargador",
        categoria: "Accesorios",
        disponible: true,
      ),
      const Producto(
        id: "prod_009",
        nombre: "Audífonos Bluetooth",
        precio: 85,
        caracteristicas: "Inalámbricos, cancelación de ruido",
        imagenUrl:
            "https://via.placeholder.com/300x300/3F51B5/FFFFFF?text=Audífonos",
        categoria: "Accesorios",
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
        categoria: "Artesanías",
        disponible: true,
      ),
      const Producto(
        id: "prod_011",
        nombre: "Cerámica Decorativa",
        precio: 75,
        caracteristicas: "Hecha a mano, motivos prehispánicos",
        imagenUrl:
            "https://via.placeholder.com/300x300/FF9800/FFFFFF?text=Cerámica",
        categoria: "Artesanías",
        disponible: true,
      ),
      const Producto(
        id: "prod_012",
        nombre: "Joyería en Plata",
        precio: 200,
        caracteristicas: "Plata 925, diseño exclusivo",
        imagenUrl:
            "https://via.placeholder.com/300x300/9E9E9E/FFFFFF?text=Joyería",
        categoria: "Artesanías",
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
        categoria: "Calzado",
        disponible: true,
      ),
      const Producto(
        id: "prod_014",
        nombre: "Zapatillas Deportivas",
        precio: 95,
        caracteristicas: "Número 40, para running, muy cómodas",
        imagenUrl:
            "https://via.placeholder.com/300x300/00BCD4/FFFFFF?text=Zapatillas",
        categoria: "Calzado",
        disponible: true,
      ),
      const Producto(
        id: "prod_015",
        nombre: "Sandalias de Verano",
        precio: 45,
        caracteristicas: "Número 38, perfectas para el calor",
        imagenUrl:
            "https://via.placeholder.com/300x300/FFEB3B/FFFFFF?text=Sandalias",
        categoria: "Calzado",
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
        categoria: "Muebles",
        disponible: true,
      ),
      const Producto(
        id: "prod_017",
        nombre: "Sillas de Madera",
        precio: 80,
        caracteristicas: "Juego de 4, tapizado en cuero sintético",
        imagenUrl:
            "https://via.placeholder.com/300x300/795548/FFFFFF?text=Sillas",
        categoria: "Muebles",
        disponible: true,
      ),
      const Producto(
        id: "prod_018",
        nombre: "Ropero 3 Puertas",
        precio: 650,
        caracteristicas: "Melaminico blanco, con espejo central",
        imagenUrl:
            "https://via.placeholder.com/300x300/607D8B/FFFFFF?text=Ropero",
        categoria: "Muebles",
        disponible: true,
      ),
    ];
  }
}
