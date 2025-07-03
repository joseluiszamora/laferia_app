import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_event.dart';
import 'package:laferia/core/blocs/categorias/categorias_state.dart';
import '../components/categorias_list_view.dart';
import '../components/categoria_search_bar.dart';
import '../forms/categoria_form_dialog.dart';

class AdminCategoriasPage extends StatefulWidget {
  const AdminCategoriasPage({super.key});

  @override
  State<AdminCategoriasPage> createState() => _AdminCategoriasPageState();
}

class _AdminCategoriasPageState extends State<AdminCategoriasPage> {
  @override
  void initState() {
    super.initState();
    // Cargar categorías al inicializar
    context.read<CategoriasBloc>().add(LoadCategorias());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Categorías'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CategoriasBloc>().add(LoadCategorias());
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          const CategoriaSearchBar(),

          // Lista de categorías
          Expanded(
            child: BlocConsumer<CategoriasBloc, CategoriasState>(
              listener: (context, state) {
                if (state is CategoriaCreada) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Categoría creada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is CategoriaActualizada) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Categoría actualizada exitosamente'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                } else if (state is CategoriaEliminada) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Categoría eliminada exitosamente'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } else if (state is CategoriaOperacionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CategoriasLoading ||
                    state is CategoriaCreandose ||
                    state is CategoriaActualizandose ||
                    state is CategoriaEliminandose) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando categorías...'),
                      ],
                    ),
                  );
                }

                if (state is CategoriasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CategoriasBloc>().add(
                              LoadCategorias(),
                            );
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is CategoriasLoaded) {
                  return const CategoriasListView();
                }

                return const Center(child: Text('Estado no reconocido'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCategoriaFormDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva Categoría'),
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showCategoriaFormDialog(BuildContext context, {int? categoriaId}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<CategoriasBloc>(),
            child: CategoriaFormDialog(categoriaId: categoriaId),
          ),
    );
  }
}
