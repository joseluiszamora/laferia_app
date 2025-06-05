import 'package:laferia/maps/offline_map_config.dart';

/// Helper para manejar proveedores de mapas dinámicamente
class MapProviderHelper {
  // Lista de todos los proveedores disponibles
  static List<String> get availableProviders =>
      OfflineMapConfig.tileProviders.keys.toList();

  // Obtener información completa de un proveedor
  static MapProviderInfo getProviderInfo(String providerId) {
    return MapProviderInfo(
      id: providerId,
      name: _getProviderDisplayName(providerId),
      url: OfflineMapConfig.getProviderUrl(providerId),
      subdomains: OfflineMapConfig.providerSubdomains[providerId] ?? [],
      attribution: OfflineMapConfig.providerAttributions[providerId] ?? '',
    );
  }

  // Obtener información del proveedor por defecto
  static MapProviderInfo get defaultProviderInfo =>
      getProviderInfo(OfflineMapConfig.defaultProvider);

  // Obtener todas las opciones de proveedores para UI
  static List<MapProviderOption> get providerOptions {
    return availableProviders
        .map(
          (id) => MapProviderOption(
            id: id,
            name: _getProviderDisplayName(id),
            description: _getProviderDescription(id),
          ),
        )
        .toList();
  }

  // Nombres amigables para mostrar en UI
  static String _getProviderDisplayName(String providerId) {
    switch (providerId) {
      case 'openstreetmap':
        return 'OpenStreetMap';
      case 'cartodb_light':
        return 'CartoDB Light';
      case 'cartodb_dark':
        return 'CartoDB Dark';
      case 'stadia_smooth':
        return 'Stadia Smooth';
      case 'stadia_dark':
        return 'Stadia Dark';
      default:
        return providerId;
    }
  }

  // Descripciones para mostrar en UI
  static String _getProviderDescription(String providerId) {
    switch (providerId) {
      case 'openstreetmap':
        return 'Mapa estándar de OpenStreetMap';
      case 'cartodb_light':
        return 'Estilo claro y minimalista';
      case 'cartodb_dark':
        return 'Estilo oscuro elegante';
      case 'stadia_smooth':
        return 'Estilo suave y moderno';
      case 'stadia_dark':
        return 'Estilo oscuro profesional';
      default:
        return 'Proveedor personalizado';
    }
  }

  // Validar si un proveedor existe
  static bool isValidProvider(String providerId) {
    return OfflineMapConfig.tileProviders.containsKey(providerId);
  }

  // Crear URL completa reemplazando placeholders
  static String buildTileUrl(
    String providerId,
    int z,
    int x,
    int y, {
    String? subdomain,
  }) {
    final url = OfflineMapConfig.getProviderUrl(providerId);
    final subdomains = OfflineMapConfig.providerSubdomains[providerId] ?? [];
    final selectedSubdomain =
        subdomain ?? (subdomains.isNotEmpty ? subdomains[0] : 'a');

    return url
        .replaceAll('{z}', z.toString())
        .replaceAll('{x}', x.toString())
        .replaceAll('{y}', y.toString())
        .replaceAll('{s}', selectedSubdomain);
  }
}

/// Información completa de un proveedor de mapas
class MapProviderInfo {
  final String id;
  final String name;
  final String url;
  final List<String> subdomains;
  final String attribution;

  const MapProviderInfo({
    required this.id,
    required this.name,
    required this.url,
    required this.subdomains,
    required this.attribution,
  });

  @override
  String toString() => 'MapProviderInfo(id: $id, name: $name)';
}

/// Opción de proveedor para mostrar en UI
class MapProviderOption {
  final String id;
  final String name;
  final String description;

  const MapProviderOption({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  String toString() => name;
}
