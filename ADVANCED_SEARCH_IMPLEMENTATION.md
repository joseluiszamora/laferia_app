# 🔍 Sistema de Búsqueda Avanzada - La Feria App

## 📋 Descripción

Sistema completo de búsqueda avanzada estilo Pinterest implementado para La Feria App, que incluye búsquedas en tiempo real, sugerencias inteligentes, filtros avanzados, chips de búsqueda rápida y una experiencia de usuario optimizada.

## ✅ Estado de Implementación

**🎉 COMPLETADO - 19 de julio de 2025**

### ✅ Modelos de Datos

- [x] `SearchHistory` - Historial de búsquedas del usuario
- [x] `TrendingSearch` - Búsquedas populares y tendencias
- [x] `SearchSuggestion` - Sugerencias de autocompletado
- [x] `SearchModels` - Filtros, resultados y tipos de chips
- [x] `SearchChip` - Chips de búsqueda rápida

### ✅ Servicios Backend

- [x] `SupabaseSearchService` - Servicio completo de búsqueda
- [x] Búsqueda global (productos, tiendas, categorías)
- [x] Búsquedas específicas por tipo
- [x] Sistema de sugerencias inteligentes
- [x] Gestión de historial y tendencias
- [x] Filtros avanzados y ordenamiento
- [x] Cache de resultados y optimización

### ✅ Gestión de Estado (BLoC)

- [x] `SearchBloc` - Gestión completa del estado
- [x] `SearchEvent` - Eventos de búsqueda
- [x] `SearchState` - Estados de la búsqueda
- [x] Debounce para búsquedas
- [x] Cache inteligente de resultados
- [x] Manejo de errores y reintentos

### ✅ Componentes UI

- [x] `AdvancedSearchSection` - Componente principal
- [x] `SearchChipsSection` - Chips categorizados
- [x] `SearchSuggestionsOverlay` - Sugerencias con highlighting
- [x] `SearchFiltersPanel` - Panel completo de filtros
- [x] `SearchResultsView` - Vista de resultados categorizados
- [x] `SearchPage` - Página completa de búsqueda
- [x] `CompactSearchWidget` - Widget para AppBar

### ✅ Funcionalidades Avanzadas

- [x] Búsqueda en tiempo real con debounce (300ms)
- [x] Sugerencias inteligentes basadas en contenido
- [x] Chips de búsqueda rápida categorizados
- [x] Filtros avanzados (precio, distancia, calificación, etc.)
- [x] Resultados mixtos y categorizados
- [x] Historial personalizado por usuario/sesión
- [x] Búsquedas populares y tendencias
- [x] Cache de resultados para performance
- [x] Highlighting de texto en sugerencias
- [x] Diseño responsive y Material 3

## 🚀 Uso Rápido

### 1. Página de Búsqueda Completa

```dart
// Navegar a página de búsqueda
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SearchPage(
      initialQuery: 'pizza', // Opcional
    ),
  ),
);

// O usando la extensión
context.navigateToSearch(initialQuery: 'smartphones');
```

### 2. Modal de Búsqueda

```dart
// Mostrar modal de búsqueda
final result = await context.showSearchModal(
  initialQuery: 'tecnología',
);
```

### 3. Widget de Búsqueda Embebido

```dart
BlocProvider(
  create: (context) => SearchBloc(),
  child: AdvancedSearchSection(
    onSearchResults: (results) {
      // Manejar resultados
      print('Encontrados: ${results.totalResults} resultados');
    },
    onQueryChanged: (query) {
      // Opcional: reaccionar a cambios de texto
    },
  ),
)
```

### 4. Widget Compacto para AppBar

```dart
AppBar(
  title: CompactSearchWidget(
    placeholder: 'Buscar en La Feria...',
    onTap: () => context.navigateToSearch(),
  ),
)
```

## 🎯 Características Principales

### 🔍 Búsqueda en Tiempo Real

- **Debounce de 300ms** para evitar spam de requests
- **Mínimo 2 caracteres** para activar búsqueda
- **Cancelación automática** de requests anteriores
- **Cache local** para resultados recientes

### 💡 Sugerencias Inteligentes

