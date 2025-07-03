import 'package:flutter/material.dart';
import '../../../core/models/comentario.dart';

class ComentarioCard extends StatelessWidget {
  final Comentario comentario;
  final VoidCallback? onEliminar;

  const ComentarioCard({super.key, required this.comentario, this.onEliminar});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con usuario y calificación
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage:
                      comentario.avatarUrl != null
                          ? NetworkImage(comentario.avatarUrl!)
                          : null,
                  child:
                      comentario.avatarUrl == null
                          ? Text(
                            comentario.nombreUsuario[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comentario.nombreUsuario,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (comentario.verificado) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue.shade600,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          _buildEstrellas(comentario.calificacion),
                          const SizedBox(width: 8),
                          Text(
                            'Hace x minutos',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          // Text(
                          //   comentario.tiempoTranscurrido,
                          //   style: TextStyle(
                          //     color: Colors.grey.shade600,
                          //     fontSize: 12,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onEliminar != null)
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _mostrarMenuOpciones(context),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Comentario
            Text(
              comentario.comentario,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),

            // Imágenes si las hay
            if (comentario.imagenes.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: comentario.imagenes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(comentario.imagenes[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEstrellas(double calificacion) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < calificacion.floor()) {
          return Icon(Icons.star, size: 16, color: Colors.amber.shade600);
        } else if (index < calificacion && calificacion % 1 != 0) {
          return Icon(Icons.star_half, size: 16, color: Colors.amber.shade600);
        } else {
          return Icon(Icons.star_border, size: 16, color: Colors.grey.shade400);
        }
      }),
    );
  }

  void _mostrarMenuOpciones(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Reportar'),
                onTap: () {
                  Navigator.pop(context);
                  // Implementar reportar
                },
              ),
              if (onEliminar != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onEliminar!();
                  },
                ),
            ],
          ),
    );
  }
}
