# Sistema de Gestión de Tiendas - La Feria App

## 📋 Descripción

Este módulo gestiona las tiendas y comentarios de La Feria, proporcionando un servicio completo para operaciones CRUD, búsquedas geoespaciales y gestión de calificaciones.

## 🗂️ Estructura de Archivos

### Modelos

- `lib/core/models/tienda.dart` - Modelo principal de Tienda
- `lib/core/models/ubicacion.dart` - Coordenadas geográficas
- `lib/core/models/contacto.dart` - Información de contacto y redes sociales
- `lib/core/models/comentario.dart` - Comentarios y calificaciones

### Servicios

- `lib/core/services/supabase_tienda_service.dart` - Servicio de Supabase para tiendas

### Base de Datos

- `supabase_tienda_setup.sql` - Script de configuración de Supabase

## 🚀 Funcionalidades Implementadas

### ✅ Gestión de Tiendas

- **Crear**: Nuevas tiendas con ubicación geográfica
- **Leer**: Listado completo con filtros por categoría
- **Actualizar**: Edición completa de información
- **Eliminar**: Con eliminación en cascada de comentarios
- **Búsqueda**: Por nombre, propietario o dirección
- **Geolocalización**: Tiendas cercanas por radio de distancia

### ✅ Gestión de Comentarios

- **Crear**: Nuevos comentarios con calificación
- **Leer**: Comentarios por tienda ordenados por fecha
- **Eliminar**: Eliminación de comentarios
- **Cálculo automático**: Calificación promedio de tienda

### ✅ Características Avanzadas

- **Triggers automáticos**: Recálculo de calificaciones
- **Búsqueda geoespacial**: Función de distancia Haversine
- **Vistas optimizadas**: Rankings y información completa
- **Políticas de seguridad**: RLS (Row Level Security)
- **Índices optimizados**: Para consultas eficientes

## 📊 Estructura de Base de Datos

### Tabla Tienda

```sql
CREATE TABLE "Tienda" (
    tienda_id UUID PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    nombre_propietario VARCHAR(255) NOT NULL,
    latitud DOUBLE PRECISION NOT NULL,
    longitud DOUBLE PRECISION NOT NULL,
    categoria_id UUID REFERENCES "Category"(category_id),
    productos TEXT[],
    contacto JSONB,
    direccion TEXT,
    dias_atencion TEXT[],
    horario_atencion VARCHAR(50),
    calificacion_promedio DECIMAL(3,2),
    activa BOOLEAN DEFAULT true,
    fecha_registro TIMESTAMP DEFAULT NOW()
);
```

### Tabla Comentario

```sql
CREATE TABLE "Comentario" (
    comentario_id UUID PRIMARY KEY,
    tienda_id UUID REFERENCES "Tienda"(tienda_id),
    nombre_usuario VARCHAR(255) NOT NULL,
    comentario TEXT NOT NULL,
    calificacion DECIMAL(2,1) CHECK (0 <= calificacion <= 5),
    fecha_creacion TIMESTAMP DEFAULT NOW(),
    verificado BOOLEAN DEFAULT false,
    imagenes TEXT[]
);
```

## 🔧 Uso del Servicio

### Ejemplo de Uso Básico

```dart
import 'package:laferia/core/services/supabase_tienda_service.dart';
import 'package:laferia/core/models/tienda.dart';

// Obtener todas las tiendas
final tiendas = await SupabaseTiendaService.getAllTiendas();

// Buscar tiendas por categoría
final tiendasRopa = await SupabaseTiendaService.getTiendasByCategoria('categoria-id');

// Buscar tiendas cercanas
final tiendasCercanas = await SupabaseTiendaService.getTiendasCercanas(
  lat: -16.5000,
  lng: -68.1500,
  radioKm: 2.0,
);

// Crear nueva tienda
final nuevaTienda = Tienda(
  id: '', // Se genera automáticamente
  nombre: 'Mi Tienda',
  nombrePropietario: 'Juan Pérez',
  ubicacion: Ubicacion(lat: -16.500, lng: -68.150),
  categoriaId: 'categoria-id',
);
final tiendaCreada = await SupabaseTiendaService.crearTienda(nuevaTienda);
```

