# Mejoras de MarkersMapsPage con Geolocalización

## 🎯 Objetivo
Mejorar `MarkersMapsPage` para mostrar la ubicación actual del usuario utilizando la librería `geolocator` y una arquitectura basada en Bloc.

## 🏗️ Arquitectura Implementada

### 1. LocationBloc - Gestión de Estado de Ubicación
**Archivo:** `lib/core/blocs/location/location_bloc.dart`

**Estados:**
- `LocationInitial` - Estado inicial
- `LocationLoading` - Cargando ubicación
- `LocationLoaded` - Ubicación obtenida exitosamente
- `LocationTracking` - Seguimiento activo de ubicación
- `LocationError` - Error al obtener ubicación
- `LocationPermissionDenied` - Permisos denegados
- `LocationServiceDisabled` - Servicio de ubicación deshabilitado

**Eventos:**
- `RequestCurrentLocation` - Solicitar ubicación actual
- `CheckLocationPermission` - Verificar permisos
- `RequestLocationPermission` - Solicitar permisos
- `StartLocationTracking` - Iniciar seguimiento
- `StopLocationTracking` - Detener seguimiento

**Características:**
- ✅ Manejo completo de permisos
- ✅ Verificación de servicios de ubicación
- ✅ Seguimiento en tiempo real
- ✅ Manejo robusto de errores
- ✅ Configuración de precisión y filtros

### 2. Componentes de UI

#### UserLocationMarker
**Archivo:** `lib/views/tiendas-maps/components/user_location_marker.dart`
- Marcador visual para la ubicación del usuario
- Círculo de precisión opcional
- Icono distintivo con sombras

#### LocationButton
**Archivo:** `lib/views/tiendas-maps/components/location_button.dart`
- Botón inteligente que cambia según el estado
- Indicadores visuales para loading, error, éxito
- Diálogos informativos para errores

### 3. MarkersMapsPage Mejorado

**Nuevas funcionalidades:**
- ✅ Integración con LocationBloc
- ✅ Marcador de ubicación del usuario
- ✅ Centrado automático en ubicación del usuario
- ✅ Actualización en tiempo real de posición
- ✅ Manejo de diferentes rubros con iconos y colores

**Métodos agregados:**
```dart
void _updateUserLocationMarker(LatLng position, {double accuracy = 0.0})
void _centerOnUserLocation()
IconData _getIconByRubro(String rubro)
Color _getColorByRubro(String rubro)
```

### 4. Ejemplo de Uso - LocationAwareMapsPage
**Archivo:** `lib/views/tiendas-maps/location_aware_maps_page.dart`

**Características:**
- Página completa con integración de LocationBloc
- AppBar con indicador de estado de ubicación
- FloatingActionButton para ayuda contextual
- Datos mock de tiendas para demostración
- Diálogos informativos para diferentes estados de error

## 🔧 Configuración

### Dependencias Agregadas
```yaml
dependencies:
  geolocator: ^13.0.2
```

### Permisos Android
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

### Service Locator
```dart
getIt.registerLazySingleton<LocationBloc>(() => LocationBloc());
```

### MultiBlocProvider
```dart
BlocProvider(create: (context) => getIt<LocationBloc>(), lazy: true),
```

## 🚀 Uso

### Básico
```dart
MarkersMapsPage(
  showControls: true,
  defaultCenter: LatLng(-33.4489, -70.6693),
  initialZoom: 13.0,
  tiendasMarkers: tiendas,
)
```

### Avanzado con LocationBloc
```dart
BlocProvider(
  create: (context) => getIt<LocationBloc>(),
  child: LocationAwareMapsPage(),
)
```

## ✨ Características Destacadas

### 1. Gestión Inteligente de Permisos
- Verificación automática al inicializar
- Solicitud progresiva de permisos
- Manejo de permisos permanentemente denegados
- Diálogos informativos para el usuario

### 2. Estados Visuales Claros
- Loading spinner durante obtención de ubicación
- Iconos distintos para cada estado (éxito, error, deshabilitado)
- Colores contextuales (azul: activo, rojo: error, gris: inactivo)

### 3. Seguimiento en Tiempo Real
- Actualización automática de posición
- Filtro de distancia para optimizar batería
- Historial de ubicaciones (últimas 50)
- Cancelación automática al cerrar

### 4. UX Optimizada
- Centrado automático en ubicación del usuario
- Botón de "Mi ubicación" en controles
- Marcador distintivo para ubicación actual
- Círculo de precisión visual

### 5. Flexibilidad
- Funciona con o sin controles
- Integrable en cualquier página
- Estados manejables independientemente
- Configuración de zoom y centro por defecto

## 🔍 Estados de Error Manejados

1. **Permisos Denegados**: Solicitud automática con opción de ir a configuración
2. **Servicio Deshabilitado**: Instrucciones para activar GPS
3. **Timeout**: Reintento automático con mensaje informativo
4. **Error de Red**: Manejo graceful con mensaje de error
5. **Ubicación No Disponible**: Fallback a ubicación por defecto

## 📱 Compatibilidad
- ✅ Android (permisos configurados)
- ✅ iOS (requiere configuración adicional en Info.plist)
- ✅ Web (limitado por navegador)

## 🎨 Personalización
Los iconos y colores por rubro son fácilmente configurables en los métodos:
- `_getIconByRubro(String rubro)`
- `_getColorByRubro(String rubro)`

Esta implementación proporciona una experiencia de usuario completa y profesional para la geolocalización en mapas Flutter.
