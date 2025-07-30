import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';
import '../../core/config/mapbox_config.dart';
import '../../core/services/mapbox_service.dart';

class MapboxPage extends StatefulWidget {
  const MapboxPage({super.key});

  @override
  State<MapboxPage> createState() => _MapboxPageState();
}

class _MapboxPageState extends State<MapboxPage> {
  MapboxMap? mapboxMap;
  geo.Position? _currentPosition;
  bool _isLoading = true;
  String _selectedMapStyle = MapboxStyles.STANDARD;
  PointAnnotationManager? _pointAnnotationManager;
  List<PointAnnotationOptions> _markers = [];

  // Coordenadas de La Paz, Bolivia como centro por defecto
  static const double _defaultLat = MapboxConfig.defaultLat;
  static const double _defaultLng = MapboxConfig.defaultLng;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _checkMapboxInitialization();
  }

  void _checkMapboxInitialization() {
    if (!MapboxService.isInitialized) {
      print('Advertencia: Mapbox no está inicializado');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurando Mapbox...'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Verificar permisos de ubicación
      final permission = await Permission.location.request();

      if (permission.isGranted) {
        final position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high,
        );

        setState(() {
          _currentPosition = position;
          _isLoading = false;
        });

        // Mover la cámara a la ubicación actual si el mapa está listo
        if (mapboxMap != null) {
          _moveToLocation(position.latitude, position.longitude);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error obteniendo ubicación: $e');
    }
  }

  void _onMapCreated(MapboxMap map) {
    mapboxMap = map;

    // Configurar el mapa
    _configureMap();

    // Si ya tenemos la ubicación, mover la cámara
    if (_currentPosition != null) {
      _moveToLocation(_currentPosition!.latitude, _currentPosition!.longitude);
    }

    // Agregar marcadores iniciales
    _addInitialMarkers();
  }

  Future<void> _configureMap() async {
    if (mapboxMap == null) return;

    try {
      // Configurar límites de zoom
      await mapboxMap!.setCamera(CameraOptions(zoom: MapboxConfig.defaultZoom));

      // Habilitar gestos usando el servicio
      await mapboxMap!.gestures.updateSettings(
        MapboxService.createDefaultGesturesSettings(),
      );
    } catch (e) {
      print('Error configurando mapa: $e');
    }
  }

  Future<void> _moveToLocation(double lat, double lng) async {
    if (mapboxMap == null) return;

    final cameraOptions = CameraOptions(
      center: Point(coordinates: Position(lng, lat)),
      zoom: 15.0,
    );

    await mapboxMap!.flyTo(cameraOptions, null);
  }

  Future<void> _addInitialMarkers() async {
    if (mapboxMap == null) return;

    try {
      // Crear manager de anotaciones de punto
      _pointAnnotationManager =
          await mapboxMap!.annotations.createPointAnnotationManager();

      // Agregar marcador en La Paz
      await _addMarker(
        lat: _defaultLat,
        lng: _defaultLng,
        title: 'La Paz, Bolivia',
        color: Colors.red,
      );

      // Agregar marcador en ubicación actual si existe
      if (_currentPosition != null) {
        await _addMarker(
          lat: _currentPosition!.latitude,
          lng: _currentPosition!.longitude,
          title: 'Mi Ubicación',
          color: Colors.blue,
        );
      }

      // Agregar algunos marcadores de ejemplo (tiendas)
      await _addExampleStores();
    } catch (e) {
      print('Error agregando marcadores iniciales: $e');
    }
  }

  Future<void> _addMarker({
    required double lat,
    required double lng,
    required String title,
    required Color color,
  }) async {
    if (_pointAnnotationManager == null) return;

    try {
      final pointAnnotationOptions = PointAnnotationOptions(
        geometry: Point(coordinates: Position(lng, lat)),
        textField: title,
        textOffset: [0.0, -2.0],
        textColor: color.value,
        iconSize: 1.2,
      );

      await _pointAnnotationManager!.create(pointAnnotationOptions);
    } catch (e) {
      print('Error agregando marcador: $e');
    }
  }

  Future<void> _addExampleStores() async {
    final exampleStores = [
      {'name': 'Mercado Rodriguez', 'lat': -16.4985, 'lng': -68.1435},
      {'name': 'Plaza San Francisco', 'lat': -16.4955, 'lng': -68.1360},
      {'name': 'Mercado de las Brujas', 'lat': -16.4950, 'lng': -68.1380},
      {'name': 'Centro Comercial Megacenter', 'lat': -16.5320, 'lng': -68.0730},
    ];

    for (final store in exampleStores) {
      await _addMarker(
        lat: store['lat'] as double,
        lng: store['lng'] as double,
        title: store['name'] as String,
        color: Colors.green,
      );
    }
  }

  void _changeMapStyle(String style) {
    setState(() {
      _selectedMapStyle = style;
    });
  }

  void _goToCurrentLocation() {
    if (_currentPosition != null) {
      _moveToLocation(_currentPosition!.latitude, _currentPosition!.longitude);
    } else {
      _getCurrentLocation();
    }
  }

  void _goToLaPaz() {
    _moveToLocation(_defaultLat, _defaultLng);
  }

  void _addMarkerAtCenter() async {
    if (mapboxMap == null) return;

    try {
      // Obtener el centro actual del mapa
      final cameraState = await mapboxMap!.getCameraState();
      final center = cameraState.center;

      await _addMarker(
        lat: center.coordinates.lat.toDouble(),
        lng: center.coordinates.lng.toDouble(),
        title: 'Nuevo Marcador',
        color: Colors.orange,
      );

      // Mostrar snackbar de confirmación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Marcador agregado en el centro del mapa'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error agregando marcador en el centro: $e');
    }
  }

  void _clearMarkers() async {
    if (_pointAnnotationManager == null) return;

    try {
      await _pointAnnotationManager!.deleteAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todos los marcadores eliminados'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error eliminando marcadores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa principal
          MapWidget(
            key: ValueKey(_selectedMapStyle),
            cameraOptions: CameraOptions(
              center:
                  _currentPosition != null
                      ? Point(
                        coordinates: Position(
                          _currentPosition!.longitude,
                          _currentPosition!.latitude,
                        ),
                      )
                      : Point(coordinates: Position(_defaultLng, _defaultLat)),
              zoom: 12.0,
            ),
            styleUri: _selectedMapStyle,
            onMapCreated: _onMapCreated,
          ),

          // Indicador de carga
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Panel de controles superior
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Estilos de Mapa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildStyleChip('Estándar', MapboxStyles.STANDARD),
                        _buildStyleChip('Satélite', MapboxStyles.SATELLITE),
                        _buildStyleChip(
                          'Calles',
                          MapboxStyles.SATELLITE_STREETS,
                        ),
                        _buildStyleChip('Oscuro', MapboxStyles.DARK),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Botones de navegación flotantes
          Positioned(
            bottom: 160,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'current_location',
                  onPressed: _goToCurrentLocation,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'la_paz',
                  onPressed: _goToLaPaz,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.location_city, color: Colors.white),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'add_marker',
                  onPressed: _addMarkerAtCenter,
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.add_location, color: Colors.white),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'clear_markers',
                  onPressed: _clearMarkers,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.clear_all, color: Colors.white),
                ),
              ],
            ),
          ),

          // Panel de información inferior
          Positioned(
            bottom: 16,
            left: 16,
            right: 80,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Información del Mapa',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text('${_markers.length} marcadores'),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                    _isLoading ? Colors.orange : Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_currentPosition != null) ...[
                      const Text('Ubicación Actual:'),
                      Text(
                        'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      Text(
                        'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ] else ...[
                      const Text('Ubicación no disponible'),
                    ],
                    const SizedBox(height: 4),
                    Text('Estilo: ${_getStyleName(_selectedMapStyle)}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleChip(String label, String style) {
    final isSelected = _selectedMapStyle == style;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _changeMapStyle(style);
        }
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  String _getStyleName(String style) {
    switch (style) {
      case MapboxStyles.STANDARD:
        return 'Estándar';
      case MapboxStyles.SATELLITE:
        return 'Satélite';
      case MapboxStyles.SATELLITE_STREETS:
        return 'Satélite con Calles';
      case MapboxStyles.DARK:
        return 'Oscuro';
      default:
        return 'Desconocido';
    }
  }
}