```dart
// Tipos de sugerencias disponibles
enum SearchSuggestionType {
  autocomplete,  // Basado en nombres de productos/tiendas
  recent,        // Búsquedas recientes del usuario
  trending,      // Búsquedas populares globales
  category,      // Nombres de categorías
  product,       // Nombres específicos de productos
  store,         // Nombres de tiendas
  related        // Términos relacionados
}
```

### 🔥 Chips de Búsqueda Rápida

```dart
// Tipos de chips disponibles
enum SearchChipType {
  recent,        // "pizza" - búsqueda reciente
  trending,      // "🔥 smartphones" - tendencia
  category,      // "📱 Tecnología" - categoría
  offer,         // "💸 Con descuento" - productos con oferta
  nearby,        // "📍 Cerca de ti" - tiendas cercanas
  featured,      // "⭐ Destacados" - productos destacados
  newArrivals,   // "🆕 Nuevos" - productos recientes
  topRated,      // "⭐ Mejor valorados" - alta calificación
}
```

### 🎛️ Filtros Avanzados

```dart
class SearchFilters {
  final String? category;           // Filtro por categoría
  final PriceRange? priceRange;     // Rango de precios
  final double? maxDistance;        // Distancia máxima
  final bool? hasOffers;           // Solo productos con descuento
  final bool? inStock;             // Solo productos disponibles
  final double? minRating;         // Calificación mínima
  final List<String>? tags;        // Tags específicos
  final SortOption sortBy;         // Criterio de ordenamiento
}
```

### 📊 Resultados Categorizados

- **Productos**: Lista con cards de productos
- **Tiendas**: Lista con cards de tiendas
- **Categorías**: Grid horizontal de categorías
- **Vista mixta**: Intercala productos y tiendas
- **Tabs**: Navegación entre tipos de resultados

## 🛠️ Configuración de Base de Datos

### Tablas Necesarias (ya incluidas en schema.prisma)

```sql
-- Historial de búsquedas
CREATE TABLE "SearchHistory" (
  search_history_id SERIAL PRIMARY KEY,
  user_id VARCHAR(255),
  session_id VARCHAR(255) NOT NULL,
  query VARCHAR(255) NOT NULL,
  search_type VARCHAR(50) DEFAULT 'general',
  result_count INTEGER DEFAULT 0,
  clicked BOOLEAN DEFAULT false,
  clicked_type VARCHAR(50),
  clicked_id INTEGER,
  filters JSON,
  location JSON,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Búsquedas populares
CREATE TABLE "TrendingSearches" (
  trending_search_id SERIAL PRIMARY KEY,
  query VARCHAR(255) UNIQUE NOT NULL,
  search_count INTEGER DEFAULT 1,
  category VARCHAR(100),
  region VARCHAR(100),
  is_promoted BOOLEAN DEFAULT false,
  trend_score DECIMAL(10,4) DEFAULT 0.0,
  last_searched TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Sugerencias de búsqueda
CREATE TABLE "SearchSuggestions" (
  suggestion_id SERIAL PRIMARY KEY,
  query VARCHAR(255) NOT NULL,
  suggestion VARCHAR(255) NOT NULL,
  suggestion_type VARCHAR(50) NOT NULL,
  weight INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

## 📱 Ejemplos de Uso

### Búsqueda Programática

```dart
class MySearchWidget extends StatefulWidget {
  @override
  State<MySearchWidget> createState() => _MySearchWidgetState();
}

class _MySearchWidgetState extends State<MySearchWidget> {
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc();

