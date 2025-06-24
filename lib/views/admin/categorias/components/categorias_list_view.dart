import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_event.dart';
import 'package:laferia/core/blocs/categorias/categorias_state.dart';
import 'package:laferia/core/models/categoria.dart';
import '../forms/categoria_form_dialog.dart';

class CategoriasListView extends StatelessWidget {
  const CategoriasListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriasBloc, CategoriasState>(
      builder: (context, state) {
        if (state is CategoriasLoaded) {
          final categorias = state.categoriasFiltradas;

          if (categorias.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No se encontraron categorías',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              return _CategoriaCard(categoria: categoria);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final Categoria categoria;

  const _CategoriaCard({required this.categoria});

  @override
  Widget build(BuildContext context) {
    final isSubcategoria =
        categoria.parentId != null && categoria.parentId!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSubcategoria ? Colors.orange[200]! : Colors.blue[200]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icono de la categoría
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getColorFromHex(categoria.color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconFromString(categoria.icon),
                        color: _getColorFromHex(categoria.color),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Información de la categoría
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (isSubcategoria) ...[
                              Icon(
                                Icons.subdirectory_arrow_right,
                                size: 16,
                                color: Colors.orange[600],
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                categoria.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categoria.slug,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (categoria.description != null &&
                            categoria.description!.isNotEmpty)
                          Text(
                            categoria.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                          _editCategoria(context, categoria);
                          break;
                        case 'delete':
                          _deleteCategoria(context, categoria);
                          break;
                        case 'subcategory':
                          _createSubcategoria(context, categoria);
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
                          if (!isSubcategoria)
                            const PopupMenuItem(
                              value: 'subcategory',
                              child: Row(
                                children: [
                                  Icon(Icons.add, size: 20),
                                  SizedBox(width: 8),
                                  Text('Agregar subcategoría'),
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

              // Chips informativos
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    isSubcategoria ? 'Subcategoría' : 'Categoría Principal',
                    isSubcategoria ? Colors.orange : Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip('Activa', Colors.green),
                  const SizedBox(width: 8),
                  if (categoria.createdAt != null)
                    _buildInfoChip(
                      'Creada: ${_formatDate(categoria.createdAt!)}',
                      Colors.grey,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.blue;
    }
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getIconFromString(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return Icons.category;
    }
    final iconMap = {
      'store': Icons.store,
      'restaurant': Icons.restaurant,
      'eco': Icons.eco,
      'checkroom': Icons.checkroom,
      'shopping_bag': Icons.shopping_bag,
      'directions_car': Icons.directions_car,
      'devices': Icons.devices,
      'menu_book': Icons.menu_book,
      'local_pharmacy': Icons.local_pharmacy,
      'build': Icons.build,
      'diamond': Icons.diamond,
      'local_florist': Icons.local_florist,
      'pets': Icons.pets,
      'face_retouching_natural': Icons.face_retouching_natural,
      'sports_soccer': Icons.sports_soccer,
      'home': Icons.home,
      'toys': Icons.toys,
      'music_note': Icons.music_note,
      'account_balance': Icons.account_balance,
      'palette': Icons.palette,
    };

    return iconMap[iconName] ?? Icons.category;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _editCategoria(BuildContext context, Categoria categoria) {
    context.read<CategoriasBloc>().add(SeleccionarParaEditar(categoria.id));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<CategoriasBloc>(),
            child: CategoriaFormDialog(categoriaId: categoria.id),
          ),
    );
  }

  void _createSubcategoria(BuildContext context, Categoria categoria) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<CategoriasBloc>(),
            child: CategoriaFormDialog(parentCategoriaId: categoria.id),
          ),
    );
  }

  void _deleteCategoria(BuildContext context, Categoria categoria) {
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
                  '¿Está seguro que desea eliminar la categoría "${categoria.name}"?',
                ),
                const SizedBox(height: 8),
                Text(
                  'Esta acción no se puede deshacer.',
                  style: TextStyle(
                    color: Colors.red[600],
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
                  context.read<CategoriasBloc>().add(
                    EliminarCategoria(categoria.id),
                  );
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
}
