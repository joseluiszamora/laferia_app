# Sistema de Mapas Offline para La Feria App

## 🗺️ Características Implementadas

### ✅ 1. Basado en OpenStreetMap con Múltiples Proveedores

- Utiliza tiles de OpenStreetMap como fuente principal
- Soporte para múltiples proveedores de tiles (CartoDB, Stadia Maps)
- **Sistema configurable**: Cambia fácilmente entre proveedores
- Atribución correcta a OpenStreetMap contributors

### ✅ 2. Funcionalidad Offline Completa

- **Cache automático**: Los tiles se descargan y almacenan automáticamente mientras navegas
- **Tiles por defecto**: Sistema para incluir tiles básicos en la app desde el primer uso
- **Gestión inteligente de caché**: Base de datos SQLite para metadatos y archivos de imagen
- **Limpieza automática**: Eliminación de tiles antiguos para optimizar el espacio

### ✅ 3. Cache Inteligente en Tiempo Real

- Los tiles se descargan automáticamente cuando el usuario navega por el mapa
- Delay configurable para evitar sobrecargar el servidor
- Actualización de último acceso para gestión eficiente del caché
- Descarga en background sin afectar la experiencia del usuario

### ✅ 4. Estilo Moderno y Personalizable

- **Filtros de color**: Aplicación de matrices de color para un aspecto más moderno
- **Bordes redondeados**: Tiles con esquinas redondeadas y sombras sutiles
- **Animaciones**: Controles flotantes con animaciones suaves
- **UI moderna**: Interfaz con gradientes y elementos visuales atractivos

## 📁 Arquitectura del Sistema

```
lib/maps/
├── tile_cache_service.dart          # Servicio principal de caché
├── custom_cached_tile_provider.dart # Proveedor personalizado de tiles
├── default_tiles_service.dart       # Gestión de tiles por defecto
├── offline_map_config.dart         # Configuración y constantes
└── views/maps/
    ├── modern_offline_map_screen.dart # Pantalla principal del mapa
    ├── offline_map_manager.dart      # Gestor de descargas offline
    └── simple_offline_map_screen.dart # Versión simplificada
```

## 🚀 Uso Rápido

### 1. Mapa Básico Offline

```dart
import 'package:laferia/views/maps/modern_offline_map_screen.dart';

// En tu navegación
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ModernOfflineMapScreen(),
  ),
);
```

### 2. Gestor de Descargas

```dart
import 'package:laferia/views/maps/offline_map_manager.dart';

// Para configurar áreas offline
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => OfflineMapManager(),
  ),
);
```

## ⚙️ Configuración Inicial

### 1. Dependencias (ya incluidas en pubspec.yaml)

```yaml
dependencies:
  flutter_map: ^8.1.1
  latlong2: ^0.9.1
  sqflite: ^2.4.2
  path_provider: ^2.1.5
  http: ^1.4.0
```

### 2. Inicialización del Sistema

```dart
// En main.dart o en tu servicio de inicialización
await TileCacheService.instance.initialize();
```

### 3. Tiles por Defecto (Opcional pero Recomendado)

Para tener mapas disponibles desde la primera vez que abren la app:

1. **Crea la estructura de assets:**

```
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
      # ... más tiles
```

2. **Agrega al pubspec.yaml:**

```yaml
flutter:
  assets:
    - assets/map_tiles/
```

3. **Descarga tiles básicos:**

```dart
// Ejecuta esto una vez para preparar los tiles
await DefaultTilesService.downloadTilesForAssets();
```

## 🎯 Áreas Predefinidas para La Paz

El sistema incluye áreas predefinidas optimizadas para La Paz, Bolivia:

- **Centro de La Paz**: Plaza Murillo y alrededores
- **Zona Sur**: Calacoto, San Miguel
- **El Alto**: Centro de El Alto
- **Área Metropolitana**: Toda la conurbación La Paz-El Alto

## 🎨 Personalización del Estilo

### Cambiar Filtros de Color

```dart
// En OfflineMapConfig
static const List<double> modernMapColorMatrix = [
  1.1, 0.0, 0.0, 0.0, -15,  // Rojo (ajusta estos valores)
  0.0, 1.15, 0.0, 0.0, -20, // Verde
  0.0, 0.0, 1.2, 0.0, -25,  // Azul
  0.0, 0.0, 0.0, 1.0, 0,    // Alpha
];
```

