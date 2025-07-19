import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/search/search_bloc.dart';
import 'advanced_search_section.dart';

class SearchPage extends StatelessWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: SearchPageView(initialQuery: initialQuery),
    );
  }
}

class SearchPageView extends StatefulWidget {
  final String? initialQuery;

  const SearchPageView({super.key, this.initialQuery});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Buscar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: AdvancedSearchSection(
          initialQuery: widget.initialQuery,
          onSearchResults: (results) {
            // Los resultados se manejan internamente
          },
          onQueryChanged: (query) {
            // Se puede usar para analytics
          },
        ),
      ),
    );
  }
}

/// Modal de búsqueda que se puede mostrar desde cualquier parte
class SearchModal {
  static Future<String?> show(
    BuildContext context, {
    String? initialQuery,
  }) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: BlocProvider(
                    create: (context) => SearchBloc(),
                    child: Column(
                      children: [
                        // Handle bar
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        // Search section
                        Expanded(
                          child: AdvancedSearchSection(
                            initialQuery: initialQuery,
                            onSearchResults: (results) {
                              // Aquí se pueden manejar los resultados
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }
}

/// Widget de búsqueda compacta para usar en AppBar
class CompactSearchWidget extends StatelessWidget {
  final String? placeholder;
  final VoidCallback? onTap;

  const CompactSearchWidget({super.key, this.placeholder, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => _openSearchPage(context),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.7),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  placeholder ?? 'Buscar productos, tiendas...',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSearchPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SearchPage()));
  }
}

/// Extensión para facilitar la navegación a búsqueda
extension SearchNavigation on BuildContext {
  void navigateToSearch({String? initialQuery}) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => SearchPage(initialQuery: initialQuery),
      ),
    );
  }

  Future<String?> showSearchModal({String? initialQuery}) {
    return SearchModal.show(this, initialQuery: initialQuery);
  }
}
