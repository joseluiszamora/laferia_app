import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_event.dart';
import '../../../../core/blocs/tiendas/tiendas_state.dart';
import '../../../../core/blocs/categorias/categorias_bloc.dart';
import '../../../../core/blocs/categorias/categorias_state.dart';
import '../../../../core/services/categoria_service.dart';

class TiendaSearchBar extends StatefulWidget {
  const TiendaSearchBar({super.key});

  @override
  State<TiendaSearchBar> createState() => _TiendaSearchBarState();
}

class _TiendaSearchBarState extends State<TiendaSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  String? _categoriaSeleccionada;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TiendasBloc, TiendasState>(
      builder: (context, state) {
        // Actualizar estado local basado en el estado del BLoC
        if (state is TiendasLoaded) {
          _categoriaSeleccionada = state.categoriaFiltro;
        }

        final hayFiltrosAplicados =
            (_searchController.text.isNotEmpty) ||
            (_categoriaSeleccionada != null);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText:
                            'Buscar tiendas por nombre, propietario o dirección...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<TiendasBloc>().add(
                                      const BuscarTiendas(''),
                                    );
                                  },
                                )
                                : null,
                      ),
                      onChanged: (value) {
                        context.read<TiendasBloc>().add(BuscarTiendas(value));
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Dropdown para filtrar por categoría
                  BlocBuilder<CategoriasBloc, CategoriasState>(
                    builder: (context, categoriaState) {
                      if (categoriaState is CategoriasLoaded) {
                        // Solo categorías principales
                        final categoriasDisponibles =
                            categoriaState.todasLasCategorias
                                .where(
                                  (cat) =>
                                      cat.parentId == null ||
                                      cat.parentId!.isEmpty,
                                )
                                .toList();

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _categoriaSeleccionada,
                              hint: const Text('Categoría'),
                              icon: const Icon(Icons.filter_list),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('Todas las categorías'),
                                ),
                                ...categoriasDisponibles.map((categoria) {
                                  return DropdownMenuItem(
                                    value: categoria.id,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getIconData(
                                            categoria.icon ?? 'store',
                                          ),
                                          size: 16,
                                          color: _getColorFromHex(
                                            categoria.color,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          categoria.name.length > 15
                                              ? '${categoria.name.substring(0, 15)}...'
                                              : categoria.name,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _categoriaSeleccionada = value;
                                });

                                if (value != null) {
                                  context.read<TiendasBloc>().add(
                                    FiltrarTiendasPorCategoria(value),
                                  );
                                } else {
                                  context.read<TiendasBloc>().add(
                                    LimpiarFiltros(),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),

              // Mostrar chips de filtros activos
              if (hayFiltrosAplicados) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Filtros activos:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Chip de búsqueda
                    if (_searchController.text.isNotEmpty) ...[
                      Chip(
                        label: Text(
                          'Búsqueda: "${_searchController.text}"',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blue[100],
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          _searchController.clear();
                          context.read<TiendasBloc>().add(
                            const BuscarTiendas(''),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],

                    // Chip de categoría
                    if (_categoriaSeleccionada != null) ...[
                      BlocBuilder<CategoriasBloc, CategoriasState>(
                        builder: (context, categoriaState) {
                          if (categoriaState is CategoriasLoaded) {
                            final categoria = categoriaState.todasLasCategorias
                                .firstWhere(
                                  (cat) => cat.id == _categoriaSeleccionada,
                                );

                            return Chip(
                              label: Text(
                                'Categoría: ${categoria.name}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.green[100],
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _categoriaSeleccionada = null;
                                });
                                context.read<TiendasBloc>().add(
                                  LimpiarFiltros(),
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],

                    const Spacer(),

                    // Botón para limpiar todos los filtros
                    TextButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _categoriaSeleccionada = null;
                        });
                        context.read<TiendasBloc>().add(LimpiarFiltros());
                      },
                      icon: const Icon(Icons.clear_all, size: 16),
                      label: const Text(
                        'Limpiar filtros',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
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
