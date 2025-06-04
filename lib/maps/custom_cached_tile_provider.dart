import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:typed_data';

import 'package:laferia/maps/tile_cache_service.dart';

class CustomCachedTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return CustomCachedImageProvider(
      coordinates: coordinates,
      options: options,
    );
  }
}

class CustomCachedImageProvider
    extends ImageProvider<CustomCachedImageProvider> {
  final TileCoordinates coordinates;
  final TileLayer options;

  CustomCachedImageProvider({required this.coordinates, required this.options});

  @override
  Future<CustomCachedImageProvider> obtainKey(
    ImageConfiguration configuration,
  ) {
    return Future.value(this);
  }

  @override
  ImageStreamCompleter loadImage(
    CustomCachedImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
    );
  }

  Future<Codec> _loadAsync(
    CustomCachedImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    try {
      // Construir URL del tile
      final url = _buildTileUrl();

      // Intentar obtener del caché usando nuestro servicio
      final bytes = await TileCacheService.instance.getTile(
        url,
        coordinates.z,
        coordinates.x,
        coordinates.y,
      );

      if (bytes != null) {
        final buffer = await ImmutableBuffer.fromUint8List(bytes);
        return await decode(buffer);
      } else {
        throw Exception('Failed to load tile');
      }
    } catch (e) {
      // En caso de error, mostrar tile de error
      return _createErrorTile(decode);
    }
  }

  String _buildTileUrl() {
    String url = options.urlTemplate ?? '';

    // Reemplazar placeholders
    url = url.replaceAll('{z}', coordinates.z.toString());
    url = url.replaceAll('{x}', coordinates.x.toString());
    url = url.replaceAll('{y}', coordinates.y.toString());
    url = url.replaceAll('{r}', '');

    // Manejar subdominios si existen
    if (options.subdomains.isNotEmpty) {
      final subdomain =
          options.subdomains[(coordinates.x + coordinates.y) %
              options.subdomains.length];
      url = url.replaceAll('{s}', subdomain);
    }

    return url;
  }

  Future<Codec> _createErrorTile(ImageDecoderCallback decode) async {
    // Crear un tile de error simple (256x256 pixels grises)
    final bytes = Uint8List(256 * 256 * 4); // RGBA

    for (int i = 0; i < bytes.length; i += 4) {
      bytes[i] = 128; // R
      bytes[i + 1] = 128; // G
      bytes[i + 2] = 128; // B
      bytes[i + 3] = 255; // A
    }

    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    return await decode(buffer);
  }

  @override
  bool operator ==(Object other) {
    if (other is! CustomCachedImageProvider) return false;
    return coordinates == other.coordinates &&
        options.urlTemplate == other.options.urlTemplate;
  }

  @override
  int get hashCode => Object.hash(coordinates, options.urlTemplate);
}
