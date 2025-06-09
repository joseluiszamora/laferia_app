import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/rubros/rubros.dart';
import '../../core/blocs/service_locator.dart';
import '../../core/models/rubro.dart';
import '../../core/models/categoria.dart';
import 'widgets/subcategoria_card.dart';
import 'productos_page.dart';

class SubcategoriasPage extends StatelessWidget {
  final Rubro rubro;
  final Categoria categoria;

  const SubcategoriasPage({
    super.key,
    required this.rubro,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<RubrosBloc>()
                ..add(LoadSubcategoriasByCategoria(categoria.id)),
      child: _SubcategoriasPageContent(rubro: rubro, categoria: categoria),
    );
  }
}

class _SubcategoriasPageContent extends StatelessWidget {
  final Rubro rubro;
  final Categoria categoria;

  const _SubcategoriasPageContent({
    required this.rubro,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategorías - ${categoria.nombre}'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con información de la categoría
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Row(
                  children: [
                    Text(
                      rubro.nombre,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      ' > ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      categoria.nombre,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(categoria.icono),
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoria.nombre,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            categoria.descripcion,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${categoria.totalSubcategorias} subcategorías disponibles',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de subcategorías
          Expanded(
            child: BlocBuilder<RubrosBloc, RubrosState>(
              builder: (context, state) {
                if (state is RubrosLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RubrosError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar subcategorías',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RubrosBloc>().add(
                              LoadSubcategoriasByCategoria(categoria.id),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final subcategorias = categoria.subcategorias;

                if (subcategorias.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay subcategorías disponibles',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Esta categoría aún no tiene subcategorías configuradas',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: subcategorias.length,
                  itemBuilder: (context, index) {
                    final subcategoria = subcategorias[index];
                    return SubcategoriaCard(
                      subcategoria: subcategoria,
                      onTap:
                          () => _navigateToProductosPage(context, subcategoria),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProductosPage(
    BuildContext context,
    Subcategoria subcategoria,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ProductosPage(
              rubro: rubro,
              categoria: categoria,
              subcategoria: subcategoria,
            ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'car_repair':
        return Icons.car_repair;
      case 'directions_car':
        return Icons.directions_car;
      case 'checkroom':
        return Icons.checkroom;
      case 'devices':
        return Icons.devices;
      case 'chair':
        return Icons.chair;
      case 'battery_alert':
        return Icons.battery_alert;
      case 'disc_full':
        return Icons.disc_full;
      case 'tire_repair':
        return Icons.tire_repair;
      case 'motorcycle':
        return Icons.motorcycle;
      case 'new_releases':
        return Icons.new_releases;
      case 'recycling':
        return Icons.recycling;
      case 'smartphone':
        return Icons.smartphone;
      case 'computer':
        return Icons.computer;
      case 'weekend':
        return Icons.weekend;
      case 'kitchen':
        return Icons.kitchen;
      default:
        return Icons.category;
    }
  }
}