### Cambiar Proveedor de Tiles

```dart
// En OfflineMapConfig.tileProviders
'mi_estilo': 'https://mi-servidor.com/tiles/{z}/{x}/{y}.png',
```

## 🔧 Configuración de Proveedores de Mapas

### Cambiar el Proveedor por Defecto

Para cambiar el proveedor de mapas por defecto, simplemente modifica la constante `defaultProvider` en el archivo `lib/maps/offline_map_config.dart`:

```dart
// En OfflineMapConfig
static const String defaultProvider = 'cartodb_light'; // Cambia este valor
```

### Proveedores Disponibles

| Proveedor     | Descripción                    | Valor             |
| ------------- | ------------------------------ | ----------------- |
| OpenStreetMap | Mapa estándar de OpenStreetMap | `'openstreetmap'` |
| CartoDB Light | Estilo claro y minimalista     | `'cartodb_light'` |
| CartoDB Dark  | Estilo oscuro elegante         | `'cartodb_dark'`  |
| Stadia Smooth | Estilo suave y moderno         | `'stadia_smooth'` |
| Stadia Dark   | Estilo oscuro profesional      | `'stadia_dark'`   |

### Ejemplo de Cambio

Para usar CartoDB Dark como proveedor por defecto:

```dart
// En lib/maps/offline_map_config.dart
class OfflineMapConfig {
  static const String defaultProvider = 'cartodb_dark'; // ← Cambiar aquí

  // ... resto del código
}
```

### Agregar Nuevos Proveedores

Para agregar un nuevo proveedor de tiles:

1. Añade la URL del tile al mapa `tileProviders`:

```dart
static const Map<String, String> tileProviders = {
  // ...existing providers...
  'mi_proveedor': 'https://mi-servidor.com/tiles/{z}/{x}/{y}.png',
};
```

2. Agrega subdominios si es necesario:

```dart
static const Map<String, List<String>> providerSubdomains = {
  // ...existing providers...
  'mi_proveedor': ['a', 'b', 'c'],
};
```

3. Agrega la atribución correspondiente:

```dart
static const Map<String, String> providerAttributions = {
  // ...existing providers...
  'mi_proveedor': '© Mi Proveedor © OpenStreetMap contributors',
};
```

## ⚡ Ventajas del Sistema Configurable

- **Flexibilidad**: Cambia el estilo visual con una sola línea
- **Mantenimiento**: Todos los URLs están centralizados
- **Escalabilidad**: Fácil agregar nuevos proveedores
- **Consistencia**: Todos los componentes usan la misma configuración

## 📱 Características de la UI

### Controles Disponibles

- **Zoom In/Out**: Controles de zoom con animaciones
- **Mi Ubicación**: Centra el mapa en La Paz
- **Descarga**: Descarga manual del área visible
- **Estadísticas**: Ver información del caché
- **Información**: Detalles sobre el mapa

### Indicadores Visuales

- **Estado Offline**: Indicador verde que muestra que el modo offline está activo
- **Progreso de Descarga**: Barra de progreso durante descargas manuales
- **Marcadores Modernos**: Marcadores con gradientes y sombras

## 🔧 Configuración Avanzada

### Límites de Caché

```dart
// En OfflineMapConfig.cacheConfig
static const Map<String, int> cacheConfig = {
  'maxTilesPerArea': 1000,        // Máximo tiles por área
  'maxCacheSizeMB': 500,          // Tamaño máximo en MB
  'maxAgeInDays': 30,             // Días antes de limpiar
  'downloadTimeoutSeconds': 10,   // Timeout de descarga
  'delayBetweenDownloadsMs': 100, // Delay entre descargas
};
```

### Niveles de Zoom

```dart
// Configuración de detalle
'basico': [12, 13, 14],           // Rápido, menos espacio
'detallado': [12, 13, 14, 15, 16], // Recomendado
'completo': [10, 11, 12, 13, 14, 15, 16, 17], // Lento, mucho espacio
```

## 🚨 Consideraciones Importantes

### Uso de Datos

- **Primera descarga**: Puede consumir varios MB dependiendo del área
- **Uso posterior**: Mínimo uso de datos (solo nuevas áreas)
- **Recomendación**: Descargar áreas importantes cuando esté conectado a WiFi

