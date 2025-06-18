// Configuración del sistema de mapas offline
class OfflineMapConfig {
  // PROVEEDOR POR DEFECTO - Cambia este valor para usar otro mapa
  static const String defaultProvider =
      'cartodb_voyager'; // Cambia aquí: 'openstreetmap', 'cartodb_light', 'cartodb_dark', 'stadia_smooth', 'stadia_dark', 'basemaps', 'stamen'

  // URLs de diferentes proveedores de mapas basados en OpenStreetMap
  // recomendado basemaps es gratuito
  static const Map<String, String> tileProviders = {
    'openstreetmap': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'cartodb_light':
        'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/light_all/{z}/{x}/{y}.png',
    'cartodb_dark':
        'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/dark_all/{z}/{x}/{y}.png',
    'cartodb_voyager':
        'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png',
    'basemaps': 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
    'esri':
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    'opentopo': 'https://tile.opentopomap.org/{z}/{x}/{y}.png',
  };

  // Subdominios para proveedores que los soportan
  static const Map<String, List<String>> providerSubdomains = {
    'openstreetmap': ['a', 'b', 'c'],
    'cartodb_light': ['a', 'b', 'c', 'd'],
    'cartodb_dark': ['a', 'b', 'c', 'd'],
    'cartodb_voyager': ['a', 'b', 'c', 'd'],
    'basemaps': ['a', 'b', 'c', 'd'],
    'stamen': ['a', 'b', 'c'],
    'esri': ['a', 'b', 'c', 'd'],
    'opentopo': ['a', 'b', 'c', 'd'],
  };

  // Atribuciones para cada proveedor
  static const Map<String, String> providerAttributions = {
    'openstreetmap': '© OpenStreetMap contributors',
    'cartodb_light': '© CartoDB © OpenStreetMap contributors',
    'cartodb_dark': '© CartoDB © OpenStreetMap contributors',
    'cartodb_voyager': '© CartoDB © OpenStreetMap contributors',
    'basemaps': '© Base Maps © OpenStreetMap contributors',
    'stamen': '© Stamen Maps © OpenStreetMap contributors',
    'esri': '© Esri Maps © OpenStreetMap contributors',
    'opentopo': '© Esri Maps © OpenStreetMap contributors',
  };

  // Métodos utilitarios para obtener configuración del proveedor por defecto
  static String getDefaultTileUrl() {
    return tileProviders[defaultProvider] ?? tileProviders['openstreetmap']!;
  }

  static String getPreferedTileUrl() {
    return tileProviders['cartodb_voyager']!;
  }

  static List<String> getDefaultSubdomains() {
    return providerSubdomains[defaultProvider] ?? [];
  }

  static String getDefaultAttribution() {
    return providerAttributions[defaultProvider] ??
        providerAttributions['openstreetmap']!;
  }

  static String getProviderUrl(String provider) {
    return tileProviders[provider] ?? getDefaultTileUrl();
  }

  static List<String> getProviderSubdomains(String provider) {
    return providerSubdomains[provider] ?? [];
  }

  static String getProviderAttribution(String provider) {
    return providerAttributions[provider] ?? getDefaultAttribution();
  }

  // Configuración de áreas predefinidas para La Paz
  static const Map<String, Map<String, double>> predefinedAreas = {
    'centro_lapaz': {
      'north': -16.490,
      'south': -16.510,
      'east': -68.120,
      'west': -68.140,
    },
    'zona_sur': {
      'north': -16.520,
      'south': -16.560,
      'east': -68.080,
      'west': -68.120,
    },
    'el_alto': {
      'north': -16.480,
      'south': -16.520,
      'east': -68.150,
      'west': -68.200,
    },
    'area_metropolitana': {
      'north': -16.400,
      'south': -16.600,
      'east': -68.000,
      'west': -68.250,
    },
    '16_de_julio': {
      'north': -16.490,
      'south': -16.500,
      'east': -68.160,
      'west': -68.180,
    },
  };

  // Niveles de zoom para diferentes tipos de uso
  static const Map<String, List<int>> zoomConfigs = {
    'basico': [12, 13, 14],
    'detallado': [12, 13, 14, 15, 16],
    'completo': [10, 11, 12, 13, 14, 15, 16, 17],
  };

  // Configuración de estilo de mapa moderno
  static const List<double> modernMapColorMatrix = [
    1.1, 0.0, 0.0, 0.0, -15, // Rojo
    0.0, 1.15, 0.0, 0.0, -20, // Verde
    0.0, 0.0, 1.2, 0.0, -25, // Azul
    0.0, 0.0, 0.0, 1.0, 0, // Alpha
  ];

  // Configuración de límites de caché
  static const Map<String, int> cacheConfig = {
    'maxTilesPerArea': 1000,
    'maxCacheSizeMB': 500,
    'maxAgeInDays': 30,
    'downloadTimeoutSeconds': 10,
    'delayBetweenDownloadsMs': 100,
  };

  // Marcadores predefinidos para La Paz
  static const Map<String, Map<String, dynamic>> landmarks = {
    'plaza_murillo': {
      'lat': -16.4955,
      'lng': -68.1336,
      'name': 'Plaza Murillo',
      'description': 'Centro político de Bolivia',
    },
    'mercado_rodriguez': {
      'lat': -16.5036,
      'lng': -68.1342,
      'name': 'Mercado Rodríguez',
      'description': 'Mercado tradicional',
    },
    'teleferico_rojo': {
      'lat': -16.5000,
      'lng': -68.1300,
      'name': 'Teleférico Línea Roja',
      'description': 'Estación Central',
    },
    'universidad_mayor': {
      'lat': -16.5403,
      'lng': -68.0739,
      'name': 'Universidad Mayor de San Andrés',
      'description': 'Campus universitario principal',
    },
  };
}
