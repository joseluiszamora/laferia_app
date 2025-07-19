# 🔍 Buscador Avanzado - Estilo Pinterest

## 📋 Descripción

Implementación de un buscador avanzado similar al de Pinterest para La Feria App, que incluya búsquedas en tiempo real, sugerencias inteligentes, filtros avanzados y experiencia de usuario optimizada.

## 🗄️ Modificaciones a la Base de Datos

### 1. Nueva Tabla: SearchHistory

```prisma
model SearchHistory {
  searchHistoryId Int      @id @default(autoincrement()) @map("search_history_id")
  userId          String?  @map("user_id") // null para usuarios anónimos
  sessionId       String   @map("session_id") // para tracking anónimo
  query           String   @db.VarChar(255)
  searchType      String   @default("general") @map("search_type") // general, product, store, category
  resultCount     Int      @default(0) @map("result_count")
  clicked         Boolean  @default(false) // si el usuario hizo clic en algún resultado
  clickedType     String?  @map("clicked_type") // product, store, category
  clickedId       Int?     @map("clicked_id")
  filters         Json?    // filtros aplicados en la búsqueda
  location        Json?    // {lat, lng} si se usó ubicación
  createdAt       DateTime @default(now()) @map("created_at") @db.Timestamptz(6)

  @@index([userId], map: "idx_search_history_user")
  @@index([sessionId], map: "idx_search_history_session")
  @@index([query], map: "idx_search_history_query")
  @@index([createdAt], map: "idx_search_history_created")
  @@map("SearchHistory")
}
```

### 2. Nueva Tabla: TrendingSearches

```prisma
model TrendingSearches {
  trendingSearchId Int      @id @default(autoincrement()) @map("trending_search_id")
  query            String   @unique @db.VarChar(255)
  searchCount      Int      @default(1) @map("search_count")
  category         String?  @db.VarChar(100) // para agrupar por categoría
  region           String?  @db.VarChar(100) // para tendencias regionales
  isPromoted       Boolean  @default(false) @map("is_promoted") // búsquedas promocionadas
  trendScore       Decimal  @default(0.0) @map("trend_score") @db.Decimal(10, 4)
  lastSearched     DateTime @default(now()) @map("last_searched") @db.Timestamptz(6)
  createdAt        DateTime @default(now()) @map("created_at") @db.Timestamptz(6)
  updatedAt        DateTime @default(now()) @updatedAt @map("updated_at") @db.Timestamptz(6)

  @@index([trendScore], map: "idx_trending_trend_score")
  @@index([searchCount], map: "idx_trending_search_count")
  @@index([category], map: "idx_trending_category")
  @@index([lastSearched], map: "idx_trending_last_searched")
  @@map("TrendingSearches")
}
```

### 3. Nueva Tabla: SearchSuggestions

```prisma
model SearchSuggestions {
  suggestionId   Int      @id @default(autoincrement()) @map("suggestion_id")
  query          String   @db.VarChar(255)
  suggestion     String   @db.VarChar(255)
  suggestionType String   @map("suggestion_type") // autocomplete, related, similar
  weight         Int      @default(1) // peso/relevancia de la sugerencia
  isActive       Boolean  @default(true) @map("is_active")
  createdAt      DateTime @default(now()) @map("created_at") @db.Timestamptz(6)

  @@index([query], map: "idx_suggestions_query")
  @@index([suggestionType], map: "idx_suggestions_type")
  @@index([weight], map: "idx_suggestions_weight")
  @@map("SearchSuggestions")
}
```

### 4. Modificaciones a Tablas Existentes

#### Product - Agregar campos para búsqueda

```prisma
model Product {
  // ... campos existentes ...

  // Nuevos campos para búsqueda
  searchKeywords String[] @default([]) @map("search_keywords") // palabras clave adicionales
  searchScore    Decimal  @default(0.0) @map("search_score") @db.Decimal(10, 4) // score de relevancia
  isPromoted     Boolean  @default(false) @map("is_promoted") // producto promocionado en búsquedas

  // ... resto de campos existentes ...

  @@index([searchKeywords], map: "idx_product_search_keywords", type: Gin)
  @@index([searchScore], map: "idx_product_search_score")
}
```

