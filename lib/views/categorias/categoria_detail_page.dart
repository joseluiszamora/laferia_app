import 'package:flutter/material.dart';
import 'package:laferia/views/producto/producto_detail_page.dart';
import 'package:laferia/views/tienda/tienda_detail_page.dart';
import '../../core/models/categoria.dart';
import '../../core/models/tienda.dart';
import '../../core/models/producto.dart';
import '../../core/services/supabase_tienda_service.dart';
import '../../core/services/supabase_producto_service.dart';

class CategoriaDetailPage extends StatefulWidget {
  final Categoria categoria;

  const CategoriaDetailPage({super.key, required this.categoria});

  @override
  State<CategoriaDetailPage> createState() => _CategoriaDetailPageState();
}

class _CategoriaDetailPageState extends State<CategoriaDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Tienda> _tiendas = [];
  List<Producto> _productos = [];
  bool _isLoadingTiendas = true;
  bool _isLoadingProductos = true;
  String? _errorTiendas;
  String? _errorProductos;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    await Future.wait([_cargarTiendas(), _cargarProductos()]);
  }

  Future<void> _cargarTiendas() async {
    try {
      setState(() {
        _isLoadingTiendas = true;
        _errorTiendas = null;
      });

      final tiendas = await SupabaseTiendaService.getTiendasByCategoria(
        widget.categoria.id,
      );

      setState(() {
        _tiendas = tiendas;
        _isLoadingTiendas = false;
      });
    } catch (e) {
      setState(() {
        _errorTiendas = e.toString();
        _isLoadingTiendas = false;
      });
    }
  }

  Future<void> _cargarProductos() async {
    try {
      setState(() {
        _isLoadingProductos = true;
        _errorProductos = null;
      });

      final productos = await SupabaseProductoService.buscarPorCategoria(
        widget.categoria.id,
        limit: 20,
      );

      setState(() {
        _productos = productos;
        _isLoadingProductos = false;
      });
    } catch (e) {
      setState(() {
        _errorProductos = e.toString();
        _isLoadingProductos = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen de fondo
          _buildSliverAppBar(theme),

          // Información de la categoría
          SliverToBoxAdapter(child: _buildCategoriaInfo(theme)),

          // Tabs
          SliverToBoxAdapter(child: _buildTabBar(theme)),

          // Contenido de tabs
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTiendasTab(), _buildProductosTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    final categoria = widget.categoria;
    final color = _getColorFromString(categoria.color);

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: color,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          categoria.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child:
              categoria.imageUrl != null
                  ? Image.network(
                    categoria.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultBackground(color);
                    },
                  )
                  : _buildDefaultBackground(color),
        ),
      ),
    );
  }

  Widget _buildDefaultBackground(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.7), color],
        ),
      ),
      child: Center(
        child: Icon(
          _getIconFromString(widget.categoria.icon),
          size: 80,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildCategoriaInfo(ThemeData theme) {
    final categoria = widget.categoria;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y subtítulo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getColorFromString(categoria.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconFromString(categoria.icon),
                  color: _getColorFromString(categoria.color),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoria.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (categoria.description != null &&
                        categoria.description!.isNotEmpty)
                      Text(
                        categoria.description!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Estadísticas
          _buildEstadisticas(theme),
        ],
      ),
    );
  }

  Widget _buildEstadisticas(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildEstadisticaCard(
            theme,
            'Tiendas',
            _tiendas.length.toString(),
            Icons.store,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildEstadisticaCard(
            theme,
            'Productos',
            _productos.length.toString(),
            Icons.inventory,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildEstadisticaCard(
    ThemeData theme,
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icono, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            valor,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titulo,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: _getColorFromString(widget.categoria.color),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        tabs: const [
          Tab(icon: Icon(Icons.store), text: 'Tiendas'),
          Tab(icon: Icon(Icons.inventory), text: 'Productos'),
        ],
      ),
    );
  }

  Widget _buildTiendasTab() {
    if (_isLoadingTiendas) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorTiendas != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar tiendas',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _cargarTiendas,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_tiendas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay tiendas en esta categoría',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tiendas.length,
      itemBuilder: (context, index) {
        final tienda = _tiendas[index];
        return _buildTiendaCard(tienda);
      },
    );
  }

  Widget _buildProductosTab() {
    if (_isLoadingProductos) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorProductos != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar productos',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _cargarProductos,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_productos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay productos en esta categoría',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _productos.length,
      itemBuilder: (context, index) {
        final producto = _productos[index];
        return _buildProductoCard(producto);
      },
    );
  }

  Widget _buildTiendaCard(Tienda tienda) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToTiendaDetail(tienda),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar de la tienda
              CircleAvatar(
                radius: 30,
                backgroundColor: _getColorFromString(
                  tienda.color,
                ).withOpacity(0.1),
                child:
                    tienda.logoUrl != null
                        ? ClipOval(
                          child: Image.network(
                            tienda.logoUrl!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                _getIconFromString(tienda.icon),
                                color: _getColorFromString(tienda.color),
                                size: 30,
                              );
                            },
                          ),
                        )
                        : Icon(
                          _getIconFromString(tienda.icon),
                          color: _getColorFromString(tienda.color),
                          size: 30,
                        ),
              ),
              const SizedBox(width: 16),

              // Información de la tienda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tienda.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Propietario: ${tienda.ownerName}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    if (tienda.address != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              tienda.address!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Calificación
                        if (tienda.averageRating != null) ...[
                          Icon(Icons.star, size: 16, color: Colors.amber[600]),
                          const SizedBox(width: 4),
                          Text(
                            tienda.averageRating!.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],

                        // Horario
                        Icon(Icons.schedule, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          tienda.operatingHours,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flecha
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductoCard(Producto producto) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToProductoDetail(producto),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child:
                      producto.imagenPrincipal != null
                          ? Image.network(
                            producto.imagenPrincipal!.url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      producto.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),

                    // Precio
                    Row(
                      children: [
                        if (producto.tieneOferta) ...[
                          Text(
                            '\$${producto.discountedPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${producto.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ] else ...[
                          Text(
                            '\$${producto.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Stock
                    if (producto.stock > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Stock: ${producto.stock}',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              producto.stockBajo
                                  ? Colors.orange
                                  : Colors.grey[600],
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        'Sin stock',
                        style: TextStyle(fontSize: 12, color: Colors.red[600]),
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

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
      ),
    );
  }

  // Métodos de navegación
  void _navigateToTiendaDetail(Tienda tienda) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TiendaDetailPage(tienda: tienda)),
    );
  }

  void _navigateToProductoDetail(Producto producto) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductoDetailPage(producto: producto),
      ),
    );
  }

  // Métodos helper para iconos y colores
  Color _getColorFromString(String? colorString) {
    if (colorString == null) return Colors.blue;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getIconFromString(String? iconString) {
    if (iconString == null) return Icons.category;

    final iconMap = {
      'store': Icons.store,
      'restaurant': Icons.restaurant,
      'eco': Icons.eco,
      'checkroom': Icons.checkroom,
      'shopping_bag': Icons.shopping_bag,
      'directions_car': Icons.directions_car,
      'devices': Icons.devices,
      'menu_book': Icons.menu_book,
      'local_pharmacy': Icons.local_pharmacy,
      'build': Icons.build,
      'diamond': Icons.diamond,
      'local_florist': Icons.local_florist,
      'pets': Icons.pets,
      'face_retouching_natural': Icons.face_retouching_natural,
      'sports_soccer': Icons.sports_soccer,
      'home': Icons.home,
      'category': Icons.category,
    };

    return iconMap[iconString] ?? Icons.category;
  }
}
