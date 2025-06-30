# Servicio de Productos para Supabase - La Feria App

## Descripción

Este documento describe el servicio `SupabaseProductoService` que maneja la gestión completa de productos en la aplicación La Feria, incluyendo operaciones CRUD, búsquedas avanzadas, y gestión de atributos y medias.

## Archivos Relacionados

- **Modelo Principal**: `lib/core/models/producto.dart`
- **Modelos Relacionados**:
  - `lib/core/models/producto_atributos.dart`
  - `lib/core/models/producto_medias.dart`
- **Servicio**: `lib/core/services/supabase_producto_service.dart`
- **Script SQL**: `supabase_producto_setup.sql`

## Configuración en Supabase

### 1. Ejecutar Script SQL

Ejecuta el archivo `supabase_producto_setup.sql` en tu instancia de Supabase para crear:

- Tablas: `Producto`, `ProductoAtributos`, `ProductoMedias`
- Vistas: `ProductoCompleto`, `ProductoPublico`
- Índices optimizados
- Políticas RLS
- Triggers automáticos

### 2. Verificar Dependencias

Asegúrate de que existan las tablas:

- `Category` (para `categoria_id`)
- Tabla de marcas (para `marca_id`) - opcional

## Estructura de Datos

### Producto Principal

```dart
class Producto {
  final String id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final double? discountedPrice;
  final bool acceptOffers;
  final String categoriaId;
  final String marcaId;
  final String status; // 'borrador', 'publicado', 'archivado'
  final bool isAvailable;
  final bool isFavorite;
  final List<ProductoAtributos> atributos;
  final List<ProductoMedias> imagenesUrl;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
```

### Atributos del Producto

```dart
class ProductoAtributos {
  final String id;
  final String productoId;
  final String nombre;    // Ej: "Color", "Talla", "Material"
  final String valor;     // Ej: "Rojo", "L", "Algodón"
}
```

### Medias del Producto

```dart
class ProductoMedias {
  final String id;
  final String productoId;
  final String type;           // 'image' o 'video'
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;
  final bool esPrincipal;      // Solo una imagen principal por producto
  final bool estaActivo;
  final int? orden;
  final String? descripcion;
  final String? altTexto;
  final String? metadata;      // JSON con información adicional
}
```

## Uso del Servicio

### Importación

```dart
import 'package:laferia/core/services/supabase_producto_service.dart';
import 'package:laferia/core/models/producto.dart';
```

### Ejemplos de Uso

#### 1. Obtener Productos Públicos

```dart
// Obtener todos los productos públicos con paginación
final productos = await SupabaseProductoService.obtenerProductosPublicos(
  limit: 20,
  offset: 0,
);

// Búsqueda con filtros
final productosEnOferta = await SupabaseProductoService.obtenerProductosPublicos(
  categoria: 'uuid-categoria',
  precioMin: 50.0,
  precioMax: 500.0,
  busqueda: 'smartphone',
  ordenarPor: 'price',
  ascending: true,
);
```

#### 2. Obtener Producto Individual

```dart
// Por ID
final producto = await SupabaseProductoService.obtenerProductoPorId('uuid-producto');

// Por slug
final producto = await SupabaseProductoService.obtenerProductoPorSlug('smartphone-samsung-s24');
```

#### 3. Crear Nuevo Producto

```dart
final nuevoProducto = Producto(
  id: 'uuid-generado',
  name: 'iPhone 15 Pro',
  slug: 'iphone-15-pro',
  description: 'Último modelo de iPhone con chip A17 Pro',
  price: 1200.00,
  discountedPrice: 1100.00,
  acceptOffers: true,
  categoriaId: 'uuid-categoria-electronica',
  marcaId: 'uuid-marca-apple',
  status: 'publicado',
  isAvailable: true,
  isFavorite: false,
  atributos: [
    ProductoAtributos(
      id: 'uuid-attr-1',
      productoId: 'uuid-producto',
      nombre: 'Color',
      valor: 'Titanio Natural',
    ),
  ],
  imagenesUrl: [
    ProductoMedias(
      id: 'uuid-media-1',
      productoId: 'uuid-producto',
      type: 'image',
      url: 'https://ejemplo.com/iphone-15-pro.jpg',
      esPrincipal: true,
      estaActivo: true,
      orden: 1,
      fechaCreacion: DateTime.now(),
    ),
  ],
  createdAt: DateTime.now(),
);

final productoCreado = await SupabaseProductoService.crearProducto(nuevoProducto);
```

#### 4. Búsquedas Especializadas

```dart
// Productos por categoría
final productosElectronica = await SupabaseProductoService.buscarPorCategoria(
  'uuid-categoria-electronica',
  limit: 10,
);

// Productos en oferta
final ofertas = await SupabaseProductoService.obtenerProductosEnOferta(limit: 15);

// Productos relacionados
final relacionados = await SupabaseProductoService.obtenerProductosRelacionados(
  'uuid-producto-actual',
  limit: 5,
);
```

#### 5. Gestión de Atributos