#### Store - Agregar campos para búsqueda

```prisma
model Store {
  // ... campos existentes ...

  // Nuevos campos para búsqueda
  searchKeywords String[] @default([]) @map("search_keywords")
  searchScore    Decimal  @default(0.0) @map("search_score") @db.Decimal(10, 4)
  isPromoted     Boolean  @default(false) @map("is_promoted")

  // ... resto de campos existentes ...

  @@index([searchKeywords], map: "idx_store_search_keywords", type: Gin)
  @@index([searchScore], map: "idx_store_search_score")
}
```

#### Category - Agregar campos para búsqueda

```prisma
model Category {
  // ... campos existentes ...

  // Nuevos campos para búsqueda
  searchKeywords String[] @default([]) @map("search_keywords")
  searchScore    Decimal  @default(0.0) @map("search_score") @db.Decimal(10, 4)

  // ... resto de campos existentes ...

  @@index([searchKeywords], map: "idx_category_search_keywords", type: Gin)
  @@index([searchScore], map: "idx_category_search_score")
}
```

## 🛠️ Servicios Necesarios

### 1. SearchService

```dart
class SearchService {
  // Búsqueda general
  static Future<SearchResults> searchGlobal(String query, SearchFilters filters);

  // Búsquedas específicas
  static Future<List<Product>> searchProducts(String query, ProductFilters filters);
  static Future<List<Store>> searchStores(String query, StoreFilters filters);
  static Future<List<Category>> searchCategories(String query);

  // Sugerencias y autocompletado
  static Future<List<String>> getAutocompleteSuggestions(String query);
  static Future<List<SearchSuggestion>> getRelatedSuggestions(String query);

  // Historial y tendencias
  static Future<List<String>> getRecentSearches(String? userId, String sessionId);
  static Future<List<TrendingSearch>> getTrendingSearches(String? category);
  static Future<void> saveSearchHistory(SearchHistoryData data);

  // Búsquedas populares y promocionadas
  static Future<List<PopularSearch>> getPopularSearches();
  static Future<List<PromotedContent>> getPromotedContent();
}
```

### 2. SearchFilters y Modelos

```dart
class SearchFilters {
  final String? category;
  final PriceRange? priceRange;
  final double? maxDistance;
  final bool? hasOffers;
  final bool? inStock;
  final double? minRating;
  final List<String>? tags;
  final SortOption sortBy;
}

class SearchResults {
  final List<Product> products;
  final List<Store> stores;
  final List<Category> categories;
  final int totalResults;
  final String query;
  final SearchFilters appliedFilters;
}

class SearchSuggestion {
  final String text;
  final SearchSuggestionType type;
  final int weight;
  final Map<String, dynamic>? metadata;
}

enum SearchSuggestionType {
  autocomplete,
  recent,
  trending,
  category,
  product,
  store,
  related
}
```

## 🎨 Componentes UI Necesarios

### 1. AdvancedSearchSection (Widget Principal)

```dart
class AdvancedSearchSection extends StatefulWidget {
  final Function(SearchResults)? onSearchResults;
  final Function(String)? onQueryChanged;

  const AdvancedSearchSection({
    super.key,
    this.onSearchResults,
    this.onQueryChanged,
  });
}
```

### 2. SearchSuggestionsOverlay

```dart
class SearchSuggestionsOverlay extends StatelessWidget {
  final List<SearchSuggestion> suggestions;
  final Function(String) onSuggestionTap;
  final Function() onClear;

  const SearchSuggestionsOverlay({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
    required this.onClear,
  });
}
```

### 3. SearchChipsSection

```dart
class SearchChipsSection extends StatelessWidget {
  final List<SearchChip> chips;
  final Function(SearchChip) onChipTap;

  const SearchChipsSection({
    super.key,
    required this.chips,
    required this.onChipTap,
  });
}
```

### 4. SearchFiltersPanel

