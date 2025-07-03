import 'package:flutter/material.dart';
import '../../../core/services/supabase_tienda_service.dart';
import '../../../core/models/tienda.dart';

class LatestStoresSection extends StatelessWidget {
  const LatestStoresSection({super.key});

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
              "Últimas tiendas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
            TextButton(
              onPressed: () => _navigateToAllLatest(context),
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
          height: 180,
          child: FutureBuilder<List<Tienda>>(
            future: SupabaseTiendaService.obtenerUltimasTiendas(limit: 10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar tiendas: ${snapshot.error}',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                );
              }

              final latestStores = snapshot.data ?? [];

              if (latestStores.isEmpty) {
                return Center(
                  child: Text(
                    'No hay tiendas recientes',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontFamily: 'Kodchasan',
                    ),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: latestStores.length,
                itemBuilder: (context, index) {
                  final tienda = latestStores[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () => _navigateToStoreDetail(context, tienda),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icono y nombre
                            Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.08,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.store,
                                  size: 36,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tienda.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: theme.textTheme.titleMedium?.color,
                                      fontFamily: 'Kodchasan',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tienda.ownerName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.textTheme.bodySmall?.color,
                                      fontFamily: 'Kodchasan',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    tienda.address ?? 'Sin dirección',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.textTheme.bodySmall?.color,
                                      fontFamily: 'Kodchasan',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToStoreDetail(BuildContext context, Tienda tienda) {
    // Aquí puedes navegar a la página de detalle de tienda si existe
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Detalle de tienda: ${tienda.name}')),
    );
  }

  void _navigateToAllLatest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mostrando las últimas tiendas agregadas...'),
        action: SnackBarAction(label: 'Filtrar', onPressed: () {}),
      ),
    );
  }
}
