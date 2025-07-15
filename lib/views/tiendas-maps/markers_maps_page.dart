import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/core/blocs/location/location.dart';
import 'package:laferia/core/models/tienda.dart';
import 'package:laferia/core/services/supabase_tienda_service.dart';
import 'package:laferia/maps/custom_cached_tile_provider.dart';
import 'package:laferia/maps/default_tiles_service.dart';
import 'package:laferia/maps/map_provider_helper.dart';
import 'package:laferia/maps/offline_map_config.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:laferia/views/tiendas-maps/components/tienda_info.dart';
import 'package:laferia/views/tiendas-maps/components/tienda_marker.dart';
import 'package:laferia/location/user_location_marker.dart';
import 'package:laferia/views/tiendas-maps/components/zoom_center_controls.dart';
import 'package:latlong2/latlong.dart';

class MarkersMapsPage extends StatefulWidget {
  const MarkersMapsPage({
    super.key,
    required this.showControls,
    required this.defaultCenter,
    required this.initialZoom,
  });

  final bool showControls;
  final LatLng defaultCenter;
  final double initialZoom;

  @override
  State<MarkersMapsPage> createState() => _MarkersMapsPageState();
}

class _MarkersMapsPageState extends State<MarkersMapsPage>
    with TickerProviderStateMixin {
  late MapController mapController;
  late AnimationController _controlsAnimationController;
  // late List<Tienda> tiendasMarkers;
  final String _currentProvider = OfflineMapConfig.defaultProvider;
  int providerChangeCounter = 0; // Contador para forzar rebuilds
  bool _isLoading = true;
  late double _currentZoom;
  late LatLng _currentCenter;
  final double _minZoom = 1.0;
  final double _maxZoom = 19.0;

  // Lista de markers de ejemplo
  List<Marker> markers = [];
  Marker? _userLocationMarker;

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
    _initializeMarkers();
    _initializeMap();
  }

  void _initializeMarkers() async {
    List<Tienda> tmpTiendas = await SupabaseTiendaService.getAllTiendas();

    List<Marker> tmpMarkers =
        tmpTiendas.map((tienda) {
          return Marker(
            point: LatLng(tienda.ubicacion.lat, tienda.ubicacion.lng),
            width: 60,
            height: 60,
            child: TiendaMarker(
              icon: Tienda.getIconData(tienda.icon),
              color: Tienda.getColorFromHex(tienda.color),
              label: tienda.nombre,
              onTap: () => _showMarkerInfo(tienda),
            ),
          );
        }).toList();

    setState(() {
      markers = tmpMarkers;
    });
  }

  void _showMarkerInfo(Tienda tienda) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => TiendaInfo(
            title: tienda.nombre,
            description: '${tienda.horarioAtencion} - ${tienda.icon}',
            color: Colors.blue,
          ),
    );
  }

  void _updateUserLocationMarker(LatLng position, {double accuracy = 0.0}) {
    setState(() {
      _userLocationMarker = Marker(
        point: position,
        width: 60,
        height: 60,
        child: UserLocationMarker(
          size: 20,
          accuracy: accuracy,
          onTap: () => _centerOnUserLocation(),
        ),
      );
    });
  }

  void _centerOnUserLocation() {
    final locationBloc = context.read<LocationBloc>();
    final locationState = locationBloc.state;

    if (locationState is LocationLoaded) {
      final userLocation = LatLng(
        locationState.position.latitude,
        locationState.position.longitude,
      );
      mapController.move(userLocation, 16.0);
      setState(() {
        _currentCenter = userLocation;
        _currentZoom = 16.0;
      });
    } else if (locationState is LocationTracking) {
      final userLocation = LatLng(
        locationState.currentPosition.latitude,
        locationState.currentPosition.longitude,
      );
      mapController.move(userLocation, 16.0);
      setState(() {
        _currentCenter = userLocation;
        _currentZoom = 16.0;
      });
    }
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
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoaded) {
          final userLocation = LatLng(
            state.position.latitude,
            state.position.longitude,
          );
          _updateUserLocationMarker(
            userLocation,
            accuracy: state.position.accuracy,
          );
        } else if (state is LocationTracking) {
          final userLocation = LatLng(
            state.currentPosition.latitude,
            state.currentPosition.longitude,
          );
          _updateUserLocationMarker(
            userLocation,
            accuracy: state.currentPosition.accuracy,
          );
        }
      },
      child: Scaffold(
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
                      children: [_buildTileLayer(), _buildMarkersLayer()],
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
                                    onLocationFound: _centerOnUserLocation,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        : SizedBox.shrink(),
                  ],
                ),
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

  Widget _buildMarkersLayer() {
    final allMarkers = <Marker>[...markers];
    if (_userLocationMarker != null) {
      allMarkers.add(_userLocationMarker!);
    }
    return MarkerLayer(markers: allMarkers);
  }
}
