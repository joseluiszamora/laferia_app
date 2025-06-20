import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/maps/custom_cached_tile_provider.dart';
import 'package:laferia/maps/default_tiles_service.dart';
import 'package:laferia/maps/map_provider_helper.dart';
import 'package:laferia/maps/offline_map_config.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:laferia/views/tiendas-maps/components/zoom_center_controls.dart';
import 'package:latlong2/latlong.dart';

class TiendasMapsPage extends StatefulWidget {
  const TiendasMapsPage({
    super.key,
    required this.showControls,
    required this.defaultCenter,
    required this.initialZoom,
  });

  final bool showControls;
  final LatLng defaultCenter;
  final double initialZoom;

  @override
  State<TiendasMapsPage> createState() => _TiendasMapsPageState();
}

class _TiendasMapsPageState extends State<TiendasMapsPage>
    with TickerProviderStateMixin {
  late MapController mapController;
  late AnimationController _controlsAnimationController;
  final String _currentProvider = OfflineMapConfig.defaultProvider;
  int providerChangeCounter = 0; // Contador para forzar rebuilds
  bool _isLoading = true;
  late double _currentZoom;
  late LatLng _currentCenter;
  final double _minZoom = 1.0;
  final double _maxZoom = 19.0;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.defaultCenter;
    _currentZoom = widget.initialZoom;
    mapController = MapController();
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initializeMap();
  }

  @override
  void dispose() {
    _controlsAnimationController.dispose();
    mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      // Inicializar servicios de caché
      await TileCacheService.instance.initialize();

      // Cargar tiles por defecto si existen
      await DefaultTilesService.loadDefaultTiles();

      setState(() {
        _isLoading = false;
      });

      _controlsAnimationController.forward();
    } catch (e) {
      debugPrint('Error inicializando mapa: $e');
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  void _centerOnDefault() {
    mapController.move(widget.defaultCenter, widget.initialZoom);
    setState(() {
      _currentCenter = widget.defaultCenter;
      _currentZoom = widget.initialZoom;
    });
  }

  void _zoomIn() {
    if (_currentZoom < _maxZoom) {
      final newZoom = (_currentZoom + 1.0).clamp(_minZoom, _maxZoom);
      mapController.move(_currentCenter, newZoom);
      setState(() {
        _currentZoom = newZoom;
      });
    }
  }

  void _zoomOut() {
    if (_currentZoom > _minZoom) {
      final newZoom = (_currentZoom - 1.0).clamp(_minZoom, _maxZoom);
      mapController.move(_currentCenter, newZoom);
      setState(() {
        _currentZoom = newZoom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? _mapLoading()
              : Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: widget.defaultCenter,
                      initialZoom: _currentZoom,
                      minZoom: _minZoom,
                      maxZoom: _maxZoom,
                      onPositionChanged: (position, hasGesture) {
                        if (hasGesture) {
                          setState(() {
                            _currentCenter = position.center;
                            _currentZoom = position.zoom;
                          });
                        }
                      },
                    ),
                    children: [_buildTileLayer()],
                  ),
                  // Controles de zoom in/out y centrado
                  widget.showControls
                      ? Positioned(
                        bottom: 16,
                        right: 16,
                        child: AnimatedBuilder(
                          animation: _controlsAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _controlsAnimationController.value,
                              child: Opacity(
                                opacity: _controlsAnimationController.value,
                                child: ZoomCenterControls(
                                  zoomIn: _zoomIn,
                                  zoomOut: _zoomOut,
                                  onCenter: _centerOnDefault,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      : SizedBox.shrink(),
                ],
              ),
    );
  }

  Center _mapLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando mapa...'),
        ],
      ),
    );
  }

  Widget _buildTileLayer() {
    final currentProviderInfo = MapProviderHelper.getProviderInfo(
      _currentProvider,
    );

    return TileLayer(
      key: ValueKey('${_currentProvider}_$providerChangeCounter'),
      urlTemplate: currentProviderInfo.url,
      subdomains: currentProviderInfo.subdomains,
      tileProvider: CustomCachedTileProvider(),
      userAgentPackageName: 'com.laferia.app',
      maxZoom: _maxZoom,
      minZoom: _minZoom,
    );
  }
}
