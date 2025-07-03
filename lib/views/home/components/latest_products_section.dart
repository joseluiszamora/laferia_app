import 'package:flutter/material.dart';
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
          height: 220,
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
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () => _navigateToProductDetail(context, producto),
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
                            // Image section
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Center(
                                child:
                                    producto.tieneImagenes
                                        ? ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                          child: Image.network(
                                            producto.imagenPrincipal?.url ?? '',
                                            width: double.infinity,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color:
                                                    theme.colorScheme.primary,
                                              );
                                            },
                                          ),
                                        )
                                        : Icon(
                                          Icons.shopping_bag,
                                          size: 40,
                                          color: theme.colorScheme.primary,
                                        ),
                              ),
                            ),
                            // Content section
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    producto.name,
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
                                    '${producto.categoryId}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.textTheme.bodySmall?.color,
                                      fontFamily: 'Kodchasan',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${producto.price.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                          fontFamily: 'Kodchasan',
                                        ),
                                      ),
                                      if (producto.acceptOffers)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(
                                              0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.green,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            'Oferta',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Kodchasan',
                                            ),
                                          ),
                                        ),
                                    ],
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
