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
                  child:
                      producto.imagenUrl != null
                          ? Image.network(
                            producto.imagenUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              );
                            },
                          )
                          : _buildPlaceholderImage(),
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
                    Text(
                      producto.nombre,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12, // Reducido el tamaño de fuente
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

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
                                    producto.disponible
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                producto.disponible ? 'Disponible' : 'Agotado',
                                style: TextStyle(
                                  fontSize: 8,
                                  color:
                                      producto.disponible
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Acepta ofertas
                            if (producto.aceptaOfertas)
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
                        producto.caracteristicas,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 10, // Reducido el tamaño de fuente
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 2), // Reducido de 4 a 2
                    // Categoría
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6, // Reducido de 8 a 6
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          6,
                        ), // Reducido de 8 a 6
                      ),
                      child: Text(
                        producto.categoria,
                        style: TextStyle(
                          fontSize: 8, // Reducido de 10 a 8
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
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

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(
            'Sin imagen',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
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
            'Bs. ${producto.precio.toStringAsFixed(0)}',
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
        'Bs. ${producto.precio.toStringAsFixed(0)}',
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }
  }
}