### Espacio de Almacenamiento

- **Tiles básicos**: ~2-5 MB para el centro de La Paz
- **Área completa**: ~50-100 MB para toda el área metropolitana
- **Limpieza automática**: El sistema elimina tiles antiguos automáticamente

### Performance

- **Carga inicial**: ~2-3 segundos para inicializar el caché
- **Navegación**: Respuesta instantánea en áreas cacheadas
- **Descarga background**: No afecta la navegación del usuario

## 🛠️ Comandos de Desarrollo

### Construir y ejecutar

```bash
cd /home/jzamora/development/laferia_app
flutter pub get
flutter run
```

### Limpiar caché de desarrollo

```bash
flutter clean
flutter pub get
```

### Generar release

```bash
flutter build apk --release
```

## 📋 TODO / Mejoras Futuras

- [ ] Soporte para navegación GPS offline
- [ ] Búsqueda de lugares offline
- [ ] Rutas offline básicas
- [ ] Exportar/importar áreas descargadas
- [ ] Compresión de tiles para optimizar espacio
- [ ] Soporte para mapas vectoriales

## 🤝 Contribución

Para agregar nuevas características al sistema de mapas:

1. Extiende `OfflineMapConfig` para nuevas configuraciones
2. Modifica `TileCacheService` para nueva funcionalidad de caché
3. Actualiza `ModernOfflineMapScreen` para nuevos controles UI
4. Documenta los cambios en este README

## 📞 Soporte

Si tienes problemas con la implementación:

1. Verifica que todas las dependencias estén instaladas
2. Asegúrate de que los permisos de almacenamiento estén configurados
3. Revisa los logs para errores de red o base de datos
4. Consulta la documentación de flutter_map para problemas específicos

## 🎯 Resumen de Cambios Completados

### ✅ Sistema Totalmente Configurable

Todos los archivos del sistema de mapas offline ahora utilizan la configuración centralizada en lugar de URLs hardcodeadas:

- ✅ `ModernOfflineMapScreen` - Utiliza `OfflineMapConfig.getDefaultTileUrl()`
- ✅ `SimpleOfflineMapScreen` - Utiliza configuración dinámica
- ✅ `MapsPage` - Actualizado para usar el sistema configurable
- ✅ `DefaultTilesService` - URLs dinámicas basadas en configuración
- ✅ `TileCacheService` - Compatible con todos los proveedores

### ✅ Nuevos Componentes Agregados

1. **MapProviderHelper** - Helper para manejo dinámico de proveedores
2. **MapProviderSwitcherExample** - Interfaz completa para cambiar proveedores en tiempo real
3. **QuickProviderChangeExample** - Ejemplos y widgets informativos
4. **Documentación ampliada** - Guía completa de configuración

### ✅ Configuración Actual

```dart
// Proveedor actual: CartoDB Dark
static const String defaultProvider = 'cartodb_dark';
```

### 🔄 Cómo Cambiar el Proveedor

#### Método 1: Editar Configuración (Recomendado)

```dart
// En lib/maps/offline_map_config.dart
static const String defaultProvider = 'cartodb_light'; // Cambiar aquí
```

#### Método 2: Usar el Switcher Dinámico

```dart
// Navegar al selector de proveedores
MapNavigationHelper.openProviderSwitcher(context);
```

#### Método 3: Programáticamente

```dart
// Obtener información del proveedor actual
MapProviderInfo info = MapProviderHelper.defaultProviderInfo;
print('Usando: ${info.name}');
```

## 🚀 Funcionalidades Avanzadas

### Selector Dinámico de Proveedores

El sistema incluye un widget completo (`MapProviderSwitcherExample`) que permite:

- ✅ Cambiar proveedores en tiempo real
- ✅ Vista previa inmediata de cada estilo
- ✅ Información detallada de cada proveedor
- ✅ Botones de acceso rápido
- ✅ Interfaz moderna y responsive

### Integración Fácil

```dart
// En cualquier parte de tu app
FloatingActionButton(
  onPressed: () => MapNavigationHelper.openProviderSwitcher(context),
  child: Icon(Icons.layers),
  tooltip: 'Cambiar estilo de mapa',
)
```