```dart
class SearchFiltersPanel extends StatefulWidget {
  final SearchFilters initialFilters;
  final Function(SearchFilters) onFiltersChanged;

  const SearchFiltersPanel({
    super.key,
    required this.initialFilters,
    required this.onFiltersChanged,
  });
}
```

## 🚀 Funcionalidades del Buscador Avanzado

### ✅ Búsqueda en Tiempo Real

- **Debounce**: 300ms para evitar spam de requests
- **Mínimo 2 caracteres**: Para activar búsqueda
- **Cancelación**: De requests anteriores cuando se escribe rápido
- **Caché local**: Para resultados recientes

### ✅ Sugerencias Inteligentes

- **Autocompletado**: Basado en productos, tiendas y categorías
- **Búsquedas recientes**: Historial del usuario
- **Búsquedas populares**: Tendencias globales y por categoría
- **Corrección de errores**: Sugerencias para términos mal escritos

### ✅ Chips de Búsqueda Rápida

```dart
class SearchChip {
  final String text;
  final SearchChipType type;
  final IconData? icon;
  final Color? color;
  final Map<String, dynamic>? data;
}

enum SearchChipType {
  recent,           // "pizza" - búsqueda reciente
  trending,         // "🔥 smartphones" - tendencia
  category,         // "📱 Tecnología" - categoría
  offer,           // "💸 Con descuento" - productos con oferta
  nearby,          // "📍 Cerca de ti" - tiendas cercanas
  featured,        // "⭐ Destacados" - productos destacados
  newArrivals,     // "🆕 Nuevos" - productos recientes
  topRated,        // "⭐ Mejor valorados" - alta calificación
}
```

### ✅ Filtros Avanzados

- **Por categoría**: Comida, tecnología, ropa, etc.
- **Por precio**: Rango de precios con slider
- **Por ubicación**: Radio de distancia
- **Por calificación**: Mínimo de estrellas
- **Por ofertas**: Solo productos con descuento
- **Por disponibilidad**: Solo productos en stock
- **Por tienda**: Filtrar por tienda específica

### ✅ Resultados Inteligentes

- **Orden por relevancia**: Score calculado
- **Resultados mixtos**: Productos, tiendas y categorías
- **Paginación**: Carga progresiva de resultados
- **Filtros rápidos**: En los resultados mismos

## 📱 Experiencia de Usuario

### Flujo de Búsqueda

1. **Usuario toca el campo de búsqueda**

   - Se expande el campo
   - Aparecen chips de búsquedas rápidas
   - Se muestran búsquedas recientes

2. **Usuario empieza a escribir**

   - Aparecen sugerencias de autocompletado
   - Se actualizan en tiempo real
   - Se muestran iconos por tipo de resultado

3. **Usuario selecciona sugerencia o presiona buscar**

   - Se ejecuta la búsqueda
   - Se muestran resultados agrupados
   - Se guarda en historial

4. **Usuario puede aplicar filtros**
   - Panel de filtros accesible
   - Aplicación en tiempo real
   - Indicadores visuales de filtros activos

### Estados del Buscador

- **Inicial**: Campo vacío con chips
- **Escribiendo**: Sugerencias activas
- **Cargando**: Spinner de búsqueda
- **Resultados**: Lista de resultados
- **Sin resultados**: Mensaje y sugerencias alternativas
- **Error**: Mensaje de error con reintento

## 🔧 Implementación Técnica

### BLoC Pattern para Search

```dart
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchExecuted>(_onSearchExecuted);
    on<SearchFiltersChanged>(_onFiltersChanged);
    on<SearchSuggestionSelected>(_onSuggestionSelected);
    on<SearchHistoryRequested>(_onHistoryRequested);
    on<TrendingSearchesRequested>(_onTrendingRequested);
  }
}
```

### Estados del Search

```dart
abstract class SearchState extends Equatable {}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuggestionsLoaded extends SearchState {}
class SearchResultsLoaded extends SearchState {}
class SearchError extends SearchState {}
```

### Optimizaciones de Performance

