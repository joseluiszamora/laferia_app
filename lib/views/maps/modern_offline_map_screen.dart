import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/maps/custom_cached_tile_provider.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:laferia/maps/default_tiles_service.dart';
import 'package:latlong2/latlong.dart';

class ModernOfflineMapScreen extends StatefulWidget {
  const ModernOfflineMapScreen({super.key});

  @override
  State<ModernOfflineMapScreen> createState() => _ModernOfflineMapScreenState();
}

class _ModernOfflineMapScreenState extends State<ModernOfflineMapScreen>
    with TickerProviderStateMixin {
  late MapController mapController;
  late AnimationController _fabAnimationController;
  bool _isLoading = true;
  bool _showFabs = true;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      // Inicializar servicios de caché
      await TileCacheService.instance.initialize();

      // Cargar tiles por defecto si existen
      await DefaultTilesService.loadDefaultTiles();

      // Precargar área básica de La Paz
      _preloadBasicArea();

      setState(() {
        _isLoading = false;
      });

      _fabAnimationController.forward();
    } catch (e) {
      print('Error inicializando mapa: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _preloadBasicArea() async {
    // Precargar área básica en background
    TileCacheService.instance.preloadArea(
      northEast_lat: -16.490,
      northEast_lng: -68.120,
      southWest_lat: -16.510,
      southWest_lng: -68.140,
      zoomLevels: [12, 13, 14, 15],
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade900, Colors.blue.shade700],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Cargando Mapa Offline...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Preparando tiles en caché',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Mapa Offline - La Feria',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 3,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blue.shade900.withOpacity(0.9),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.info_outline), onPressed: _showMapInfo),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(-16.500, -68.130), // La Paz, Bolivia
              initialZoom: 13.0,
              minZoom: 5.0,
              maxZoom: 18.0,
              // Auto-cachear área visible cuando el usuario navega
              onPositionChanged: (MapCamera position, bool hasGesture) {
                if (hasGesture) {
                  _cacheVisibleAreaDelayed();
                }
              },
              // Ocultar FABs cuando el usuario interactúa con el mapa
              onTap: (_, __) => _toggleFabs(),
            ),
            children: [
              // Capa de tiles con estilo moderno
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.laferia.app',
                tileProvider: CustomCachedTileProvider(),
                tileSize: 256,
                tileBuilder:
                    (context, tileWidget, tile) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 1,
                            offset: Offset(0, 0.5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix([
                            // Matriz de color para un estilo más moderno y vibrante
                            1.1, 0.0, 0.0, 0.0, -15, // Rojo
                            0.0, 1.15, 0.0, 0.0, -20, // Verde
                            0.0, 0.0, 1.2, 0.0, -25, // Azul
                            0.0, 0.0, 0.0, 1.0, 0, // Alpha
                          ]),
                          child: tileWidget,
                        ),
                      ),
                    ),
                additionalOptions: const {
                  'attribution': '© OpenStreetMap contributors',
                },
              ),

              // Marcador principal
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50.0,
                    height: 50.0,
                    point: LatLng(-16.500, -68.130),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.red.shade400, Colors.red.shade700],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),

              // Attribution personalizada
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    '© OpenStreetMap contributors',
                    textStyle: TextStyle(color: Colors.black87, fontSize: 10),
                  ),
                  TextSourceAttribution(
                    'Modo Offline Habilitado',
                    textStyle: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                alignment: AttributionAlignment.bottomLeft,
              ),
            ],
          ),

          // Indicador de estado de caché
          Positioned(
            top: 100,
            right: 16,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade600.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.offline_bolt, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'OFFLINE',
                    style: TextStyle(
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

      // Controles flotantes mejorados
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimationController.value,
            child: Visibility(
              visible: _showFabs,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildModernFAB(
                    heroTag: "zoom_in",
                    icon: Icons.add,
                    onPressed: () => _zoomIn(),
                    backgroundColor: Colors.blue.shade600,
                  ),
                  SizedBox(height: 12),
                  _buildModernFAB(
                    heroTag: "zoom_out",
                    icon: Icons.remove,
                    onPressed: () => _zoomOut(),
                    backgroundColor: Colors.blue.shade600,
                  ),
                  SizedBox(height: 12),
                  _buildModernFAB(
                    heroTag: "my_location",
                    icon: Icons.my_location,
                    onPressed: () => _centerOnLaPaz(),
                    backgroundColor: Colors.indigo.shade600,
                  ),
                  SizedBox(height: 12),
                  _buildModernFAB(
                    heroTag: "download",
                    icon: Icons.download_for_offline,
                    onPressed: () => _downloadVisibleArea(),
                    backgroundColor: Colors.green.shade600,
                  ),
                  SizedBox(height: 12),
                  _buildModernFAB(
                    heroTag: "stats",
                    icon: Icons.analytics_outlined,
                    onPressed: () => _showCacheStats(),
                    backgroundColor: Colors.orange.shade600,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernFAB({
    required String heroTag,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      elevation: 4,
      child: Icon(icon, color: Colors.white, size: 24),
      mini: true,
    );
  }

  void _toggleFabs() {
    setState(() {
      _showFabs = !_showFabs;
    });
  }

  void _zoomIn() {
    final newZoom = math.min(18.0, mapController.camera.zoom + 1);
    mapController.move(mapController.camera.center, newZoom);
  }

  void _zoomOut() {
    final newZoom = math.max(5.0, mapController.camera.zoom - 1);
    mapController.move(mapController.camera.center, newZoom);
  }

  void _centerOnLaPaz() {
    mapController.move(LatLng(-16.500, -68.130), 13.0);
  }

  // Cache automático con delay para evitar demasiadas llamadas
  Timer? _cacheTimer;
  void _cacheVisibleAreaDelayed() {
    _cacheTimer?.cancel();
    _cacheTimer = Timer(Duration(seconds: 2), () {
      _cacheVisibleArea();
    });
  }

  void _cacheVisibleArea() {
    final bounds = mapController.camera.visibleBounds;
    final zoom = mapController.camera.zoom.round();
    _downloadTilesForBounds(bounds, zoom);
  }

  Future<void> _downloadTilesForBounds(LatLngBounds bounds, int zoom) async {
    final tileBounds = _getTileBounds(bounds, zoom);

    for (int x = tileBounds['minX']!; x <= tileBounds['maxX']!; x++) {
      for (int y = tileBounds['minY']!; y <= tileBounds['maxY']!; y++) {
        final url = 'https://tile.openstreetmap.org/$zoom/$x/$y.png';
        try {
          TileCacheService.instance.getTile(url, zoom, x, y);
        } catch (e) {
          // Error silencioso para no interrumpir la experiencia
        }
      }
    }
  }

  void _downloadVisibleArea() async {
    final bounds = mapController.camera.visibleBounds;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.download_for_offline, color: Colors.green.shade600),
                SizedBox(width: 8),
                Text('Descargando Área'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green.shade600,
                  ),
                ),
                SizedBox(height: 16),
                Text('Descargando tiles para uso offline...'),
                Text(
                  'Esto puede tardar unos minutos',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
    );

    try {
      final currentZoom = mapController.camera.zoom.round();
      for (int z = currentZoom - 1; z <= currentZoom + 2; z++) {
        if (z >= 10 && z <= 18) {
          await _downloadTilesForBounds(bounds, z);
        }
      }

      Navigator.of(context).pop();
      _showSuccessSnackbar('Área descargada exitosamente');
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorSnackbar('Error al descargar: $e');
    }
  }

  void _showCacheStats() async {
    final stats = await TileCacheService.instance.getCacheStats();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.analytics_outlined, color: Colors.blue.shade600),
                SizedBox(width: 8),
                Text('Estadísticas del Caché'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                  'Tiles almacenados:',
                  '${stats['tile_count'] ?? 0}',
                ),
                _buildStatRow(
                  'Tamaño total:',
                  '${(stats['total_size_mb'] ?? 0).toStringAsFixed(2)} MB',
                ),
                if (stats['last_used'] != null)
                  _buildStatRow(
                    'Último uso:',
                    '${stats['last_used'].toString().split('.')[0]}',
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cerrar'),
              ),
              TextButton(
                onPressed: () async {
                  await TileCacheService.instance.cleanOldCache();
                  Navigator.of(context).pop();
                  _showSuccessSnackbar('Caché limpiado');
                },
                child: Text('Limpiar Caché'),
              ),
            ],
          ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  void _showMapInfo() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600),
                SizedBox(width: 8),
                Text('Información del Mapa'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🗺️ Basado en OpenStreetMap'),
                SizedBox(height: 8),
                Text('📱 Funciona completamente offline'),
                SizedBox(height: 8),
                Text('⚡ Los tiles se cachean automáticamente'),
                SizedBox(height: 8),
                Text('🎨 Estilo moderno aplicado'),
                SizedBox(height: 8),
                Text('🌟 Optimizado para La Paz, Bolivia'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Entendido'),
              ),
            ],
          ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 4),
      ),
    );
  }

  Map<String, int> _getTileBounds(LatLngBounds bounds, int zoom) {
    final factor = (1 << zoom).toDouble();

    final minX = ((bounds.west + 180.0) / 360.0 * factor).floor();
    final maxX = ((bounds.east + 180.0) / 360.0 * factor).floor();

    final northLatRad = bounds.north * math.pi / 180.0;
    final southLatRad = bounds.south * math.pi / 180.0;

    final minY =
        ((1.0 - _asinh(math.tan(northLatRad)) / math.pi) / 2.0 * factor)
            .floor();
    final maxY =
        ((1.0 - _asinh(math.tan(southLatRad)) / math.pi) / 2.0 * factor)
            .floor();

    return {'minX': minX, 'maxX': maxX, 'minY': minY, 'maxY': maxY};
  }

  double _asinh(double x) {
    return math.log(x + math.sqrt(x * x + 1.0));
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _cacheTimer?.cancel();
    mapController.dispose();
    super.dispose();
  }
}
