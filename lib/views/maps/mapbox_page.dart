import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart';
import '../../core/config/mapbox_config.dart';
import '../../core/services/mapbox_service.dart';
import '../../core/services/supabase_tienda_service.dart';
import '../../core/models/tienda.dart';
import 'components/mapbox_tienda_marker.dart';

class MapboxPage extends StatefulWidget {
  const MapboxPage({super.key});

  @override
  State<MapboxPage> createState() => _MapboxPageState();
}

class _MapboxPageState extends State<MapboxPage> {
  MapboxMap? mapboxMap;
  geo.Position? _currentPosition;
  bool _isLoading = true;
  bool _isLoadingTiendas = false;
  int _tiendasCount = 0;
  String _selectedMapStyle = MapboxStyles.STANDARD;
  PointAnnotationManager? _pointAnnotationManager;
  CircleAnnotationManager? _circleAnnotationManager;
  List<PointAnnotationOptions> _markers = [];
  List<Tienda> _tiendas = [];

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

      // Configurar listeners de eventos del mapa
      _setupMapListeners();
    } catch (e) {
      print('Error configurando mapa: $e');
    }
  }

  void _setupMapListeners() {
    if (mapboxMap == null) return;

    // Listener para clics en el mapa
    mapboxMap!.setOnMapTapListener((context) {
      _onMapTapped(context);
    });
  }

  void _onMapTapped(MapContentGestureContext context) {
    // Obtener el punto tocado
    final point = context.point;
    final tappedLat = point.coordinates.lat.toDouble();
    final tappedLng = point.coordinates.lng.toDouble();

    print('Mapa tocado en: $tappedLng, $tappedLat');

    // Buscar tienda más cercana al punto tocado con radio más amplio
    const double searchRadius =
        0.003; // Aumentado a ~300 metros para mejor detección

    Tienda? nearestTienda;
    double minDistance = double.infinity;

    for (final tienda in _tiendas) {
      final distance = _calculateDistance(
        tappedLat,
        tappedLng,
        tienda.ubicacion.lat,
        tienda.ubicacion.lng,
      );

      if (distance < searchRadius && distance < minDistance) {
        minDistance = distance;
        nearestTienda = tienda;
      }
    }

    // Si encontramos una tienda cerca, mostrar su información
    if (nearestTienda != null) {
      print(
        'Tienda encontrada: ${nearestTienda.name} (distancia: ${minDistance.toStringAsFixed(6)})',
      );
      _showTiendaInfo(nearestTienda);
    } else if (_tiendas.isNotEmpty && mounted) {
      // Si no hay tienda cerca, mostrar información general con indicación de cómo usar
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_tiendas.length} tiendas disponibles'),
              const Text(
                'Toca sobre un marcador circular para ver sus detalles',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          action:
              _tiendas.isNotEmpty
                  ? SnackBarAction(
                    label: 'Ver Lista',
                    onPressed: _showTiendasList,
                  )
                  : null,
        ),
      );
    }
  }

  // Función auxiliar para calcular distancia entre dos puntos
  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    return ((lat1 - lat2).abs() + (lng1 - lng2).abs());
  }

  // Función auxiliar para obtener emoji apropiado según la categoría de la tienda
  String _getTiendaEmoji(Tienda tienda) {
    // Para debug, vamos a usar emojis simples primero
    final iconData = Tienda.getIconData(tienda.icon);

    print(
      'Debug: Tienda=${tienda.name}, icon=${tienda.icon}, codePoint=0x${iconData.codePoint.toRadixString(16)}',
    );

    // Primero intentamos mapeo directo por codePoint
    final emoji = _getSimpleEmoji(iconData.codePoint);
    print(
      'Debug: Emoji para ${tienda.name}: "$emoji" (${emoji.runes.length} runes)',
    );

    return emoji;
  }

  // Función simplificada para debug
  String _getSimpleEmoji(int codePoint) {
    switch (codePoint) {
      case 0xe57f: // Icons.store
        return '🏪';
      case 0xe56c: // Icons.restaurant
        return '🍽️';
      case 0xe533: // Icons.local_cafe
        return '☕';
      case 0xe59c: // Icons.shopping_bag
        return '🛍️';
      case 0xe531: // Icons.directions_car
        return '🚗';
      case 0xe677: // Icons.local_pharmacy
        return '💊';
      case 0xe02f: // Icons.menu_book
        return '📚';
      case 0xe55f: // Icons.build
        return '🔧';
      case 0xe80e: // Icons.home
        return '🏠';
      default:
        return '🏪'; // Default emoji para todas las tiendas
    }
  }

  // Función para convertir IconData a caracteres Unicode equivalentes - TEMPORALMENTE COMENTADA
  /*
  String _iconDataToUnicode(IconData iconData, Tienda tienda) {
    // Mapear iconos comunes de Material Icons a símbolos Unicode equivalentes
    switch (iconData.codePoint) {
      case 0xe57f: // Icons.store
        return '🏪';
      case 0xe56c: // Icons.restaurant
        return '🍽️';
      case 0xe533: // Icons.local_cafe
        return '☕';
      case 0xe59c: // Icons.shopping_bag
        return '🛍️';
      case 0xe531: // Icons.directions_car
        return '🚗';
      case 0xe677: // Icons.local_pharmacy
        return '💊';
      case 0xe02f: // Icons.menu_book
        return '📚';
      case 0xe55f: // Icons.build
        return '🔧';
      case 0xe22a: // Icons.eco
        return '🌱';
      case 0xe429: // Icons.checkroom
        return '👕';
      case 0xe1b8: // Icons.devices
        return '📱';
      case 0xe80e: // Icons.home
        return '🏠';
      case 0xe57e: // Icons.sports_soccer
        return '⚽';
      case 0xe405: // Icons.music_note
        return '�';
      case 0xe30e: // Icons.games
        return '🎮';
      case 0xe654: // Icons.diamond
        return '💎';
      case 0xe540: // Icons.fitness_center
        return '💪';
      case 0xe7fd: // Icons.school
        return '🎓';
      case 0xe3f7: // Icons.pets
        return '🐕';
      case 0xe7ee: // Icons.child_care
        return '👶';
      case 0xe56d: // Icons.spa
        return '🧘';
      case 0xe16c: // Icons.local_gas_station
        return '⛽';
      case 0xe564: // Icons.local_hospital
        return '🏥';
      case 0xe15c: // Icons.hotel
        return '🏨';
      case 0xe558: // Icons.local_taxi
        return '🚕';

      // Intentar mapear por el nombre de la categoría y el icono como fallback
      default:
        return _getEmojiByIconName(tienda);
    }
  }
  */

  // Función mejorada para mapear por nombre de icono - TEMPORALMENTE COMENTADA
  /*
  String _getEmojiByIconName(Tienda tienda) {
    final iconName = tienda.icon?.toLowerCase() ?? '';

    // Mapeo directo por nombre de icono
    switch (iconName) {
      case 'store':
        return '🏪';
      case 'shopping_bag':
      case 'shopping_cart':
        return '🛍️';
      case 'car':
      case 'motorcycle':
        return '🚗';
      case 'tshirt':
      case 'dress':
      case 'male_clothes':
      case 'baby_clothes':
        return '👕';
      case 'mobile':
      case 'laptop':
      case 'tablet':
      case 'desktop':
        return '📱';
      case 'pharmacy':
      case 'medical':
        return '💊';
      case 'restaurant':
      case 'hamburger':
      case 'pizza':
        return '🍽️';
      case 'coffee':
        return '☕';
      case 'home':
      case 'chair':
      case 'bed':
      case 'kitchen':
        return '🏠';
      case 'dumbbell':
      case 'basketball':
      case 'tennis':
      case 'football':
        return '💪';
      case 'tools':
      case 'hammer':
      case 'wrench':
        return '🔧';
      case 'gamepad':
      case 'esports':
        return '🎮';
      case 'beauty':
      case 'spa':
        return '💄';
      case 'dog':
      case 'cat':
      case 'paw':
        return '🐕';
      case 'wine':
      case 'beer':
        return '🍷';
      case 'cake':
      case 'bread':
        return '🍰';
      case 'gas_station':
        return '⛽';
      case 'shoe':
        return '👟';
      case 'lightbulb':
        return '💡';
      case 'camera':
        return '📷';
      case 'tv':
        return '📺';
      case 'bicycle':
        return '🚲';
      default:
        return _getEmojiByCategory(tienda);
    }
  }
  */

  // Función auxiliar para obtener emoji por nombre de categoría como fallback - TEMPORALMENTE COMENTADA
  /*
  String _getEmojiByCategory(Tienda tienda) {
    final categoryName = tienda.categoryName?.toLowerCase() ?? '';
    final iconName = tienda.icon?.toLowerCase() ?? '';

    // Mapeo por nombre de categoría e icono
    if (categoryName.contains('comida') ||
        categoryName.contains('restaurante') ||
        iconName.contains('restaurant') ||
        iconName.contains('food'))
      return '🍽️';
    if (categoryName.contains('café') ||
        categoryName.contains('cafetería') ||
        iconName.contains('coffee') ||
        iconName.contains('cafe'))
      return '☕';
    if (categoryName.contains('ropa') ||
        categoryName.contains('vestimenta') ||
        iconName.contains('clothes') ||
        iconName.contains('fashion'))
      return '👕';
    if (categoryName.contains('tecnología') ||
        categoryName.contains('electrónico') ||
        iconName.contains('electronic') ||
        iconName.contains('device'))
      return '📱';
    if (categoryName.contains('farmacia') ||
        categoryName.contains('medicina') ||
        iconName.contains('pharmacy') ||
        iconName.contains('medical'))
      return '💊';
    if (categoryName.contains('librería') ||
        categoryName.contains('libro') ||
        iconName.contains('book') ||
        iconName.contains('library'))
      return '📚';
    if (categoryName.contains('ferretería') ||
        categoryName.contains('herramienta') ||
        iconName.contains('build') ||
        iconName.contains('tool'))
      return '🔧';
    if (categoryName.contains('belleza') ||
        categoryName.contains('cosmético') ||
        iconName.contains('beauty') ||
        iconName.contains('cosmetic'))
      return '�';
    if (categoryName.contains('deportes') ||
        categoryName.contains('fitness') ||
        iconName.contains('sport') ||
        iconName.contains('fitness'))
      return '⚽';
    if (categoryName.contains('música') ||
        categoryName.contains('instrumento') ||
        iconName.contains('music') ||
        iconName.contains('sound'))
      return '🎵';
    if (categoryName.contains('juguete') ||
        categoryName.contains('juego') ||
        iconName.contains('game') ||
        iconName.contains('toy'))
      return '🎮';
    if (categoryName.contains('auto') ||
        categoryName.contains('carro') ||
        iconName.contains('car') ||
        iconName.contains('auto'))
      return '�';
    if (categoryName.contains('joyería') ||
        categoryName.contains('joyas') ||
        iconName.contains('diamond') ||
        iconName.contains('jewelry'))
      return '💎';
    if (categoryName.contains('hogar') ||
        categoryName.contains('casa') ||
        iconName.contains('home') ||
        iconName.contains('house'))
      return '�';

    // Emoji por defecto para tiendas
    return '🏪';
  }
  */

  void _showTiendasList() {
    if (_tiendas.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Barra superior
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.store,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Tiendas (${_tiendas.length})',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Lista de tiendas
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _tiendas.length,
                      itemBuilder: (context, index) {
                        final tienda = _tiendas[index];
                        final color = MapboxTiendaMarker.getMarkerColor(tienda);
                        final icon = MapboxTiendaMarker.getMarkerIcon(tienda);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.1),
                            child: Icon(icon, color: color, size: 20),
                          ),
                          title: Text(
                            tienda.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tienda.categoryName != null)
                                Text(
                                  tienda.categoryName!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              Text(
                                '${tienda.ubicacion.lat.toStringAsFixed(4)}, ${tienda.ubicacion.lng.toStringAsFixed(4)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.location_on, size: 20),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _moveToLocation(
                                    tienda.ubicacion.lat,
                                    tienda.ubicacion.lng,
                                  );
                                },
                                tooltip: 'Ir a ubicación',
                              ),
                              IconButton(
                                icon: const Icon(Icons.info, size: 20),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _showTiendaInfo(tienda);
                                },
                                tooltip: 'Ver detalles',
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _showTiendaInfo(tienda);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
      // Crear managers de anotaciones
      _pointAnnotationManager =
          await mapboxMap!.annotations.createPointAnnotationManager();
      _circleAnnotationManager =
          await mapboxMap!.annotations.createCircleAnnotationManager();

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

      // Agregar marcadores de tiendas desde Supabase
      await _addTiendasFromSupabase();
    } catch (e) {
      print('Error agregando marcadores iniciales: $e');
    }
  }

  Future<void> _addMarker({
    required double lat,
    required double lng,
    required String title,
    required Color color,
    Tienda? tienda,
  }) async {
    if (_pointAnnotationManager == null) return;

    try {
      // Si es una tienda, crear marcador visual mejorado
      if (tienda != null && _circleAnnotationManager != null) {
        await _addTiendaMarker(tienda);
      } else {
        // Marcador estándar para ubicaciones generales
        final pointAnnotationOptions = PointAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
          textField: title,
          textOffset: [0.0, -2.5],
          textColor: color.value,
          textSize: 12.0,
          textHaloColor: Colors.white.value,
          textHaloWidth: 1.5,
          iconSize: 1.2,
          iconColor: color.value,
          iconOpacity: 0.9,
        );

        await _pointAnnotationManager!.create(pointAnnotationOptions);
      }

      // Almacenar la referencia de la tienda
      if (tienda != null) {
        _tiendas.add(tienda);
        print(
          'Marcador creado para tienda: ${tienda.name} (${tienda.categoryName ?? 'Sin categoría'})',
        );
      }
    } catch (e) {
      print('Error agregando marcador: $e');
    }
  }

  Future<void> _addTiendaMarker(Tienda tienda) async {
    if (_circleAnnotationManager == null || _pointAnnotationManager == null)
      return;

    try {
      final tiendaColor = MapboxTiendaMarker.getMarkerColor(tienda);
      final position = Position(tienda.ubicacion.lng, tienda.ubicacion.lat);

      // Crear círculo exterior (sombra/halo) - MÁS GRANDE para mejor detección
      final haloCircleOptions = CircleAnnotationOptions(
        geometry: Point(coordinates: position),
        circleRadius: 35.0, // Aumentado de 25.0 a 35.0
        circleColor: tiendaColor.withOpacity(0.2).value,
        circleOpacity: 0.4,
        circleStrokeWidth: 0.0,
      );
      await _circleAnnotationManager!.create(haloCircleOptions);

      // Crear círculo principal (globo del marcador) - MÁS GRANDE
      final mainCircleOptions = CircleAnnotationOptions(
        geometry: Point(coordinates: position),
        circleRadius: 22.0, // Aumentado de 18.0 a 22.0
        circleColor: tiendaColor.value,
        circleOpacity: 0.9,
        circleStrokeColor: Colors.white.value,
        circleStrokeWidth: 3.0, // Aumentado de 2.5 a 3.0
        circleStrokeOpacity: 1.0,
      );
      await _circleAnnotationManager!.create(mainCircleOptions);

      // Crear punto con icono de tienda usando emoji/símbolo contextual
      final tiendaEmoji = _getTiendaEmoji(tienda);
      print(
        'Debug: Emoji para ${tienda.name}: "$tiendaEmoji" (length: ${tiendaEmoji.length})',
      );
      final iconPointOptions = PointAnnotationOptions(
        geometry: Point(coordinates: position),
        textField: tiendaEmoji,
        textColor: Colors.white.value,
        textSize: 18.0, // Aumentado de 16.0 a 18.0
        textOffset: [0.0, 0.0], // Centrado
        textHaloColor: Colors.black.value,
        textHaloWidth: 1.5,
      );
      await _pointAnnotationManager!.create(iconPointOptions);

      // Crear texto con el nombre de la tienda - MÁS VISIBLE
      final namePointOptions = PointAnnotationOptions(
        geometry: Point(coordinates: position),
        textField: tienda.name,
        textOffset: [0.0, -4.5], // Alejado más del marcador
        textColor: tiendaColor.value,
        textSize: 11.0, // Aumentado de 10.0 a 11.0
        textHaloColor: Colors.white.value,
        textHaloWidth: 2.5, // Aumentado de 2.0 a 2.5
      );
      await _pointAnnotationManager!.create(namePointOptions);

      print(
        'Marcador mejorado creado para: ${tienda.name} en (${tienda.ubicacion.lat}, ${tienda.ubicacion.lng})',
      );
    } catch (e) {
      print('Error creando marcador de tienda: $e');
    }
  }

  Future<void> _addTiendasFromSupabase() async {
    setState(() {
      _isLoadingTiendas = true;
    });

    try {
      // Obtener tiendas desde Supabase
      final tiendas = await SupabaseTiendaService.getAllTiendas();

      // Agregar marcador para cada tienda con su color específico
      for (final tienda in tiendas) {
        final tiendaColor = MapboxTiendaMarker.getMarkerColor(tienda);
        await _addMarker(
          lat: tienda.ubicacion.lat,
          lng: tienda.ubicacion.lng,
          title: tienda.name,
          color: tiendaColor,
          tienda: tienda,
        );
      }

      // Actualizar contador de marcadores y estado
      setState(() {
        _tiendasCount = tiendas.length;
        _markers = List.generate(
          tiendas.length + 2,
          (index) => PointAnnotationOptions(
            geometry: Point(coordinates: Position(0, 0)),
          ),
        );
        _isLoadingTiendas = false;
      });

      // Mostrar información de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tiendas.length} tiendas cargadas desde Supabase'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error cargando tiendas desde Supabase: $e');

      // Fallback: usar tiendas de ejemplo si falla la carga desde Supabase
      final exampleStores = [
        {'name': 'Mercado Rodriguez', 'lat': -16.4985, 'lng': -68.1435},
        {'name': 'Plaza San Francisco', 'lat': -16.4955, 'lng': -68.1360},
        {'name': 'Mercado de las Brujas', 'lat': -16.4950, 'lng': -68.1380},
        {
          'name': 'Centro Comercial Megacenter',
          'lat': -16.5320,
          'lng': -68.0730,
        },
      ];

      for (final store in exampleStores) {
        await _addMarker(
          lat: store['lat'] as double,
          lng: store['lng'] as double,
          title: store['name'] as String,
          color:
              Colors
                  .orange, // Color diferente para indicar que son datos de ejemplo
        );
      }

      // Actualizar contador con datos de ejemplo
      setState(() {
        _tiendasCount = exampleStores.length;
        _markers = List.generate(
          exampleStores.length + 2,
          (index) => PointAnnotationOptions(
            geometry: Point(coordinates: Position(0, 0)),
          ),
        );
        _isLoadingTiendas = false;
      });

      // Mostrar notificación de fallback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Usando datos de ejemplo. Error al cargar desde Supabase',
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
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

      // Limpiar también los círculos de las tiendas
      if (_circleAnnotationManager != null) {
        await _circleAnnotationManager!.deleteAll();
      }

      // Reiniciar contadores y listas
      setState(() {
        _tiendasCount = 0;
        _markers = [];
        _tiendas = [];
      });

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

  Future<void> _reloadTiendas() async {
    // Limpiar marcadores actuales
    _clearMarkers();

    // Esperar un momento para que la limpieza se complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Recargar marcadores básicos
    await _addInitialMarkers();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tiendas recargadas desde Supabase'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showMapStyleModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Indicador de arrastre
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Título
                      const Text(
                        'Estilos de Mapa',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Lista de estilos
                      _buildStyleOption(
                        'Estándar',
                        MapboxStyles.STANDARD,
                        Icons.map,
                        'Vista estándar con calles y etiquetas',
                      ),
                      _buildStyleOption(
                        'Satélite',
                        MapboxStyles.SATELLITE,
                        Icons.satellite_alt,
                        'Imágenes satelitales de alta resolución',
                      ),
                      _buildStyleOption(
                        'Satélite con Calles',
                        MapboxStyles.SATELLITE_STREETS,
                        Icons.layers,
                        'Combina vista satelital con información de calles',
                      ),
                      _buildStyleOption(
                        'Oscuro',
                        MapboxStyles.DARK,
                        Icons.dark_mode,
                        'Tema oscuro ideal para navegación nocturna',
                      ),

                      // Espacio extra en la parte inferior
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStyleOption(
    String title,
    String style,
    IconData icon,
    String description,
  ) {
    final isSelected = _selectedMapStyle == style;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          _changeMapStyle(style);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTiendaInfo(Tienda tienda) {
    final Color tiendaColor = MapboxTiendaMarker.getMarkerColor(tienda);
    final IconData tiendaIcon = MapboxTiendaMarker.getMarkerIcon(tienda);
    final String tiendaEmoji = _getTiendaEmoji(tienda);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Aumentado de 0.4 a 0.5
          minChildSize: 0.3,
          maxChildSize: 0.8, // Aumentado de 0.7 a 0.8
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra superior con indicador de arrastre
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Título con icono y emoji
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: tiendaColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: tiendaColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                tiendaEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tienda.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (tienda.categoryName != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tiendaColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tienda.categoryName!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: tiendaColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Información básica en cards
                      if (tienda.ownerName.isNotEmpty) ...[
                        _buildInfoCard(
                          Icons.person,
                          'Propietario',
                          tienda.ownerName,
                          tiendaColor,
                        ),
                        const SizedBox(height: 12),
                      ],

                      if (tienda.address?.isNotEmpty == true) ...[
                        _buildInfoCard(
                          Icons.location_on,
                          'Dirección',
                          tienda.address!,
                          tiendaColor,
                        ),
                        const SizedBox(height: 12),
                      ],

                      _buildInfoCard(
                        Icons.schedule,
                        'Horario',
                        tienda.operatingHours,
                        tiendaColor,
                      ),

                      if (tienda.schedules.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          Icons.calendar_today,
                          'Días de atención',
                          tienda.schedules.join(', '),
                          tiendaColor,
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Ubicación con mapa mini
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.map, color: tiendaColor, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Ubicación',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(tiendaIcon, color: tiendaColor, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Lat: ${tienda.ubicacion.lat.toStringAsFixed(6)}\nLng: ${tienda.ubicacion.lng.toStringAsFixed(6)}',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botones de acción mejorados
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _moveToLocation(
                                  tienda.ubicacion.lat,
                                  tienda.ubicacion.lng,
                                );
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text('Ir a ubicación'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tiendaColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close),
                              label: const Text('Cerrar'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: tiendaColor,
                                side: BorderSide(color: tiendaColor),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Espacio extra para el área segura inferior
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String title,
    String content,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildInfoRow - Función anterior mantenida por compatibilidad
  /*
  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  */

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

          // Botón de estilos de mapa (superior derecho)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'map_styles',
              onPressed: _showMapStyleModal,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              mini: true,
              child: const Icon(Icons.layers),
            ),
          ),

          // Botones de navegación flotantes
          Positioned(
            bottom: 160,
            right: 16,
            child: SizedBox(
              width: 56, // Ancho fijo para evitar constraints infinitos
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'reload_tiendas',
                    onPressed: _reloadTiendas,
                    backgroundColor: Colors.purple,
                    child: const Icon(Icons.refresh, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Panel de información inferior
          Positioned(
            bottom: 16,
            left: 16,
            right: 80,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: double.infinity,
                maxHeight: 200, // Altura máxima para evitar overflow
              ),
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
                          const Expanded(
                            child: Text(
                              'Información del Mapa',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_tiendas.isNotEmpty)
                            GestureDetector(
                              onTap: _showTiendasList,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Ver lista',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.store,
                            size: 16,
                            color:
                                _isLoadingTiendas
                                    ? Colors.orange
                                    : (_tiendasCount > 0
                                        ? Colors.green
                                        : Colors.grey),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_tiendasCount} tiendas • ${_markers.length} marcadores',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  _isLoadingTiendas
                                      ? Colors.orange
                                      : (_tiendasCount > 0
                                          ? Colors.green
                                          : Colors.grey),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      if (_isLoadingTiendas) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Cargando tiendas...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Toca cerca de un marcador para ver detalles de la tienda',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
          ),
        ],
      ),
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
