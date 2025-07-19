# CategoriaDetailPage - Documentación

## 📱 Descripción

`CategoriaDetailPage` es una vista completa que muestra información detallada de una categoría, incluyendo las tiendas y productos que pertenecen a ella. Proporciona una interfaz amigable e intuitiva para explorar el contenido de cada categoría.

## 🎯 Características

### ✅ Vista Moderna

- **SliverAppBar**: Header expansible con imagen/color de fondo
- **TabView**: Pestañas para alternar entre tiendas y productos
- **Cards responsivas**: Diseño adaptativo para diferentes pantallas
- **Estados de carga**: Indicadores visuales mientras cargan los datos

### ✅ Información Completa de Categoría

- **Header visual**: Icono, color y nombre prominente
- **Descripción**: Texto descriptivo si está disponible
- **Estadísticas**: Contadores de tiendas y productos
- **Imagen de fondo**: Soporte para imagen personalizada

### ✅ Lista de Tiendas

- **Información básica**: Nombre, propietario, dirección
- **Calificación**: Estrellas y puntuación numérica
- **Horarios**: Información de funcionamiento
- **Avatar**: Logo de la tienda o icono por defecto

### ✅ Grid de Productos

- **Imagen**: Foto principal del producto
- **Precios**: Precio normal y con descuento
- **Stock**: Indicador de disponibilidad
- **Navegación**: Tap para ver detalles

### ✅ Manejo de Estados

- **Loading**: Spinner mientras cargan datos
- **Error**: Mensaje y botón de reintento
- **Empty**: Mensaje cuando no hay contenido

## 🛠️ Uso

### Navegación Básica

```dart
// Desde cualquier parte de la app
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => CategoriaDetailPage(
      categoria: categoria, // Objeto Categoria
    ),
  ),
);
```

### Con Named Routes

```dart
// En routes/app_router.dart
GoRoute(
  path: '/categoria/:id',
  builder: (context, state) {
    final categoriaId = state.pathParameters['id']!;
    // Obtener categoria por ID...
    return CategoriaDetailPage(categoria: categoria);
  },
),

// Navegación
context.go('/categoria/${categoria.id}');
```

### Desde Lista de Categorías

```dart
// En un ListView de categorías
ListView.builder(
  itemCount: categorias.length,
  itemBuilder: (context, index) {
    final categoria = categorias[index];
    return ListTile(
      title: Text(categoria.name),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoriaDetailPage(
              categoria: categoria,
            ),
          ),
        );
      },
    );
  },
)
```

## 📊 Estructura de Datos

### Modelo Categoria Requerido

```dart
class Categoria {
  final int id;              // ID único
  final String name;         // Nombre de la categoría
  final String? description; // Descripción opcional
  final String? icon;        // Nombre del icono
  final String? color;       // Color en formato hex #RRGGBB
  final String? imageUrl;    // URL de imagen opcional

  // ... otros campos
}
```

### Datos Cargados Automáticamente

- **Tiendas**: Obtenidas via `SupabaseTiendaService.getTiendasByCategoria()`
- **Productos**: Obtenidos via `SupabaseProductoService.buscarPorCategoria()`

## 🎨 Personalización

### Colores e Iconos

La página utiliza el color e icono definidos en la categoría:

```dart
// Color personalizado
final color = _getColorFromString(categoria.color);

// Icono personalizado
final icono = _getIconFromString(categoria.icon);
```

### Iconos Soportados

```dart
'store', 'restaurant', 'eco', 'checkroom', 'shopping_bag',
'directions_car', 'devices', 'menu_book', 'local_pharmacy',
'build', 'diamond', 'local_florist', 'pets',
'face_retouching_natural', 'sports_soccer', 'home', 'category'
```

### Temas

La página respeta el tema de la aplicación:

```dart
final theme = Theme.of(context);
// Usa colores y tipografías del tema
```

## 🔄 Integración con Servicios

### Tiendas por Categoría

```dart
// Servicio utilizado internamente
final tiendas = await SupabaseTiendaService.getTiendasByCategoria(
  categoria.id,
);
```

### Productos por Categoría

```dart
// Servicio utilizado internamente
final productos = await SupabaseProductoService.buscarPorCategoria(
  categoria.id,
  limit: 20, // Límite configurable
);
```

## ⚡ Optimizaciones

### Carga Paralela

```dart
// Los datos se cargan en paralelo
await Future.wait([
  _cargarTiendas(),
  _cargarProductos(),
]);
```

### Manejo de Errores

```dart
// Manejo independiente de errores
try {
  // Cargar tiendas...
} catch (e) {
  setState(() {
    _errorTiendas = e.toString();
  });
}
```

### Estados Independientes

- Cada tab maneja su propio estado de carga
- Los errores no afectan al otro tab
- Reintentos independientes

## 🔮 Extensiones Futuras

### Navegación Pendiente

```dart
// TODO: Implementar navegaciones
void _navigateToTiendaDetail(Tienda tienda) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => TiendaDetailPage(tienda: tienda),
    ),
  );
}

void _navigateToProductoDetail(Producto producto) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProductoDetailPage(producto: producto),
    ),
  );
}
```

### Filtros y Búsqueda

- Filtro por precio en productos
- Búsqueda por nombre en tiendas
- Ordenamiento personalizable

### Funcionalidades Adicionales

- Favoritos de productos/tiendas
- Compartir categoría
- Mapa de tiendas cercanas
- Comparación de productos

## 📱 Ejemplo Completo

```dart
import 'package:flutter/material.dart';
import 'package:laferia/views/categorias/categoria_detail_page.dart';
import 'package:laferia/core/models/categoria.dart';

class CategoriasListPage extends StatelessWidget {
  final List<Categoria> categorias;

  const CategoriasListPage({super.key, required this.categorias});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: ListView.builder(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getColor(categoria.color),
                child: Icon(
                  _getIcon(categoria.icon),
                  color: Colors.white,
                ),
              ),
              title: Text(categoria.name),
              subtitle: Text(categoria.description ?? ''),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoriaDetailPage(
                      categoria: categoria,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
```

---

## 🏷️ Versión: 1.0.0

## 📅 Última actualización: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

## 👨‍💻 Desarrollado para: La Feria App
