import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/blocs/tiendas/tiendas_bloc.dart';
import '../../core/blocs/tiendas/tiendas_event.dart';
import '../../core/blocs/tiendas/tiendas_state.dart';
import '../../core/models/tienda.dart';
import 'components/tienda_card.dart';
import 'tienda_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TiendasBloc()..add(LoadTiendas()),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TiendasBloc, TiendasState>(
        builder: (context, state) {
          if (state is TiendasLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TiendasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar las tiendas',
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
                      context.read<TiendasBloc>().add(LoadTiendas());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is TiendasLoaded) {
            if (state.tiendas.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.store_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay tiendas disponibles',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TiendasBloc>().add(LoadTiendas());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.tiendas.length,
                itemBuilder: (context, index) {
                  final tienda = state.tiendas[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TiendaCard(
                      tienda: tienda,
                      onTap: () => _navigateToTiendaDetail(context, tienda),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _navigateToTiendaDetail(BuildContext context, Tienda tienda) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TiendaDetailPage(tienda: tienda)),
    );
  }
}
