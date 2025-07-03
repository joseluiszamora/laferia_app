import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/comentarios/comentarios.dart';
import '../../../core/models/comentario.dart';
import 'comentario_card.dart';

class ComentariosSection extends StatefulWidget {
  final int tiendaId;

  const ComentariosSection({super.key, required this.tiendaId});

  @override
  State<ComentariosSection> createState() => _ComentariosSectionState();
}

class _ComentariosSectionState extends State<ComentariosSection> {
  final TextEditingController _comentarioController = TextEditingController();
  double _calificacionSeleccionada = 5.0;

  @override
  void initState() {
    super.initState();
    context.read<ComentariosBloc>().add(CargarComentarios(widget.tiendaId));
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComentariosBloc, ComentariosState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estadísticas
            _buildHeader(state),
            const SizedBox(height: 16),

            // Lista de comentarios
            _buildComentarios(state),
            const SizedBox(height: 16),

            // Formulario para agregar comentario
            _buildFormularioComentario(),
          ],
        );
      },
    );
  }

  Widget _buildHeader(ComentariosState state) {
    if (state is ComentariosLoaded) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reseñas y Comentarios',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildEstrellas(state.calificacionPromedio),
                      const SizedBox(width: 8),
                      Text(
                        '${state.calificacionPromedio.toStringAsFixed(1)} de 5',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Basado en ${state.totalComentarios} ${state.totalComentarios == 1 ? 'reseña' : 'reseñas'}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${state.calificacionPromedio.toStringAsFixed(1)}⭐',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildComentarios(ComentariosState state) {
    if (state is ComentariosLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state is ComentariosError) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 8),
            Text(
              state.mensaje,
              style: TextStyle(color: Colors.red.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ComentariosBloc>().add(
                  CargarComentarios(widget.tiendaId),
                );
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is ComentariosLoaded) {
      if (state.comentarios.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.comment_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Aún no hay comentarios',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '¡Sé el primero en dejar una reseña!',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }

      return Column(
        children:
            state.comentarios
                .map(
                  (comentario) => ComentarioCard(
                    comentario: comentario,
                    onEliminar: () => _eliminarComentario(comentario.id),
                  ),
                )
                .toList(),
      );
    }

    return Container();
  }

  Widget _buildFormularioComentario() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deja tu comentario',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Selector de calificación
          Row(
            children: [
              const Text('Tu calificación: '),
              const SizedBox(width: 8),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _calificacionSeleccionada = (index + 1).toDouble();
                      });
                    },
                    child: Icon(
                      index < _calificacionSeleccionada
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber.shade600,
                      size: 28,
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text('($_calificacionSeleccionada/5)'),
            ],
          ),
          const SizedBox(height: 16),

          // Campo de texto
          TextField(
            controller: _comentarioController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Comparte tu experiencia...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Botón enviar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _enviarComentario,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Enviar Comentario'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstrellas(double calificacion) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < calificacion.floor()) {
          return Icon(Icons.star, size: 20, color: Colors.amber.shade600);
        } else if (index < calificacion && calificacion % 1 != 0) {
          return Icon(Icons.star_half, size: 20, color: Colors.amber.shade600);
        } else {
          return Icon(Icons.star_border, size: 20, color: Colors.grey.shade400);
        }
      }),
    );
  }

  void _enviarComentario() {
    if (_comentarioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe un comentario')),
      );
      return;
    }

    final comentario = Comentario(
      id: DateTime.now().millisecondsSinceEpoch,
      storeId: widget.tiendaId,
      userName:
          'Usuario Anónimo', // En una app real vendría del usuario logueado
      comment: _comentarioController.text.trim(),
      rating: _calificacionSeleccionada,
      createdAt: DateTime.now(),
    );

    context.read<ComentariosBloc>().add(AgregarComentario(comentario));

    // Limpiar formulario
    _comentarioController.clear();
    setState(() {
      _calificacionSeleccionada = 5.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comentario enviado correctamente')),
    );
  }

  void _eliminarComentario(int comentarioId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar comentario'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar este comentario?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ComentariosBloc>().add(
                    EliminarComentario(
                      comentarioId: comentarioId,
                      tiendaId: widget.tiendaId,
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