    // Inicializar con sesión
    _searchBloc.add(
      SearchInitialized(SupabaseSearchService.generateSessionId())
    );
  }

  void _performSearch(String query) {
    _searchBloc.add(SearchExecuted(query));
  }

  void _applyFilters(SearchFilters filters) {
    _searchBloc.add(SearchFiltersChanged(filters));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchResultsLoaded) {
            return Text('Encontrados: ${state.results.totalResults}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
```

### Integración en AppBar

```dart
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CompactSearchWidget(
        placeholder: 'Buscar productos...',
        onTap: () {
          // Opción 1: Página completa
          context.navigateToSearch();

          // Opción 2: Modal
          // context.showSearchModal();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // Mostrar filtros directamente
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

## 🎨 Personalización

### Colores de Chips

```dart
// Los chips usan colores predefinidos por tipo
SearchChipType.trending.color    // Colors.orange
SearchChipType.category.color    // Colors.blue
SearchChipType.offer.color       // Colors.red
SearchChipType.nearby.color      // Colors.green
SearchChipType.featured.color    // Colors.amber
```

### Iconos Personalizados

```dart
SearchChip(
  text: 'Mi búsqueda',
  type: SearchChipType.category,
  icon: Icons.custom_icon,     // Icono personalizado
  color: Colors.purple,        // Color personalizado
  data: {'custom': 'data'},    // Datos adicionales
)
```

## 📈 Analytics y Métricas

### Eventos Trackeados

- Búsquedas realizadas con query y filtros
- Clicks en sugerencias por tipo
- Uso de filtros y ordenamiento
- Conversiones de búsqueda a vista de detalle
- Tiempo en resultados de búsqueda

### Métricas Disponibles

```dart
// En SearchHistoryData
class SearchHistoryData {
  final String query;
  final int resultCount;
  final SearchFilters? filters;
  final String searchType;
  // ... más campos para analytics
}
```

## 🚀 Performance

### Optimizaciones Implementadas

- **Debounce**: 300ms para reducir requests
- **Cache**: Resultados recientes en memoria
- **Cancelación**: Requests anteriores se cancelan automáticamente
- **Paginación**: Límites en resultados por tipo
- **Índices**: Base de datos optimizada para búsquedas

### Configuración de Cache

```dart
// En SearchBloc
final Map<String, SearchResults> _searchCache = {};
static const int _maxCacheSize = 20;  // Máximo 20 búsquedas en cache
```

## 🔧 Troubleshooting

### Problemas Comunes

1. **No aparecen sugerencias**

   - Verificar que `SearchSuggestions` table tenga datos
   - Verificar conexión a Supabase
   - Verificar que `query.length >= 2`

2. **Búsquedas lentas**

   - Verificar índices en base de datos
   - Verificar configuración de cache
   - Verificar timeout de requests

3. **Filtros no funcionan**
   - Verificar que los campos existen en las tablas
   - Verificar mapping de filtros en el servicio
   - Verificar tipos de datos en filtros

### Debug Mode

```dart
// Habilitar logs detallados
Logger.level = LogLevel.debug;

// En SearchBloc, se pueden ver todos los estados
BlocObserver.onChange((bloc, change) {
  if (bloc is SearchBloc) {
    print('Search State: ${change.currentState} -> ${change.nextState}');
  }
});
```

## 📝 TODO / Mejoras Futuras

### Funcionalidades Pendientes

- [ ] Búsqueda por voz
- [ ] Búsqueda por imagen
- [ ] Geolocalización avanzada
- [ ] Búsqueda colaborativa
- [ ] AI/ML para mejores sugerencias
- [ ] Búsqueda offline básica
- [ ] Export de resultados
- [ ] Búsquedas programadas

### Optimizaciones

- [ ] Implementar Elasticsearch para búsquedas complejas
- [ ] Agregar más índices de base de datos
- [ ] Implementar Redis para cache distribuido
- [ ] Agregar analytics más detallados
- [ ] Implementar A/B testing para UX

---

## 📚 Archivos Principales

### Modelos

- `lib/core/models/search_history.dart`
- `lib/core/models/trending_search.dart`
- `lib/core/models/search_suggestion.dart`
- `lib/core/models/search_models.dart`

### Servicios

- `lib/core/services/supabase_search_service.dart`

### BLoC

- `lib/core/blocs/search/search_bloc.dart`
- `lib/core/blocs/search/search_event.dart`
- `lib/core/blocs/search/search_state.dart`

### UI Components

- `lib/views/search/advanced_search_section.dart`
- `lib/views/search/search_page.dart`
- `lib/views/search/components/search_chips_section.dart`
- `lib/views/search/components/search_suggestions_overlay.dart`
- `lib/views/search/components/search_filters_panel.dart`
- `lib/views/search/components/search_results_view.dart`

### Ejemplos

- `lib/examples/advanced_search_example.dart`

---

**Versión**: 1.0.0  
**Fecha**: 19 de julio de 2025  
**Estado**: ✅ COMPLETADO  
**Autor**: Sistema de Búsqueda Avanzada - La Feria App
