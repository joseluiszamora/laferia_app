import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TileCacheService {
  static TileCacheService? _instance;
  static TileCacheService get instance => _instance ??= TileCacheService._();

  TileCacheService._();

  Database? _database;
  String? _cachePath;

  // Inicializar el servicio de caché
  Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _cachePath = '${directory.path}/map_tiles';

    // Crear directorio si no existe
    final cacheDir = Directory(_cachePath!);
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    // Inicializar base de datos para metadatos
    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tile_cache.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tiles(
            id TEXT PRIMARY KEY,
            url TEXT NOT NULL,
            file_path TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            last_accessed INTEGER NOT NULL,
            zoom_level INTEGER NOT NULL,
            x INTEGER NOT NULL,
            y INTEGER NOT NULL,
            size INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Obtener tile del caché o descargarlo
  Future<Uint8List?> getTile(String url, int z, int x, int y) async {
    final tileId = _getTileId(z, x, y);

    // Intentar obtener del caché primero
    final cachedTile = await _getCachedTile(tileId);
    if (cachedTile != null) {
      await _updateLastAccessed(tileId);
      return cachedTile;
    }

    // Si no está en caché, descargar
    return await _downloadAndCacheTile(url, tileId, z, x, y);
  }

  // Obtener tile del caché
  Future<Uint8List?> _getCachedTile(String tileId) async {
    try {
      final result = await _database!.query(
        'tiles',
        where: 'id = ?',
        whereArgs: [tileId],
      );

      if (result.isNotEmpty) {
        final filePath = result.first['file_path'] as String;
        final file = File(filePath);

        if (await file.exists()) {
          return await file.readAsBytes();
        } else {
          // Archivo no existe, eliminar registro
          await _database!.delete(
            'tiles',
            where: 'id = ?',
            whereArgs: [tileId],
          );
        }
      }
    } catch (e) {
      print('Error obteniendo tile del caché: $e');
    }

    return null;
  }

  // Descargar y cachear tile
  Future<Uint8List?> _downloadAndCacheTile(
    String url,
    String tileId,
    int z,
    int x,
    int y,
  ) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: {'User-Agent': 'Flutter Map Cache/1.0'})
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        await _saveTileToCache(tileId, url, bytes, z, x, y);
        return bytes;
      }
    } catch (e) {
      print('Error descargando tile: $e');
    }

    return null;
  }

  // Guardar tile en caché
  Future<void> _saveTileToCache(
    String tileId,
    String url,
    Uint8List bytes,
    int z,
    int x,
    int y,
  ) async {
    try {
      final filePath = '$_cachePath/$tileId.png';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      final now = DateTime.now().millisecondsSinceEpoch;

      await _database!.insert('tiles', {
        'id': tileId,
        'url': url,
        'file_path': filePath,
        'created_at': now,
        'last_accessed': now,
        'zoom_level': z,
        'x': x,
        'y': y,
        'size': bytes.length,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('Error guardando tile en caché: $e');
    }
  }

  // Guardar tile desde bytes (para tiles por defecto desde assets)
  Future<void> saveTileFromBytes(
    String url,
    int z,
    int x,
    int y,
    Uint8List bytes,
  ) async {
    final tileId = _getTileId(z, x, y);
    await _saveTileToCache(tileId, url, bytes, z, x, y);
  }

  // Actualizar último acceso
  Future<void> _updateLastAccessed(String tileId) async {
    try {
      await _database!.update(
        'tiles',
        {'last_accessed': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [tileId],
      );
    } catch (e) {
      print('Error actualizando último acceso: $e');
    }
  }

  // Generar ID único para tile
  String _getTileId(int z, int x, int y) {
    return '${z}_${x}_$y';
  }

  // Precargar área específica
  Future<void> preloadArea({
    required double northEast_lat,
    required double northEast_lng,
    required double southWest_lat,
    required double southWest_lng,
    required List<int> zoomLevels,
    required String urlTemplate,
    Function(int current, int total)? onProgress,
  }) async {
    int totalTiles = 0;
    int currentTile = 0;

    // Calcular total de tiles
    for (int zoom in zoomLevels) {
      final bounds = _calculateTileBounds(
        northEast_lat,
        northEast_lng,
        southWest_lat,
        southWest_lng,
        zoom,
      );
      totalTiles +=
          ((bounds['maxX'] ?? 0) - (bounds['minX'] ?? 0) + 1) *
          ((bounds['maxY'] ?? 0) - (bounds['minY'] ?? 0) + 1);
    }

    // Descargar tiles
    for (int zoom in zoomLevels) {
      final bounds = _calculateTileBounds(
        northEast_lat,
        northEast_lng,
        southWest_lat,
        southWest_lng,
        zoom,
      );

      for (int x = bounds['minX']!; x <= bounds['maxX']!; x++) {
        for (int y = bounds['minY']!; y <= bounds['maxY']!; y++) {
          final url = urlTemplate
              .replaceAll('{z}', zoom.toString())
              .replaceAll('{x}', x.toString())
              .replaceAll('{y}', y.toString());

          await getTile(url, zoom, x, y);
          currentTile++;

          if (onProgress != null) {
            onProgress(currentTile, totalTiles);
          }

          // Pequeña pausa para no sobrecargar el servidor
          await Future.delayed(Duration(milliseconds: 50));
        }
      }
    }
  }

  // Calcular bounds de tiles
  Map<String, int> _calculateTileBounds(
    double northEast_lat,
    double northEast_lng,
    double southWest_lat,
    double southWest_lng,
    int zoom,
  ) {
    final factor = (1 << zoom).toDouble();

    final minX = ((southWest_lng + 180.0) / 360.0 * factor).floor();
    final maxX = ((northEast_lng + 180.0) / 360.0 * factor).floor();

    // Convertir latitud a radianes y calcular Y usando proyección de Mercator
    final northEastLatRad = northEast_lat * math.pi / 180.0;
    final southWestLatRad = southWest_lat * math.pi / 180.0;

    final minY =
        ((1.0 - _asinh(math.tan(northEastLatRad)) / math.pi) / 2.0 * factor)
            .floor();
    final maxY =
        ((1.0 - _asinh(math.tan(southWestLatRad)) / math.pi) / 2.0 * factor)
            .floor();

    return {'minX': minX, 'maxX': maxX, 'minY': minY, 'maxY': maxY};
  }

  // Función auxiliar para calcular asinh (arcoseno hiperbólico)
  double _asinh(double x) {
    return math.log(x + math.sqrt(x * x + 1.0));
  }

  // Limpiar caché antiguo
  Future<void> cleanOldCache({int maxAgeInDays = 30}) async {
    try {
      final cutoffDate =
          DateTime.now()
              .subtract(Duration(days: maxAgeInDays))
              .millisecondsSinceEpoch;

      // Obtener tiles antiguos
      final oldTiles = await _database!.query(
        'tiles',
        where: 'last_accessed < ?',
        whereArgs: [cutoffDate],
      );

      // Eliminar archivos
      for (final tile in oldTiles) {
        final file = File(tile['file_path'] as String);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Eliminar registros de la BD
      await _database!.delete(
        'tiles',
        where: 'last_accessed < ?',
        whereArgs: [cutoffDate],
      );

      print('Limpieza completada: ${oldTiles.length} tiles eliminados');
    } catch (e) {
      print('Error limpiando caché: $e');
    }
  }

  // Obtener estadísticas del caché
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final result = await _database!.rawQuery('''
        SELECT 
          COUNT(*) as tile_count,
          SUM(size) as total_size,
          MAX(last_accessed) as last_used
        FROM tiles
      ''');

      return {
        'tile_count': result.first['tile_count'] ?? 0,
        'total_size_mb':
            ((result.first['total_size'] ?? 0) as int) / (1024 * 1024),
        'last_used':
            result.first['last_used'] != null
                ? DateTime.fromMillisecondsSinceEpoch(
                  result.first['last_used'] as int,
                )
                : null,
      };
    } catch (e) {
      print('Error obteniendo estadísticas: $e');
      return {};
    }
  }
}