### Gestión de Comentarios

```dart
// Obtener comentarios de una tienda
final comentarios = await SupabaseTiendaService.getComentariosByTienda('tienda-id');

// Crear nuevo comentario
final nuevoComentario = Comentario(
  id: '',
  tiendaId: 'tienda-id',
  nombreUsuario: 'Usuario',
  comentario: 'Excelente servicio!',
  calificacion: 5.0,
  fechaCreacion: DateTime.now(),
);
await SupabaseTiendaService.crearComentario(nuevoComentario);
```

## 🛡️ Seguridad

### Políticas RLS Implementadas

- **Lectura pública**: Todos pueden ver tiendas activas
- **Escritura autenticada**: Solo usuarios autenticados pueden crear/editar
- **Comentarios públicos**: Lectura libre, escritura autenticada

### Validaciones

- **Coordenadas válidas**: Latitud y longitud dentro de rangos válidos
- **Calificaciones**: Entre 0 y 5 estrellas
- **Referencias**: Integridad referencial con categorías

## 📍 Funciones Geoespaciales

### Búsqueda por Proximidad

```sql
SELECT * FROM buscar_tiendas_cercanas(-16.5000, -68.1500, 5.0);
```

### Estadísticas de Tienda

```sql
SELECT * FROM obtener_estadisticas_tienda('tienda-uuid');
```

## 📈 Vistas Disponibles

### Vista Completa de Tiendas

```sql
SELECT * FROM vista_tiendas_completa;
```

### Ranking de Tiendas

```sql
SELECT * FROM vista_ranking_tiendas ORDER BY calificacion_promedio DESC;
```

## 🔄 Triggers Automáticos

### Actualización de Fechas

- Actualiza `fecha_actualizacion` automáticamente en cambios

### Recálculo de Calificaciones

- Actualiza `calificacion_promedio` cuando se agregan/modifican comentarios

## 🚀 Próximas Mejoras

### Funcionalidades Pendientes

- [ ] Sistema de favoritos
- [ ] Notificaciones push
- [ ] Sistema de mensajería
- [ ] Horarios especiales por fechas
- [ ] Sistema de promociones
- [ ] Analytics avanzados

### Optimizaciones

- [ ] Implementación completa de PostGIS
- [ ] Cache de consultas frecuentes
- [ ] Paginación para listas grandes
- [ ] Compresión de imágenes
- [ ] Sync offline

## 📱 Integración con la App

### Blocs Sugeridos

```dart
// Bloc para gestión de tiendas
class TiendasBloc extends Bloc<TiendasEvent, TiendasState> {
  final SupabaseTiendaService _service = SupabaseTiendaService();

  // Implementar eventos para CRUD de tiendas
}

// Bloc para comentarios
class ComentariosBloc extends Bloc<ComentariosEvent, ComentariosState> {
  final SupabaseTiendaService _service = SupabaseTiendaService();

  // Implementar eventos para gestión de comentarios
}
```

### Widgets Sugeridos

- `TiendaCard` - Tarjeta de tienda con información básica
- `TiendaDetailPage` - Página de detalle con comentarios
- `TiendaFormDialog` - Formulario para crear/editar tiendas
- `ComentariosList` - Lista de comentarios con calificaciones
- `MapaTiendas` - Mapa con ubicación de tiendas

## 🗄️ Instalación y Configuración

### 1. Ejecutar Script SQL

```bash
# En Supabase SQL Editor
-- Ejecutar el contenido de supabase_tienda_setup.sql
```

### 2. Configurar Variables de Entorno

```dart
// En main.dart o configuración de Supabase
await Supabase.initialize(
  url: 'tu_supabase_url',
  anonKey: 'tu_supabase_anon_key',
);
```

### 3. Verificar Dependencias

```yaml
# pubspec.yaml
dependencies:
  supabase_flutter: ^2.0.0
  equatable: ^2.0.0
```

## 📄 Licencia

Este proyecto es parte de La Feria - Marketplace App.

---

**Nota**: Este sistema está diseñado para manejar las necesidades específicas de La Feria El Alto, incluyendo la gestión de ubicaciones geográficas, horarios de funcionamiento típicos (jueves y domingos) y la estructura de categorías del marketplace.
