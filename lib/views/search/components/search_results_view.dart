import 'package:flutter/material.dart';
import '../../../core/models/search_models.dart';
import '../../../core/models/producto.dart';
import '../../../core/models/tienda.dart';
import '../../../core/models/categoria.dart';

class SearchResultsView extends StatefulWidget {
  final SearchResults results;
  final Function(Producto)? onProductTap;
  final Function(Tienda)? onStoreTap;
  final Function(Categoria)? onCategoryTap;
  final bool showCategorizedResults;

  const SearchResultsView({
    super.key,
    required this.results,
    this.onProductTap,
    this.onStoreTap,
    this.onCategoryTap,
    this.showCategorizedResults = true,
  });

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.showCategorizedResults ? 4 : 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.results.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _buildResultsHeader(),
        if (widget.showCategorizedResults)
          _buildTabBar()
        else
          Expanded(child: _buildMixedResults()),
      ],
    );
  }

  Widget _buildResultsHeader() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '${widget.results.totalResults} resultado${widget.results.totalResults != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'para "${widget.results.query}"',
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          if (widget.results.appliedFilters.hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Filtrado',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorColor: theme.colorScheme.primary,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        tabs: [
          Tab(text: 'Todos (${widget.results.totalResults})'),
          Tab(text: 'Productos (${widget.results.products.length})'),
          Tab(text: 'Tiendas (${widget.results.stores.length})'),
          Tab(text: 'Categorías (${widget.results.categories.length})'),
        ],
      ),
    );
  }

  Widget _buildMixedResults() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Mostrar categorías primero si las hay
          if (widget.results.categories.isNotEmpty) ...[
            _buildSectionHeader('Categorías', widget.results.categories.length),
            _buildCategoriesHorizontalList(),
            const SizedBox(height: 24),
          ],

          // Mostrar productos y tiendas mezclados
          ..._buildMixedProductsAndStores(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$title ($count)',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoriesHorizontalList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.results.categories.length,
        itemBuilder: (context, index) {
          final category = widget.results.categories[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            child: _buildCategoryCard(category),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(Categoria category) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onCategoryTap?.call(category),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getCategoryIcon(category.name),
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMixedProductsAndStores() {
    final widgets = <Widget>[];
    final products = widget.results.products;
    final stores = widget.results.stores;

    int productIndex = 0;
    int storeIndex = 0;

    // Intercalar productos y tiendas
    while (productIndex < products.length || storeIndex < stores.length) {
      // Agregar 2-3 productos
      for (int i = 0; i < 3 && productIndex < products.length; i++) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildProductCard(products[productIndex]),
          ),
        );
        productIndex++;
      }

      // Agregar 1 tienda
      if (storeIndex < stores.length) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildStoreCard(stores[storeIndex]),
          ),
        );
        storeIndex++;
      }
    }

    return widgets;
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('comida') || name.contains('restaurante')) {
      return Icons.restaurant;
    } else if (name.contains('tecnolog') || name.contains('electrón')) {
      return Icons.phone_android;
    } else if (name.contains('ropa') || name.contains('moda')) {
      return Icons.checkroom;
    } else if (name.contains('hogar') || name.contains('casa')) {
      return Icons.home;
    } else if (name.contains('belleza') || name.contains('cosmét')) {
      return Icons.face;
    } else if (name.contains('deporte') || name.contains('fitness')) {
      return Icons.fitness_center;
    } else if (name.contains('salud') || name.contains('farmacia')) {
      return Icons.local_hospital;
    } else if (name.contains('auto') || name.contains('vehículo')) {
      return Icons.directions_car;
    } else if (name.contains('libro') || name.contains('educación')) {
      return Icons.book;
    } else {
      return Icons.category;
    }
  }

  Widget _buildProductCard(Producto product) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => widget.onProductTap?.call(product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard(Tienda store) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => widget.onStoreTap?.call(store),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.store,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tienda en ${store.categoryName ?? 'Categoría'}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            store.address ?? 'Dirección no disponible',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget simplificado para mostrar solo productos en lista
class ProductSearchResults extends StatelessWidget {
  final List<Producto> products;
  final Function(Producto)? onProductTap;
  final String query;

  const ProductSearchResults({
    super.key,
    required this.products,
    this.onProductTap,
    this.query = '',
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No se encontraron productos'));
    }

    return Column(
      children: [
        if (query.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${products.length} producto${products.length != 1 ? 's' : ''} encontrado${products.length != 1 ? 's' : ''} para "$query"',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildProductCard(product, context),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Producto product, BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => onProductTap?.call(product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_bag,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget simplificado para mostrar solo tiendas en lista
class StoreSearchResults extends StatelessWidget {
  final List<Tienda> stores;
  final Function(Tienda)? onStoreTap;
  final String query;

  const StoreSearchResults({
    super.key,
    required this.stores,
    this.onStoreTap,
    this.query = '',
  });

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) {
      return const Center(child: Text('No se encontraron tiendas'));
    }

    return Column(
      children: [
        if (query.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${stores.length} tienda${stores.length != 1 ? 's' : ''} encontrada${stores.length != 1 ? 's' : ''} para "$query"',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildStoreCard(store, context),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoreCard(Tienda store, BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => onStoreTap?.call(store),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.store,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tienda en ${store.categoryName ?? 'Categoría'}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            store.address ?? 'Dirección no disponible',
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
