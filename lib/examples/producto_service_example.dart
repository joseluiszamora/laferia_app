import 'package:flutter/material.dart';
import 'package:laferia/core/services/supabase_producto_service.dart';
import 'package:laferia/core/models/producto.dart';
import 'package:laferia/core/models/producto_atributos.dart';
import 'package:laferia/core/models/producto_medias.dart';

/// Ejemplo de uso del SupabaseProductoService
/// Este archivo muestra cómo implementar las funcionalidades principales
/// del servicio de productos en widgets de Flutter.
class ProductoServiceExample extends StatefulWidget {
  const ProductoServiceExample({super.key});

  @override
  State<ProductoServiceExample> createState() => _ProductoServiceExampleState();
}

class _ProductoServiceExampleState extends State<ProductoServiceExample> {
  List<Producto> _productos = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  /// Ejemplo 1: Cargar productos públicos con paginación
  Future<void> _cargarProductos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final productos = await SupabaseProductoService.obtenerProductosPublicos(
        limit: 20,
        offset: 0,
        ordenarPor: 'created_at',
        ascending: false,
      );

      setState(() {
        _productos = productos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Ejemplo 3: Buscar productos con filtros
  Future<void> _buscarConFiltros(String busqueda) async {
    setState(() => _isLoading = true);

    try {
      final productos = await SupabaseProductoService.obtenerProductosPublicos(
        busqueda: busqueda,
        precioMin: 50.0,
        precioMax: 1000.0,
        ordenarPor: 'price',
        ascending: true,
      );

      setState(() {
        _productos = productos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Ejemplo 4: Obtener productos en oferta
  Future<void> _cargarOfertas() async {
    setState(() => _isLoading = true);

    try {
      final ofertas = await SupabaseProductoService.obtenerProductosEnOferta(
        limit: 15,
      );

      setState(() {
        _productos = ofertas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Ejemplo 5: Crear un nuevo producto (para administradores)
  Future<void> _crearProductoEjemplo() async {
    try {
      final nuevoProducto = Producto(
        id: 0, // En inserción se genera automáticamente
        name: 'Producto de Ejemplo',
        slug: 'producto-ejemplo-${DateTime.now().millisecondsSinceEpoch}',
        description: 'Este es un producto de ejemplo creado desde la app',
        shortDescription: 'Ejemplo de producto moderno',
        sku: 'EJEMPLO-001',
        barcode: '1234567890123',
        price: 99.99,
        discountedPrice: 79.99,
        costPrice: 50.00,
        acceptOffers: true,
        stock: 100,
        lowStockAlert: 10,
        weight: 1.5,
        dimensions: {'width': 20.0, 'height': 15.0, 'depth': 10.0},
        categoryId: 1, // Debe existir en la base de datos
        brandId: 1, // Debe existir en la base de datos
        storeId: 1,
        status: ProductStatus.draft,
        isAvailable: true,
        isFeatured: false,
        metaTitle: 'Producto de Ejemplo - La Feria',
        metaDescription: 'Descripción SEO del producto de ejemplo',
        tags: ['ejemplo', 'test', 'demo'],
        viewCount: 0,
        saleCount: 0,
        atributos: [
          ProductoAtributos(
            id: 0, // Se genera automáticamente
            productId: 0, // Se asigna después de crear el producto
            name: 'Color',
            value: 'Azul',
            type: 'color',
            unity: null,
            order: 1,
            createdAt: DateTime.now(),
          ),
          ProductoAtributos(
            id: 0,
            productId: 0,
            name: 'Tamaño',
            value: 'Mediano',
            type: 'size',
            unity: 'cm',
            order: 2,
            createdAt: DateTime.now(),
          ),
        ],
        medias: [
          ProductoMedias(
            id: 0, // Se genera automáticamente
            productId: 0, // Se asigna después de crear el producto
            type: MediaType.image,
            url: 'https://via.placeholder.com/400x400?text=Producto+Ejemplo',
            thumbnailUrl: 'https://via.placeholder.com/200x200?text=Thumb',
            width: 400,
            height: 400,
            fileSize: 50000,
            order: 1,
            isMain: true,
            isActive: true,
            description: 'Imagen principal del producto',
            altText: 'Producto de ejemplo',
            metadata: {'source': 'ejemplo'},
            createdAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
      );

      final productoCreado = await SupabaseProductoService.crearProducto(
        nuevoProducto,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Producto creado: ${productoCreado.name}'),
          backgroundColor: Colors.green,
        ),
      );

      // Recargar la lista
      _cargarProductos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear producto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos - Ejemplo de Servicio'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Botones de ejemplo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: _cargarProductos,
                  child: const Text('Todos'),
                ),
                ElevatedButton(
                  onPressed: _cargarOfertas,
                  child: const Text('Ofertas'),
                ),
                ElevatedButton(
                  onPressed: () => _buscarConFiltros('ejemplo'),
                  child: const Text('Buscar "ejemplo"'),
                ),
                ElevatedButton(
                  onPressed: _crearProductoEjemplo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Crear Producto'),
                ),
              ],
            ),
          ),

          // Contenido principal
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _cargarProductos,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar productos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.red[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarProductos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_productos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay productos disponibles',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _productos.length,
      itemBuilder: (context, index) {
        final producto = _productos[index];
        return ProductoCard(
          producto: producto,
          onTap: () => _mostrarDetalleProducto(producto),
        );
      },
    );
  }

  void _mostrarDetalleProducto(Producto producto) {
    showDialog(
      context: context,
      builder: (context) => ProductoDetailDialog(producto: producto),
    );
  }
}

/// Widget para mostrar un producto en la lista
class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onTap;

  const ProductoCard({super.key, required this.producto, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child:
              producto.tieneImagenes
                  ? ClipOval(
                    child: Image.network(
                      producto.imagenPrincipal!.url,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                    ),
                  )
                  : const Icon(Icons.inventory_2),
        ),
        title: Text(
          producto.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                if (producto.tieneOferta) ...[
                  Text(
                    '\$${producto.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '\$${producto.precioEfectivo.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${producto.porcentajeDescuento.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] else
                  Text(
                    '\$${producto.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(producto.status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                producto.status.value.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (producto.acceptOffers)
              const Icon(Icons.local_offer, size: 16, color: Colors.orange),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor(ProductStatus status) {
    switch (status) {
      case ProductStatus.published:
        return Colors.green;
      case ProductStatus.draft:
        return Colors.orange;
      case ProductStatus.archived:
        return Colors.grey;
      case ProductStatus.exhausted:
        return Colors.red;
    }
  }
}

/// Dialog para mostrar detalles del producto
class ProductoDetailDialog extends StatelessWidget {
  final Producto producto;

  const ProductoDetailDialog({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      producto.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen principal
                    if (producto.tieneImagenes)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            producto.imagenPrincipal!.url,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                  ),
                                ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Descripción
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(producto.description),

                    const SizedBox(height: 16),

                    // Precio
                    Text(
                      'Precio',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (producto.tieneOferta) ...[
                      Row(
                        children: [
                          Text(
                            '\$${producto.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${producto.precioEfectivo.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Ahorras: \$${producto.ahorroEnDinero.toStringAsFixed(2)} (${producto.porcentajeDescuento.toStringAsFixed(0)}%)',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ] else
                      Text(
                        '\$${producto.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Atributos
                    if (producto.atributos.isNotEmpty) ...[
                      Text(
                        'Atributos',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            producto.atributos.map((attr) {
                              return Chip(
                                label: Text('${attr.name}: ${attr.value}'),
                                backgroundColor: Colors.blue[50],
                              );
                            }).toList(),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Información adicional
                    Text(
                      'Información',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow('Estado', producto.status.value),
                    _buildInfoRow(
                      'Disponible',
                      producto.isAvailable ? 'Sí' : 'No',
                    ),
                    _buildInfoRow(
                      'Acepta ofertas',
                      producto.acceptOffers ? 'Sí' : 'No',
                    ),
                    _buildInfoRow('Slug', producto.slug),
                    _buildInfoRow('Imágenes', '${producto.cantidadImagenes}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
