import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/maps/custom_cached_tile_provider.dart';
import 'package:laferia/maps/map_provider_helper.dart';
import 'package:laferia/maps/offline_map_config.dart';
import 'package:latlong2/latlong.dart';

/// Ejemplo de cómo usar el sistema de proveedores dinámicamente
class MapProviderSwitcherExample extends StatefulWidget {
  const MapProviderSwitcherExample({super.key});

  @override
  State<MapProviderSwitcherExample> createState() =>
      _MapProviderSwitcherExampleState();
}

class _MapProviderSwitcherExampleState
    extends State<MapProviderSwitcherExample> {
  late MapController _mapController;
  String _currentProvider = OfflineMapConfig.defaultProvider;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProviderInfo = MapProviderHelper.getProviderInfo(
      _currentProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar Proveedor de Mapas'),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.layers),
            onSelected: (String providerId) {
              setState(() {
                _currentProvider = providerId;
              });
            },
            itemBuilder: (BuildContext context) {
              return MapProviderHelper.providerOptions.map((option) {
                return PopupMenuItem<String>(
                  value: option.id,
                  child: ListTile(
                    title: Text(option.name),
                    subtitle: Text(option.description),
                    leading: Icon(
                      option.id == _currentProvider
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color:
                          option.id == _currentProvider
                              ? Colors.blue
                              : Colors.grey,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Información del proveedor actual
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blueGrey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proveedor Actual: ${currentProviderInfo.name}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentProviderInfo.attribution,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Mapa con el proveedor seleccionado
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(
                  -16.500,
                  -68.130,
                ), // La Paz, Bolivia
                initialZoom: 13.0,
                minZoom: 5.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: currentProviderInfo.url,
                  userAgentPackageName: 'com.laferia.app',
                  tileProvider: CustomCachedTileProvider(),
                  tileSize: 256,
                  subdomains: currentProviderInfo.subdomains,
                ),

                // Atribución en el mapa
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      currentProviderInfo.attribution,
                      textStyle: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Botones de acceso rápido
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickProviderButton('openstreetmap', 'OSM'),
              _buildQuickProviderButton('cartodb_light', 'Light'),
              _buildQuickProviderButton('cartodb_dark', 'Dark'),
              _buildQuickProviderButton('stadia_smooth', 'Smooth'),
              _buildQuickProviderButton('stadia_dark', 'Stadia'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickProviderButton(String providerId, String label) {
    final isSelected = _currentProvider == providerId;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentProvider = providerId;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(60, 40),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

/// Widget para mostrar todos los proveedores disponibles
class ProviderListWidget extends StatelessWidget {
  final String currentProvider;
  final ValueChanged<String> onProviderChanged;

  const ProviderListWidget({
    super.key,
    required this.currentProvider,
    required this.onProviderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: MapProviderHelper.providerOptions.length,
      itemBuilder: (context, index) {
        final option = MapProviderHelper.providerOptions[index];
        final isSelected = option.id == currentProvider;

        return ListTile(
          leading: Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          title: Text(option.name),
          subtitle: Text(option.description),
          onTap: () => onProviderChanged(option.id),
        );
      },
    );
  }
}
