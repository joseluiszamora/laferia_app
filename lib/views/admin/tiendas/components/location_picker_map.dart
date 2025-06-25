import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/core/models/ubicacion.dart';
import 'package:laferia/maps/custom_cached_tile_provider.dart';
import 'package:laferia/maps/offline_map_config.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerMap extends StatefulWidget {
  final Ubicacion? initialLocation;
  final Function(Ubicacion) onLocationChanged;
  final double height;

  const LocationPickerMap({
    super.key,
    this.initialLocation,
    required this.onLocationChanged,
    this.height = 250,
  });

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late MapController _mapController;
  late LatLng _currentLocation;
  static const _laPazCenter = LatLng(-16.5000, -68.1193);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Usar ubicación inicial o La Paz como centro por defecto
    _currentLocation =
        widget.initialLocation != null
            ? LatLng(widget.initialLocation!.lat, widget.initialLocation!.lng)
            : _laPazCenter;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _currentLocation = position;
    });
    widget.onLocationChanged(
      Ubicacion(lat: position.latitude, lng: position.longitude),
    );
  }

  void _centerOnLaPaz() {
    _mapController.move(_laPazCenter, 14.0);
    setState(() {
      _currentLocation = _laPazCenter;
    });
    widget.onLocationChanged(
      Ubicacion(lat: _laPazCenter.latitude, lng: _laPazCenter.longitude),
    );
  }

  void _zoomIn() {
    final newZoom = (_mapController.camera.zoom + 1.0).clamp(1.0, 25.0);
    _mapController.move(_currentLocation, newZoom);
  }

  void _zoomOut() {
    final newZoom = (_mapController.camera.zoom - 1.0).clamp(1.0, 25.0);
    _mapController.move(_currentLocation, newZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Mapa
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 14.0,
                minZoom: 1.0,
                maxZoom: 25.0,
                onTap: (tapPosition, point) => _onMapTap(point),
              ),
              children: [
                // Capa de tiles
                TileLayer(
                  urlTemplate: OfflineMapConfig.getDefaultTileUrl(),
                  userAgentPackageName: 'com.laferia.app',
                  tileProvider: CustomCachedTileProvider(),
                  subdomains: OfflineMapConfig.getDefaultSubdomains(),
                ),

                // Marcador de ubicación seleccionada
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red[600],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Controles del mapa
          Positioned(
            top: 8,
            right: 8,
            child: Column(
              children: [
                // Botón de zoom in
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: _zoomIn,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Botón de zoom out
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: _zoomOut,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Botón de centrar en La Paz
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.my_location, size: 20),
                    onPressed: _centerOnLaPaz,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Instrucciones de uso
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Toca en el mapa para seleccionar ubicación',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),

          // Coordenadas actuales
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                'Lat: ${_currentLocation.latitude.toStringAsFixed(6)}\n'
                'Lng: ${_currentLocation.longitude.toStringAsFixed(6)}',
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
