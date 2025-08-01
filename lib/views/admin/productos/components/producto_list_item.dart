import 'package:flutter/material.dart';
import '../../../../core/models/producto.dart';

class ProductoListItem extends StatelessWidget {
  final Producto producto;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(bool) onSelectionChanged;

  const ProductoListItem({
    super.key,
    required this.producto,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onSelectionChanged,
  });

  Color _getStatusColor(ProductStatus status) {
    switch (status) {
      case ProductStatus.published:
        return Colors.green;
      case ProductStatus.draft:
        return Colors.orange;
      case ProductStatus.archived:
        return Colors.blue;
      case ProductStatus.exhausted:
        return Colors.red;
    }
  }

  String _getStatusText(ProductStatus status) {
    switch (status) {
      case ProductStatus.published:
        return 'Publicado';
      case ProductStatus.draft:
        return 'Borrador';
      case ProductStatus.archived:
        return 'Archivado';
      case ProductStatus.exhausted:
        return 'Agotado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading:
            isSelectionMode
                ? Checkbox(
                  value: isSelected,
                  onChanged: (value) => onSelectionChanged(value ?? false),
                )
                : _buildProductImage(),
        title: Text(
          producto.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              producto.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (producto.sku != null) ...[
                  Text(
                    'SKU: ${producto.sku}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                ],
                Text(
                  'Stock: ${producto.stock}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        producto.stock <= producto.lowStockAlert
                            ? Colors.red
                            : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${producto.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(producto.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(producto.status),
                  width: 1,
                ),
              ),
              child: Text(
                _getStatusText(producto.status),
                style: TextStyle(
                  color: _getStatusColor(producto.status),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildProductImage() {
    if (producto.medias.isNotEmpty && producto.medias.first.url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          producto.medias.first.url,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        ),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image, color: Colors.grey, size: 30),
    );
  }
}
