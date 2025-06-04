import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/maps/custom_cached_tile_provider.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class SimpleOfflineMapScreen extends StatefulWidget {
  const SimpleOfflineMapScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SimpleOfflineMapScreenState createState() => _SimpleOfflineMapScreenState();
}

class _SimpleOfflineMapScreenState extends State<SimpleOfflineMapScreen> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _initializeCache();
  }

  // Inicializar el servicio de caché
  Future<void> _initializeCache() async {
    await TileCacheService.instance.initialize();
    // Precargar tiles básicos para La Paz
    _preloadBasicTiles();
  }

  // Precargar tiles básicos de La Paz para uso offline
  void _preloadBasicTiles() async {
    await TileCacheService.instance.preloadArea(
      northEast_lat: -16.4900,
      northEast_lng: -68.1200,
      southWest_lat: -16.5100,
      southWest_lng: -68.1400,
      zoomLevels: [12, 13, 14, 15],
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa Offline'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(-16.500, -68.130), // La Paz, Bolivia
          initialZoom: 13.0,
          minZoom: 5.0,
          maxZoom: 18.0,
          // Callback cuando el usuario mueve el mapa
          onPositionChanged: (MapCamera position, bool hasGesture) {
            if (hasGesture) {
              _cacheVisibleArea();
            }
          },
        ),
        children: [
          // Capa de tiles con estilo moderno basado en OpenStreetMap
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.laferia.app',

            // Usar nuestro tile provider personalizado con caché
            tileProvider: CustomCachedTileProvider(),

            tileSize: 256,
            tileBuilder:
                (context, tileWidget, tile) => Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix([
                        1.1, 0, 0, 0, -20, // Reducir rojo
                        0, 1.2, 0, 0, -30, // Aumentar verde
                        0, 0, 1.3, 0, -40, // Aumentar azul
                        0, 0, 0, 1, 0, // Alpha sin cambios
                      ]),
                      child: tileWidget,
                    ),
                  ),
                ),

            // Configuración adicional
            additionalOptions: const {
              'attribution': '© OpenStreetMap contributors',
            },
          ),

          // Capa de marcadores
          MarkerLayer(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(-16.500, -68.130),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.location_on, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),

      // Botones de control
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "zoom_in",
            onPressed: () {
              final zoom = mapController.camera.zoom + 1;
              mapController.move(mapController.camera.center, zoom);
            },
            child: Icon(Icons.add),
            mini: true,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "zoom_out",
            onPressed: () {
              final zoom = mapController.camera.zoom - 1;
              mapController.move(mapController.camera.center, zoom);
            },
            child: Icon(Icons.remove),
            mini: true,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "cache",
            onPressed: _downloadVisibleArea,
            child: Icon(Icons.download),
            mini: true,
            backgroundColor: Colors.green,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "stats",
            onPressed: _showCacheStats,
            child: Icon(Icons.info),
            mini: true,
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  // Cachear automáticamente el área visible
  void _cacheVisibleArea() {
    final bounds = mapController.camera.visibleBounds;
    final zoom = mapController.camera.zoom.round();
    _downloadTilesForBounds(bounds, zoom);
  }

  // Función para descargar tiles de un área específica
  Future<void> _downloadTilesForBounds(LatLngBounds bounds, int zoom) async {
    final tileBounds = _getTileBounds(bounds, zoom);

    for (int x = tileBounds['minX']!; x <= tileBounds['maxX']!; x++) {
      for (int y = tileBounds['minY']!; y <= tileBounds['maxY']!; y++) {
        final url = 'https://tile.openstreetmap.org/$zoom/$x/$y.png';
        try {
          // Usar nuestro servicio de caché personalizado
          await TileCacheService.instance.getTile(url, zoom, x, y);
        } catch (e) {
          print('Error descargando tile: $e');
        }
      }
    }
  }

  // Función para descargar manualmente el área visible
  void _downloadVisibleArea() async {
    final bounds = mapController.camera.visibleBounds;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Descargando...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Descargando tiles del área visible'),
              ],
            ),
          ),
    );

    try {
      // Descargar varios niveles de zoom
      final currentZoom = mapController.camera.zoom.round();
      for (int z = currentZoom - 1; z <= currentZoom + 2; z++) {
        if (z >= 10 && z <= 18) {
          await _downloadTilesForBounds(bounds, z);
        }
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Área descargada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al descargar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Mostrar estadísticas del caché
  void _showCacheStats() async {
    final stats = await TileCacheService.instance.getCacheStats();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Estadísticas del Caché'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tiles almacenados: ${stats['tile_count'] ?? 0}'),
                Text(
                  'Tamaño total: ${(stats['total_size_mb'] ?? 0).toStringAsFixed(2)} MB',
                ),
                if (stats['last_used'] != null)
                  Text(
                    'Último uso: ${stats['last_used'].toString().split('.')[0]}',
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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Caché limpiado')));
                },
                child: Text('Limpiar Caché'),
              ),
            ],
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
    mapController.dispose();
    super.dispose();
  }
}
