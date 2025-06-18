import 'package:flutter/services.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:laferia/maps/offline_map_config.dart';

class DefaultTilesService {
  static const String _assetBasePath = 'assets/map_tiles';

  // Precargar tiles básicos desde assets
  static Future<void> loadDefaultTiles() async {
    try {
      // Lista de tiles básicos que deberías incluir en assets/map_tiles/
      final basicTiles = [
        {'z': 12, 'x': 1241, 'y': 1816}, // La Paz centro
        {'z': 12, 'x': 1240, 'y': 1816},
        {'z': 12, 'x': 1241, 'y': 1815},
        {'z': 12, 'x': 1240, 'y': 1815},
        {'z': 13, 'x': 2482, 'y': 3632},
        {'z': 13, 'x': 2481, 'y': 3632},
        {'z': 13, 'x': 2482, 'y': 3631},
        {'z': 13, 'x': 2481, 'y': 3631},
        {'z': 14, 'x': 4964, 'y': 7264},
        {'z': 14, 'x': 4963, 'y': 7264},
        {'z': 14, 'x': 4964, 'y': 7263},
        {'z': 14, 'x': 4963, 'y': 7263},
      ];

      for (final tile in basicTiles) {
        await _loadTileFromAssets(
          tile['z'] as int,
          tile['x'] as int,
          tile['y'] as int,
        );
      }

      print('Tiles por defecto cargados exitosamente');
    } catch (e) {
      print('Error cargando tiles por defecto: $e');
    }
  }

  static Future<void> _loadTileFromAssets(int z, int x, int y) async {
    try {
      final tilePath = '$_assetBasePath/$z/$x/$y.png';
      final bytes = await rootBundle.load(tilePath);
      final uint8List = bytes.buffer.asUint8List();

      // Guardar en el caché usando el servicio
      final url = OfflineMapConfig.getDefaultTileUrl()
          .replaceAll('{z}', z.toString())
          .replaceAll('{x}', x.toString())
          .replaceAll('{y}', y.toString())
          .replaceAll('{s}', 'a'); // Usar primer subdominio por defecto
      await TileCacheService.instance.saveTileFromBytes(
        url,
        z,
        x,
        y,
        uint8List,
      );
    } catch (e) {
      // Si el tile no existe en assets, descargarlo
      print('Tile $z/$x/$y no encontrado en assets, será descargado online');
    }
  }

  // Crear estructura de directorios para tiles por defecto
  static String getAssetTileStructure() {
    return '''
Para tener tiles offline por defecto, crea esta estructura en assets/:

assets/
  map_tiles/
    12/
      1240/
        1815.png
        1816.png
      1241/
        1815.png
        1816.png
    13/
      2481/
        3631.png
        3632.png
      2482/
        3631.png
        3632.png
    14/
      4963/
        7263.png
        7264.png
      4964/
        7263.png
        7264.png

Y agrega esto al pubspec.yaml:
assets:
  - assets/map_tiles/
    ''';
  }

  // Función para descargar y preparar tiles para assets
  static Future<void> downloadTilesForAssets() async {
    print('Para preparar tiles por defecto:');
    print('1. Ejecuta esta función una vez para descargar tiles básicos');
    print('2. Copia los archivos de la carpeta de caché a assets/map_tiles/');
    print('3. Incluye los assets en pubspec.yaml');

    // Descargar tiles básicos de La Paz
    await TileCacheService.instance.preloadArea(
      northEast_lat: -16.490,
      northEast_lng: -68.160,
      southWest_lat: -16.500,
      southWest_lng: -68.180,
      zoomLevels: [10, 11, 12, 13, 14, 15, 16, 17],
      urlTemplate: OfflineMapConfig.getPreferedTileUrl(),
    );

    print(
      'Tiles descargados. Revisa la carpeta de caché para copiarlos a assets/',
    );
  }
}
