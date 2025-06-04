// Configuración del sistema de mapas offline
class OfflineMapConfig {
  // URLs de diferentes proveedores de mapas basados en OpenStreetMap
  static const Map<String, String> tileProviders = {
    'openstreetmap': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'cartodb_light':
        'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
    'cartodb_dark':
        'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
    'stadia_smooth':
        'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png',
    'stadia_dark':
        'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png',
  };

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
