import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/supabase_tienda_service.dart';
import '../../models/tienda.dart';
import 'tiendas_event.dart';
import 'tiendas_state.dart';

class TiendasBloc extends Bloc<TiendasEvent, TiendasState> {
  TiendasBloc() : super(TiendasInitial()) {
    on<LoadTiendas>(_onLoadTiendas);
    on<SelectTienda>(_onSelectTienda);
    // Nuevos eventos para administración
    on<CrearTienda>(_onCrearTienda);
    on<ActualizarTienda>(_onActualizarTienda);
    on<EliminarTienda>(_onEliminarTienda);
    on<BuscarTiendas>(_onBuscarTiendas);
    on<FiltrarTiendasPorCategoria>(_onFiltrarTiendasPorCategoria);
    on<LimpiarFiltros>(_onLimpiarFiltros);
    on<SeleccionarParaEditar>(_onSeleccionarParaEditar);
  }

  void _onLoadTiendas(LoadTiendas event, Emitter<TiendasState> emit) async {
    emit(TiendasLoading());

    try {
      final tiendas = await SupabaseTiendaService.getAllTiendas();
      emit(TiendasLoaded(tiendas: tiendas, todasLasTiendas: tiendas));
    } catch (e) {
      emit(TiendasError('Error al cargar las tiendas: $e'));
    }
  }

  void _onSelectTienda(SelectTienda event, Emitter<TiendasState> emit) {
    if (state is TiendasLoaded) {
      final currentState = state as TiendasLoaded;
      emit(currentState.copyWith(selectedTienda: event.tienda));
    }
  }

  void _onCrearTienda(CrearTienda event, Emitter<TiendasState> emit) async {
    emit(TiendaCreandose());

    try {
      final nuevaTienda = Tienda(
        id: 0, // Se genera automáticamente en Supabase
        name: event.name,
        ownerName: event.ownerName,
        ubicacion: event.ubicacion,
        categoryId: event.categoryId,
        productos: event.productos ?? [],
        contacto: event.contacto,
        address: event.address,
        schedules: event.schedules ?? ['Jueves', 'Domingo'],
        operatingHours: event.operatingHours ?? '08:00 - 18:00',
        status: StoreStatus.active,
        averageRating: 0.0,
        totalComments: 0,
      );

      final tiendaCreada = await SupabaseTiendaService.crearTienda(nuevaTienda);
      emit(TiendaCreada(tiendaCreada));

      // Recargar la lista
      _recargarTiendas(emit);
    } catch (e) {
      emit(TiendaOperacionError('Error al crear tienda: $e'));
    }
  }

  void _onActualizarTienda(
    ActualizarTienda event,
    Emitter<TiendasState> emit,
  ) async {
    emit(TiendaActualizandose());

    try {
      final tiendaActualizada = Tienda(
        id: event.id,
        name: event.name,
        ownerName: event.ownerName,
        ubicacion: event.ubicacion,
        categoryId: event.categoryId,
        productos: event.productos ?? [],
        contacto: event.contacto,
        address: event.address,
        schedules: event.schedules ?? ['Jueves', 'Domingo'],
        operatingHours: event.operatingHours ?? '08:00 - 18:00',
        status: StoreStatus.active,
        averageRating: event.averageRating ?? 0.0,
        totalComments: 0,
        comentarios: event.comentarios ?? [],
      );

      final tiendaGuardada = await SupabaseTiendaService.actualizarTienda(
        tiendaActualizada,
      );
      emit(TiendaActualizada(tiendaGuardada));

      // Recargar la lista
      _recargarTiendas(emit);
    } catch (e) {
      emit(TiendaOperacionError('Error al actualizar tienda: $e'));
    }
  }

  void _onEliminarTienda(
    EliminarTienda event,
    Emitter<TiendasState> emit,
  ) async {
    emit(TiendaEliminandose());

    try {
      await SupabaseTiendaService.eliminarTienda(event.id);
      emit(TiendaEliminada(event.id));

      // Recargar la lista
      _recargarTiendas(emit);
    } catch (e) {
      emit(TiendaOperacionError('Error al eliminar tienda: $e'));
    }
  }

  void _onBuscarTiendas(BuscarTiendas event, Emitter<TiendasState> emit) {
    if (state is TiendasLoaded) {
      final currentState = state as TiendasLoaded;

      final nuevoEstado = currentState.copyWith(terminoBusqueda: event.termino);
      emit(nuevoEstado.copyWith(tiendas: nuevoEstado.tiendasFiltradas));
    }
  }

  void _onFiltrarTiendasPorCategoria(
    FiltrarTiendasPorCategoria event,
    Emitter<TiendasState> emit,
  ) {
    if (state is TiendasLoaded) {
      final currentState = state as TiendasLoaded;

      final nuevoEstado = currentState.copyWith(
        categoriaFiltro: event.categoriaId,
      );
      emit(nuevoEstado.copyWith(tiendas: nuevoEstado.tiendasFiltradas));
    }
  }

  void _onLimpiarFiltros(LimpiarFiltros event, Emitter<TiendasState> emit) {
    if (state is TiendasLoaded) {
      final currentState = state as TiendasLoaded;

      final nuevoEstado = currentState.copyWith(
        terminoBusqueda: '',
        categoriaFiltro: null,
        clearTerminoBusqueda: true,
        clearCategoriaFiltro: true,
      );

      emit(nuevoEstado.copyWith(tiendas: nuevoEstado.todasLasTiendas));
    }
  }

  void _onSeleccionarParaEditar(
    SeleccionarParaEditar event,
    Emitter<TiendasState> emit,
  ) {
    if (state is TiendasLoaded) {
      final currentState = state as TiendasLoaded;
      final tienda = currentState.todasLasTiendas.firstWhere(
        (t) => t.id == event.tiendaId,
      );
      emit(currentState.copyWith(tiendaParaEditar: tienda));
    }
  }

  // Método auxiliar para recargar tiendas manteniendo filtros actuales
  Future<void> _recargarTiendas(Emitter<TiendasState> emit) async {
    if (state is TiendasLoaded) {
      final currentState = state as TiendasLoaded;

      try {
        final nuevasTiendas = await SupabaseTiendaService.getAllTiendas();

        final nuevoEstado = currentState.copyWith(
          todasLasTiendas: nuevasTiendas,
        );

        emit(nuevoEstado.copyWith(tiendas: nuevoEstado.tiendasFiltradas));
      } catch (e) {
        emit(TiendaOperacionError('Error al recargar tiendas: $e'));
      }
    }
  }
}
