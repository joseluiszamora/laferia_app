import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/comentario.dart';
import 'comentarios_event.dart';
import 'comentarios_state.dart';

class ComentariosBloc extends Bloc<ComentariosEvent, ComentariosState> {
  // Simulación de datos - en una app real vendría de un servicio
  final Map<int, List<Comentario>> _comentariosPorTienda = {};

  ComentariosBloc() : super(ComentariosInitial()) {
    on<CargarComentarios>(_onCargarComentarios);
    on<AgregarComentario>(_onAgregarComentario);
    on<EliminarComentario>(_onEliminarComentario);
    on<ActualizarComentario>(_onActualizarComentario);

    // Inicializar con datos mock
    _inicializarDatosMock();
  }

  void _inicializarDatosMock() {
    // Comentarios para Chicharrones Rosario
    _comentariosPorTienda[1] = [
      Comentario(
        id: 1,
        storeId: 1,
        userName: 'María González',
        comment:
            '¡Los mejores chicharrones de toda la feria! Muy crujientes y sabrosos. El precio es muy justo.',
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isVerified: true,
      ),
      Comentario(
        id: 2,
        storeId: 1,
        userName: 'Carlos Mendoza',
        comment:
            'Excelente sabor, pero a veces hay que esperar un poco. Vale la pena la espera.',
        rating: 4.0,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Comentario(
        id: 3,
        storeId: 1,
        userName: 'Ana Rodríguez',
        comment:
            'Muy buenos, aunque me gustaría que tuvieran más variedad de salsas.',
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        isVerified: true,
      ),
    ];

    // Comentarios para Autopartes Gonzalo
    _comentariosPorTienda[2] = [
      Comentario(
        id: 4,
        storeId: 2,
        userName: 'Pedro Mamani',
        comment:
            'Encontré justo la pieza que necesitaba para mi auto. Precios accesibles y buena atención.',
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isVerified: true,
      ),
      Comentario(
        id: 5,
        storeId: 2,
        userName: 'Luis Quispe',
        comment:
            'Gran variedad de repuestos. El dueño conoce mucho del tema y te asesora bien.',
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    // Comentarios para Ropa Casual Betty
    _comentariosPorTienda[3] = [
      Comentario(
        id: 6,
        storeId: 3,
        userName: 'Sofia Huanca',
        comment:
            'Ropa de buena calidad y muy a la moda. Los precios son competitivos.',
        rating: 4.0,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        isVerified: true,
      ),
    ];

    // Comentarios para Artesanías Andinas
    _comentariosPorTienda[4] = [
      Comentario(
        id: 7,
        storeId: 4,
        userName: 'Roberto Choque',
        comment:
            'Hermosas artesanías tradicionales. Perfecto para regalos o decoración del hogar.',
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        isVerified: true,
      ),
      Comentario(
        id: 8,
        storeId: 4,
        userName: 'Elena Vargas',
        comment:
            'Trabajo muy detallado en cada pieza. Se nota la dedicación del artesano.',
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  Future<void> _onCargarComentarios(
    CargarComentarios event,
    Emitter<ComentariosState> emit,
  ) async {
    emit(ComentariosLoading());

    try {
      // Simular delay de carga
      await Future.delayed(const Duration(milliseconds: 500));

      final comentarios = _comentariosPorTienda[event.tiendaId] ?? [];

      // Ordenar comentarios por fecha (más recientes primero)
      comentarios.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final calificacionPromedio =
          comentarios.isEmpty
              ? 0.0
              : comentarios.fold(0.0, (sum, c) => sum + c.rating) /
                  comentarios.length;

      emit(
        ComentariosLoaded(
          comentarios: comentarios,
          calificacionPromedio: calificacionPromedio,
          totalComentarios: comentarios.length,
        ),
      );
    } catch (e) {
      emit(ComentariosError('Error al cargar comentarios: $e'));
    }
  }

  Future<void> _onAgregarComentario(
    AgregarComentario event,
    Emitter<ComentariosState> emit,
  ) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 300));

      final comentarios = _comentariosPorTienda[event.comentario.storeId] ?? [];
      comentarios.insert(0, event.comentario); // Agregar al inicio
      _comentariosPorTienda[event.comentario.storeId] = comentarios;

      emit(ComentarioAgregado(event.comentario));

      // Recargar comentarios
      add(CargarComentarios(event.comentario.storeId));
    } catch (e) {
      emit(ComentariosError('Error al agregar comentario: $e'));
    }
  }

  Future<void> _onEliminarComentario(
    EliminarComentario event,
    Emitter<ComentariosState> emit,
  ) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 300));

      final comentarios = _comentariosPorTienda[event.tiendaId] ?? [];
      comentarios.removeWhere((c) => c.id == event.comentarioId);
      _comentariosPorTienda[event.tiendaId] = comentarios;

      emit(ComentarioEliminado(event.comentarioId));

      // Recargar comentarios
      add(CargarComentarios(event.tiendaId));
    } catch (e) {
      emit(ComentariosError('Error al eliminar comentario: $e'));
    }
  }

  Future<void> _onActualizarComentario(
    ActualizarComentario event,
    Emitter<ComentariosState> emit,
  ) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 300));

      final comentarios = _comentariosPorTienda[event.comentario.storeId] ?? [];
      final index = comentarios.indexWhere((c) => c.id == event.comentario.id);

      if (index != -1) {
        comentarios[index] = event.comentario;
        _comentariosPorTienda[event.comentario.storeId] = comentarios;
      }

      // Recargar comentarios
      add(CargarComentarios(event.comentario.storeId));
    } catch (e) {
      emit(ComentariosError('Error al actualizar comentario: $e'));
    }
  }
}
