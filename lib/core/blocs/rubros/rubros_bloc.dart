import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/rubro.dart';
import '../../models/categoria.dart';
import 'rubros_event.dart';
import 'rubros_state.dart';

class RubrosBloc extends Bloc<RubrosEvent, RubrosState> {
  RubrosBloc() : super(const RubrosInitial()) {
    on<LoadRubros>(_onLoadRubros);
    on<SelectRubro>(_onSelectRubro);
    on<SelectCategoria>(_onSelectCategoria);
    on<SelectSubcategoria>(_onSelectSubcategoria);
    on<FilterRubros>(_onFilterRubros);
    on<ResetSelection>(_onResetSelection);
    on<LoadCategoriasByRubro>(_onLoadCategoriasByRubro);
    on<LoadSubcategoriasByCategoria>(_onLoadSubcategoriasByCategoria);
  }

  void _onLoadRubros(LoadRubros event, Emitter<RubrosState> emit) async {
    emit(const RubrosLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 500));

      // Datos de prueba de rubros
      final rubros = _getMockRubros();

      emit(RubrosLoaded(rubros: rubros, filteredRubros: rubros));
    } catch (e) {
      emit(RubrosError('Error al cargar los rubros: $e'));
    }
  }

  void _onSelectRubro(SelectRubro event, Emitter<RubrosState> emit) {
    if (state is RubrosLoaded) {
      final currentState = state as RubrosLoaded;
      emit(
        currentState.copyWith(
          selectedRubroId: event.rubroId,
          clearCategoriaSelection: true,
          clearSubcategoriaSelection: true,
        ),
      );
    }
  }

  void _onSelectCategoria(SelectCategoria event, Emitter<RubrosState> emit) {
    if (state is RubrosLoaded) {
      final currentState = state as RubrosLoaded;
      emit(
        currentState.copyWith(
          selectedRubroId: event.rubroId,
          selectedCategoriaId: event.categoriaId,
          clearSubcategoriaSelection: true,
        ),
      );
    }
  }

  void _onSelectSubcategoria(
    SelectSubcategoria event,
    Emitter<RubrosState> emit,
  ) {
    if (state is RubrosLoaded) {
      final currentState = state as RubrosLoaded;
      emit(
        currentState.copyWith(
          selectedRubroId: event.rubroId,
          selectedCategoriaId: event.categoriaId,
          selectedSubcategoriaId: event.subcategoriaId,
        ),
      );
    }
  }

  void _onFilterRubros(FilterRubros event, Emitter<RubrosState> emit) {
    if (state is RubrosLoaded) {
      final currentState = state as RubrosLoaded;
      final filteredRubros =
          event.query.isEmpty
              ? currentState.rubros
              : currentState.rubros
                  .where(
                    (rubro) =>
                        rubro.nombre.toLowerCase().contains(
                          event.query.toLowerCase(),
                        ) ||
                        rubro.descripcion.toLowerCase().contains(
                          event.query.toLowerCase(),
                        ),
                  )
                  .toList();

      emit(
        currentState.copyWith(
          filteredRubros: filteredRubros,
          searchQuery: event.query,
        ),
      );
    }
  }

  void _onResetSelection(ResetSelection event, Emitter<RubrosState> emit) {
    if (state is RubrosLoaded) {
      final currentState = state as RubrosLoaded;
      emit(
        currentState.copyWith(
          clearRubroSelection: true,
          clearCategoriaSelection: true,
          clearSubcategoriaSelection: true,
        ),
      );
    }
  }

  void _onLoadCategoriasByRubro(
    LoadCategoriasByRubro event,
    Emitter<RubrosState> emit,
  ) async {
    emit(const RubrosLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Necesitamos obtener los rubros de alguna manera
      // Opción 1: Cargar todos los rubros primero
      final rubros = _getMockRubros();
      final rubro = rubros.firstWhere(
        (r) => r.id == event.rubroId,
        orElse: () => throw Exception('Rubro no encontrado'),
      );

      emit(
        CategoriasLoaded(rubroId: event.rubroId, categorias: rubro.categorias),
      );
    } catch (e) {
      emit(RubrosError('Error al cargar las categorías: $e'));
    }
  }

  void _onLoadSubcategoriasByCategoria(
    LoadSubcategoriasByCategoria event,
    Emitter<RubrosState> emit,
  ) async {
    emit(const RubrosLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Necesitamos obtener los rubros de alguna manera
      final rubros = _getMockRubros();

      // Buscar la categoría en todos los rubros
      Categoria? categoria;
      String? rubroId;

      for (final rubro in rubros) {
        try {
          categoria = rubro.categorias.firstWhere(
            (cat) => cat.id == event.categoriaId,
          );
          rubroId = rubro.id;
          break;
        } catch (e) {
          continue;
        }
      }

      if (categoria != null && rubroId != null) {
        emit(
          SubcategoriasLoaded(
            rubroId: rubroId,
            categoriaId: event.categoriaId,
            subcategorias: categoria.subcategorias,
          ),
        );
      } else {
        emit(const RubrosError('Categoría no encontrada'));
      }
    } catch (e) {
      emit(RubrosError('Error al cargar las subcategorías: $e'));
    }
  }

  /// Datos de prueba para rubros
  List<Rubro> _getMockRubros() {
    return [
      Rubro(
        id: '1',
        nombre: 'Autopartes y repuestos',
        descripcion: 'Todo para el mantenimiento y reparación de vehículos',
        icono: 'car_repair',
        categorias: [
          Categoria(
            id: '1_1',
            nombre: 'Baterías',
            descripcion: 'Baterías para todo tipo de vehículos',
            icono: 'battery_alert',
            rubroId: '1',
            subcategorias: [
              Subcategoria(
                id: '1_1_1',
                nombre: 'Baterías de auto',
                descripcion: 'Baterías para automóviles',
                categoriaId: '1_1',
                rubroId: '1',
              ),
              Subcategoria(
                id: '1_1_2',
                nombre: 'Baterías de moto',
                descripcion: 'Baterías para motocicletas',
                categoriaId: '1_1',
                rubroId: '1',
              ),
            ],
          ),
          Categoria(
            id: '1_2',
            nombre: 'Frenos',
            descripcion: 'Sistema de frenos y componentes',
            icono: 'disc_full',
            rubroId: '1',
            subcategorias: [
              Subcategoria(
                id: '1_2_1',
                nombre: 'Pastillas de freno',
                descripcion: 'Pastillas de freno para autos',
                categoriaId: '1_2',
                rubroId: '1',
              ),
              Subcategoria(
                id: '1_2_2',
                nombre: 'Discos de freno',
                descripcion: 'Discos de freno para vehículos',
                categoriaId: '1_2',
                rubroId: '1',
              ),
            ],
          ),
          Categoria(
            id: '1_3',
            nombre: 'Llantas',
            descripcion: 'Llantas y neumáticos',
            icono: 'tire_repair',
            rubroId: '1',
            subcategorias: [
              Subcategoria(
                id: '1_3_1',
                nombre: 'Llantas de auto',
                descripcion: 'Llantas para automóviles',
                categoriaId: '1_3',
                rubroId: '1',
              ),
              Subcategoria(
                id: '1_3_2',
                nombre: 'Llantas de camión',
                descripcion: 'Llantas para camiones',
                categoriaId: '1_3',
                rubroId: '1',
              ),
            ],
          ),
        ],
      ),
      Rubro(
        id: '2',
        nombre: 'Vehículos',
        descripcion: 'Compra y venta de vehículos',
        icono: 'directions_car',
        categorias: [
          Categoria(
            id: '2_1',
            nombre: 'Autos',
            descripcion: 'Automóviles de todo tipo',
            icono: 'directions_car',
            rubroId: '2',
            subcategorias: [
              Subcategoria(
                id: '2_1_1',
                nombre: 'Hatchback',
                descripcion: 'Autos tipo hatchback',
                categoriaId: '2_1',
                rubroId: '2',
              ),
              Subcategoria(
                id: '2_1_2',
                nombre: 'Sedán',
                descripcion: 'Autos tipo sedán',
                categoriaId: '2_1',
                rubroId: '2',
              ),
              Subcategoria(
                id: '2_1_3',
                nombre: 'SUV',
                descripcion: 'Vehículos deportivos utilitarios',
                categoriaId: '2_1',
                rubroId: '2',
              ),
            ],
          ),
          Categoria(
            id: '2_2',
            nombre: 'Motos',
            descripcion: 'Motocicletas y scooters',
            icono: 'motorcycle',
            rubroId: '2',
            subcategorias: [
              Subcategoria(
                id: '2_2_1',
                nombre: 'Motos deportivas',
                descripcion: 'Motocicletas deportivas',
                categoriaId: '2_2',
                rubroId: '2',
              ),
              Subcategoria(
                id: '2_2_2',
                nombre: 'Scooters',
                descripcion: 'Scooters y motonetas',
                categoriaId: '2_2',
                rubroId: '2',
              ),
            ],
          ),
        ],
      ),
      Rubro(
        id: '3',
        nombre: 'Ropa',
        descripcion: 'Vestimenta y accesorios',
        icono: 'checkroom',
        categorias: [
          Categoria(
            id: '3_1',
            nombre: 'Ropa nueva',
            descripcion: 'Vestimenta nueva con etiquetas',
            icono: 'new_releases',
            rubroId: '3',
            subcategorias: [
              Subcategoria(
                id: '3_1_1',
                nombre: 'Jeans',
                descripcion: 'Pantalones de mezclilla',
                categoriaId: '3_1',
                rubroId: '3',
              ),
              Subcategoria(
                id: '3_1_2',
                nombre: 'Camisas',
                descripcion: 'Camisas y blusas',
                categoriaId: '3_1',
                rubroId: '3',
              ),
              Subcategoria(
                id: '3_1_3',
                nombre: 'Vestidos',
                descripcion: 'Vestidos para dama',
                categoriaId: '3_1',
                rubroId: '3',
              ),
            ],
          ),
          Categoria(
            id: '3_2',
            nombre: 'Ropa usada',
            descripcion: 'Vestimenta de segunda mano',
            icono: 'recycling',
            rubroId: '3',
            subcategorias: [
              Subcategoria(
                id: '3_2_1',
                nombre: 'Ropa casual',
                descripcion: 'Ropa casual de uso diario',
                categoriaId: '3_2',
                rubroId: '3',
              ),
              Subcategoria(
                id: '3_2_2',
                nombre: 'Ropa formal',
                descripcion: 'Ropa para ocasiones formales',
                categoriaId: '3_2',
                rubroId: '3',
              ),
            ],
          ),
        ],
      ),
      Rubro(
        id: '4',
        nombre: 'Electrónica y tecnología',
        descripcion: 'Dispositivos electrónicos y tecnológicos',
        icono: 'devices',
        categorias: [
          Categoria(
            id: '4_1',
            nombre: 'Smartphones',
            descripcion: 'Teléfonos inteligentes',
            icono: 'smartphone',
            rubroId: '4',
            subcategorias: [
              Subcategoria(
                id: '4_1_1',
                nombre: 'Android',
                descripcion: 'Teléfonos con sistema Android',
                categoriaId: '4_1',
                rubroId: '4',
              ),
              Subcategoria(
                id: '4_1_2',
                nombre: 'iPhone',
                descripcion: 'Teléfonos Apple iPhone',
                categoriaId: '4_1',
                rubroId: '4',
              ),
            ],
          ),
          Categoria(
            id: '4_2',
            nombre: 'Computadoras',
            descripcion: 'Equipos de cómputo',
            icono: 'computer',
            rubroId: '4',
            subcategorias: [
              Subcategoria(
                id: '4_2_1',
                nombre: 'Laptops',
                descripcion: 'Computadoras portátiles',
                categoriaId: '4_2',
                rubroId: '4',
              ),
              Subcategoria(
                id: '4_2_2',
                nombre: 'PC Escritorio',
                descripcion: 'Computadoras de escritorio',
                categoriaId: '4_2',
                rubroId: '4',
              ),
            ],
          ),
        ],
      ),
      Rubro(
        id: '5',
        nombre: 'Muebles y madera',
        descripcion: 'Muebles y artículos de madera',
        icono: 'chair',
        categorias: [
          Categoria(
            id: '5_1',
            nombre: 'Muebles de sala',
            descripcion: 'Muebles para sala de estar',
            icono: 'weekend',
            rubroId: '5',
            subcategorias: [
              Subcategoria(
                id: '5_1_1',
                nombre: 'Sofás',
                descripcion: 'Sofás y sillones',
                categoriaId: '5_1',
                rubroId: '5',
              ),
              Subcategoria(
                id: '5_1_2',
                nombre: 'Mesas de centro',
                descripcion: 'Mesas para sala',
                categoriaId: '5_1',
                rubroId: '5',
              ),
            ],
          ),
          Categoria(
            id: '5_2',
            nombre: 'Muebles de cocina',
            descripcion: 'Muebles para cocina',
            icono: 'kitchen',
            rubroId: '5',
            subcategorias: [
              Subcategoria(
                id: '5_2_1',
                nombre: 'Gabinetes',
                descripcion: 'Gabinetes de cocina',
                categoriaId: '5_2',
                rubroId: '5',
              ),
              Subcategoria(
                id: '5_2_2',
                nombre: 'Mesas de comedor',
                descripcion: 'Mesas para comedor',
                categoriaId: '5_2',
                rubroId: '5',
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
