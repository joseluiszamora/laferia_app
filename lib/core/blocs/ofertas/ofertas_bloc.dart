import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/oferta.dart';
import 'ofertas_event.dart';
import 'ofertas_state.dart';

class OfertasBloc extends Bloc<OfertasEvent, OfertasState> {
  OfertasBloc() : super(OfertasInitial()) {
    on<LoadOfertas>(_onLoadOfertas);
    on<CreateOferta>(_onCreateOferta);
    on<UpdateOferta>(_onUpdateOferta);
    on<CancelOferta>(_onCancelOferta);
    on<AcceptOferta>(_onAcceptOferta);
    on<RejectOferta>(_onRejectOferta);
  }

  // Storage interno para simular una base de datos
  final List<Oferta> _ofertas = [];
  int _nextId = 1;

  void _onLoadOfertas(LoadOfertas event, Emitter<OfertasState> emit) async {
    emit(OfertasLoading());

    try {
      // Simular carga de datos
      await Future.delayed(const Duration(milliseconds: 300));

      List<Oferta> filteredOfertas = List.from(_ofertas);

      // Filtrar por producto si se especifica
      if (event.productoId != null) {
        filteredOfertas =
            filteredOfertas
                .where((o) => o.productoId == event.productoId)
                .toList();
      }

      // Filtrar por usuario si se especifica
      if (event.usuarioId != null) {
        filteredOfertas =
            filteredOfertas
                .where((o) => o.nombreUsuario == event.usuarioId)
                .toList();
      }

      // Separar ofertas enviadas y recibidas
      final ofertasEnviadas =
          filteredOfertas
              .where(
                (o) =>
                    event.usuarioId != null &&
                    o.nombreUsuario == event.usuarioId,
              )
              .toList();

      final ofertasRecibidas =
          filteredOfertas
              .where(
                (o) =>
                    event.usuarioId != null &&
                    o.nombreUsuario != event.usuarioId,
              )
              .toList();

      emit(
        OfertasLoaded(
          ofertas: filteredOfertas,
          ofertasEnviadas: ofertasEnviadas,
          ofertasRecibidas: ofertasRecibidas,
        ),
      );
    } catch (e) {
      emit(OfertasError('Error al cargar las ofertas: $e'));
    }
  }

  void _onCreateOferta(CreateOferta event, Emitter<OfertasState> emit) async {
    try {
      // Simular creación en servidor
      await Future.delayed(const Duration(milliseconds: 500));

      final nuevaOferta = Oferta(
        id: 'oferta_${_nextId++}',
        productoId: event.productoId,
        nombreUsuario: event.nombreUsuario,
        avatarUsuario: event.avatarUsuario,
        montoOferta: event.montoOferta,
        mensaje: event.mensaje,
        fechaCreacion: DateTime.now(),
        estado: EstadoOferta.pendiente,
      );

      _ofertas.add(nuevaOferta);

      emit(OfertaCreated(nuevaOferta));

      // Recargar ofertas para reflejar los cambios
      if (state is OfertasLoaded) {
        final currentState = state as OfertasLoaded;
        add(
          LoadOfertas(
            productoId: event.productoId,
            usuarioId: event.nombreUsuario,
          ),
        );
      }
    } catch (e) {
      emit(OfertasError('Error al crear la oferta: $e'));
    }
  }

  void _onUpdateOferta(UpdateOferta event, Emitter<OfertasState> emit) async {
    try {
      // Simular actualización en servidor
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _ofertas.indexWhere((o) => o.id == event.ofertaId);
      if (index == -1) {
        emit(const OfertasError('Oferta no encontrada'));
        return;
      }

      final ofertaActual = _ofertas[index];
      if (!ofertaActual.puedeEditarse) {
        emit(const OfertasError('Esta oferta no puede ser editada'));
        return;
      }

      final ofertaActualizada = ofertaActual.copyWith(
        montoOferta: event.nuevoMonto,
        mensaje: event.nuevoMensaje,
      );

      _ofertas[index] = ofertaActualizada;

      emit(OfertaUpdated(ofertaActualizada));

      // Recargar ofertas
      if (state is OfertasLoaded) {
        add(LoadOfertas());
      }
    } catch (e) {
      emit(OfertasError('Error al actualizar la oferta: $e'));
    }
  }

  void _onCancelOferta(CancelOferta event, Emitter<OfertasState> emit) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _ofertas.indexWhere((o) => o.id == event.ofertaId);
      if (index == -1) {
        emit(const OfertasError('Oferta no encontrada'));
        return;
      }

      final ofertaActual = _ofertas[index];
      if (!ofertaActual.puedeCancelarse) {
        emit(const OfertasError('Esta oferta no puede ser cancelada'));
        return;
      }

      final ofertaCancelada = ofertaActual.copyWith(
        estado: EstadoOferta.cancelada,
        fechaRespuesta: DateTime.now(),
      );

      _ofertas[index] = ofertaCancelada;

      emit(OfertaCancelled(event.ofertaId));

      // Recargar ofertas
      if (state is OfertasLoaded) {
        add(LoadOfertas());
      }
    } catch (e) {
      emit(OfertasError('Error al cancelar la oferta: $e'));
    }
  }

  void _onAcceptOferta(AcceptOferta event, Emitter<OfertasState> emit) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _ofertas.indexWhere((o) => o.id == event.ofertaId);
      if (index == -1) {
        emit(const OfertasError('Oferta no encontrada'));
        return;
      }

      final ofertaActual = _ofertas[index];
      if (ofertaActual.estado != EstadoOferta.pendiente) {
        emit(const OfertasError('Solo se pueden aceptar ofertas pendientes'));
        return;
      }

      final ofertaAceptada = ofertaActual.copyWith(
        estado: EstadoOferta.aceptada,
        fechaRespuesta: DateTime.now(),
        respuestaVendedor: event.respuestaVendedor,
      );

      _ofertas[index] = ofertaAceptada;

      emit(OfertaUpdated(ofertaAceptada));

      // Recargar ofertas
      if (state is OfertasLoaded) {
        add(LoadOfertas());
      }
    } catch (e) {
      emit(OfertasError('Error al aceptar la oferta: $e'));
    }
  }

  void _onRejectOferta(RejectOferta event, Emitter<OfertasState> emit) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _ofertas.indexWhere((o) => o.id == event.ofertaId);
      if (index == -1) {
        emit(const OfertasError('Oferta no encontrada'));
        return;
      }

      final ofertaActual = _ofertas[index];
      if (ofertaActual.estado != EstadoOferta.pendiente) {
        emit(const OfertasError('Solo se pueden rechazar ofertas pendientes'));
        return;
      }

      final ofertaRechazada = ofertaActual.copyWith(
        estado: EstadoOferta.rechazada,
        fechaRespuesta: DateTime.now(),
        respuestaVendedor: event.respuestaVendedor,
      );

      _ofertas[index] = ofertaRechazada;

      emit(OfertaUpdated(ofertaRechazada));

      // Recargar ofertas
      if (state is OfertasLoaded) {
        add(LoadOfertas());
      }
    } catch (e) {
      emit(OfertasError('Error al rechazar la oferta: $e'));
    }
  }

  /// Obtiene todas las ofertas para un producto específico
  List<Oferta> getOfertasForProducto(String productoId) {
    return _ofertas.where((o) => o.productoId == productoId).toList();
  }

  /// Obtiene todas las ofertas de un usuario específico
  List<Oferta> getOfertasForUsuario(String nombreUsuario) {
    return _ofertas.where((o) => o.nombreUsuario == nombreUsuario).toList();
  }
}
