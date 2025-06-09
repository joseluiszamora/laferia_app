import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/productos/productos.dart';
import '../../core/blocs/service_locator.dart';
import '../../core/models/rubro.dart';
import '../../core/models/categoria.dart';
import '../../core/models/producto.dart';

class ProductosPage extends StatelessWidget {
  final Rubro rubro;
  final Categoria categoria;
  final Subcategoria subcategoria;

  const ProductosPage({
    super.key,
    required this.rubro,
    required this.categoria,
    required this.subcategoria,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<ProductosBloc>()
                ..add(LoadProductosBySubcategoria(subcategoria.id)),
      child: _ProductosPageContent(
        rubro: rubro,
        categoria: categoria,
        subcategoria: subcategoria,
      ),
    );
  }
}

class _ProductosPageContent extends StatelessWidget {
  final Rubro rubro;
  final Categoria categoria;
  final Subcategoria subcategoria;

  const _ProductosPageContent({
    required this.rubro,
    required this.categoria,
    required this.subcategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos - ${subcategoria.nombre}'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header con información de la subcategoría
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              rubro.nombre,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              ' > ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              categoria.nombre,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              ' > ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              subcategoria.nombre,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.inventory_2,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subcategoria.nombre,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subcategoria.descripcion,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Lista de productos
          Expanded(
            child: BlocBuilder<ProductosBloc, ProductosState>(
              builder: (context, state) {
                if (state is ProductosLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductosError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar productos',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductosBloc>().add(
                              LoadProductosBySubcategoria(subcategoria.id),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductosLoaded) {
                  final productos = state.productos;

                  if (productos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay productos disponibles',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Esta subcategoría aún no tiene productos publicados',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductosBloc>().add(
                        LoadProductosBySubcategoria(subcategoria.id),
                      );
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        return _ProductCard(producto: producto);
                      },
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Producto producto;

  const _ProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Navegar a detalle del producto
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ver detalles de ${producto.nombre}'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
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
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child:
                    producto.imagenUrl != null
                        ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.network(
                            producto.imagenUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        )
                        : const Center(
                          child: Icon(
                            Icons.inventory_2,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
              ),
            ),
            // Información del producto
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (producto.tieneOferta) ...[
                      Row(
                        children: [
                          Text(
                            '\$${producto.precio.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${producto.porcentajeDescuento.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${producto.precioEfectivo.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ] else ...[
                      Text(
                        '\$${producto.precio.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
