import 'package:flutter/material.dart';
import 'package:laferia/views/admin/tiendas/components/tienda_card_mini.dart';
import 'package:laferia/views/tienda/tienda_detail_page.dart';
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
          height: 220,
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
                  return TiendaCardMini(
                    tienda: tienda,
                    onTap: () => _navigateToStoreDetail(context, tienda),
                    width: 160,
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TiendaDetailPage(tienda: tienda)),
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
