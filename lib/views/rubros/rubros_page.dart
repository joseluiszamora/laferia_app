import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/rubros/rubros.dart';
import '../../core/blocs/service_locator.dart';
import '../../core/models/rubro.dart';
import 'widgets/rubro_card.dart';
import 'widgets/search_bar.dart';
import 'categorias_page.dart';

class RubrosPage extends StatelessWidget {
  static const String routeName = '/rubros';

  const RubrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RubrosBloc>()..add(const LoadRubros()),
      child: const _RubrosPageContent(),
    );
  }
}

class _RubrosPageContent extends StatelessWidget {
  const _RubrosPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rubros'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: RubrosSearchBar(
              onSearch: (query) {
                context.read<RubrosBloc>().add(FilterRubros(query));
              },
            ),
          ),
          // Lista de rubros
          Expanded(
            child: BlocBuilder<RubrosBloc, RubrosState>(
              builder: (context, state) {
                if (state is RubrosLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RubrosError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar rubros',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<RubrosBloc>().add(const LoadRubros());
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is RubrosLoaded) {
                  final rubros = state.filteredRubros;

                  if (rubros.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.searchQuery.isEmpty
                                ? 'No hay rubros disponibles'
                                : 'No se encontraron rubros',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (state.searchQuery.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Intenta con otros términos de búsqueda',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<RubrosBloc>().add(const LoadRubros());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: rubros.length,
                      itemBuilder: (context, index) {
                        final rubro = rubros[index];
                        return RubroCard(
                          rubro: rubro,
                          onTap:
                              () => _navigateToCategoriasPage(context, rubro),
                        );
                      },
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCategoriasPage(BuildContext context, Rubro rubro) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CategoriasPage(rubro: rubro)),
    );
  }
}
