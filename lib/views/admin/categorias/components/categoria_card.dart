import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_event.dart';
import 'package:laferia/core/blocs/categorias/categorias_state.dart';
import 'package:laferia/core/models/categoria.dart';
import 'package:laferia/core/services/categoria_service.dart';
import 'package:laferia/views/admin/categorias/forms/categoria_form_dialog.dart';

class CategoriaCard extends StatelessWidget {
  const CategoriaCard({super.key, required this.categoria});
  final Categoria categoria;

  @override
  Widget build(BuildContext context) {
    final nivel = _calcularNivelJerarquia(context);

    return Card(
      margin: EdgeInsets.only(
        bottom: 12,
        left: (nivel * 16.0), // Indentación según el nivel
      ),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _getColorPorNivel(nivel), width: 1),
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
                            if (nivel > 0) ...[
                              ...List.generate(
                                nivel,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Icon(
                                    Icons.subdirectory_arrow_right,
                                    size: 14,
                                    color: _getColorPorNivel(nivel),
                                  ),
                                ),
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
                    _getLabelNivel(nivel),
                    _getColorPorNivel(nivel),
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
    final selectedIconData =
        CategoriaService.availableIcons.firstWhere(
          (icon) => icon['name'] == (iconName ?? 'category'),
          orElse: () => CategoriaService.availableIcons.first,
        )['icon'];

    return selectedIconData ?? Icons.category;
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

  // Función para calcular el nivel jerárquico de la categoría
  int _calcularNivelJerarquia(BuildContext context) {
    if (categoria.parentId == null || categoria.parentId!.isEmpty) {
      return 0; // Categoría principal
    }

    final state = context.read<CategoriasBloc>().state;
    if (state is CategoriasLoaded) {
      int nivel = 1;
      String? currentParentId = categoria.parentId;

      while (currentParentId != null && currentParentId.isNotEmpty) {
        final parent = state.categorias.firstWhere(
          (cat) => cat.id == currentParentId,
          orElse: () => const Categoria(id: '', name: '', slug: ''),
        );

        if (parent.id.isEmpty) break;

        currentParentId = parent.parentId;
        if (currentParentId != null && currentParentId.isNotEmpty) {
          nivel++;
        }
      }

      return nivel;
    }

    return 1; // Por defecto subcategoría de primer nivel
  }

  // Función para obtener el color según el nivel jerárquico
  Color _getColorPorNivel(int nivel) {
    switch (nivel) {
      case 0:
        return Colors.blue[200]!; // Categorías principales
      case 1:
        return Colors.orange[200]!; // Subcategorías de primer nivel
      case 2:
        return Colors.green[200]!; // Subcategorías de segundo nivel
      case 3:
        return Colors.purple[200]!; // Subcategorías de tercer nivel
      default:
        return Colors.grey[200]!; // Niveles superiores
    }
  }

  // Función para obtener el label del nivel jerárquico
  String _getLabelNivel(int nivel) {
    switch (nivel) {
      case 0:
        return 'Categoría Principal';
      case 1:
        return 'Subcategoría';
      case 2:
        return 'Sub-subcategoría';
      case 3:
        return 'Nivel 4';
      default:
        return 'Nivel ${nivel + 1}';
    }
  }
}
