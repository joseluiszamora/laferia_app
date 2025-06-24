# Sistema Administrativo de Categorías - La Feria

Este documento describe la implementación del sistema administrativo de categorías integrado con Supabase.

## 🗂️ Estructura del Sistema

### Archivos Principales

- **Servicio Supabase**: `lib/core/services/supabase_categoria_service.dart`
- **BLoC**: `lib/core/blocs/categorias/categorias_bloc.dart`
- **Eventos**: `lib/core/blocs/categorias/categorias_event.dart`
- **Estados**: `lib/core/blocs/categorias/categorias_state.dart`
- **Modelo**: `lib/core/models/categoria.dart`
- **Páginas Admin**: `lib/views/admin/categorias/`

### Componentes de UI

- **Página Principal**: `admin_categorias_page.dart`
- **Lista de Categorías**: `categorias_list_view.dart`
- **Barra de Búsqueda**: `categoria_search_bar.dart`
- **Formulario**: `categoria_form_dialog.dart`

## 🗄️ Configuración de Base de Datos

### 1. Ejecutar Script SQL

```sql
-- Ejecutar el archivo supabase_category_setup.sql en el panel SQL de Supabase
```

### 2. Estructura de la Tabla

```sql
CREATE TABLE "Category" (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_category_id UUID REFERENCES "Category"(category_id),
    name VARCHAR(255) UNIQUE NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    color VARCHAR(7),
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 3. Políticas RLS

- ✅ SELECT: Permitido para usuarios autenticados
- ✅ INSERT: Permitido para usuarios autenticados
- ✅ UPDATE: Permitido para usuarios autenticados
- ✅ DELETE: Permitido para usuarios autenticados

> **Nota**: En producción, estas políticas deberían limitarse solo a administradores.

## 🚀 Funcionalidades Implementadas

### ✅ CRUD Completo

- **Crear**: Nuevas categorías y subcategorías
- **Leer**: Listado con búsqueda y filtros
- **Actualizar**: Edición completa de categorías
- **Eliminar**: Con validación de dependencias

### ✅ Interfaz de Usuario

- **Dashboard administrativo**: Acceso desde `AdminDemoPage`
- **Lista dinámica**: Cards con información completa
- **Búsqueda en tiempo real**: Por nombre y descripción
- **Formularios validados**: Creación y edición
- **Selector de iconos**: 18+ iconos predefinidos
- **Selector de colores**: 12+ colores predefinidos
- **Vista previa**: Preview en tiempo real

### ✅ Gestión de Estados

- **Loading states**: Indicadores de carga
- **Error handling**: Manejo robusto de errores
- **Success feedback**: Confirmaciones de acciones
- **Real-time updates**: Actualización automática

## 🎯 Características Técnicas

### Validaciones

- **Nombres únicos**: Verificación en tiempo real
- **Slugs automáticos**: Generación desde el nombre
- **Campos requeridos**: Validación de formularios
- **Dependencias**: Verificación antes de eliminar

### Manejo de Datos

- **Valores nullable**: Manejo seguro de campos opcionales
- **Tipado estricto**: TypeScript/Dart type safety
- **Relaciones**: Soporte para categorías padre-hijo
- **Índices optimizados**: Consultas eficientes

### UI/UX

- **Responsive design**: Adaptable a diferentes pantallas
- **Material Design**: Seguimiento de guidelines
- **Feedback visual**: Estados claros para el usuario
- **Navegación intuitiva**: Flujo lógico de operaciones

## 📱 Cómo Usar

### Acceder al Sistema

1. Ejecutar la aplicación
2. Navegar a `AdminDemoPage`
3. Seleccionar "Gestión de Categorías"

### Crear Categoría

1. Presionar el botón flotante "+"
2. Llenar el formulario
3. Seleccionar icono y color
4. Confirmar creación

### Editar Categoría

1. Presionar el menú "⋮" en una categoría
2. Seleccionar "Editar"
3. Modificar campos necesarios
4. Guardar cambios

### Crear Subcategoría

1. Presionar el menú "⋮" en una categoría padre
2. Seleccionar "Crear subcategoría"
3. Completar formulario
4. Confirmar creación

### Eliminar Categoría

1. Presionar el menú "⋮" en una categoría
2. Seleccionar "Eliminar"
3. Confirmar en el diálogo
4. La categoría se elimina si no tiene dependencias

### Buscar Categorías

1. Usar la barra de búsqueda superior
2. Escribir término de búsqueda
3. Los resultados se filtran automáticamente

## 🔧 Próximas Mejoras

### Funcionalidades Pendientes

- [ ] Bulk operations (eliminar múltiples)
- [ ] Import/Export de categorías
- [ ] Historial de cambios
- [ ] Categorías archivadas
- [ ] Permisos por rol de usuario
- [ ] Analytics y estadísticas

### Optimizaciones

- [ ] Caché de datos
- [ ] Paginación para listas grandes
- [ ] Lazy loading de imágenes
- [ ] Offline support

## 🛠️ Desarrollo

### Comandos Útiles

```bash
# Ejecutar la aplicación
flutter run

# Verificar análisis de código
flutter analyze

# Ejecutar tests
flutter test

# Generar build
flutter build apk
```

### Estructura de Archivos

```
lib/views/admin/categorias/
├── pages/
│   └── admin_categorias_page.dart
├── components/
│   ├── categoria_search_bar.dart
│   └── categorias_list_view.dart
├── forms/
│   └── categoria_form_dialog.dart
└── categorias.dart (exports)
```

## 📄 Licencia

Este proyecto es parte de La Feria - Marketplace App.
