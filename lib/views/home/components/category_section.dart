import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/rubros/rubros.dart';
import '../../../core/models/rubro.dart';
import '../../rubros/categorias_page.dart';
import '../../rubros/rubros_page.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

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
              onPressed: () => _navigateToAllRubros(context),
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
                      Icon(Icons.error_outline, size: 32, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Error al cargar rubros',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              if (state is RubrosLoaded) {
                // Tomar solo los primeros 5 rubros para mostrar en el home
                final rubros = state.rubros.take(5).toList();

                if (rubros.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay rubros disponibles',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: rubros.length,
                  itemBuilder: (context, index) {
                    final rubro = rubros[index];
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: () => _navigateToRubro(context, rubro),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    index < 2
                                        ? theme.colorScheme.primary.withOpacity(
                                          0.1,
                                        )
                                        : theme.cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color:
                                      index < 2
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outline
                                              .withOpacity(0.3),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  _getIconData(rubro.icono),
                                  size: 24,
                                  color:
                                      index < 2
                                          ? theme.colorScheme.primary
                                          : theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              rubro.nombre,
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

  void _navigateToRubro(BuildContext context, Rubro rubro) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CategoriasPage(rubro: rubro)),
    );
  }

  void _navigateToAllRubros(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const RubrosPage()));
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
