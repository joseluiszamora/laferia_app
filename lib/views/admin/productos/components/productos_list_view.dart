import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/admin_productos/admin_productos.dart';
import '../../../../core/models/producto.dart';
import 'producto_list_item.dart';

class ProductosListView extends StatelessWidget {
  final ScrollController scrollController;
  final bool isSelectionMode;
  final Set<int> selectedProductos;
  final Function(int, bool) onProductoSelected;
  final Function(Producto) onProductoTap;

  const ProductosListView({
    super.key,
    required this.scrollController,
    required this.isSelectionMode,
    required this.selectedProductos,
    required this.onProductoSelected,
    required this.onProductoTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminProductosBloc, AdminProductosState>(
      builder: (context, state) {
        if (state is AdminProductosLoading &&
            !(state is AdminProductosLoaded)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminProductosError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
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
                    context.read<AdminProductosBloc>().add(
                      LoadAdminProductos(),
                    );
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is AdminProductosLoaded) {
          if (state.productos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay productos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea tu primer producto para comenzar',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: scrollController,
            itemCount:
                state.hasReachedMax
                    ? state.productos.length
                    : state.productos.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.productos.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final producto = state.productos[index];
              final isSelected = selectedProductos.contains(producto.id);

              return ProductoListItem(
                producto: producto,
                isSelectionMode: isSelectionMode,
                isSelected: isSelected,
                onTap: () => onProductoTap(producto),
                onSelectionChanged: (selected) {
                  onProductoSelected(producto.id, selected);
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