```dart
// Obtener atributos de un producto
final atributos = await SupabaseProductoService.obtenerAtributosProducto('uuid-producto');

// Agregar atributo
final nuevoAtributo = ProductoAtributos(
  id: 'uuid-attr-nuevo',
  productoId: 'uuid-producto',
  nombre: 'Memoria',
  valor: '256GB',
);
await SupabaseProductoService.agregarAtributo(nuevoAtributo);

// Actualizar atributo
final atributoActualizado = nuevoAtributo.copyWith(valor: '512GB');
await SupabaseProductoService.actualizarAtributo('uuid-attr-nuevo', atributoActualizado);
```

#### 6. Gestión de Medias

```dart
// Obtener medias de un producto
final medias = await SupabaseProductoService.obtenerMediasProducto('uuid-producto');

// Establecer imagen principal
await SupabaseProductoService.establecerImagenPrincipal(
  'uuid-producto',
  'uuid-media-id'
);
```

#### 7. Administración de Productos

```dart
// Cambiar estado
await SupabaseProductoService.cambiarEstadoProducto('uuid-producto', 'archivado');

// Alternar disponibilidad
await SupabaseProductoService.alternarDisponibilidad('uuid-producto');

// Establecer descuento
await SupabaseProductoService.establecerDescuento('uuid-producto', 899.99);

// Eliminar producto
await SupabaseProductoService.eliminarProducto('uuid-producto');
```

## Métodos Disponibles

### Consultas Públicas

- `obtenerProductosPublicos()` - Lista productos públicos con filtros
- `obtenerProductoPorId()` - Obtiene producto por ID
- `obtenerProductoPorSlug()` - Obtiene producto por slug
- `buscarPorCategoria()` - Productos de una categoría
- `buscarPorMarca()` - Productos de una marca
- `obtenerProductosEnOferta()` - Productos con descuento
- `obtenerProductosRelacionados()` - Productos similares

### Administración

- `obtenerProductos()` - Lista completa (incluye borradores)
- `crearProducto()` - Crear nuevo producto
- `actualizarProducto()` - Actualizar producto existente
- `eliminarProducto()` - Eliminar producto
- `cambiarEstadoProducto()` - Cambiar estado (borrador/publicado/archivado)
- `alternarDisponibilidad()` - Activar/desactivar disponibilidad
- `establecerDescuento()` - Configurar precio con descuento

### Gestión de Atributos

- `obtenerAtributosProducto()` - Lista atributos del producto
- `agregarAtributo()` - Agregar nuevo atributo
- `actualizarAtributo()` - Actualizar atributo existente
- `eliminarAtributo()` - Eliminar atributo

### Gestión de Medias

- `obtenerMediasProducto()` - Lista medias del producto
- `agregarMedia()` - Agregar nueva media
- `actualizarMedia()` - Actualizar media existente
- `eliminarMedia()` - Eliminar media
- `establecerImagenPrincipal()` - Establecer imagen principal

## Propiedades Calculadas del Modelo

El modelo `Producto` incluye propiedades calculadas útiles:

```dart
// Precio efectivo (con descuento si existe)
double precioEfectivo = producto.priceEfectivo;

// Verificar si tiene oferta
bool tieneOferta = producto.tieneOferta;

// Porcentaje de descuento
double descuento = producto.porcentajeDescuento;

// Ahorro en dinero
double ahorro = producto.ahorroEnDinero;

// Imagen principal
ProductoMedias? imagenPrincipal = producto.imagenPrincipal;

// Verificar si tiene imágenes
bool tieneImagenes = producto.tieneImagenes;

// Cantidad de imágenes
int totalImagenes = producto.cantidadImagenes;
```

## Manejo de Errores

Todos los métodos del servicio lanzan excepciones con mensajes descriptivos:

```dart
try {
  final producto = await SupabaseProductoService.obtenerProductoPorId('uuid-inexistente');
} catch (e) {
  print('Error al obtener producto: $e');
  // Manejar error apropiadamente
}
```

## Seguridad (RLS)

El sistema implementa Row Level Security con las siguientes políticas:

### Usuarios Públicos (No Autenticados)

- **Lectura**: Solo productos con `status = 'publicado'` y `is_available = true`
- **Escritura**: No permitida

### Usuarios Autenticados

- **Lectura**: Todos los productos
- **Escritura**: Todas las operaciones (en producción se debería limitar a administradores)

## Optimización

### Índices Implementados

- Búsquedas por categoría, marca, estado
- Filtros por precio y disponibilidad
- Búsqueda full-text en nombre y descripción
- Ordenamiento por fecha de creación

### Vistas Optimizadas

- `ProductoCompleto`: Incluye atributos y medias
- `ProductoPublico`: Solo productos públicos con medias activas

## Próximos Pasos

1. **Implementar caché local** para mejorar rendimiento
2. **Agregar validaciones** adicionales en el cliente
3. **Implementar sistema de favoritos** por usuario
4. **Agregar métricas** de visualizaciones y popularity
5. **Implementar sistema de reviews** y calificaciones

## Notas Importantes

- **UUIDs**: Todos los IDs deben ser UUIDs válidos
- **Slugs**: Deben ser únicos y URL-friendly
- **Imágenes Principales**: Solo una por producto (validado por trigger)
- **Estados**: Solo permitidos: 'borrador', 'publicado', 'archivado'
- **Precios**: Deben ser valores positivos
- **Descuentos**: Deben ser menores al precio original
