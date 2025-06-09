import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/rubros/rubros.dart';
import '../../core/blocs/service_locator.dart';
import '../../core/models/rubro.dart';
import '../../core/models/categoria.dart';
import 'widgets/categoria_card.dart';
import 'subcategorias_page.dart';

class CategoriasPage extends StatelessWidget {
  final Rubro rubro;

  const CategoriasPage({super.key, required this.rubro});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<RubrosBloc>()..add(LoadCategoriasByRubro(rubro.id)),
      child: _CategoriasPageContent(rubro: rubro),
    );
  }
}

class _CategoriasPageContent extends StatelessWidget {
  final Rubro rubro;

  const _CategoriasPageContent({required this.rubro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías - ${rubro.nombre}'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con información del rubro
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(rubro.icono),
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
                            rubro.nombre,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rubro.descripcion,
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
                    '${rubro.totalCategorias} categorías disponibles',
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
          // Lista de categorías
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
                          'Error al cargar categorías',
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
                              LoadCategoriasByRubro(rubro.id),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final categorias = rubro.categorias;

                if (categorias.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay categorías disponibles',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Este rubro aún no tiene categorías configuradas',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    return CategoriaCard(
                      categoria: categoria,
                      onTap:
                          () =>
                              _navigateToSubcategoriasPage(context, categoria),
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

  void _navigateToSubcategoriasPage(BuildContext context, Categoria categoria) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => SubcategoriasPage(rubro: rubro, categoria: categoria),
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
