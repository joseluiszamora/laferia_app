import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_bloc.dart';
import '../../../../core/blocs/tiendas/tiendas_event.dart';
import '../../../../core/blocs/tiendas/tiendas_state.dart';
import '../../../../core/blocs/categorias/categorias_bloc.dart';
import '../../../../core/blocs/categorias/categorias_event.dart';
import '../components/tienda_search_bar.dart';
import '../components/tiendas_list_view.dart';
import '../forms/tienda_form_dialog.dart';

class AdminTiendasPage extends StatefulWidget {
  const AdminTiendasPage({super.key});

  @override
  State<AdminTiendasPage> createState() => _AdminTiendasPageState();
}

class _AdminTiendasPageState extends State<AdminTiendasPage> {
  @override
  void initState() {
    super.initState();
    // Cargar tiendas y categorías al inicializar
    context.read<TiendasBloc>().add(LoadTiendas());
    context.read<CategoriasBloc>().add(LoadCategorias());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tiendas'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TiendasBloc>().add(LoadTiendas());
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          const TiendaSearchBar(),

          // Lista de tiendas
          Expanded(
            child: BlocConsumer<TiendasBloc, TiendasState>(
              listener: (context, state) {
                if (state is TiendaCreada) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tienda creada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is TiendaActualizada) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tienda actualizada exitosamente'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                } else if (state is TiendaEliminada) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tienda eliminada exitosamente'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } else if (state is TiendaOperacionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TiendasLoading ||
                    state is TiendaCreandose ||
                    state is TiendaActualizandose ||
                    state is TiendaEliminandose) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Procesando...'),
                      ],
                    ),
                  );
                }

                if (state is TiendasError) {
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
                            context.read<TiendasBloc>().add(LoadTiendas());
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TiendasLoaded) {
                  return const TiendasListView();
                }

                return const Center(child: Text('Estado no reconocido'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showTiendaFormDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva Tienda'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showTiendaFormDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<TiendasBloc>(),
            child: BlocProvider.value(
              value: context.read<CategoriasBloc>(),
              child: const TiendaFormDialog(),
            ),
          ),
    );
  }
}
