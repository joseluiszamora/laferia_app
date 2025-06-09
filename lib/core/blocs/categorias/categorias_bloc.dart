import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/categoria.dart';
import 'categorias_event.dart';
import 'categorias_state.dart';

class CategoriasBloc extends Bloc<CategoriasEvent, CategoriasState> {
  CategoriasBloc() : super(CategoriasInitial()) {
    on<LoadCategorias>(_onLoadCategorias);
    on<SelectCategoria>(_onSelectCategoria);
    on<SelectSubcategoria>(_onSelectSubcategoria);
    on<FilterByCategoria>(_onFilterByCategoria);
  }

  void _onLoadCategorias(
    LoadCategorias event,
    Emitter<CategoriasState> emit,
  ) async {
    emit(CategoriasLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 300));

      // Datos de prueba de categorías
      final categorias = _getMockCategorias();

      emit(CategoriasLoaded(categorias: categorias));
    } catch (e) {
      emit(CategoriasError('Error al cargar las categorías: $e'));
    }
  }

  void _onSelectCategoria(
    SelectCategoria event,
    Emitter<CategoriasState> emit,
  ) {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;
      emit(
        currentState.copyWith(
          selectedCategoria: event.categoria,
          selectedSubcategoria: null, // Reset subcategoria al cambiar categoría
        ),
      );
    }
  }

  void _onSelectSubcategoria(
    SelectSubcategoria event,
    Emitter<CategoriasState> emit,
  ) {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;
      emit(currentState.copyWith(selectedSubcategoria: event.subcategoria));
    }
  }

  void _onFilterByCategoria(
    FilterByCategoria event,
    Emitter<CategoriasState> emit,
  ) {
    if (state is CategoriasLoaded) {
      final currentState = state as CategoriasLoaded;
      final categoria = currentState.categorias.firstWhere(
        (cat) => cat.id == event.categoriaId,
      );
      emit(currentState.copyWith(selectedCategoria: categoria));
    }
  }

  List<Categoria> _getMockCategorias() {
    return [
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
  }
}
