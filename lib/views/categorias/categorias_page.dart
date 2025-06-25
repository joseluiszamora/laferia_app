import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/categorias/categorias.dart';
import '../../core/models/categoria.dart';
import '../../core/services/categoria_service.dart';

class CategoriasPage extends StatelessWidget {
  const CategoriasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriasBloc()..add(LoadCategorias()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categorías'),
          elevation: 0,
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<CategoriasBloc, CategoriasState>(
          builder: (context, state) {
            if (state is CategoriasLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Cargando categorías...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (state is CategoriasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar categorías',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CategoriasBloc>().add(LoadCategorias());
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (state is CategoriasLoaded) {
              // Organizar categorías jerárquicamente
              final categoriasJerarquicas = _organizarJerarquicamente(
                state.categorias,
              );

              if (categoriasJerarquicas.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay categorías disponibles',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categoriasJerarquicas.length,
                itemBuilder: (context, index) {
                  final item = categoriasJerarquicas[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CategoriaCard(
                      categoria: item.categoria,
                      nivel: item.nivel,
                      isSelected:
                          state.selectedCategoria?.id == item.categoria.id,
                      onTap: () {
                        context.read<CategoriasBloc>().add(
                          SelectCategoria(item.categoria),
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Organiza las categorías jerárquicamente con categorías principales seguidas de sus subcategorías
  List<CategoriaItem> _organizarJerarquicamente(List<Categoria> categorias) {
    final List<CategoriaItem> resultado = [];

    // Primero obtener todas las categorías principales
    final categoriasPrincipales =
        categorias
            .where((cat) => cat.parentId == null || cat.parentId!.isEmpty)
            .toList();

    // Ordenar alfabéticamente
    categoriasPrincipales.sort((a, b) => a.name.compareTo(b.name));

    // Para cada categoría principal, agregarla seguida de sus subcategorías
    for (final principal in categoriasPrincipales) {
      // Agregar la categoría principal
      resultado.add(CategoriaItem(categoria: principal, nivel: 0));

      // Agregar sus subcategorías recursivamente
      _agregarSubcategoriasRecursivamente(
        resultado,
        categorias,
        principal.id,
        1,
      );
    }

    return resultado;
  }

  /// Agrega subcategorías de forma recursiva manteniendo la jerarquía
  void _agregarSubcategoriasRecursivamente(
    List<CategoriaItem> resultado,
    List<Categoria> todasLasCategorias,
    String parentId,
    int nivel,
  ) {
    // Encontrar todas las subcategorías directas del padre actual
    final subcategorias =
        todasLasCategorias.where((cat) => cat.parentId == parentId).toList();

    // Ordenar alfabéticamente
    subcategorias.sort((a, b) => a.name.compareTo(b.name));

    // Agregar cada subcategoría y sus hijas
    for (final subcategoria in subcategorias) {
      resultado.add(CategoriaItem(categoria: subcategoria, nivel: nivel));

      // Recursivamente agregar las subcategorías de esta subcategoría
      _agregarSubcategoriasRecursivamente(
        resultado,
        todasLasCategorias,
        subcategoria.id,
        nivel + 1,
      );
    }
  }
}

/// Clase auxiliar para organizar categorías con su nivel jerárquico
class CategoriaItem {
  final Categoria categoria;
  final int nivel;

  CategoriaItem({required this.categoria, required this.nivel});
}

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final int nivel;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoriaCard({
    super.key,
    required this.categoria,
    required this.nivel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 8 : 4,
      margin: EdgeInsets.only(
        bottom: 8,
        left: (nivel * 20.0), // Indentación según el nivel jerárquico
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getColorPorNivel(nivel),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Indicadores de jerarquía para subcategorías
                if (nivel > 0) ...[
                  ...List.generate(
                    nivel,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.subdirectory_arrow_right,
                        size: 16,
                        color: _getColorPorNivel(nivel),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Icono de la categoría
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getColorFromHex(categoria.color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _getColorPorNivel(nivel).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _getIconData(categoria.icon ?? 'category'),
                    color: _getColorFromHex(categoria.color),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Información de la categoría
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Badge de nivel para categorías principales
                          if (nivel == 0) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Principal',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              categoria.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight:
                                    nivel == 0
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                color: isSelected ? theme.primaryColor : null,
                                fontSize: nivel == 0 ? 16 : 14,
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
                      if (categoria.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          categoria.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Indicador de selección
                if (isSelected)
                  Icon(Icons.check_circle, color: theme.primaryColor, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Obtiene el color según el nivel jerárquico
  Color _getColorPorNivel(int nivel) {
    switch (nivel) {
      case 0:
        return Colors.blue[300]!; // Categorías principales
      case 1:
        return Colors.orange[300]!; // Subcategorías de primer nivel
      case 2:
        return Colors.green[300]!; // Subcategorías de segundo nivel
      case 3:
        return Colors.purple[300]!; // Subcategorías de tercer nivel
      default:
        return Colors.grey[400]!; // Niveles superiores
    }
  }

  /// Convierte string hex a Color
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

  /// Obtiene el IconData basado en el nombre del icono
  IconData _getIconData(String iconName) {
    // Buscar el icono en la lista de iconos disponibles
    final iconData = CategoriaService.availableIcons.firstWhere(
      (icon) => icon['name'] == iconName,
      orElse: () => CategoriaService.availableIcons.first,
    );

    return iconData['icon'] as IconData;
  }
}
