# Módulo de Administración de Productos

## Descripción

Este módulo proporciona una interfaz completa de administración para la gestión de productos (ABM - Alta, Baja, Modificación) dentro de la aplicación LaFeria.

## Estructura del Módulo

```
lib/
├── core/
│   ├── blocs/
│   │   └── admin_productos/
│   │       ├── admin_productos_bloc.dart
│   │       ├── admin_productos_event.dart
│   │       ├── admin_productos_state.dart
│   │       └── admin_productos.dart
│   └── services/
│       └── admin_producto_service.dart
└── views/
    └── admin/
        ├── admin_main_page.dart
        └── productos/
            ├── admin_productos_page.dart
            ├── admin_producto_form_page.dart
            ├── productos.dart
            └── components/
                ├── productos_list_view.dart
                ├── productos_search_bar.dart
                ├── productos_filter_bar.dart
                └── producto_list_item.dart
```

## Características Implementadas

### ✅ Funcionalidades Completas

1. **Lista de Productos**

   - Visualización de productos con paginación infinita
   - Información detallada: nombre, descripción, precio, stock, estado
   - Indicadores visuales de estado y stock bajo
   - Imágenes de productos con fallback

2. **Búsqueda y Filtros**

   - Búsqueda por nombre, SKU o descripción
   - Filtros por categoría y estado del producto
   - Aplicación de filtros en tiempo real

3. **Modo de Selección Múltiple**

   - Selección individual y masiva de productos
   - Acciones en lote: cambiar estado, eliminar
   - Interfaz intuitiva con contadores

4. **CRUD Completo**

   - Crear nuevos productos
   - Editar productos existentes
   - Eliminar productos (individual y masivo)
   - Cambio de estados de productos

5. **Estados de Producto**
   - Borrador (draft)
   - Publicado (published)
   - Archivado (archived)
   - Agotado (exhausted)

### 🔄 Gestión de Estados

El módulo utiliza **BLoC pattern** para la gestión de estados:

- **AdminProductosBloc**: Maneja toda la lógica de negocio
- **Estados**: Loading, Loaded, Error, OperationSuccess, etc.
- **Eventos**: LoadProducts, CreateProduct, UpdateProduct, etc.

### 🎨 Interfaz de Usuario

- **Material Design**: Consistente con el resto de la aplicación
- **Responsive**: Adaptable a diferentes tamaños de pantalla
- **Accesible**: Cumple con estándares de accesibilidad
- **Intuitiva**: Navegación clara y acciones evidentes

## Cómo Usar el Módulo

### 1. Importar el Módulo

```dart
import 'package:laferia/views/admin/productos/productos.dart';
import 'package:laferia/core/blocs/admin_productos/admin_productos.dart';
```

### 2. Navegar a la Administración de Productos

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AdminProductosPage(),
  ),
);
```

### 3. Integrar con el Panel de Administración

```dart
// Ejemplo usando AdminMainPage
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AdminMainPage(),
  ),
);
```

## Servicios y APIs

### AdminProductoService

Proporciona métodos para:

- `obtenerProductosAdmin()`: Lista productos con filtros y paginación
- `crearProducto()`: Crea un nuevo producto
- `actualizarProducto()`: Actualiza un producto existente
- `eliminarProducto()`: Elimina un producto
- `actualizarEstadoProducto()`: Cambia el estado de un producto
- `actualizarEstadoMasivo()`: Cambia el estado de múltiples productos
- `eliminarProductosMasivo()`: Elimina múltiples productos

### Base de Datos

Utiliza las siguientes tablas de Supabase:

- `Product`: Datos principales del producto
- `ProductAttributes`: Atributos específicos del producto
- `ProductMedias`: Imágenes y archivos multimedia

## Personalización

### Agregar Nuevos Filtros

1. Modificar `ProductosFilterBar` para agregar nuevos dropdowns
2. Actualizar `AdminProductosEvent` para incluir nuevos parámetros
3. Modificar `AdminProductoService.obtenerProductosAdmin()` para aplicar los filtros

### Modificar el Formulario de Producto

1. Editar `AdminProductoFormPage` para agregar nuevos campos
2. Actualizar la validación en `_saveProducto()`
3. Modificar el servicio para manejar los nuevos campos

### Personalizar la Vista de Lista

1. Modificar `ProductoListItem` para cambiar la presentación
2. Agregar nuevas acciones en `AdminProductosPage`
3. Crear nuevos componentes según sea necesario

## Próximas Mejoras

### 🚀 Funcionalidades Pendientes

1. **Formulario Completo de Productos**

   - Manejo de imágenes y archivos multimedia
   - Atributos personalizables del producto
   - Validaciones avanzadas
   - Preview del producto

2. **Importación/Exportación**

   - Importar productos desde CSV/Excel
   - Exportar lista de productos
   - Plantillas de importación

3. **Analytics y Reportes**

   - Estadísticas de productos más vendidos
   - Análisis de stock
   - Reportes de rendimiento

4. **Integración con Categorías**

   - Selector dinámico de categorías
   - Creación de categorías desde el formulario
   - Jerarquía de categorías

5. **Historial de Cambios**
   - Auditoría de modificaciones
   - Versiones de productos
   - Restauración de versiones anteriores

## Dependencias

- `flutter_bloc`: Gestión de estados
- `supabase_flutter`: Base de datos y API
- `equatable`: Comparación de objetos
- Material Design Icons y Widgets

## Testing

Para probar el módulo:

1. Asegúrate de tener datos de prueba en Supabase
2. Ejecuta la aplicación y navega a la administración
3. Prueba todas las funcionalidades CRUD
4. Verifica el comportamiento de búsqueda y filtros
5. Testa las acciones masivas

## Soporte y Mantenimiento

Este módulo está diseñado para ser:

- **Escalable**: Fácil agregar nuevas funcionalidades
- **Mantenible**: Código limpio y bien documentado
- **Testeable**: Separación clara de responsabilidades
- **Reutilizable**: Componentes modulares

Para reportar bugs o solicitar funcionalidades, crear un issue en el repositorio del proyecto.
