import 'package:flutter/material.dart';
import 'package:laferia/views/producto/components/producto_card_mini.dart';
import '../../../core/services/supabase_producto_service.dart';
import '../../../core/models/producto.dart';
import '../../producto/producto_detail_page.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

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
              "Recomendaciones para ti",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
            TextButton(
              onPressed: () => _navigateToAllRecommended(context),
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
          child: FutureBuilder<List<Producto>>(
            future: SupabaseProductoService.obtenerProductosEnOferta(limit: 10),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar productos: ${snapshot.error}',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                );
              }

              final recommendedProducts = snapshot.data ?? [];

              if (recommendedProducts.isEmpty) {
                return Center(
                  child: Text(
                    'No hay productos en oferta disponibles',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontFamily: 'Kodchasan',
                    ),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedProducts.length,
                itemBuilder: (context, index) {
                  final producto = recommendedProducts[index];
                  return ProductoCardMini(
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

  void _navigateToAllRecommended(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mostrando todos los productos recomendados...'),
        action: SnackBarAction(label: 'Filtrar', onPressed: () {}),
      ),
    );
  }
}
