import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/blocs/search/search_bloc.dart';
import '../core/blocs/search/search_event.dart';
import '../core/blocs/search/search_state.dart';
import '../views/search/advanced_search_section.dart';
import '../views/search/search_page.dart';
import '../views/search/components/search_chips_section.dart';
import '../core/models/search_models.dart';

/// Ejemplo completo de uso del sistema de búsqueda avanzada
class AdvancedSearchExamplePage extends StatelessWidget {
  const AdvancedSearchExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejemplos de Búsqueda Avanzada')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            'Búsqueda completa en página dedicada',
            'Página completa con todas las funcionalidades',
            () => _showFullSearchPage(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            'Modal de búsqueda',
            'Búsqueda en modal deslizable',
            () => _showSearchModal(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            'Widget de búsqueda embebido',
            'Componente integrado en otra vista',
            () => _showEmbeddedSearch(context),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            'Solo chips de búsqueda rápida',
            'Chips para categorías y tendencias',
            () => _showSearchChipsOnly(context),
          ),
          const SizedBox(height: 32),
          _buildUsageInfo(),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildUsageInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Funcionalidades del Buscador:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem('🔍', 'Búsqueda en tiempo real con debounce'),
            _buildFeatureItem(
              '💡',
              'Sugerencias inteligentes y autocompletado',
            ),
            _buildFeatureItem('🔥', 'Chips de búsquedas populares y recientes'),
            _buildFeatureItem(
              '🎯',
              'Filtros avanzados (precio, distancia, calificación)',
            ),
            _buildFeatureItem(
              '📊',
              'Resultados categorizados (productos, tiendas, categorías)',
            ),
            _buildFeatureItem('📝', 'Historial de búsquedas personalizado'),
            _buildFeatureItem(
              '🚀',
              'Cache de resultados para mejor performance',
            ),
            _buildFeatureItem('📱', 'Diseño responsive y Material 3'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _showFullSearchPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchPage(initialQuery: 'pizza'),
      ),
    );
  }

  void _showSearchModal(BuildContext context) {
    context.showSearchModal(initialQuery: 'tecnología');
  }

  void _showEmbeddedSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmbeddedSearchExample()),
    );
  }

  void _showSearchChipsOnly(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchChipsOnlyExample()),
    );
  }
}

/// Ejemplo de búsqueda embebida en otra vista
class EmbeddedSearchExample extends StatelessWidget {
  const EmbeddedSearchExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Búsqueda Embebida')),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Text(
                'Esta es una vista normal con búsqueda integrada abajo',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Expanded(
              child: AdvancedSearchSection(
                onSearchResults: _handleSearchResults,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _handleSearchResults(SearchResults results) {
    // Manejar resultados de búsqueda
    print('Resultados encontrados: ${results.totalResults}');
  }
}

/// Ejemplo de solo chips de búsqueda rápida
class SearchChipsOnlyExample extends StatelessWidget {
  const SearchChipsOnlyExample({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleChips = [
      const SearchChip(text: 'Pizza', type: SearchChipType.trending),
      const SearchChip(text: 'Smartphones', type: SearchChipType.trending),
      const SearchChip(text: 'Comida japonesa', type: SearchChipType.recent),
      const SearchChip(text: 'Tecnología', type: SearchChipType.category),
      const SearchChip(text: 'Con descuento', type: SearchChipType.offer),
      const SearchChip(text: 'Cerca de ti', type: SearchChipType.nearby),
      const SearchChip(text: 'Mejor valorados', type: SearchChipType.topRated),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Solo Chips de Búsqueda')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chips de búsqueda rápida:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CategorizedSearchChips(
              chips: sampleChips,
              onChipTap: (chip) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Seleccionaste: ${chip.text}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Ejemplo de uso programático del SearchBloc
class ProgrammaticSearchExample extends StatefulWidget {
  const ProgrammaticSearchExample({super.key});

  @override
  State<ProgrammaticSearchExample> createState() =>
      _ProgrammaticSearchExampleState();
}

class _ProgrammaticSearchExampleState extends State<ProgrammaticSearchExample> {
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc();
    _initializeSearch();
  }

  @override
  void dispose() {
    _searchBloc.close();
    super.dispose();
  }

  void _initializeSearch() {
    // Inicializar búsqueda
    _searchBloc.add(const SearchInitialized('example_session_123'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Uso Programático')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Controla la búsqueda programáticamente:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _searchBloc.add(const SearchExecuted('pizza')),
                child: const Text('Buscar "pizza"'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed:
                    () => _searchBloc.add(const SearchExecuted('smartphones')),
                child: const Text('Buscar "smartphones"'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _searchBloc.add(const SearchCleared()),
                child: const Text('Limpiar búsqueda'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estado actual: ${state.runtimeType}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(state.toString()),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
