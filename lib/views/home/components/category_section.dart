import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/services/categoria_service.dart';
import '../../../core/blocs/categorias/categorias_bloc.dart';
import '../../../core/blocs/categorias/categorias_event.dart';
import '../../../core/blocs/categorias/categorias_state.dart';
import '../../../core/models/categoria.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  void initState() {
    super.initState();
    // Cargar las categorías principales al inicializar el widget
    context.read<CategoriasBloc>().add(LoadMainCategorias());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Buscar por categorías",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
            TextButton(
              onPressed: () => _navigateToAllCategorias(context),
              child: Text(
                "Ver Más",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Kodchasan',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: BlocBuilder<CategoriasBloc, CategoriasState>(
            builder: (context, state) {
              if (state is CategoriasLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CategoriasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 32, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Error al cargar categorías',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              if (state is CategoriasLoaded) {
                // Tomar solo las primeras 5 categorías para mostrar en el home
                final categorias = state.categorias.take(10).toList();

                if (categorias.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay categorías disponibles',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => _navigateToCategoria(context, categoria),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(
                                    categoria.color!.replaceFirst('#', '0xFF'),
                                  ),
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Color(
                                    int.parse(
                                      categoria.color!.replaceFirst(
                                        '#',
                                        '0xFF',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  _getIconData(categoria.icon!),
                                  size: 24,
                                  color: Color(
                                    int.parse(
                                      categoria.color!.replaceFirst(
                                        '#',
                                        '0xFF',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categoria.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.bodyMedium?.color,
                                fontFamily: 'Kodchasan',
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  void _navigateToCategoria(BuildContext context, Categoria categoria) {
    // TODO: Navegar a la página de productos de la categoría
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => ProductosPage(categoria: categoria)),
    // );
  }

  void _navigateToAllCategorias(BuildContext context) {
    // TODO: Navegar a la página de todas las categorías
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => const CategoriasPage()),
    // );
  }

  IconData _getIconData(String iconName) {
    final selectedIconData =
        CategoriaService.availableIcons.firstWhere(
          (icon) => icon['name'] == (iconName),
          orElse: () => CategoriaService.availableIcons.first,
        )['icon'];

    return selectedIconData ?? Icons.category;
  }
}
