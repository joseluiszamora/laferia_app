import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/producto.dart';
import 'productos_event.dart';
import 'productos_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  ProductosBloc() : super(ProductosInitial()) {
    on<LoadProductos>(_onLoadProductos);
    on<SelectProducto>(_onSelectProducto);
    on<LoadProductosBySubcategoria>(_onLoadProductosBySubcategoria);
    on<LoadProductosByCategoria>(_onLoadProductosByCategoria);
    on<LoadProductosByRubro>(_onLoadProductosByRubro);
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

  void _onLoadProductosBySubcategoria(
    LoadProductosBySubcategoria event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Filtrar productos por subcategoría
      final productos =
          _getMockProductos()
              .where(
                (producto) => producto.subcategoriaId == event.subcategoriaId,
              )
              .toList();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar productos por subcategoría: $e'));
    }
  }

  void _onLoadProductosByCategoria(
    LoadProductosByCategoria event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Filtrar productos por categoría
      final productos =
          _getMockProductos()
              .where((producto) => producto.categoriaId == event.categoriaId)
              .toList();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar productos por categoría: $e'));
    }
  }

  void _onLoadProductosByRubro(
    LoadProductosByRubro event,
    Emitter<ProductosState> emit,
  ) async {
    emit(ProductosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Filtrar productos por rubro
      final productos =
          _getMockProductos()
              .where((producto) => producto.rubroId == event.rubroId)
              .toList();

      emit(ProductosLoaded(productos: productos));
    } catch (e) {
      emit(ProductosError('Error al cargar productos por rubro: $e'));
    }
  }

  List<Producto> _getMockProductos() {
    return [
      // Productos de Ropa (Rubro 3)
      const Producto(
        id: "prod_001",
        nombre: "Jeans Levis 501",
        precio: 80,
        precioOferta: 65,
        aceptaOfertas: true,
        caracteristicas: "Talla 32, usado, buen estado, color azul clásico",
        imagenUrl:
            "https://via.placeholder.com/300x300/4285F4/FFFFFF?text=Jeans",
        categoria: "Ropa nueva",
        rubroId: "3", // Ropa
        categoriaId: "3_1", // Ropa nueva
        subcategoriaId: "3_1_1", // Jeans
        disponible: true,
      ),
      const Producto(
        id: "prod_002",
        nombre: "Camisa Ralph Lauren",
        precio: 45,
        aceptaOfertas: true,
        caracteristicas: "Talla M, seminueva, color blanco",
        imagenUrl:
            "https://via.placeholder.com/300x300/34A853/FFFFFF?text=Camisa",
        categoria: "Ropa nueva",
        rubroId: "3", // Ropa
        categoriaId: "3_1", // Ropa nueva
        subcategoriaId: "3_1_2", // Camisas
        disponible: true,
      ),
      const Producto(
        id: "prod_003",
        nombre: "Vestido floral",
        precio: 120,
        precioOferta: 95,
        aceptaOfertas: false,
        caracteristicas: "Talla S, nuevo con etiquetas, estampado floral",
        imagenUrl:
            "https://via.placeholder.com/300x300/FF9800/FFFFFF?text=Vestido",
        categoria: "Ropa nueva",
        rubroId: "3", // Ropa
        categoriaId: "3_1", // Ropa nueva
        subcategoriaId: "3_1_3", // Vestidos
        disponible: true,
      ),
      const Producto(
        id: "prod_004",
        nombre: "Jeans usados vintage",
        precio: 25,
        aceptaOfertas: true,
        caracteristicas: "Talla 30, estilo vintage, buen estado",
        imagenUrl:
            "https://via.placeholder.com/300x300/6F42C1/FFFFFF?text=Vintage",
        categoria: "Ropa usada",
        rubroId: "3", // Ropa
        categoriaId: "3_2", // Ropa usada
        subcategoriaId: "3_2_1", // Ropa casual
        disponible: true,
      ),

      // Productos de Electrónica (Rubro 4)
      const Producto(
        id: "prod_005",
        nombre: "iPhone 13",
        precio: 650,
        aceptaOfertas: true,
        caracteristicas: "128GB, color azul, estado excelente, con caja",
        imagenUrl:
            "https://via.placeholder.com/300x300/007BFF/FFFFFF?text=iPhone",
        categoria: "Smartphones",
        rubroId: "4", // Electrónica y tecnología
        categoriaId: "4_1", // Smartphones
        subcategoriaId: "4_1_2", // iPhone
        disponible: true,
      ),
      const Producto(
        id: "prod_006",
        nombre: "Samsung Galaxy S21",
        precio: 450,
        precioOferta: 380,
        aceptaOfertas: true,
        caracteristicas: "256GB, color negro, seminuevo",
        imagenUrl:
            "https://via.placeholder.com/300x300/6F42C1/FFFFFF?text=Samsung",
        categoria: "Smartphones",
        rubroId: "4", // Electrónica y tecnología
        categoriaId: "4_1", // Smartphones
        subcategoriaId: "4_1_1", // Android
        disponible: true,
      ),
      const Producto(
        id: "prod_007",
        nombre: "MacBook Air M1",
        precio: 850,
        aceptaOfertas: false,
        caracteristicas: "8GB RAM, 256GB SSD, estado excelente",
        imagenUrl:
            "https://via.placeholder.com/300x300/17A2B8/FFFFFF?text=MacBook",
        categoria: "Computadoras",
        rubroId: "4", // Electrónica y tecnología
        categoriaId: "4_2", // Computadoras
        subcategoriaId: "4_2_1", // Laptops
        disponible: true,
      ),
      const Producto(
        id: "prod_008",
        nombre: "PC Gamer Intel i7",
        precio: 1200,
        aceptaOfertas: true,
        caracteristicas: "16GB RAM, RTX 3060, SSD 512GB",
        imagenUrl: "https://via.placeholder.com/300x300/28A745/FFFFFF?text=PC",
        categoria: "Computadoras",
        rubroId: "4", // Electrónica y tecnología
        categoriaId: "4_2", // Computadoras
        subcategoriaId: "4_2_2", // PC Escritorio
        disponible: true,
      ),

      // Productos de Vehículos (Rubro 2)
      const Producto(
        id: "prod_009",
        nombre: "Toyota Corolla 2018",
        precio: 12000,
        aceptaOfertas: true,
        caracteristicas: "Automático, 80,000 km, excelente estado",
        imagenUrl:
            "https://via.placeholder.com/300x300/28A745/FFFFFF?text=Toyota",
        categoria: "Autos",
        rubroId: "2", // Vehículos
        categoriaId: "2_1", // Autos
        subcategoriaId: "2_1_2", // Sedán
        disponible: true,
      ),
      const Producto(
        id: "prod_010",
        nombre: "Honda Civic Hatchback",
        precio: 15000,
        aceptaOfertas: true,
        caracteristicas: "Manual, 60,000 km, color rojo",
        imagenUrl:
            "https://via.placeholder.com/300x300/DC3545/FFFFFF?text=Honda",
        categoria: "Autos",
        rubroId: "2", // Vehículos
        categoriaId: "2_1", // Autos
        subcategoriaId: "2_1_1", // Hatchback
        disponible: true,
      ),
      const Producto(
        id: "prod_011",
        nombre: "Yamaha FZ 150",
        precio: 3500,
        aceptaOfertas: true,
        caracteristicas: "Deportiva, 25,000 km, excelente motor",
        imagenUrl:
            "https://via.placeholder.com/300x300/FFC107/FFFFFF?text=Yamaha",
        categoria: "Motos",
        rubroId: "2", // Vehículos
        categoriaId: "2_2", // Motos
        subcategoriaId: "2_2_1", // Motos deportivas
        disponible: true,
      ),

      // Productos de Autopartes (Rubro 1)
      const Producto(
        id: "prod_012",
        nombre: "Batería Bosch 12V",
        precio: 120,
        aceptaOfertas: true,
        caracteristicas: "Para auto, nueva, 2 años de garantía",
        imagenUrl:
            "https://via.placeholder.com/300x300/FFC107/FFFFFF?text=Bateria",
        categoria: "Baterías",
        rubroId: "1", // Autopartes y repuestos
        categoriaId: "1_1", // Baterías
        subcategoriaId: "1_1_1", // Baterías de auto
        disponible: true,
      ),
      const Producto(
        id: "prod_013",
        nombre: "Batería de moto 12V",
        precio: 65,
        aceptaOfertas: true,
        caracteristicas: "Para motocicleta, nueva, marca YTX",
        imagenUrl:
            "https://via.placeholder.com/300x300/FF9800/FFFFFF?text=BatMoto",
        categoria: "Baterías",
        rubroId: "1", // Autopartes y repuestos
        categoriaId: "1_1", // Baterías
        subcategoriaId: "1_1_2", // Baterías de moto
        disponible: true,
      ),
      const Producto(
        id: "prod_014",
        nombre: "Pastillas de freno Brembo",
        precio: 85,
        aceptaOfertas: false,
        caracteristicas: "Para Toyota Corolla, nuevas, calidad premium",
        imagenUrl:
            "https://via.placeholder.com/300x300/6C757D/FFFFFF?text=Frenos",
        categoria: "Frenos",
        rubroId: "1", // Autopartes y repuestos
        categoriaId: "1_2", // Frenos
        subcategoriaId: "1_2_1", // Pastillas de freno
        disponible: true,
      ),
      const Producto(
        id: "prod_015",
        nombre: "Llantas Michelin R15",
        precio: 280,
        precioOferta: 240,
        aceptaOfertas: true,
        caracteristicas: "Set de 4 llantas, 90% de vida útil",
        imagenUrl:
            "https://via.placeholder.com/300x300/495057/FFFFFF?text=Llantas",
        categoria: "Llantas",
        rubroId: "1", // Autopartes y repuestos
        categoriaId: "1_3", // Llantas
        subcategoriaId: "1_3_1", // Llantas de auto
        disponible: true,
      ),

      // Productos de Muebles (Rubro 5)
      const Producto(
        id: "prod_016",
        nombre: "Sofá de 3 plazas",
        precio: 450,
        aceptaOfertas: true,
        caracteristicas: "Tela gris, muy cómodo, como nuevo",
        imagenUrl:
            "https://via.placeholder.com/300x300/20C997/FFFFFF?text=Sofa",
        categoria: "Muebles de sala",
        rubroId: "5", // Muebles y madera
        categoriaId: "5_1", // Muebles de sala
        subcategoriaId: "5_1_1", // Sofás
        disponible: true,
      ),
      const Producto(
        id: "prod_017",
        nombre: "Mesa de centro moderna",
        precio: 180,
        aceptaOfertas: true,
        caracteristicas: "Vidrio templado, patas de acero, excelente estado",
        imagenUrl:
            "https://via.placeholder.com/300x300/FD7E14/FFFFFF?text=Mesa",
        categoria: "Muebles de sala",
        rubroId: "5", // Muebles y madera
        categoriaId: "5_1", // Muebles de sala
        subcategoriaId: "5_1_2", // Mesas de centro
        disponible: true,
      ),
      const Producto(
        id: "prod_018",
        nombre: "Mesa de comedor familiar",
        precio: 380,
        aceptaOfertas: true,
        caracteristicas: "Madera maciza, 6 personas, barnizada",
        imagenUrl:
            "https://via.placeholder.com/300x300/8D6E63/FFFFFF?text=Comedor",
        categoria: "Muebles de cocina",
        rubroId: "5", // Muebles y madera
        categoriaId: "5_2", // Muebles de cocina
        subcategoriaId: "5_2_2", // Mesas de comedor
        disponible: true,
      ),
    ];
  }
}
