import 'package:flutter/material.dart';
import '../../../core/models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onTap;

  const ProductoCard({super.key, required this.producto, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Badge de múltiples imágenes
                      if (producto.cantidadImagenes > 1)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${producto.cantidadImagenes}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Badge de favorito
                      if (producto.isFeatured)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 14,
                            ),
                          ),
                        ),

                      // Badge de oferta
                      if (producto.tieneOferta)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${producto.porcentajeDescuento.round()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Información del producto
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8), // Reducido de 12 a 8
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:
                      MainAxisSize.min, // Agregado para evitar overflow
                  children: [
                    // Nombre del producto
                    // Text(
                    //   producto.name,
                    //   style: theme.textTheme.titleSmall?.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 12, // Reducido el tamaño de fuente
                    //   ),
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    const SizedBox(height: 2), // Reducido de 4 a 2
                    // Precio y disponibilidad
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Precios
                        _buildPriceSection(theme),
                        const SizedBox(height: 4),
                        // Estado de disponibilidad y acepta ofertas
                        Row(
                          children: [
                            // Estado de disponibilidad
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    producto.isAvailable
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                producto.isAvailable ? 'Disponible' : 'Agotado',
                                style: TextStyle(
                                  fontSize: 8,
                                  color:
                                      producto.isAvailable
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Acepta ofertas
                            if (producto.acceptOffers)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Acepta ofertas',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 4), // Reducido de 6 a 4
                    // Características
                    Expanded(
                      child: Text(
                        producto.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 10, // Reducido el tamaño de fuente
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(ThemeData theme) {
    if (producto.tieneOferta) {
      // Mostrar precio original tachado y precio de oferta
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Precio original tachado
          Text(
            'Bs. ${producto.price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          // Precio de oferta
          Row(
            children: [
              Text(
                'Bs. ${producto.precioEfectivo.toStringAsFixed(0)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-${producto.porcentajeDescuento.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Mostrar precio normal
      return Text(
        'Bs. ${producto.price.toStringAsFixed(0)}',
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }
  }
}
