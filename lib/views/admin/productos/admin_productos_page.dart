import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/admin_productos/admin_productos.dart';
import '../../../core/models/producto.dart';
import 'components/productos_list_view.dart';
import 'components/productos_search_bar.dart';
import 'components/productos_filter_bar.dart';
import 'admin_producto_form_page.dart';

class AdminProductosPage extends StatefulWidget {
  const AdminProductosPage({super.key});

  @override
  State<AdminProductosPage> createState() => _AdminProductosPageState();
}

class _AdminProductosPageState extends State<AdminProductosPage> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _selectedProductos = {};
  bool _isSelectionMode = false;

  // Estados de filtros
  String? _currentSearchQuery;
  int? _currentCategoryId;
  ProductStatus? _currentStatus;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      // Cargar más productos
      final currentState = context.read<AdminProductosBloc>().state;
      if (currentState is AdminProductosLoaded && !currentState.hasReachedMax) {
        context.read<AdminProductosBloc>().add(
          LoadAdminProductos(
            offset: currentState.productos.length,
            searchQuery: _currentSearchQuery,
            categoryId: _currentCategoryId,
            status: _currentStatus,
          ),
        );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedProductos.clear();
      }
    });
  }

  void _selectProducto(int productoId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedProductos.add(productoId);
      } else {
        _selectedProductos.remove(productoId);
      }
    });
  }

  void _selectAllProductos(List<Producto> productos) {
    setState(() {
      if (_selectedProductos.length == productos.length) {
        _selectedProductos.clear();
      } else {
        _selectedProductos.clear();
        _selectedProductos.addAll(productos.map((p) => p.id));
      }
    });
  }

  void _showBulkActions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => _BulkActionsSheet(
            selectedIds: _selectedProductos.toList(),
            onAction: (action) {
              Navigator.pop(context);
              _handleBulkAction(action);
            },
          ),
    );
  }

  void _handleBulkAction(String action) {
    final bloc = context.read<AdminProductosBloc>();
    final selectedIds = _selectedProductos.toList();

    switch (action) {
      case 'publish':
        bloc.add(
          BulkUpdateStatus(
            productoIds: selectedIds,
            status: ProductStatus.published,
          ),
        );
        break;
      case 'draft':
        bloc.add(
          BulkUpdateStatus(
            productoIds: selectedIds,
            status: ProductStatus.draft,
          ),
        );
        break;
      case 'archive':
        bloc.add(
          BulkUpdateStatus(
            productoIds: selectedIds,
            status: ProductStatus.archived,
          ),
        );
        break;
      case 'delete':
        _confirmBulkDelete(selectedIds);
        break;
    }
  }

  void _confirmBulkDelete(List<int> productIds) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que deseas eliminar ${productIds.length} producto(s)? Esta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AdminProductosBloc>().add(
                    BulkDeleteProductos(productoIds: productIds),
                  );
                  _toggleSelectionMode();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminProductosBloc()..add(LoadAdminProductos()),
      child: BlocListener<AdminProductosBloc, AdminProductosState>(
        listener: (context, state) {
          if (state is AdminProductoOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AdminProductosError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Administrar Productos'),
            elevation: 0,
            actions: [
              if (_isSelectionMode) ...[
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: () {
                    final state = context.read<AdminProductosBloc>().state;
                    if (state is AdminProductosLoaded) {
                      _selectAllProductos(state.productos);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed:
                      _selectedProductos.isNotEmpty ? _showBulkActions : null,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _toggleSelectionMode,
                ),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<AdminProductosBloc>().add(
                      LoadAdminProductos(
                        searchQuery: _currentSearchQuery,
                        categoryId: _currentCategoryId,
                        status: _currentStatus,
                      ),
                    );
                  },
                  tooltip: 'Actualizar lista',
                ),
                IconButton(
                  icon: const Icon(Icons.checklist),
                  onPressed: _toggleSelectionMode,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => BlocProvider.value(
                              value: context.read<AdminProductosBloc>(),
                              child: const AdminProductoFormPage(),
                            ),
                      ),
                    );

                    // Si se creó/editó un producto, recargar la lista
                    if (result == true) {
                      context.read<AdminProductosBloc>().add(
                        LoadAdminProductos(
                          searchQuery: _currentSearchQuery,
                          categoryId: _currentCategoryId,
                          status: _currentStatus,
                        ),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
          body: Column(
            children: [
              // Barra de búsqueda
              ProductosSearchBar(
                onSearch: (query) {
                  setState(() {
                    _currentSearchQuery = query;
                  });
                  context.read<AdminProductosBloc>().add(
                    LoadAdminProductos(
                      searchQuery: _currentSearchQuery,
                      categoryId: _currentCategoryId,
                      status: _currentStatus,
                    ),
                  );
                },
              ),

              // Barra de filtros
              ProductosFilterBar(
                onFilterChanged: (categoryId, status) {
                  setState(() {
                    _currentCategoryId = categoryId;
                    _currentStatus = status;
                  });
                  context.read<AdminProductosBloc>().add(
                    LoadAdminProductos(
                      searchQuery: _currentSearchQuery,
                      categoryId: _currentCategoryId,
                      status: _currentStatus,
                    ),
                  );
                },
              ),

              // Lista de productos
              Expanded(
                child: ProductosListView(
                  scrollController: _scrollController,
                  isSelectionMode: _isSelectionMode,
                  selectedProductos: _selectedProductos,
                  onProductoSelected: _selectProducto,
                  onProductoTap: (producto) async {
                    if (_isSelectionMode) {
                      _selectProducto(
                        producto.id,
                        !_selectedProductos.contains(producto.id),
                      );
                    } else {
                      // Navegar a detalle o edición
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: context.read<AdminProductosBloc>(),
                                child: AdminProductoFormPage(
                                  producto: producto,
                                ),
                              ),
                        ),
                      );

                      // Si se editó el producto, recargar la lista
                      if (result == true) {
                        context.read<AdminProductosBloc>().add(
                          LoadAdminProductos(
                            searchQuery: _currentSearchQuery,
                            categoryId: _currentCategoryId,
                            status: _currentStatus,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),

          // Información de selección
          bottomNavigationBar:
              _isSelectionMode && _selectedProductos.isNotEmpty
                  ? Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedProductos.length} producto(s) seleccionado(s)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        ElevatedButton(
                          onPressed: _showBulkActions,
                          child: const Text('Acciones'),
                        ),
                      ],
                    ),
                  )
                  : null,
        ),
      ),
    );
  }
}

class _BulkActionsSheet extends StatelessWidget {
  final List<int> selectedIds;
  final Function(String) onAction;

  const _BulkActionsSheet({required this.selectedIds, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Acciones para ${selectedIds.length} producto(s)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.publish, color: Colors.green),
            title: const Text('Publicar'),
            onTap: () => onAction('publish'),
          ),
          ListTile(
            leading: const Icon(Icons.edit_note, color: Colors.orange),
            title: const Text('Marcar como borrador'),
            onTap: () => onAction('draft'),
          ),
          ListTile(
            leading: const Icon(Icons.archive, color: Colors.blue),
            title: const Text('Archivar'),
            onTap: () => onAction('archive'),
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Eliminar'),
            onTap: () => onAction('delete'),
          ),
        ],
      ),
    );
  }
}
