import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_event.dart';
import 'package:laferia/core/blocs/categorias/categorias_state.dart';

class CategoriaSearchBar extends StatefulWidget {
  const CategoriaSearchBar({super.key});

  @override
  State<CategoriaSearchBar> createState() => _CategoriaSearchBarState();
}

class _CategoriaSearchBarState extends State<CategoriaSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  // Estados de filtros
  String _tipoFiltroSeleccionado = 'todas';
  String _estadoFiltroSeleccionado = 'activas';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriasBloc, CategoriasState>(
      builder: (context, state) {
        // Actualizar estados locales basados en el estado del BLoC
        if (state is CategoriasLoaded) {
          _tipoFiltroSeleccionado = state.tipoFiltro ?? 'todas';
          _estadoFiltroSeleccionado = state.estadoFiltro ?? 'activas';
        }

        final hayFiltrosAplicados =
            _tipoFiltroSeleccionado != 'todas' ||
            _estadoFiltroSeleccionado != 'activas';

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
                        hintText: 'Buscar categorías...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<CategoriasBloc>().add(
                                      const BuscarCategorias(''),
                                    );
                                  },
                                )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueGrey[700]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (value) {
                        setState(() {});
                        context.read<CategoriasBloc>().add(
                          BuscarCategorias(value),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          hayFiltrosAplicados
                              ? Colors.orange[700]
                              : Colors.blueGrey[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _showFilterDialog(context);
                          },
                          tooltip: 'Filtros',
                        ),
                        if (hayFiltrosAplicados)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              // Mostrar filtros aplicados
              if (hayFiltrosAplicados) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Filtros activos: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    if (_tipoFiltroSeleccionado != 'todas') ...[
                      Chip(
                        label: Text(
                          _getTipoFiltroLabel(_tipoFiltroSeleccionado),
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blue[100],
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          context.read<CategoriasBloc>().add(
                            const AplicarFiltros(tipoFiltro: 'todas'),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (_estadoFiltroSeleccionado != 'activas') ...[
                      Chip(
                        label: Text(
                          _getEstadoFiltroLabel(_estadoFiltroSeleccionado),
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.green[100],
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          context.read<CategoriasBloc>().add(
                            const AplicarFiltros(estadoFiltro: 'activas'),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (dialogContext, setDialogState) => AlertDialog(
                  title: const Text('Filtros de Categorías'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tipo de categoría:'),
                      const SizedBox(height: 8),
                      _buildFilterChip(
                        'Todas',
                        'todas',
                        _tipoFiltroSeleccionado,
                        (value) {
                          setDialogState(() {
                            _tipoFiltroSeleccionado = value;
                          });
                        },
                      ),
                      _buildFilterChip(
                        'Principales',
                        'principales',
                        _tipoFiltroSeleccionado,
                        (value) {
                          setDialogState(() {
                            _tipoFiltroSeleccionado = value;
                          });
                        },
                      ),
                      _buildFilterChip(
                        'Subcategorías',
                        'subcategorias',
                        _tipoFiltroSeleccionado,
                        (value) {
                          setDialogState(() {
                            _tipoFiltroSeleccionado = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Estado:'),
                      const SizedBox(height: 8),
                      _buildFilterChip(
                        'Activas',
                        'activas',
                        _estadoFiltroSeleccionado,
                        (value) {
                          setDialogState(() {
                            _estadoFiltroSeleccionado = value;
                          });
                        },
                      ),
                      _buildFilterChip(
                        'Todas',
                        'todas_estado',
                        _estadoFiltroSeleccionado,
                        (value) {
                          setDialogState(() {
                            _estadoFiltroSeleccionado = value;
                          });
                        },
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
                        // Aplicar filtros
                        context.read<CategoriasBloc>().add(
                          AplicarFiltros(
                            tipoFiltro: _tipoFiltroSeleccionado,
                            estadoFiltro: _estadoFiltroSeleccionado,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Aplicar'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Limpiar filtros
                        setDialogState(() {
                          _tipoFiltroSeleccionado = 'todas';
                          _estadoFiltroSeleccionado = 'activas';
                        });
                        context.read<CategoriasBloc>().add(LimpiarFiltros());
                        Navigator.of(context).pop();
                      },
                      child: const Text('Limpiar'),
                    ),
                  ],
                ),
          ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String selectedValue,
    Function(String) onSelected,
  ) {
    final selected = selectedValue == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (bool isSelected) {
          if (isSelected) {
            onSelected(value);
          }
        },
        selectedColor: Colors.blueGrey[100],
        checkmarkColor: Colors.blueGrey[700],
      ),
    );
  }

  String _getTipoFiltroLabel(String tipo) {
    switch (tipo) {
      case 'principales':
        return 'Principales';
      case 'subcategorias':
        return 'Subcategorías';
      default:
        return 'Todas';
    }
  }

  String _getEstadoFiltroLabel(String estado) {
    switch (estado) {
      case 'inactivas':
        return 'Inactivas';
      case 'todas_estado':
        return 'Todos los estados';
      default:
        return 'Activas';
    }
  }
}
