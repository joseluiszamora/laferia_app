import 'package:flutter/material.dart';
import 'package:laferia/core/models/producto.dart';

class ProductoCardMini extends StatelessWidget {
  const ProductoCardMini({
    super.key,
    required this.producto,
    required this.onTap,
    required this.width,
  });

  final Producto producto;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap,
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
                  color: theme.colorScheme.primary.withOpacity(0.1),
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
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: theme.colorScheme.primary,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green, width: 1),
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
  }
}