```dart
class SearchOptimizations {
  // Debounce para búsquedas
  static Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  // Caché de resultados
  static final Map<String, SearchResults> _searchCache = {};
  static const int _maxCacheSize = 50;

  // Cancelación de requests
  static CancelToken? _currentSearchToken;
}
```

## 📊 Analytics y Métricas

### Eventos a Trackear

- **Búsquedas realizadas**: Query, filtros, resultados
- **Clicks en sugerencias**: Tipo, posición, conversión
- **Tiempo en resultados**: Engagement con resultados
- **Filtros utilizados**: Popularidad de filtros
- **Conversiones**: De búsqueda a vista de producto/tienda

### Dashboard de Búsquedas

- Top búsquedas por período
- Búsquedas sin resultados
- Tendencias de búsqueda
- Performance de sugerencias
- Uso de filtros

## 🔄 Migración y Deployment

### Scripts de Migración

```sql
-- 1. Crear nuevas tablas
CREATE TABLE "SearchHistory" (...);
CREATE TABLE "TrendingSearches" (...);
CREATE TABLE "SearchSuggestions" (...);

-- 2. Agregar campos a tablas existentes
ALTER TABLE "Product" ADD COLUMN "search_keywords" TEXT[];
ALTER TABLE "Product" ADD COLUMN "search_score" DECIMAL(10,4) DEFAULT 0.0;
ALTER TABLE "Product" ADD COLUMN "is_promoted" BOOLEAN DEFAULT false;

-- 3. Crear índices
CREATE INDEX CONCURRENTLY "idx_product_search_keywords" ON "Product" USING gin("search_keywords");
CREATE INDEX CONCURRENTLY "idx_product_search_score" ON "Product"("search_score");

-- 4. Poblar datos iniciales
INSERT INTO "TrendingSearches" (query, search_count) VALUES
  ('comida', 100),
  ('tecnología', 85),
  ('ropa', 70);
```

### Configuración por Fases

1. **Fase 1**: Implementar búsqueda básica con sugerencias
2. **Fase 2**: Agregar filtros avanzados
3. **Fase 3**: Implementar analytics y optimizaciones
4. **Fase 4**: Features avanzadas (geolocalización, AI)

## 🎯 Métricas de Éxito

### KPIs Principales

- **Search Success Rate**: % búsquedas que generan clicks
- **Search Abandonment Rate**: % búsquedas sin interacción
- **Filter Usage Rate**: % usuarios que usan filtros
- **Search to Purchase**: Conversión de búsqueda a compra

### Objetivos

- Reducir búsquedas sin resultados en 60%
- Aumentar clicks en sugerencias en 40%
- Mejorar tiempo de búsqueda promedio en 50%
- Incrementar conversión de búsqueda en 25%

---

## 📋 Checklist de Implementación

### Base de Datos

- [ ] Crear tabla SearchHistory
- [ ] Crear tabla TrendingSearches
- [ ] Crear tabla SearchSuggestions
- [ ] Agregar campos de búsqueda a Product
- [ ] Agregar campos de búsqueda a Store
- [ ] Agregar campos de búsqueda a Category
- [ ] Crear índices necesarios
- [ ] Scripts de migración

### Servicios Backend

- [ ] SearchService básico
- [ ] Autocompletado inteligente
- [ ] Gestión de historial
- [ ] Cálculo de tendencias
- [ ] API de sugerencias
- [ ] Filtros avanzados

### UI/UX

- [ ] Rediseñar SearchSection
- [ ] Componente de sugerencias
- [ ] Sistema de chips
- [ ] Panel de filtros
- [ ] Página de resultados
- [ ] Estados de loading/error

### Testing

- [ ] Tests unitarios de servicios
- [ ] Tests de UI components
- [ ] Tests de performance
- [ ] Tests de UX flow

### Deployment

- [ ] Configuración de staging
- [ ] Migración de datos
- [ ] Monitoreo de métricas
- [ ] Feature flags
- [ ] Rollback plan

---

**Versión**: 1.0.0  
**Fecha**: 18 de julio de 2025  
**Autor**: Sistema de Búsqueda Avanzada - La Feria App
