# MainMap - Mapa Principal con Controles

Este archivo contiene un widget de mapa completo con controles de navegación y selector de proveedores de mapas.

## Características

### ✨ Funcionalidades principales:

- **Mapa offline cacheado** usando los tiles descargados
- **Controles de zoom** (acercar/alejar) con botones dedicados
- **Selector de proveedores** de mapas con menú desplegable
- **Indicador de zoom** en tiempo real
- **Botón de centrado** en La Paz, Bolivia
- **Controles animados** que se pueden ocultar/mostrar
- **Interfaz responsiva** con indicadores visuales

### 🎛️ Controles disponibles:

1. **Selector de mapas** (esquina superior izquierda) - Cambia entre diferentes proveedores
2. **Zoom +/-** (esquina superior derecha) - Controles de acercamiento
3. **Mi ubicación** - Centra el mapa en La Paz
4. **Toggle controles** - Oculta/muestra los controles de navegación
5. **Indicadores** - Zoom actual y proveedor activo

### 🗺️ Proveedores soportados:

- OpenStreetMap
- CartoDB (Light, Dark, Voyager)
- Base Maps
- Esri Satellite
- OpenTopo

## Uso

### Uso básico:

```dart
import 'package:laferia/views/maps/main_map.dart';

// En tu widget
const MainMap()
```

### En una ruta/página:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MainMap()),
);
```

### Como contenedor con tamaño personalizado:

```dart
import 'package:laferia/views/maps/main_map_example.dart';

MainMapContainer(
  height: 400,
  width: double.infinity,
)
```

## Estructura de archivos

- `main_map.dart` - Widget principal del mapa
- `main_map_example.dart` - Ejemplos de uso y contenedores
- `main_map_usage.md` - Esta documentación

## Dependencias

El mapa utiliza:

- `flutter_map` - Motor de mapas
- `latlong2` - Coordenadas geográficas
- Servicios internos de caché y tiles offline

## Personalización

### Cambiar ubicación inicial:

```dart
// En _MainMapState
LatLng _currentCenter = const LatLng(-16.5000, -68.1193); // Cambia estas coordenadas
```

### Modificar zoom inicial:

```dart
// En _MainMapState
double _currentZoom = 14.0; // Cambia el nivel de zoom
```

### Agregar marcadores:

```dart
// En FlutterMap children, después de TileLayer
MarkerLayer(
  markers: [
    Marker(
      point: LatLng(-16.5000, -68.1193),
      child: Icon(Icons.location_on, color: Colors.red),
    ),
  ],
),
```

## Eventos y callbacks

El mapa responde a:

- Gestos de zoom (pellizco)
- Arrastrar para mover
- Tap en controles
- Cambio de proveedores

## Rendimiento

- Los tiles se cachean automáticamente
- Animaciones optimizadas
- Carga lazy de recursos
- Manejo eficiente de memoria

## Troubleshooting

### Si el mapa no carga:

1. Verificar conexión a internet (primera vez)
2. Comprobar que los tiles offline estén descargados
3. Revisar logs de depuración en consola

### Si los controles no responden:

1. Verificar que el widget tenga suficiente espacio
2. Comprobar que no haya widgets superpuestos
3. Reiniciar la animación de controles
