import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_event.dart';
import '../../../../core/blocs/categorias/categorias_bloc.dart';
import '../../../../core/blocs/categorias/categorias_state.dart';
import '../../../../core/models/tienda.dart';
import '../../../../core/services/categoria_service.dart';
import '../forms/tienda_form_dialog.dart';

class TiendaCard extends StatelessWidget {
  const TiendaCard({super.key, required this.tienda});
  final Tienda tienda;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre e información básica
              Row(
                children: [
                  // Icono de la tienda
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.green[300]!),
                    ),
                    child: Icon(
                      Icons.store,
                      color: Colors.green[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Información principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tienda.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Propietario: ${tienda.nombrePropietario}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (tienda.direccion != null &&
                            tienda.direccion!.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  tienda.direccion!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  // Acciones
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _editTienda(context, tienda);
                          break;
                        case 'delete':
                          _deleteTienda(context, tienda);
                          break;
                        case 'view_location':
                          _viewLocation(context, tienda);
                          break;
                      }
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'view_location',
                            child: Row(
                              children: [
                                Icon(Icons.map, size: 20),
                                SizedBox(width: 8),
                                Text('Ver ubicación'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Eliminar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Información de categoría
              BlocBuilder<CategoriasBloc, CategoriasState>(
                builder: (context, state) {
                  if (state is CategoriasLoaded) {
                    final categoria =
                        state.todasLasCategorias
                            .where((cat) => cat.id == tienda.categoriaId)
                            .firstOrNull;

                    if (categoria != null) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getColorFromHex(
                            categoria.color,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getColorFromHex(
                              categoria.color,
                            ).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getIconData(categoria.icon ?? 'store'),
                              size: 16,
                              color: _getColorFromHex(categoria.color),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              categoria.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: _getColorFromHex(categoria.color),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Categoría no encontrada',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Información adicional
              Row(
                children: [
                  // Horarios
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tienda.horarioAtencion,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Días de atención
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            tienda.diasAtencion.join(', '),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Calificación y contacto
              Row(
                children: [
                  // Calificación
                  if (tienda.calificacion != null &&
                      tienda.calificacion! > 0) ...[
                    Icon(Icons.star, size: 16, color: Colors.amber[600]),
                    const SizedBox(width: 4),
                    Text(
                      tienda.calificacion!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' (${tienda.comentarios.length} reseñas)',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ] else ...[
                    Text(
                      'Sin calificaciones',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],

                  const Spacer(),

                  // Ubicación
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tienda.ubicacion.lat.toStringAsFixed(4)}, ${tienda.ubicacion.lng.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[700],
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editTienda(BuildContext context, Tienda tienda) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<TiendasBloc>(),
            child: BlocProvider.value(
              value: context.read<CategoriasBloc>(),
              child: TiendaFormDialog(tiendaId: tienda.id),
            ),
          ),
    );
  }

  void _deleteTienda(BuildContext context, Tienda tienda) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Está seguro que desea eliminar la tienda "${tienda.nombre}"?',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Esta acción eliminará también todos los comentarios asociados.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Esta acción no se puede deshacer.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<TiendasBloc>().add(EliminarTienda(tienda.id));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  void _viewLocation(BuildContext context, Tienda tienda) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Ubicación de ${tienda.nombre}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tienda.direccion != null &&
                    tienda.direccion!.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tienda.direccion!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.my_location, size: 20),
                          const SizedBox(width: 8),
                          const Text('Coordenadas:'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Latitud: ${tienda.ubicacion.lat}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      Text(
                        'Longitud: ${tienda.ubicacion.lng}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implementar navegación a mapa
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Función de mapa en desarrollo'),
                    ),
                  );
                },
                child: const Text('Ver en mapa'),
              ),
            ],
          ),
    );
  }

  // Método auxiliar para obtener el icono
  IconData _getIconData(String iconName) {
    final iconMap = CategoriaService.availableIcons.firstWhere(
      (icon) => icon['name'] == iconName,
      orElse: () => CategoriaService.availableIcons.first,
    );
    return iconMap['icon'] as IconData;
  }

  // Método auxiliar para obtener el color desde hex
  Color _getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.blue;
    }

    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
