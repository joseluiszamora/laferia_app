import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/categorias/categorias.dart';
import '../../core/models/categoria.dart';

class CategoriasPage extends StatelessWidget {
  const CategoriasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriasBloc()..add(LoadCategorias()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Categorías'), elevation: 0),
        body: BlocBuilder<CategoriasBloc, CategoriasState>(
          builder: (context, state) {
            if (state is CategoriasLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoriasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (state is CategoriasLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.categorias.length,
                itemBuilder: (context, index) {
                  final categoria = state.categorias[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CategoriaCard(
                      categoria: categoria,
                      isSelected: state.selectedCategoria?.id == categoria.id,
                      onTap: () {
                        context.read<CategoriasBloc>().add(
                          SelectCategoria(categoria),
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
}

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoriaCard({
    super.key,
    required this.categoria,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isSelected ? 8 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
                isSelected
                    ? Border.all(color: theme.primaryColor, width: 2)
                    : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        _getIconData(categoria.icon),
                        color: theme.primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoria.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? theme.primaryColor : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            categoria.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                  ],
                ),

                if (categoria.subcategorias.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Subcategorías',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        categoria.subcategorias.map((subcategoria) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: theme.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              subcategoria.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'checkroom':
        return Icons.checkroom;
      case 'devices':
        return Icons.devices;
      case 'palette':
        return Icons.palette;
      case 'home':
        return Icons.home;
      case 'build':
        return Icons.build;
      default:
        return Icons.category;
    }
  }
}
