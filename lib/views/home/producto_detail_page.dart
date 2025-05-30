import 'package:flutter/material.dart';
import '../../core/models/producto.dart';

class ProductoDetailPage extends StatelessWidget {
  final Producto producto;

  const ProductoDetailPage({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto.nombre),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareProduct(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductImageSection(producto: producto),
            _ProductInfoSection(producto: producto),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActionBar(producto: producto),
    );
  }

  void _shareProduct(BuildContext context) {
    // Implementar lógica de compartir producto
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de compartir próximamente')),
    );
  }
}

class _ProductImageSection extends StatelessWidget {
  final Producto producto;

  const _ProductImageSection({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.shade100),
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
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                    ),
                  );
                },
              )
              : _buildPlaceholderImage(),
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
          Icon(Icons.image_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Sin imagen disponible',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _ProductInfoSection extends StatelessWidget {
  final Producto producto;

  const _ProductInfoSection({required this.producto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del producto
          Text(
            producto.nombre,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Precio y disponibilidad
          Row(
            children: [
              Text(
                'Bs. ${producto.precio.toStringAsFixed(0)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      producto.disponible
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      producto.disponible ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color:
                          producto.disponible
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      producto.disponible ? 'Disponible' : 'Agotado',
                      style: TextStyle(
                        color:
                            producto.disponible
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Categoría
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
            ),
            child: Text(
              producto.categoria,
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Título de características
          Text(
            'Características',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Características del producto
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              producto.caracteristicas,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),

          const SizedBox(height: 24),

          // Información adicional
          _InfoCard(
            icon: Icons.info_outline,
            title: 'ID del Producto',
            content: producto.id,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final Producto producto;

  const _BottomActionBar({required this.producto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botón de contactar vendedor
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    producto.disponible ? () => _contactSeller(context) : null,
                icon: const Icon(Icons.chat),
                label: const Text('Contactar'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Botón de consultar precio
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed:
                    producto.disponible ? () => _consultPrice(context) : null,
                icon: const Icon(Icons.price_check),
                label: const Text('Consultar Precio'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _contactSeller(BuildContext context) {
    // Implementar lógica para contactar al vendedor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de contacto próximamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _consultPrice(BuildContext context) {
    // Implementar lógica para consultar precio
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Consultar Precio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Producto: ${producto.nombre}'),
              const SizedBox(height: 8),
              Text('Precio actual: Bs. ${producto.precio.toStringAsFixed(0)}'),
              const SizedBox(height: 16),
              const Text(
                '¿Deseas contactar al vendedor para más información sobre este producto?',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _contactSeller(context);
              },
              child: const Text('Contactar'),
            ),
          ],
        );
      },
    );
  }
}
