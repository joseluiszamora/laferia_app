import 'package:flutter/material.dart';
import 'package:laferia/views/maps/modern_offline_map_screen.dart';
import 'package:laferia/views/maps/offline_map_manager.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:laferia/maps/default_tiles_service.dart';
import 'package:laferia/maps/map_provider_switcher_example.dart';
import 'package:laferia/maps/map_provider_helper.dart';

class MapNavigationHelper {
  // Navegar al mapa principal
  static void openMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ModernOfflineMapScreen()),
    );
  }

  // Navegar al gestor de mapas offline
  static void openMapManager(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OfflineMapManager()),
    );
  }

  // Navegar al ejemplo de cambio de proveedores
  static void openProviderSwitcher(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapProviderSwitcherExample(),
      ),
    );
  }

  // Obtener información del proveedor actual
  static MapProviderInfo getCurrentProviderInfo() {
    return MapProviderHelper.defaultProviderInfo;
  }

  // Widget para botón de mapa en la página principal
  static Widget buildMapButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () => openMap(context),
        icon: Icon(Icons.map_outlined),
        label: Text('Abrir Mapa Offline'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Widget para card de mapa en dashboard
  static Widget buildMapCard(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade600, Colors.blue.shade800],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.offline_bolt, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mapa Offline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Navega sin conexión a internet',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => openMap(context),
                      icon: Icon(Icons.map),
                      label: Text('Abrir Mapa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => openMapManager(context),
                    icon: Icon(Icons.settings),
                    label: Text('Config'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => openProviderSwitcher(context),
                    icon: Icon(Icons.layers),
                    label: Text('Estilo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para inicializar mapas en el startup de la app
  static Future<void> initializeMapsOnStartup() async {
    try {
      // Este método se puede llamar en main.dart o en un splash screen
      await TileCacheService.instance.initialize();
      await DefaultTilesService.loadDefaultTiles();
      print('Sistema de mapas offline inicializado exitosamente');
    } catch (e) {
      print('Error inicializando mapas offline: $e');
    }
  }
}

// Ejemplo de uso en una página principal
class ExampleHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('La Feria App'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => MapNavigationHelper.openMap(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Otros widgets de la app...

            // Card del mapa offline
            MapNavigationHelper.buildMapCard(context),

            // Más contenido...
          ],
        ),
      ),
    );
  }
}
