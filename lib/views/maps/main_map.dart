import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/maps/custom_cached_tile_provider.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:laferia/maps/default_tiles_service.dart';
import 'package:laferia/maps/offline_map_config.dart';
import 'package:laferia/maps/map_provider_helper.dart';
import 'package:latlong2/latlong.dart';

class MainMap extends StatefulWidget {
  const MainMap({super.key});

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> with TickerProviderStateMixin {
  late MapController mapController;
  late AnimationController _controlsAnimationController;
  String _currentProvider = OfflineMapConfig.defaultProvider;
  int _providerChangeCounter = 0; // Contador para forzar rebuilds
  bool _isLoading = true;
  bool _showControls = true;
  bool _isChangingProvider = false;
  double _currentZoom = 14.0;
  LatLng _currentCenter = const LatLng(-16.5000, -68.1193); // La Paz, Bolivia

  @override
  void initState() {
    super.initState();
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _zoomIn() {
    final newZoom = (_currentZoom + 1.0).clamp(1.0, 18.0);
    mapController.move(_currentCenter, newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
  }

  void _zoomOut() {
    final newZoom = (_currentZoom - 1.0).clamp(1.0, 18.0);
    mapController.move(_currentCenter, newZoom);
    setState(() {
      _currentZoom = newZoom;
    });
  }

  void _changeMapProvider(String providerId) {
    if (_currentProvider == providerId || _isChangingProvider) {
      return; // No hacer nada si es el mismo proveedor o si ya está cambiando
    }

    // Validar que el proveedor existe
    if (!OfflineMapConfig.tileProviders.containsKey(providerId)) {
      return;
    }

    setState(() {
      _isChangingProvider = true;
      _currentProvider = providerId;
      _providerChangeCounter++;
    });

    // Quitar el loading después de un momento
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isChangingProvider = false;
        });
      }
    });

    // Mostrar snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cambiado a: ${_getProviderDisplayName(providerId)}'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blueGrey[700],
      ),
    );
  }

  String _getProviderDisplayName(String providerId) {
    switch (providerId) {
      case 'openstreetmap':
        return 'OpenStreetMap';
      case 'cartodb_light':
        return 'CartoDB Light';
      case 'cartodb_dark':
        return 'CartoDB Dark';
      case 'cartodb_voyager':
        return 'CartoDB Voyager';
      case 'basemaps':
        return 'Base Maps';
      case 'esri':
        return 'Esri Satellite';
      case 'opentopo':
        return 'OpenTopo';
      default:
        return 'Mapa por defecto';
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _controlsAnimationController.forward();
    } else {
      _controlsAnimationController.reverse();
    }
  }

  void _centerOnLaPaz() {
    const laPazCenter = LatLng(-16.5000, -68.1193);
    mapController.move(laPazCenter, 14.0);
    setState(() {
      _currentCenter = laPazCenter;
      _currentZoom = 14.0;
    });
  }

  Widget _buildMapProviderSelector() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.layers, color: Colors.blueGrey),
        tooltip: 'Cambiar proveedor de mapa',
        onSelected: _changeMapProvider,
        itemBuilder: (BuildContext context) {
          return OfflineMapConfig.tileProviders.keys.map((String providerId) {
            return PopupMenuItem<String>(
              value: providerId,
              child: Row(
                children: [
                  Icon(
                    _currentProvider == providerId
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color:
                        _currentProvider == providerId
                            ? Colors.blue
                            : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(_getProviderDisplayName(providerId)),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildZoomControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blueGrey),
                tooltip: 'Acercar',
                onPressed: _currentZoom < 18.0 ? _zoomIn : null,
              ),
              Container(
                height: 1,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.blueGrey),
                tooltip: 'Alejar',
                onPressed: _currentZoom > 1.0 ? _zoomOut : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.my_location, color: Colors.blueGrey),
            tooltip: 'Centrar en La Paz',
            onPressed: _centerOnLaPaz,
          ),
        ),
      ],
    );
  }

  Widget _buildControlsToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          _showControls ? Icons.visibility : Icons.visibility_off,
          color: Colors.blueGrey,
        ),
        tooltip: _showControls ? 'Ocultar controles' : 'Mostrar controles',
        onPressed: _toggleControls,
      ),
    );
  }

  Widget _buildTileLayer() {
    final currentProviderInfo = MapProviderHelper.getProviderInfo(
      _currentProvider,
    );

    return TileLayer(
      key: ValueKey('${_currentProvider}_${_providerChangeCounter}'),
      urlTemplate: currentProviderInfo.url,
      subdomains: currentProviderInfo.subdomains,
      tileProvider: CustomCachedTileProvider(),
      userAgentPackageName: 'com.laferia.app',
      maxZoom: 18,
      minZoom: 1,
    );
  }

  Widget _buildZoomIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        'Zoom: ${_currentZoom.toStringAsFixed(1)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Principal'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando mapa...'),
                  ],
                ),
              )
              : Stack(
                children: [
                  // Mapa principal
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: _currentCenter,
                      initialZoom: _currentZoom,
                      minZoom: 1.0,
                      maxZoom: 18.0,
                      onPositionChanged: (position, hasGesture) {
                        if (hasGesture) {
                          setState(() {
                            _currentCenter = position.center;
                            _currentZoom = position.zoom;
                          });
                        }
                      },
                    ),
                    children: [
                      _buildTileLayer(), // Usar el método separado
                    ],
                  ),

                  // Controles en la esquina superior izquierda
                  Positioned(
                    top: 16,
                    left: 16,
                    child: AnimatedBuilder(
                      animation: _controlsAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              _showControls
                                  ? _controlsAnimationController.value
                                  : 0.0,
                          child: Opacity(
                            opacity: _controlsAnimationController.value,
                            child: _buildMapProviderSelector(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Controles de zoom en la esquina derecha
                  Positioned(
                    top: 16,
                    right: 16,
                    child: AnimatedBuilder(
                      animation: _controlsAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              _showControls
                                  ? _controlsAnimationController.value
                                  : 0.0,
                          child: Opacity(
                            opacity: _controlsAnimationController.value,
                            child: _buildZoomControls(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Toggle de controles en la esquina inferior derecha
                  Positioned(
                    bottom: 80,
                    right: 16,
                    child: _buildControlsToggle(),
                  ),

                  // Indicador de zoom en la esquina inferior izquierda
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: _buildZoomIndicator(),
                  ),

                  // Indicador del proveedor actual
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        _getProviderDisplayName(_currentProvider),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // Indicador de cambio de proveedor
                  if (_isChangingProvider)
                    Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 8),
                                Text('Cambiando mapa...'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}
