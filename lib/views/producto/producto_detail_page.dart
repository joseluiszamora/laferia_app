import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/producto.dart';
import '../../core/blocs/ofertas/ofertas_bloc.dart';
import '../oferta/components/ofertar_producto_dialog.dart';

class ProductoDetailPage extends StatelessWidget {
  final Producto producto;

  const ProductoDetailPage({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfertasBloc(),
      child: Scaffold(
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
      ),
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
      child: Stack(
        children: [
          // Imágenes del producto
          producto.tieneImagenes
              ? PageView.builder(
                itemCount: producto.imagenesUrl.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    producto.imagenesUrl[index],
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
                  );
                },
              )
              : _buildPlaceholderImage(),

          // Indicador de múltiples imágenes
          if (producto.cantidadImagenes > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  producto.cantidadImagenes,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

          // Botón de favorito
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _toggleFavorite(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  producto.esFavorito ? Icons.favorite : Icons.favorite_border,
                  color: producto.esFavorito ? Colors.red : Colors.grey,
                  size: 24,
                ),
              ),
            ),
          ),

          // Badge de cantidad de imágenes
          if (producto.cantidadImagenes > 1)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${producto.cantidadImagenes}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleFavorite(BuildContext context) {
    // Implementar lógica para cambiar favorito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          producto.esFavorito
              ? '${producto.nombre} removido de favoritos'
              : '${producto.nombre} agregado a favoritos',
        ),
        duration: const Duration(seconds: 2),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de precios
              Expanded(child: _buildPriceSection(theme)),
              const SizedBox(width: 16),
              // Disponibilidad
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

          const SizedBox(height: 12),

          // Información de imágenes y favorito
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  icon: Icons.photo_library,
                  title: 'Imágenes',
                  content: '${producto.cantidadImagenes} disponibles',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  icon:
                      producto.esFavorito
                          ? Icons.favorite
                          : Icons.favorite_border,
                  title: 'Estado',
                  content: producto.esFavorito ? 'En favoritos' : 'No favorito',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (producto.tieneOferta) ...[
          // Precio original tachado
          Text(
            'Precio normal:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            'Bs. ${producto.precio.toStringAsFixed(0)}',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey.shade600,
              decoration: TextDecoration.lineThrough,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Precio de oferta
          Row(
            children: [
              Text(
                'Oferta especial:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Ahorro ${producto.porcentajeDescuento.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Bs. ${producto.precioEfectivo.toStringAsFixed(0)}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.red.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ] else ...[
          // Precio normal
          Text(
            'Precio:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            'Bs. ${producto.precio.toStringAsFixed(0)}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],

        // Acepta ofertas
        if (producto.aceptaOfertas) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_offer,
                  size: 16,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  'Acepta ofertas',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Información de precio
            if (producto.tieneOferta)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.red.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Precio normal: Bs. ${producto.precio.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            'Precio de oferta: Bs. ${producto.precioEfectivo.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Ahorra ${producto.porcentajeDescuento.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (producto.tieneOferta) const SizedBox(height: 12),

            // Botones de acción
            Row(
              children: [
                // Botón de contactar vendedor
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        producto.disponible
                            ? () => _contactSeller(context)
                            : null,
                    icon: const Icon(Icons.chat),
                    label: const Text('Contactar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Botón de ofertar (si acepta ofertas)
                if (producto.aceptaOfertas && producto.disponible)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showOfertarDialog(context),
                      icon: const Icon(Icons.local_offer),
                      label: const Text('Ofertar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),

                if (producto.aceptaOfertas && producto.disponible)
                  const SizedBox(width: 8),

                // Botón de consultar precio
                Expanded(
                  flex: producto.aceptaOfertas ? 1 : 2,
                  child: ElevatedButton.icon(
                    onPressed:
                        producto.disponible
                            ? () => _consultPrice(context)
                            : null,
                    icon: const Icon(Icons.price_check),
                    label: Text(
                      producto.aceptaOfertas ? 'Consultar' : 'Consultar Precio',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOfertarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OfertarProductoDialog(
          producto: producto,
          onOfertaEnviada: (double oferta) {
            // Aquí se podría manejar la oferta enviada
            // Por ejemplo, guardarla en una base de datos local o enviarla a un servidor
            debugPrint(
              'Oferta de Bs. ${oferta.toStringAsFixed(0)} enviada para ${producto.nombre}',
            );
          },
        );
      },
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
