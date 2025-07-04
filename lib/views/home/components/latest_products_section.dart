import 'package:flutter/material.dart';
import 'package:laferia/views/producto/components/producto_card.dart';
import '../../../core/services/supabase_producto_service.dart';
import '../../../core/models/producto.dart';
import '../../producto/producto_detail_page.dart';

class LatestProductsSection extends StatelessWidget {
  const LatestProductsSection({super.key});

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
              "Últimos productos",
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
          height: 250,
          child: FutureBuilder<List<Producto>>(
            future: SupabaseProductoService.obtenerUltimosProductos(limit: 10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar productos: \\${snapshot.error}',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                );
              }

              final latestProducts = snapshot.data ?? [];

              if (latestProducts.isEmpty) {
                return Center(
                  child: Text(
                    'No hay productos recientes',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontFamily: 'Kodchasan',
                    ),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: latestProducts.length,
                itemBuilder: (context, index) {
                  final producto = latestProducts[index];
                  return ProductoCard(
                    producto: producto,
                    onTap: () => _navigateToProductDetail(context, producto),
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

  void _navigateToProductDetail(BuildContext context, Producto producto) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductoDetailPage(producto: producto),
      ),
    );
  }

  void _navigateToAllLatest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mostrando los últimos productos agregados...'),
        action: SnackBarAction(label: 'Filtrar', onPressed: () {}),
      ),
    );
  }
}
