import 'package:flutter/material.dart';
import 'package:laferia/maps/offline_map_config.dart';

void main() {
  runApp(const MapProviderTestApp());
}

class MapProviderTestApp extends StatelessWidget {
  const MapProviderTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Map Provider',
      debugShowCheckedModeBanner: false,
      home: const MapProviderTestScreen(),
    );
  }
}

class MapProviderTestScreen extends StatefulWidget {
  const MapProviderTestScreen({super.key});

  @override
  State<MapProviderTestScreen> createState() => _MapProviderTestScreenState();
}

class _MapProviderTestScreenState extends State<MapProviderTestScreen> {
  String _currentProvider = OfflineMapConfig.defaultProvider;

  void _changeProvider(String newProvider) {
    setState(() {
      _currentProvider = newProvider;
    });
    print('✅ Proveedor cambiado a: $newProvider');
    print('✅ URL: ${OfflineMapConfig.getProviderUrl(newProvider)}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Proveedores de Mapa'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Proveedor Actual:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getProviderDisplayName(_currentProvider),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: $_currentProvider',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    'URL: ${OfflineMapConfig.getProviderUrl(_currentProvider)}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Selecciona un proveedor:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children:
                    OfflineMapConfig.tileProviders.keys.map((providerId) {
                      final isSelected = _currentProvider == providerId;
                      return Card(
                        color: isSelected ? Colors.blue[100] : null,
                        child: ListTile(
                          leading: Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected ? Colors.blue : Colors.grey,
                          ),
                          title: Text(_getProviderDisplayName(providerId)),
                          subtitle: Text(providerId),
                          onTap: () => _changeProvider(providerId),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
